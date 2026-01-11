//
//  Artifacts.swift
//  IdeaKit - Project Operating System
//
//  Data models for all artifacts produced by tools
//

import Foundation

// MARK: - Intent Artifacts

/// Structured project intent extracted from raw idea
public struct ProjectIntent: Codable, Sendable {
    public var problemStatement: String
    public var targetUser: String
    public var valueProposition: String
    public var projectType: ProjectType
    public var nonGoals: [String]
    public var constraints: [String]
    public var successCriteria: [String]
    
    public init(
        problemStatement: String = "",
        targetUser: String = "",
        valueProposition: String = "",
        projectType: ProjectType = .app,
        nonGoals: [String] = [],
        constraints: [String] = [],
        successCriteria: [String] = []
    ) {
        self.problemStatement = problemStatement
        self.targetUser = targetUser
        self.valueProposition = valueProposition
        self.projectType = projectType
        self.nonGoals = nonGoals
        self.constraints = constraints
        self.successCriteria = successCriteria
    }
}

public enum ProjectType: String, Codable, CaseIterable, Sendable {
    case app = "app"
    case library = "library"
    case saas = "saas"
    case cli = "cli"
    case framework = "framework"
    case plugin = "plugin"
    case api = "api"
    case other = "other"
}

// MARK: - Assumption Artifacts

/// Tracked assumption with confidence score
public struct Assumption: Codable, Sendable, Identifiable {
    public var id: UUID
    public var category: AssumptionCategory
    public var statement: String
    public var confidence: Double // 0.0 - 1.0
    public var validatedAt: Date?
    public var validationResult: Bool?
    public var notes: String
    
    public init(
        id: UUID = UUID(),
        category: AssumptionCategory,
        statement: String,
        confidence: Double = 0.5,
        validatedAt: Date? = nil,
        validationResult: Bool? = nil,
        notes: String = ""
    ) {
        self.id = id
        self.category = category
        self.statement = statement
        self.confidence = confidence
        self.validatedAt = validatedAt
        self.validationResult = validationResult
        self.notes = notes
    }
}

public enum AssumptionCategory: String, Codable, CaseIterable, Sendable {
    case technical = "technical"
    case userBehavior = "user_behavior"
    case market = "market"
    case timeline = "timeline"
    case skill = "skill"
    case resource = "resource"
}

public struct AssumptionSet: Codable, Sendable {
    public var assumptions: [Assumption]
    public var createdAt: Date
    public var lastUpdated: Date
    
    public init(assumptions: [Assumption] = []) {
        self.assumptions = assumptions
        self.createdAt = Date()
        self.lastUpdated = Date()
    }
}

// MARK: - Specification Artifacts

/// Generated specification
public struct Specification: Codable, Sendable {
    public var requirements: String
    public var functional: String
    public var nonFunctional: String
    public var acceptanceCriteria: [AcceptanceCriterion]
    
    public init(
        requirements: String = "",
        functional: String = "",
        nonFunctional: String = "",
        acceptanceCriteria: [AcceptanceCriterion] = []
    ) {
        self.requirements = requirements
        self.functional = functional
        self.nonFunctional = nonFunctional
        self.acceptanceCriteria = acceptanceCriteria
    }
}

public struct AcceptanceCriterion: Codable, Sendable, Identifiable {
    public var id: UUID
    public var feature: String
    public var given: String
    public var when: String
    public var then: String
    
    public init(id: UUID = UUID(), feature: String, given: String, when: String, then: String) {
        self.id = id
        self.feature = feature
        self.given = given
        self.when = when
        self.then = then
    }
}

// MARK: - Scope Artifacts

/// Project scope definition
public struct ScopeDefinition: Codable, Sendable {
    public var mvpFeatures: [ScopedFeature]
    public var niceToHave: [ScopedFeature]
    public var outOfScope: [ScopedFeature]
    public var mvpGates: [MVPGate]
    
    public init(
        mvpFeatures: [ScopedFeature] = [],
        niceToHave: [ScopedFeature] = [],
        outOfScope: [ScopedFeature] = [],
        mvpGates: [MVPGate] = []
    ) {
        self.mvpFeatures = mvpFeatures
        self.niceToHave = niceToHave
        self.outOfScope = outOfScope
        self.mvpGates = mvpGates
    }
}

public struct ScopedFeature: Codable, Sendable, Identifiable {
    public var id: UUID
    public var name: String
    public var description: String
    public var priority: FeaturePriority
    public var effort: EffortEstimate
    
    public init(id: UUID = UUID(), name: String, description: String = "", priority: FeaturePriority = .medium, effort: EffortEstimate = .medium) {
        self.id = id
        self.name = name
        self.description = description
        self.priority = priority
        self.effort = effort
    }
}

public enum FeaturePriority: String, Codable, CaseIterable, Sendable {
    case critical, high, medium, low
}

public enum EffortEstimate: String, Codable, CaseIterable, Sendable {
    case trivial, small, medium, large, epic
}

public struct MVPGate: Codable, Sendable, Identifiable {
    public var id: UUID
    public var name: String
    public var criteria: String
    public var passed: Bool
    
    public init(id: UUID = UUID(), name: String, criteria: String, passed: Bool = false) {
        self.id = id
        self.name = name
        self.criteria = criteria
        self.passed = passed
    }
}

// MARK: - Task Artifacts

/// Decomposed task
public struct ProjectTask: Codable, Sendable, Identifiable {
    public var id: UUID
    public var title: String
    public var description: String
    public var milestone: String
    public var effort: EffortEstimate
    public var confidence: Double
    public var dependencies: [UUID]
    public var status: TaskStatus
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        milestone: String = "",
        effort: EffortEstimate = .medium,
        confidence: Double = 0.7,
        dependencies: [UUID] = [],
        status: TaskStatus = .pending
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.milestone = milestone
        self.effort = effort
        self.confidence = confidence
        self.dependencies = dependencies
        self.status = status
    }
}

public enum TaskStatus: String, Codable, CaseIterable, Sendable {
    case pending, inProgress, blocked, completed, cancelled
}

public struct TaskDecomposition: Codable, Sendable {
    public var tasks: [ProjectTask]
    public var milestones: [ProjectMilestone]
    
    public init(tasks: [ProjectTask] = [], milestones: [ProjectMilestone] = []) {
        self.tasks = tasks
        self.milestones = milestones
    }
}

public struct ProjectMilestone: Codable, Sendable, Identifiable {
    public var id: UUID
    public var name: String
    public var description: String
    public var targetDate: Date?
    public var taskIds: [UUID]
    
    public init(id: UUID = UUID(), name: String, description: String = "", targetDate: Date? = nil, taskIds: [UUID] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.targetDate = targetDate
        self.taskIds = taskIds
    }
}

// MARK: - Architecture Artifacts

/// Architecture recommendation
public struct ArchitectureRecommendation: Codable, Sendable {
    public var pattern: ArchitecturePattern
    public var modules: [ModuleDefinition]
    public var boundaries: [BoundaryDefinition]
    public var rationale: String
    
    public init(
        pattern: ArchitecturePattern = .mvvm,
        modules: [ModuleDefinition] = [],
        boundaries: [BoundaryDefinition] = [],
        rationale: String = ""
    ) {
        self.pattern = pattern
        self.modules = modules
        self.boundaries = boundaries
        self.rationale = rationale
    }
}

public enum ArchitecturePattern: String, Codable, CaseIterable, Sendable {
    case mvc, mvvm, clean, hexagonal, modular, microservices, serverless
}

public struct ModuleDefinition: Codable, Sendable, Identifiable {
    public var id: UUID
    public var name: String
    public var responsibility: String
    public var dependencies: [String]
    
    public init(id: UUID = UUID(), name: String, responsibility: String = "", dependencies: [String] = []) {
        self.id = id
        self.name = name
        self.responsibility = responsibility
        self.dependencies = dependencies
    }
}

public struct BoundaryDefinition: Codable, Sendable, Identifiable {
    public var id: UUID
    public var name: String
    public var type: BoundaryType
    public var modules: [String]
    
    public init(id: UUID = UUID(), name: String, type: BoundaryType = .layer, modules: [String] = []) {
        self.id = id
        self.name = name
        self.type = type
        self.modules = modules
    }
}

public enum BoundaryType: String, Codable, CaseIterable, Sendable {
    case layer, feature, domain, infrastructure
}

// MARK: - Risk Artifacts

/// Identified risk
public struct Risk: Codable, Sendable, Identifiable {
    public var id: UUID
    public var category: RiskCategory
    public var description: String
    public var severity: RiskSeverity
    public var likelihood: RiskLikelihood
    public var mitigation: String
    public var status: RiskStatus
    
    public init(
        id: UUID = UUID(),
        category: RiskCategory,
        description: String,
        severity: RiskSeverity = .medium,
        likelihood: RiskLikelihood = .possible,
        mitigation: String = "",
        status: RiskStatus = .identified
    ) {
        self.id = id
        self.category = category
        self.description = description
        self.severity = severity
        self.likelihood = likelihood
        self.mitigation = mitigation
        self.status = status
    }
}

public enum RiskCategory: String, Codable, CaseIterable, Sendable {
    case technical, timeline, dependency, skill, resource, scope
}

public enum RiskSeverity: String, Codable, CaseIterable, Sendable {
    case critical, high, medium, low
}

public enum RiskLikelihood: String, Codable, CaseIterable, Sendable {
    case certain, likely, possible, unlikely, rare
}

public enum RiskStatus: String, Codable, CaseIterable, Sendable {
    case identified, mitigating, mitigated, accepted, occurred
}

public struct RiskAnalysis: Codable, Sendable {
    public var risks: [Risk]
    public var overallRiskScore: Double
    public var analyzedAt: Date
    
    public init(risks: [Risk] = [], overallRiskScore: Double = 0) {
        self.risks = risks
        self.overallRiskScore = overallRiskScore
        self.analyzedAt = Date()
    }
}
