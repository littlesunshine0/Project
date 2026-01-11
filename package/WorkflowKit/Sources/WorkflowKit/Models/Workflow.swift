//
//  Workflow.swift
//  WorkflowKit
//
//  Core workflow data models
//

import Foundation

// MARK: - Workflow Models

public struct Workflow: Codable, Identifiable, Equatable, Sendable {
    public let id: UUID
    public var name: String
    public var description: String
    public var steps: [WorkflowStep]
    public var category: WorkflowCategory
    public var tags: [String]
    public var isBuiltIn: Bool
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        steps: [WorkflowStep] = [],
        category: WorkflowCategory = .general,
        tags: [String] = [],
        isBuiltIn: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.steps = steps
        self.category = category
        self.tags = tags
        self.isBuiltIn = isBuiltIn
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Workflow Category

public enum WorkflowCategory: String, Codable, CaseIterable, Hashable, Sendable {
    case all = "All"
    case general = "General"
    case development = "Development"
    case testing = "Testing"
    case documentation = "Documentation"
    case deployment = "Deployment"
    case systemAdmin = "System Admin"
    case analytics = "Analytics"
    case automation = "Automation"
    case collaboration = "Collaboration"
    case database = "Database"
    case api = "API"
    case git = "Git"
    case build = "Build"
    case debug = "Debug"
    case security = "Security"
    case performance = "Performance"
    case ui = "UI"
    case backend = "Backend"
    case mobile = "Mobile"
    case web = "Web"
    case cloud = "Cloud"
    case ai = "AI/ML"
    
    public var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .general: return "gearshape"
        case .development: return "hammer"
        case .testing: return "checkmark.seal"
        case .documentation: return "doc.text"
        case .deployment: return "arrow.up.doc"
        case .systemAdmin: return "server.rack"
        case .analytics: return "chart.bar"
        case .automation: return "gearshape.2"
        case .collaboration: return "person.2"
        case .database: return "cylinder"
        case .api: return "network"
        case .git: return "arrow.triangle.branch"
        case .build: return "wrench.and.screwdriver"
        case .debug: return "ant"
        case .security: return "lock.shield"
        case .performance: return "gauge"
        case .ui: return "paintbrush"
        case .backend: return "cpu"
        case .mobile: return "iphone"
        case .web: return "globe"
        case .cloud: return "cloud"
        case .ai: return "brain"
        }
    }
}

// MARK: - Workflow Status

public enum WorkflowStatus: String, Codable, CaseIterable, Sendable {
    case draft = "Draft"
    case ready = "Ready"
    case running = "Running"
    case completed = "Completed"
    case failed = "Failed"
    case cancelled = "Cancelled"
    case paused = "Paused"
    
    public var icon: String {
        switch self {
        case .draft: return "doc.badge.ellipsis"
        case .ready: return "checkmark.circle"
        case .running: return "play.circle.fill"
        case .completed: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        case .cancelled: return "stop.circle"
        case .paused: return "pause.circle.fill"
        }
    }
    
    public var isActive: Bool {
        self == .running || self == .paused
    }
}

// MARK: - Workflow Section

public enum WorkflowSection: String, CaseIterable, Sendable {
    case all = "All Workflows"
    case recent = "Recent"
    case templates = "Templates"
    case running = "Running"
    case history = "History"
    case favorites = "Favorites"
    
    public var icon: String {
        switch self {
        case .all: return "square.stack.3d.up"
        case .recent: return "clock"
        case .templates: return "doc.on.doc"
        case .running: return "play.circle"
        case .history: return "clock.arrow.circlepath"
        case .favorites: return "star"
        }
    }
}

// MARK: - Workflow Step

public indirect enum WorkflowStep: Codable, Equatable, Sendable {
    case command(Command)
    case prompt(Prompt)
    case conditional(Condition, trueBranch: WorkflowStep, falseBranch: WorkflowStep)
    case parallel([WorkflowStep])
    case subworkflow(UUID)
    
    enum CodingKeys: String, CodingKey {
        case type, command, prompt, condition, trueBranch, falseBranch, steps, subworkflowId
    }
    
    enum StepType: String, Codable {
        case command, prompt, conditional, parallel, subworkflow
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .command(let cmd):
            try container.encode(StepType.command, forKey: .type)
            try container.encode(cmd, forKey: .command)
        case .prompt(let p):
            try container.encode(StepType.prompt, forKey: .type)
            try container.encode(p, forKey: .prompt)
        case .conditional(let cond, let trueBranch, let falseBranch):
            try container.encode(StepType.conditional, forKey: .type)
            try container.encode(cond, forKey: .condition)
            try container.encode(trueBranch, forKey: .trueBranch)
            try container.encode(falseBranch, forKey: .falseBranch)
        case .parallel(let steps):
            try container.encode(StepType.parallel, forKey: .type)
            try container.encode(steps, forKey: .steps)
        case .subworkflow(let id):
            try container.encode(StepType.subworkflow, forKey: .type)
            try container.encode(id, forKey: .subworkflowId)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(StepType.self, forKey: .type)
        
        switch type {
        case .command:
            let cmd = try container.decode(Command.self, forKey: .command)
            self = .command(cmd)
        case .prompt:
            let p = try container.decode(Prompt.self, forKey: .prompt)
            self = .prompt(p)
        case .conditional:
            let cond = try container.decode(Condition.self, forKey: .condition)
            let trueBranch = try container.decode(WorkflowStep.self, forKey: .trueBranch)
            let falseBranch = try container.decode(WorkflowStep.self, forKey: .falseBranch)
            self = .conditional(cond, trueBranch: trueBranch, falseBranch: falseBranch)
        case .parallel:
            let steps = try container.decode([WorkflowStep].self, forKey: .steps)
            self = .parallel(steps)
        case .subworkflow:
            let id = try container.decode(UUID.self, forKey: .subworkflowId)
            self = .subworkflow(id)
        }
    }
}

// MARK: - Workflow Extensions

public extension Workflow {
    /// Keywords for workflow matching
    var keywords: [String] {
        var allKeywords = tags
        allKeywords.append(contentsOf: name.lowercased().split(separator: " ").map(String.init))
        allKeywords.append(contentsOf: description.lowercased().split(separator: " ").map(String.init))
        return allKeywords
    }
    
    /// Convenience initializer with keywords
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        category: WorkflowCategory,
        steps: [WorkflowStep],
        keywords: [String]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.steps = steps
        self.tags = keywords
        self.isBuiltIn = true
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - WorkflowStep Extensions

public extension WorkflowStep {
    /// Get the name/description of the step
    var name: String {
        switch self {
        case .command(let cmd): return cmd.description
        case .prompt(let p): return p.message
        case .conditional(let cond, _, _): return "Conditional: \(cond.expression)"
        case .parallel(let steps): return "Parallel execution (\(steps.count) steps)"
        case .subworkflow: return "Sub-workflow"
        }
    }
    
    /// Get the command/script for the step
    var command: String {
        switch self {
        case .command(let cmd): return cmd.script
        case .prompt(let p): return p.message
        case .conditional(let cond, _, _): return cond.expression
        case .parallel: return "parallel"
        case .subworkflow(let id): return "subworkflow:\(id.uuidString)"
        }
    }
    
    /// Whether this step requires user input
    var requiresInput: Bool {
        if case .prompt = self { return true }
        return false
    }
    
    /// Estimated duration
    var estimatedDuration: TimeInterval {
        switch self {
        case .command(let cmd): return cmd.timeout
        default: return 30.0
        }
    }
}
