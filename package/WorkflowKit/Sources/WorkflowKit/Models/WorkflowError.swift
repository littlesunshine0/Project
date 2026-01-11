//
//  WorkflowError.swift
//  WorkflowKit
//
//  Workflow-related errors
//

import Foundation

// MARK: - Workflow Errors

public enum WorkflowError: LocalizedError, Equatable, Sendable {
    case workflowNotFound
    case invalidStep
    case executionFailed(String)
    case permissionDenied
    case timeout
    case cancelled
    
    public var errorDescription: String? {
        switch self {
        case .workflowNotFound:
            return "Workflow not found"
        case .invalidStep:
            return "Invalid workflow step"
        case .executionFailed(let message):
            return "Workflow execution failed: \(message)"
        case .permissionDenied:
            return "Permission denied for command execution"
        case .timeout:
            return "Workflow execution timed out"
        case .cancelled:
            return "Workflow execution was cancelled"
        }
    }
}

// MARK: - Command Execution Errors

public enum CommandExecutionError: LocalizedError, Sendable {
    case permissionDenied
    case executionFailed(Error)
    case timeout
    case cancelled
    
    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Permission denied for command execution"
        case .executionFailed(let error):
            return "Command execution failed: \(error.localizedDescription)"
        case .timeout:
            return "Command execution timed out"
        case .cancelled:
            return "Command execution was cancelled"
        }
    }
}
