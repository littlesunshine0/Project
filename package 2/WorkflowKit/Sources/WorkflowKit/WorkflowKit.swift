//
//  WorkflowKit.swift
//  WorkflowKit
//
//  Workflow Orchestration & Execution System
//  A reusable package for defining, matching, and executing workflows
//

import Foundation

/// WorkflowKit - Professional Workflow Orchestration System
///
/// Provides:
/// - Workflow definition and modeling
/// - Step-based execution with parallelism
/// - Natural language workflow matching
/// - Pattern extraction from documentation
/// - Execution history tracking
/// - Error recovery and retry logic
///
public struct WorkflowKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.workflowkit"
    
    public init() {}
}

// MARK: - Public API

public extension WorkflowKit {
    /// Create a new workflow orchestrator
    static func createOrchestrator() -> WorkflowOrchestrator {
        return WorkflowOrchestrator()
    }
    
    /// Create a workflow extractor for documentation parsing
    static func createExtractor() -> WorkflowExtractor {
        return WorkflowExtractor()
    }
}
