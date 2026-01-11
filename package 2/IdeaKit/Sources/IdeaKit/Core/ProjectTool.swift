//
//  ProjectTool.swift
//  IdeaKit - Project Operating System
//
//  Protocol that all project tools must conform to
//

import Foundation

/// Protocol for all IdeaKit tools
/// Each tool is a phase-aware agent that produces artifacts
public protocol ProjectTool {
    
    /// Unique identifier for the tool
    static var id: String { get }
    
    /// Human-readable name
    static var name: String { get }
    
    /// Description of what the tool does
    static var description: String { get }
    
    /// Phase this tool belongs to
    static var phase: ProjectPhase { get }
    
    /// Artifacts this tool produces
    static var outputs: [String] { get }
    
    /// Artifacts this tool requires as input
    static var inputs: [String] { get }
    
    /// Whether this tool is enabled by default
    static var isDefault: Bool { get }
}

/// Project phases that tools operate in
public enum ProjectPhase: String, Codable, CaseIterable, Sendable {
    case ideaAndIntent = "idea_and_intent"
    case specification = "specification"
    case architecture = "architecture"
    case documentation = "documentation"
    case quality = "quality"
    case execution = "execution"
    case learning = "learning"
    
    public var displayName: String {
        switch self {
        case .ideaAndIntent: return "Idea & Intent"
        case .specification: return "Specification & Planning"
        case .architecture: return "Architecture & Technical"
        case .documentation: return "Documentation"
        case .quality: return "Quality & Risk"
        case .execution: return "Execution & Feedback"
        case .learning: return "Learning & Adaptation"
        }
    }
    
    public var order: Int {
        switch self {
        case .ideaAndIntent: return 1
        case .specification: return 2
        case .architecture: return 3
        case .documentation: return 4
        case .quality: return 5
        case .execution: return 6
        case .learning: return 7
        }
    }
}

/// Result of a tool execution
public struct ToolResult: Sendable {
    public let toolId: String
    public let success: Bool
    public let artifacts: [String]
    public let errors: [String]
    public let duration: TimeInterval
    
    public init(toolId: String, success: Bool, artifacts: [String], errors: [String] = [], duration: TimeInterval = 0) {
        self.toolId = toolId
        self.success = success
        self.artifacts = artifacts
        self.errors = errors
        self.duration = duration
    }
}
