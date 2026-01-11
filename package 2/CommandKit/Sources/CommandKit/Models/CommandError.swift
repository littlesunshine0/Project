//
//  CommandError.swift
//  CommandKit
//

import Foundation

public enum CommandError: LocalizedError, Sendable {
    case notACommand
    case emptyCommand
    case unknownCommand(String)
    case invalidArguments(String)
    case executionFailed(String)
    case permissionDenied(String)
    case timeout
    case cancelled
    case parsingFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .notACommand: return "Input must start with /"
        case .emptyCommand: return "Command is empty"
        case .unknownCommand(let name): return "Unknown command: /\(name)"
        case .invalidArguments(let msg): return "Invalid arguments: \(msg)"
        case .executionFailed(let msg): return "Execution failed: \(msg)"
        case .permissionDenied(let msg): return "Permission denied: \(msg)"
        case .timeout: return "Command timed out"
        case .cancelled: return "Command was cancelled"
        case .parsingFailed(let msg): return "Parsing failed: \(msg)"
        }
    }
    
    public var icon: String {
        switch self {
        case .notACommand, .emptyCommand, .unknownCommand: return "questionmark.circle"
        case .invalidArguments, .parsingFailed: return "exclamationmark.triangle"
        case .executionFailed: return "xmark.circle"
        case .permissionDenied: return "lock"
        case .timeout: return "clock.badge.exclamationmark"
        case .cancelled: return "stop.circle"
        }
    }
}
