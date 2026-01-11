//
//  WorkflowKind.swift
//  WorkflowKit
//

import Foundation

public enum WorkflowKind: String, CaseIterable, Codable, Sendable {
    case sequential = "Sequential"
    case parallel = "Parallel"
    case conditional = "Conditional"
    case loop = "Loop"
    case event = "Event-Driven"
    
    public var icon: String {
        switch self {
        case .sequential: return "arrow.right"
        case .parallel: return "arrow.triangle.branch"
        case .conditional: return "questionmark.diamond"
        case .loop: return "repeat"
        case .event: return "bolt"
        }
    }
    
    public var description: String {
        switch self {
        case .sequential: return "Steps execute one after another"
        case .parallel: return "Steps execute simultaneously"
        case .conditional: return "Steps execute based on conditions"
        case .loop: return "Steps repeat until condition met"
        case .event: return "Steps triggered by events"
        }
    }
}
