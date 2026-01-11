//
//  WorkflowManager.swift
//  WorkflowKit
//
//  Workflow lifecycle management and execution tracking
//

import Foundation
import Combine
import SQLite3

// MARK: - Workflow Manager

@MainActor
public class WorkflowManager: ObservableObject {
    public static let shared = WorkflowManager()
    
    @Published public var workflows: [Workflow] = []
    @Published public var runningWorkflows: Set<UUID> = []
    @Published public var recentResults: [WorkflowRunResult] = []
    @Published public var isLoading = false
    
    private let workflowsKey = "savedWorkflows"
    private let maxResults = 100
    
    private init() {
        loadWorkflows()
    }
    
    // MARK: - Workflow CRUD
    
    public func createWorkflow(
        name: String,
        description: String,
        steps: [WorkflowStep] = [],
        category: WorkflowCategory = .general,
        tags: [String] = []
    ) -> Workflow {
        let workflow = Workflow(
            name: name,
            description: description,
            steps: steps,
            category: category,
            tags: tags,
            isBuiltIn: false
        )
        
        workflows.append(workflow)
        saveWorkflows()
        
        return workflow
    }
    
    public func updateWorkflow(_ workflow: Workflow) {
        if let index = workflows.firstIndex(where: { $0.id == workflow.id }) {
            var updated = workflow
            updated = Workflow(
                id: workflow.id,
                name: workflow.name,
                description: workflow.description,
                steps: workflow.steps,
                category: workflow.category,
                tags: workflow.tags,
                isBuiltIn: workflow.isBuiltIn,
                createdAt: workflow.createdAt,
                updatedAt: Date()
            )
            workflows[index] = updated
            saveWorkflows()
        }
    }
    
    public func deleteWorkflow(_ workflow: Workflow) {
        workflows.removeAll { $0.id == workflow.id }
        saveWorkflows()
    }
    
    public func getWorkflow(byId id: UUID) -> Workflow? {
        workflows.first { $0.id == id }
    }
    
    public func getWorkflows(byCategory category: WorkflowCategory) -> [Workflow] {
        if category == .all { return workflows }
        return workflows.filter { $0.category == category }
    }
    
    public func searchWorkflows(_ query: String) -> [Workflow] {
        guard !query.isEmpty else { return workflows }
        let lowercased = query.lowercased()
        return workflows.filter {
            $0.name.lowercased().contains(lowercased) ||
            $0.description.lowercased().contains(lowercased) ||
            $0.tags.contains { $0.lowercased().contains(lowercased) }
        }
    }
    
    // MARK: - Workflow Execution
    
    public func runWorkflow(_ workflow: Workflow) async -> WorkflowRunResult {
        guard !runningWorkflows.contains(workflow.id) else {
            return WorkflowRunResult(
                workflowId: workflow.id,
                workflowName: workflow.name,
                startTime: Date(),
                endTime: Date(),
                status: .failure,
                stepResults: [],
                error: "Workflow is already running"
            )
        }
        
        runningWorkflows.insert(workflow.id)
        
        let startTime = Date()
        var stepResults: [WorkflowRunResult.StepResult] = []
        var overallSuccess = true
        var errorMessage: String?
        
        for (index, step) in workflow.steps.enumerated() {
            let stepStart = Date()
            let result = await executeStep(step, stepIndex: index)
            let stepEnd = Date()
            
            let stepResult = WorkflowRunResult.StepResult(
                stepIndex: index,
                stepName: step.name,
                success: result.success,
                output: result.output,
                error: result.error,
                duration: stepEnd.timeIntervalSince(stepStart)
            )
            
            stepResults.append(stepResult)
            
            if !result.success {
                overallSuccess = false
                errorMessage = result.error
                break
            }
        }
        
        let endTime = Date()
        runningWorkflows.remove(workflow.id)
        
        let runResult = WorkflowRunResult(
            workflowId: workflow.id,
            workflowName: workflow.name,
            startTime: startTime,
            endTime: endTime,
            status: overallSuccess ? .success : .failure,
            stepResults: stepResults,
            error: errorMessage
        )
        
        recentResults.insert(runResult, at: 0)
        if recentResults.count > maxResults {
            recentResults.removeLast()
        }
        
        return runResult
    }
    
    private func executeStep(_ step: WorkflowStep, stepIndex: Int) async -> (success: Bool, output: String, error: String?) {
        switch step {
        case .command(let cmd):
            return await executeCommand(cmd)
        case .prompt(let prompt):
            return (true, "Prompt: \(prompt.message)", nil)
        case .conditional(let condition, let trueBranch, let falseBranch):
            let conditionMet = evaluateCondition(condition)
            let branch = conditionMet ? trueBranch : falseBranch
            return await executeStep(branch, stepIndex: stepIndex)
        case .parallel(let steps):
            return await executeParallelSteps(steps)
        case .subworkflow(let id):
            if let subworkflow = getWorkflow(byId: id) {
                let result = await runWorkflow(subworkflow)
                return (result.status == .success, "Subworkflow completed", result.error)
            }
            return (false, "", "Subworkflow not found")
        }
    }
    
    private func executeCommand(_ command: Command) async -> (success: Bool, output: String, error: String?) {
        // Check if this is a registered script reference (format: @script:script-id)
        if command.script.hasPrefix("@script:") {
            let scriptId = String(command.script.dropFirst(8))
            return await executeRegisteredScript(scriptId)
        }
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", command.script]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            
            let output = String(data: outputData, encoding: .utf8) ?? ""
            let error = String(data: errorData, encoding: .utf8)
            
            let success = process.terminationStatus == 0
            return (success, output, success ? nil : error)
        } catch {
            return (false, "", error.localizedDescription)
        }
    }
    
    /// Execute a script from the unified registry by ID
    /// Uses ScriptKit's SQL-backed database for script lookup and execution
    private func executeRegisteredScript(_ scriptId: String) async -> (success: Bool, output: String, error: String?) {
        // Try to use ScriptKit if available (SQL-backed)
        // This provides access to 12,000+ scripts with proper placeholder resolution
        
        // First, try to load from ScriptKit's SQL database
        let dbPaths = [
            "ScriptKit/Sources/ScriptKit/Resources/scripts.db",
            Bundle.main.path(forResource: "scripts", ofType: "db"),
            FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .first?.appendingPathComponent("ScriptKit/scripts.db").path
        ].compactMap { $0 }
        
        for dbPath in dbPaths {
            if FileManager.default.fileExists(atPath: dbPath) {
                if let result = await executeFromSQLDatabase(scriptId: scriptId, dbPath: dbPath) {
                    return result
                }
            }
        }
        
        // Fallback: try JSON registry (legacy)
        return await executeFromJSONRegistry(scriptId: scriptId)
    }
    
    /// Execute script from SQL database
    private func executeFromSQLDatabase(scriptId: String, dbPath: String) async -> (success: Bool, output: String, error: String?)? {
        var db: OpaquePointer?
        guard sqlite3_open_v2(dbPath, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else {
            return nil
        }
        defer { sqlite3_close(db) }
        
        let query = "SELECT content, type FROM scripts WHERE id = ? LIMIT 1"
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return nil
        }
        defer { sqlite3_finalize(statement) }
        
        sqlite3_bind_text(statement, 1, scriptId, -1, nil)
        
        guard sqlite3_step(statement) == SQLITE_ROW else {
            return nil
        }
        
        let content = String(cString: sqlite3_column_text(statement, 0))
        let typeStr = String(cString: sqlite3_column_text(statement, 1))
        
        // Resolve placeholders
        var resolved = content
        resolved = resolved.replacingOccurrences(of: "{{USER_HOME}}", with: FileManager.default.homeDirectoryForCurrentUser.path)
        resolved = resolved.replacingOccurrences(of: "{{USERNAME}}", with: NSUserName())
        resolved = resolved.replacingOccurrences(of: "{{DATE}}", with: ISO8601DateFormatter().string(from: Date()))
        resolved = resolved.replacingOccurrences(of: "{{TIMESTAMP}}", with: String(Int(Date().timeIntervalSince1970)))
        
        // Execute based on type
        return await executeContent(resolved, type: typeStr)
    }
    
    /// Execute script from JSON registry (legacy fallback)
    private func executeFromJSONRegistry(scriptId: String) async -> (success: Bool, output: String, error: String?) {
        let registryPath = "ScriptKit/UnifiedScriptRegistry.json"
        
        guard let data = FileManager.default.contents(atPath: registryPath),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let scripts = json["scripts"] as? [[String: Any]],
              let script = scripts.first(where: { $0["id"] as? String == scriptId }),
              let content = script["content"] as? String else {
            return (false, "", "Script not found: \(scriptId)")
        }
        
        let typeStr = script["type"] as? String ?? "shell"
        
        var resolved = content
        resolved = resolved.replacingOccurrences(of: "{{USER_HOME}}", with: FileManager.default.homeDirectoryForCurrentUser.path)
        resolved = resolved.replacingOccurrences(of: "{{USERNAME}}", with: NSUserName())
        
        return await executeContent(resolved, type: typeStr)
    }
    
    /// Execute resolved content based on script type
    private func executeContent(_ content: String, type: String) async -> (success: Bool, output: String, error: String?) {
        let process = Process()
        let tempFile = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        do {
            switch type {
            case "python":
                let pyFile = tempFile.appendingPathExtension("py")
                try content.write(to: pyFile, atomically: true, encoding: .utf8)
                defer { try? FileManager.default.removeItem(at: pyFile) }
                process.executableURL = URL(fileURLWithPath: "/usr/bin/python3")
                process.arguments = [pyFile.path]
                
            case "swift":
                let swiftFile = tempFile.appendingPathExtension("swift")
                try content.write(to: swiftFile, atomically: true, encoding: .utf8)
                defer { try? FileManager.default.removeItem(at: swiftFile) }
                process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
                process.arguments = [swiftFile.path]
                
            case "applescript":
                process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
                process.arguments = ["-e", content]
                
            case "ruby":
                process.executableURL = URL(fileURLWithPath: "/usr/bin/ruby")
                process.arguments = ["-e", content]
                
            default: // shell
                process.executableURL = URL(fileURLWithPath: "/bin/zsh")
                process.arguments = ["-c", content]
            }
            
            let outputPipe = Pipe()
            let errorPipe = Pipe()
            process.standardOutput = outputPipe
            process.standardError = errorPipe
            
            try process.run()
            process.waitUntilExit()
            
            let output = String(data: outputPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
            let error = String(data: errorPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
            
            return (process.terminationStatus == 0, output.trimmingCharacters(in: .whitespacesAndNewlines),
                    process.terminationStatus == 0 ? nil : error?.trimmingCharacters(in: .whitespacesAndNewlines))
        } catch {
            return (false, "", error.localizedDescription)
        }
    }
    
    private func evaluateCondition(_ condition: Condition) -> Bool {
        // Simple condition evaluation
        return true
    }
    
    private func executeParallelSteps(_ steps: [WorkflowStep]) async -> (success: Bool, output: String, error: String?) {
        var outputs: [String] = []
        var allSuccess = true
        var firstError: String?
        
        await withTaskGroup(of: (Bool, String, String?).self) { group in
            for (index, step) in steps.enumerated() {
                group.addTask {
                    await self.executeStep(step, stepIndex: index)
                }
            }
            
            for await result in group {
                outputs.append(result.1)
                if !result.0 {
                    allSuccess = false
                    if firstError == nil { firstError = result.2 }
                }
            }
        }
        
        return (allSuccess, outputs.joined(separator: "\n"), firstError)
    }
    
    // MARK: - Statistics
    
    public var totalWorkflows: Int { workflows.count }
    
    public var successRate: Double {
        guard !recentResults.isEmpty else { return 0 }
        let successful = recentResults.filter { $0.status == .success }.count
        return Double(successful) / Double(recentResults.count)
    }
    
    public var recentSuccessCount: Int {
        recentResults.prefix(10).filter { $0.status == .success }.count
    }
    
    // MARK: - Persistence
    
    private func loadWorkflows() {
        if let data = UserDefaults.standard.data(forKey: workflowsKey),
           let decoded = try? JSONDecoder().decode([Workflow].self, from: data) {
            workflows = decoded
        }
    }
    
    private func saveWorkflows() {
        if let encoded = try? JSONEncoder().encode(workflows) {
            UserDefaults.standard.set(encoded, forKey: workflowsKey)
        }
    }
}

// MARK: - Workflow Run Result

public struct WorkflowRunResult: Identifiable, Sendable {
    public let id: UUID
    public let workflowId: UUID
    public let workflowName: String
    public let startTime: Date
    public let endTime: Date
    public let status: Status
    public let stepResults: [StepResult]
    public let error: String?
    
    public var duration: String {
        let interval = endTime.timeIntervalSince(startTime)
        if interval < 1 { return "<1s" }
        if interval < 60 { return "\(Int(interval))s" }
        return "\(Int(interval / 60))m \(Int(interval.truncatingRemainder(dividingBy: 60)))s"
    }
    
    public enum Status: String, Sendable {
        case success, failure, cancelled
    }
    
    public struct StepResult: Sendable {
        public let stepIndex: Int
        public let stepName: String
        public let success: Bool
        public let output: String
        public let error: String?
        public let duration: TimeInterval
        
        public init(stepIndex: Int, stepName: String, success: Bool, output: String, error: String?, duration: TimeInterval) {
            self.stepIndex = stepIndex
            self.stepName = stepName
            self.success = success
            self.output = output
            self.error = error
            self.duration = duration
        }
    }
    
    public init(
        id: UUID = UUID(),
        workflowId: UUID,
        workflowName: String,
        startTime: Date,
        endTime: Date,
        status: Status,
        stepResults: [StepResult],
        error: String? = nil
    ) {
        self.id = id
        self.workflowId = workflowId
        self.workflowName = workflowName
        self.startTime = startTime
        self.endTime = endTime
        self.status = status
        self.stepResults = stepResults
        self.error = error
    }
}
