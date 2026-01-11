//
//  UnderstandingModels.swift
//  AIKit - Understanding Engine Models
//

import Foundation

// MARK: - Understanding Result

public struct UnderstandingResult: Sendable {
    public let input: String
    public let intent: ExtractedIntent
    public let entities: [Entity]
    public let constraints: [Constraint]
    public let risks: [Risk]
    public let unknowns: [Unknown]
    public let assumptions: [Assumption]
    public let ambiguities: [Ambiguity]
    public let contradictions: [Contradiction]
    public let confidence: Float
    public let processingTime: TimeInterval
}

// MARK: - Intent

public struct ExtractedIntent: Sendable {
    public let type: IntentType
    public let action: String
    public let target: String
    public let confidence: Float
    public let rawText: String
}

public enum IntentType: String, Sendable, CaseIterable {
    case create, build, analyze, search, update, delete, help
    case optimize, debug, deploy, test
    case plan, measure, decide, evaluate
    case unknown
}

public struct IntentModel: Sendable {
    public let id: String
    public let patterns: [IntentPattern]
}

public struct IntentPattern: Sendable {
    public let keywords: [String]
    public let intentType: IntentType
    public let confidence: Float
}

// MARK: - Entity

public struct Entity: Sendable {
    public let value: String
    public let type: EntityType
    public let confidence: Float
}

public enum EntityType: String, Sendable, CaseIterable {
    case technology, action, person, organization, location, time, quantity, concept
}

// MARK: - Constraint

public struct Constraint: Sendable {
    public let type: ConstraintType
    public let description: String
    public let severity: ConstraintSeverity
}

public enum ConstraintType: String, Sendable {
    case time, resource, technical, business, legal, scope
}

public enum ConstraintSeverity: String, Sendable {
    case hard, soft, preference
}

// MARK: - Risk

public struct Risk: Sendable {
    public let description: String
    public let category: RiskCategory
    public let likelihood: RiskLevel
    public let impact: RiskLevel
}

public enum RiskCategory: String, Sendable {
    case technical, business, timeline, resource, dependency, security
}

public enum RiskLevel: String, Sendable {
    case low, medium, high, critical
}

// MARK: - Unknown

public struct Unknown: Sendable {
    public let area: String
    public let description: String
    public let priority: Priority
}

public enum Priority: String, Sendable {
    case low, medium, high, critical
}

// MARK: - Assumption

public struct Assumption: Sendable {
    public let assumption: String
    public let category: AssumptionCategory
    public let risk: RiskLevel
    public let validationSuggestion: String
}

public enum AssumptionCategory: String, Sendable {
    case technical, business, timeline, resource, user
}

// MARK: - Ambiguity

public struct Ambiguity: Sendable {
    public let text: String
    public let type: AmbiguityType
    public let location: Int
    public let suggestion: String
    public let severity: AmbiguitySeverity
}

public enum AmbiguityType: String, Sendable {
    case vagueQuantifier, unclearReference, passiveVoice, missingSubject, undefinedTerm
}

public enum AmbiguitySeverity: String, Sendable {
    case low, medium, high
}

// MARK: - Contradiction

public struct Contradiction: Sendable {
    public let statement1: String
    public let statement2: String
    public let conflictType: ConflictType
    public let resolution: String
}

public enum ConflictType: String, Sendable {
    case logical, temporal, scope, priority
}

// MARK: - Inferred Requirements

public struct InferredRequirements: Sendable {
    public let explicit: [String]
    public let inferred: [InferredRequirement]
    public let gaps: [RequirementGap]
    public let completenessScore: Float
}

public struct InferredRequirement: Sendable {
    public let requirement: String
    public let source: String
    public let confidence: Float
}

public struct RequirementGap: Sendable {
    public let area: String
    public let description: String
    public let priority: Priority
}

// MARK: - Context

public struct UnderstandingContext: Sendable {
    public let domain: String
    public let previousStatements: [String]
    public let metadata: [String: String]
    
    public init(domain: String = "general", previousStatements: [String] = [], metadata: [String: String] = [:]) {
        self.domain = domain
        self.previousStatements = previousStatements
        self.metadata = metadata
    }
}

// MARK: - Execution Log

public struct UnderstandingExecution: Sendable {
    public let input: String
    public let result: UnderstandingResult
    public let timestamp: Date
}

// MARK: - Stats

public struct UnderstandingStats: Sendable {
    public let totalAnalyses: Int
    public let cacheHitRate: Float
    public let averageConfidence: Float
    public let modelCount: Int
}
