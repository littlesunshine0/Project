//
//  AppIdea.swift
//  AppIdeaKit - Core App Idea Model
//

import Foundation

// MARK: - App Idea

public struct AppIdea: Identifiable, Codable, Sendable {
    public let id: String
    public var name: String
    public var description: String
    public var category: AppCategory
    public var kind: AppKind
    public var type: AppType
    public var complexity: Complexity
    public var tags: [String]
    public var features: [Feature]
    public var requiredKits: [String]
    public var suggestedKits: [String]
    public var context: IdeaContext
    public var mlMetadata: MLMetadata
    public let createdAt: Date
    public var updatedAt: Date
    public var status: IdeaStatus
    
    public init(
        name: String,
        description: String,
        category: AppCategory,
        kind: AppKind = .standalone,
        type: AppType = .utility
    ) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.category = category
        self.kind = kind
        self.type = type
        self.complexity = .medium
        self.tags = []
        self.features = []
        self.requiredKits = []
        self.suggestedKits = []
        self.context = IdeaContext()
        self.mlMetadata = MLMetadata()
        self.createdAt = Date()
        self.updatedAt = Date()
        self.status = .draft
    }
}

// MARK: - App Category

public enum AppCategory: String, Codable, Sendable, CaseIterable {
    // Developer Tools
    case developerTool = "Developer Tool"
    case builderTool = "Builder Tool"
    case cliTool = "CLI Tool"
    case codeAnalysis = "Code Analysis"
    case documentation = "Documentation"
    
    // AI & Intelligence
    case aiFirst = "AI-First"
    case mlPowered = "ML-Powered"
    case automation = "Automation"
    case assistant = "Assistant"
    
    // Productivity
    case productivity = "Productivity"
    case organization = "Organization"
    case planning = "Planning"
    case tracking = "Tracking"
    
    // Learning
    case learning = "Learning"
    case skillBuilding = "Skill Building"
    case education = "Education"
    
    // Business
    case startup = "Startup"
    case business = "Business"
    case enterprise = "Enterprise"
    case marketplace = "Marketplace"
    
    // Consumer
    case consumer = "Consumer"
    case lifestyle = "Lifestyle"
    case social = "Social"
    
    // Meta
    case metaApp = "Meta-App"
    case framework = "Framework"
    case platform = "Platform"
}

// MARK: - App Kind

public enum AppKind: String, Codable, Sendable, CaseIterable {
    case standalone = "Standalone App"
    case package = "Reusable Package"
    case cli = "Command Line Tool"
    case service = "Background Service"
    case plugin = "Plugin/Extension"
    case widget = "Widget"
    case api = "API Service"
    case library = "Library"
    case framework = "Framework"
    case template = "Template"
}

// MARK: - App Type

public enum AppType: String, Codable, Sendable, CaseIterable {
    case utility = "Utility"
    case generator = "Generator"
    case analyzer = "Analyzer"
    case converter = "Converter"
    case manager = "Manager"
    case tracker = "Tracker"
    case builder = "Builder"
    case assistant = "Assistant"
    case dashboard = "Dashboard"
    case marketplace = "Marketplace"
    case engine = "Engine"
    case compiler = "Compiler"
    case orchestrator = "Orchestrator"
}

// MARK: - Complexity

public enum Complexity: String, Codable, Sendable, CaseIterable {
    case trivial = "Trivial"      // < 1 day
    case simple = "Simple"        // 1-3 days
    case medium = "Medium"        // 1-2 weeks
    case complex = "Complex"      // 2-4 weeks
    case advanced = "Advanced"    // 1-3 months
    case enterprise = "Enterprise" // 3+ months
    
    public var estimatedDays: ClosedRange<Int> {
        switch self {
        case .trivial: return 0...1
        case .simple: return 1...3
        case .medium: return 7...14
        case .complex: return 14...28
        case .advanced: return 30...90
        case .enterprise: return 90...365
        }
    }
}

// MARK: - Idea Status

public enum IdeaStatus: String, Codable, Sendable, CaseIterable {
    case draft = "Draft"
    case refined = "Refined"
    case validated = "Validated"
    case planned = "Planned"
    case inProgress = "In Progress"
    case generated = "Generated"
    case completed = "Completed"
    case archived = "Archived"
}

// MARK: - Feature

public struct Feature: Identifiable, Codable, Sendable {
    public let id: String
    public var name: String
    public var description: String
    public var priority: Priority
    public var requiredKits: [String]
    
    public init(name: String, description: String, priority: Priority = .medium) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.priority = priority
        self.requiredKits = []
    }
}

public enum Priority: String, Codable, Sendable, CaseIterable {
    case critical, high, medium, low, nice
}

// MARK: - Idea Context

public struct IdeaContext: Codable, Sendable {
    public var problemStatement: String
    public var targetAudience: String
    public var useCases: [String]
    public var constraints: [String]
    public var inspirations: [String]
    public var competitors: [String]
    public var differentiators: [String]
    
    public init() {
        self.problemStatement = ""
        self.targetAudience = ""
        self.useCases = []
        self.constraints = []
        self.inspirations = []
        self.competitors = []
        self.differentiators = []
    }
}

// MARK: - ML Metadata

public struct MLMetadata: Codable, Sendable {
    public var embedding: [Float]?
    public var similarIdeas: [String]
    public var predictedComplexity: Complexity?
    public var predictedKits: [String]
    public var confidenceScore: Float
    public var keywords: [String]
    public var topics: [String]
    
    public init() {
        self.embedding = nil
        self.similarIdeas = []
        self.predictedComplexity = nil
        self.predictedKits = []
        self.confidenceScore = 0
        self.keywords = []
        self.topics = []
    }
}
