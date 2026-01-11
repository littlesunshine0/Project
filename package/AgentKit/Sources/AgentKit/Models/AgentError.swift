//
//  AgentError.swift
//  AgentKit
//

import Foundation

public enum AgentError: LocalizedError, Sendable {
    case notFound(UUID)
    case alreadyRunning(String)
    case executionFailed(String)
    case configurationInvalid(String)
    case permissionDenied(String)
    case timeout
    case cancelled
    case triggerFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .notFound(let id): return "Agent not found: \(id)"
        case .alreadyRunning(let name): return "Agent already running: \(name)"
        case .executionFailed(let msg): return "Execution failed: \(msg)"
        case .configurationInvalid(let msg): return "Invalid configuration: \(msg)"
        case .permissionDenied(let msg): return "Permission denied: \(msg)"
        case .timeout: return "Agent timed out"
        case .cancelled: return "Agent was cancelled"
        case .triggerFailed(let msg): return "Trigger failed: \(msg)"
        }
    }
    
    public var icon: String {
        switch self {
        case .notFound: return "questionmark.circle"
        case .alreadyRunning: return "exclamationmark.triangle"
        case .executionFailed: return "xmark.circle"
        case .configurationInvalid: return "gearshape.triangle"
        case .permissionDenied: return "lock"
        case .timeout: return "clock.badge.exclamationmark"
        case .cancelled: return "stop.circle"
        case .triggerFailed: return "bell.slash"
        }
    }
}
