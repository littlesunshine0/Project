//
//  WorkflowOrchestrator.swift
//  WorkflowKit
//
//  Orchestrates workflow execution with parallelism, branching, and error recovery
//

import Foundation

// MARK: - Workflow Orchestrator

/// Manages workflow execution with support for parallelism, branching, and error recovery
public actor WorkflowOrchestrator {
    
    // MARK: - Dependencies
    
    private let commandExecutor: CommandExecutor
    
    // MARK: - State
    
    private var activeWorkflows: [UUID: WorkflowExecution] = [:]
    private var pausedWorkflows: [UUID: WorkflowState] = [:]
    private var workflowStore: [UUID: Workflow] = [:]
    
    // MARK: - Initialization
    
    public init(commandExecutor: CommandExecutor = CommandExecutor()) {
        self.commandExecutor = commandExecutor
    }
    
    // MARK: - Workflow Execution
    
    /// Executes a workflow and returns the result
    public func executeWorkflow(_ workflow: Workflow) async throws -> WorkflowResult {
        var execution = WorkflowExecution(workflow: workflow)
        activeWorkflows[execution.id] = execution
        
        defer {
            activeWorkflows.removeValue(forKey: execution.id)
        }
        
        do {
            for (index, step) in workflow.steps.enumerated() {
                execution.currentStepIndex = index
                activeWorkflows[execution.id] = execution
                
                let stepResults = try await executeStep(step, in: &execution)
                execution.results.append(contentsOf: stepResults)
            }
            
            execution.state = .completed
            execution.completedAt = Date()
            return .success(execution.results)
            
        } catch let error as WorkflowError {
            execution.state = .failed
            execution.completedAt = Date()
            return .failure(error)
        } catch {
            execution.state = .failed
            execution.completedAt = Date()
            return .failure(.executionFailed(error.localizedDescription))
        }
    }
    
    /// Pauses a workflow execution
    public func pauseWorkflow(_ id: UUID) async {
        guard var execution = activeWorkflows[id] else { return }
        
        execution.state = .paused
        let state = WorkflowState(execution: execution)
        
        pausedWorkflows[id] = state
        activeWorkflows.removeValue(forKey: id)
        
        await persistPausedWorkflow(state)
    }
    
    /// Resumes a paused workflow
    public func resumeWorkflow(_ id: UUID) async throws -> WorkflowResult {
        guard let state = pausedWorkflows[id] else {
            throw WorkflowError.workflowNotFound
        }
        
        pausedWorkflows.removeValue(forKey: id)
        await deletePausedWorkflow(id)
        
        var execution = state.execution
        execution.state = .running
        activeWorkflows[execution.id] = execution
        
        defer {
            activeWorkflows.removeValue(forKey: execution.id)
        }
        
        do {
            for index in execution.currentStepIndex..<execution.workflow.steps.count {
                execution.currentStepIndex = index
                activeWorkflows[execution.id] = execution
                
                let step = execution.workflow.steps[index]
                let stepResults = try await executeStep(step, in: &execution)
                execution.results.append(contentsOf: stepResults)
            }
            
            execution.state = .completed
            execution.completedAt = Date()
            return .success(execution.results)
            
        } catch let error as WorkflowError {
            execution.state = .failed
            execution.completedAt = Date()
            return .failure(error)
        } catch {
            execution.state = .failed
            execution.completedAt = Date()
            return .failure(.executionFailed(error.localizedDescription))
        }
    }
    
    /// Cancels a workflow execution
    public func cancelWorkflow(_ id: UUID) async {
        if var execution = activeWorkflows[id] {
            execution.state = .cancelled
            execution.completedAt = Date()
            activeWorkflows.removeValue(forKey: id)
        }
        if pausedWorkflows.removeValue(forKey: id) != nil {
            await deletePausedWorkflow(id)
        }
    }
    
    /// Gets the current state of a workflow execution
    public func getState(_ execution: WorkflowExecution) -> ExecutionState {
        return execution.state
    }
    
    /// Gets all paused workflows
    public func getPausedWorkflows() -> [WorkflowState] {
        return Array(pausedWorkflows.values)
    }
    
    /// Gets the summary for a paused workflow
    public func getWorkflowSummary(_ id: UUID) -> WorkflowSummary? {
        return pausedWorkflows[id]?.summary
    }
    
    /// Gets all stale paused workflows (paused for more than 24 hours)
    public func getStaleWorkflows() -> [WorkflowState] {
        return pausedWorkflows.values.filter { $0.isStale }
    }
    
    /// Stores a workflow for later reference (e.g., for sub-workflows)
    public func storeWorkflow(_ workflow: Workflow) {
        workflowStore[workflow.id] = workflow
    }
    
    /// Loads a workflow by ID
    public func loadWorkflow(_ id: UUID) async throws -> Workflow {
        guard let workflow = workflowStore[id] else {
            throw WorkflowError.workflowNotFound
        }
        return workflow
    }
    
    // MARK: - Step Execution
    
    private func executeStep(_ step: WorkflowStep, in execution: inout WorkflowExecution) async throws -> [StepResult] {
        let startTime = Date()
        
        switch step {
        case .command(let cmd):
            let result = try await commandExecutor.execute(cmd)
            let duration = Date().timeIntervalSince(startTime)
            
            return [StepResult(
                stepIndex: execution.currentStepIndex,
                success: result.isSuccess,
                output: result.output,
                error: result.isSuccess ? nil : result.error,
                executedAt: Date(),
                duration: duration
            )]
            
        case .prompt(let prompt):
            let duration = Date().timeIntervalSince(startTime)
            
            return [StepResult(
                stepIndex: execution.currentStepIndex,
                success: true,
                output: "Prompt: \(prompt.message)",
                error: nil,
                executedAt: Date(),
                duration: duration
            )]
            
        case .parallel(let steps):
            return try await executeParallelSteps(steps, in: &execution, startTime: startTime)
            
        case .conditional(let condition, let trueBranch, let falseBranch):
            let shouldExecuteTrueBranch = try await evaluateCondition(condition, in: execution)
            let branch = shouldExecuteTrueBranch ? trueBranch : falseBranch
            
            let branchResults = try await executeStep(branch, in: &execution)
            
            let branchId = shouldExecuteTrueBranch ? "true_branch" : "false_branch"
            execution.context.storeBranchResults(branchId, results: branchResults)
            
            return branchResults
            
        case .subworkflow(let workflowId):
            let subworkflow = try await loadWorkflow(workflowId)
            let subResult = try await executeWorkflow(subworkflow)
            
            switch subResult {
            case .success(let results): return results
            case .partial(let results): return results
            case .failure(let error): throw error
            }
        }
    }
    
    private func executeParallelSteps(_ steps: [WorkflowStep], in execution: inout WorkflowExecution, startTime: Date) async throws -> [StepResult] {
        let executionSnapshot = execution
        
        return try await withThrowingTaskGroup(of: [StepResult].self) { group in
            var allResults: [StepResult] = []
            
            for step in steps {
                group.addTask {
                    var tempExecution = executionSnapshot
                    return try await self.executeStep(step, in: &tempExecution)
                }
            }
            
            for try await results in group {
                allResults.append(contentsOf: results)
            }
            
            return allResults
        }
    }
    
    private func evaluateCondition(_ condition: Condition, in execution: WorkflowExecution) async throws -> Bool {
        var evaluatedExpression = condition.expression
        
        for (key, value) in condition.variables {
            evaluatedExpression = evaluatedExpression.replacingOccurrences(of: "${\(key)}", with: value)
        }
        
        for (key, value) in execution.context.variables {
            evaluatedExpression = evaluatedExpression.replacingOccurrences(of: "${\(key)}", with: value)
        }
        
        if evaluatedExpression == "true" { return true }
        if evaluatedExpression == "false" { return false }
        
        if evaluatedExpression.contains("==") {
            let parts = evaluatedExpression.split(separator: "=").map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 3 && parts[1].isEmpty {
                return parts[0] == parts[2]
            }
        }
        
        return false
    }
    
    // MARK: - Persistence
    
    private func persistPausedWorkflow(_ state: WorkflowState) async {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        guard let data = try? encoder.encode(state) else { return }
        
        let fileURL = getPausedWorkflowFileURL(for: state.id)
        try? data.write(to: fileURL)
    }
    
    private func deletePausedWorkflow(_ id: UUID) async {
        let fileURL = getPausedWorkflowFileURL(for: id)
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    private func getPausedWorkflowsDirectory() -> URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let directory = appSupport.appendingPathComponent("WorkflowKit/PausedWorkflows", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }
    
    private func getPausedWorkflowFileURL(for id: UUID) -> URL {
        return getPausedWorkflowsDirectory().appendingPathComponent("\(id.uuidString).json")
    }
    
    /// Loads all persisted paused workflows
    public func loadPausedWorkflows() async {
        let directory = getPausedWorkflowsDirectory()
        
        guard let files = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil) else {
            return
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        for fileURL in files where fileURL.pathExtension == "json" {
            guard let data = try? Data(contentsOf: fileURL),
                  let state = try? decoder.decode(WorkflowState.self, from: data) else {
                continue
            }
            
            pausedWorkflows[state.id] = state
        }
    }
}
