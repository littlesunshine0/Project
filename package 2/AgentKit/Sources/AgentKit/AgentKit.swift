//
//  AgentKit.swift
//  AgentKit
//
//  Autonomous Agent System for Task Execution
//

import Foundation

/// AgentKit - Professional Autonomous Agent System
///
/// Provides:
/// - Agent definition and lifecycle management
/// - Trigger-based automation
/// - Action execution with retry logic
/// - Scheduling and monitoring
/// - AI-powered capabilities
///
public struct AgentKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.agentkit"
    
    public init() {}
}

// MARK: - Public API

public extension AgentKit {
    /// Create a new agent manager
    @MainActor
    static func createManager() -> AgentManager {
        return AgentManager.shared
    }
    
    /// Create a simple task agent
    static func createTaskAgent(
        name: String,
        description: String,
        actions: [AgentAction]
    ) -> Agent {
        return Agent(
            name: name,
            description: description,
            type: .task,
            capabilities: [.executeCommands],
            triggers: [AgentTrigger(type: .manual, condition: "On demand")],
            actions: actions
        )
    }
    
    /// Create an automation agent with triggers
    static func createAutomationAgent(
        name: String,
        description: String,
        triggers: [AgentTrigger],
        actions: [AgentAction]
    ) -> Agent {
        return Agent(
            name: name,
            description: description,
            type: .automation,
            capabilities: [.executeCommands, .notifications],
            triggers: triggers,
            actions: actions
        )
    }
}
