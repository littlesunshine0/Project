//
//  WorkflowExecution.swift
//  WorkflowKit
//
//  Workflow execution state and results
//

import Foundation

// MARK: - Workflow Execution

public struct WorkflowExecution: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let workflow: Workflow
    public var currentStepIndex: Int
    public var state: ExecutionState
    public var results: [StepResult]
    public var startedAt: Date
    public var completedAt: Date?
    public var context: ExecutionContext
    
    public init(workflow: Workflow) {
        self.id = UUID()
        self.workflow = workflow
        self.currentStepIndex = 0
        self.state = .running
        self.results = []
        self.startedAt = Date()
        self.completedAt = nil
        self.context = ExecutionContext()
    }
    
    public var duration: TimeInterval {
        if let completed = completedAt {
            return completed.timeIntervalSince(startedAt)
        }
        return Date().timeIntervalSince(startedAt)
    }
}

// MARK: - Execution State

public enum ExecutionState: String, Codable, Equatable, Sendable {
    case pending
    case running
    case paused
    case completed
    case failed
    case cancelled
}

// MARK: - Step Result

public struct StepResult: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let stepIndex: Int
    public let success: Bool
    public let output: String
    public let error: String?
    public let executedAt: Date
    public let duration: TimeInterval
    
    public init(
        id: UUID = UUID(),
        stepIndex: Int,
        success: Bool,
        output: String,
        error: String? = nil,
        executedAt: Date = Date(),
        duration: TimeInterval
    ) {
        self.id = id
        self.stepIndex = stepIndex
        self.success = success
        self.output = output
        self.error = error
        self.executedAt = executedAt
        self.duration = duration
    }
}

// MARK: - Execution Context

public struct ExecutionContext: Codable, Equatable, Sendable {
    public var variables: [String: String] = [:]
    public var branchResults: [String: [StepResult]] = [:]
    
    public init() {}
    
    public mutating func setVariable(_ key: String, value: String) {
        variables[key] = value
    }
    
    public func getVariable(_ key: String) -> String? {
        return variables[key]
    }
    
    public mutating func storeBranchResults(_ branchId: String, results: [StepResult]) {
        branchResults[branchId] = results
    }
    
    public func getBranchResults(_ branchId: String) -> [StepResult]? {
        return branchResults[branchId]
    }
}

// MARK: - Workflow Result

public enum WorkflowResult: Equatable, Sendable {
    case success([StepResult])
    case partial([StepResult])
    case failure(WorkflowError)
    
    public var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
    
    public static func == (lhs: WorkflowResult, rhs: WorkflowResult) -> Bool {
        switch (lhs, rhs) {
        case (.success(let l), .success(let r)): return l == r
        case (.partial(let l), .partial(let r)): return l == r
        case (.failure(let l), .failure(let r)): return l == r
        default: return false
        }
    }
}

// MARK: - Workflow State (for pausing/resuming)

public struct WorkflowState: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public let execution: WorkflowExecution
    public let pausedAt: Date
    
    public init(execution: WorkflowExecution, pausedAt: Date = Date()) {
        self.id = execution.id
        self.execution = execution
        self.pausedAt = pausedAt
    }
    
    /// Returns true if the workflow has been paused for more than 24 hours
    public var isStale: Bool {
        Date().timeIntervalSince(pausedAt) > 24 * 60 * 60
    }
    
    /// Returns a summary of completed and remaining steps
    public var summary: WorkflowSummary {
        WorkflowSummary(
            workflowName: execution.workflow.name,
            totalSteps: execution.workflow.steps.count,
            completedSteps: execution.currentStepIndex,
            remainingSteps: execution.workflow.steps.count - execution.currentStepIndex,
            pausedAt: pausedAt,
            isStale: isStale
        )
    }
}

// MARK: - Workflow Summary

public struct WorkflowSummary: Codable, Equatable, Sendable {
    public let workflowName: String
    public let totalSteps: Int
    public let completedSteps: Int
    public let remainingSteps: Int
    public let pausedAt: Date
    public let isStale: Bool
}

// MARK: - Workflow Outcome

public enum WorkflowOutcome: String, Codable, Sendable {
    case success
    case failure
    case partial
    case cancelled
}

// MARK: - Workflow History Entry

public struct WorkflowHistoryEntry: Identifiable, Codable, Sendable {
    public let id: UUID
    public let executionId: UUID
    public let workflowId: UUID
    public let workflowName: String
    public let outcome: WorkflowOutcome
    public let completedAt: Date
    public let duration: TimeInterval
    public let execution: WorkflowExecution
    public let inputs: [String: String]?
    
    public init(
        id: UUID = UUID(),
        executionId: UUID,
        workflowId: UUID,
        workflowName: String,
        outcome: WorkflowOutcome,
        completedAt: Date,
        duration: TimeInterval,
        execution: WorkflowExecution,
        inputs: [String: String]? = nil
    ) {
        self.id = id
        self.executionId = executionId
        self.workflowId = workflowId
        self.workflowName = workflowName
        self.outcome = outcome
        self.completedAt = completedAt
        self.duration = duration
        self.execution = execution
        self.inputs = inputs
    }
}
