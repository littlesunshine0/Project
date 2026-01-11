//
//  Artifact.swift
//  IdeaKit - Project Operating System
//
//  Base protocol for all artifacts in the system
//  Artifacts are the outputs of packages and inputs to other packages
//

import Foundation

/// Protocol for all artifacts in the system
/// Artifacts are structured outputs that packages produce and consume
public protocol Artifact: Codable, Sendable {
    /// Unique identifier for this artifact instance
    var artifactId: String { get }
    
    /// The type/kind of artifact
    static var artifactType: String { get }
    
    /// Schema version for migration support
    static var schemaVersion: Int { get }
    
    /// Render to markdown (for human-readable output)
    func toMarkdown() -> String
    
    /// Render to JSON (for machine-readable output)
    func toJSON() throws -> Data
}

// MARK: - Default Implementations

extension Artifact {
    public static var schemaVersion: Int { 1 }
    
    public func toJSON() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(self)
    }
}

// MARK: - Concrete Artifact Types

/// Intent artifact - output of ProjectIntentAnalyzer
public struct IntentArtifact: Artifact {
    public static let artifactType = "intent"
    public var artifactId: String { "intent_\(id.uuidString.prefix(8))" }
    
    public let id: UUID
    public var problemStatement: String
    public var targetUser: String
    public var valueProposition: String
    public var projectType: ProjectType
    public var nonGoals: [String]
    public var constraints: [String]
    public var successCriteria: [String]
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        problemStatement: String = "",
        targetUser: String = "",
        valueProposition: String = "",
        projectType: ProjectType = .app,
        nonGoals: [String] = [],
        constraints: [String] = [],
        successCriteria: [String] = []
    ) {
        self.id = id
        self.problemStatement = problemStatement
        self.targetUser = targetUser
        self.valueProposition = valueProposition
        self.projectType = projectType
        self.nonGoals = nonGoals
        self.constraints = constraints
        self.successCriteria = successCriteria
        self.createdAt = Date()
    }
    
    public func toMarkdown() -> String {
        """
        # Project Intent
        
        ## Problem Statement
        \(problemStatement)
        
        ## Target User
        \(targetUser)
        
        ## Value Proposition
        \(valueProposition)
        
        ## Project Type
        \(projectType.rawValue.capitalized)
        
        ## Success Criteria
        \(successCriteria.enumerated().map { index, criterion in "\\(index + 1). \\(criterion)" }.joined(separator: "\n"))
        
        ## Constraints
        \(constraints.map { "- \($0)" }.joined(separator: "\n"))
        
        ## Non-Goals
        \(nonGoals.map { "- \($0)" }.joined(separator: "\n"))
        """
    }
}

/// Requirements artifact - output of SpecGenerator
public struct RequirementsArtifact: Artifact {
    public static let artifactType = "requirements"
    public var artifactId: String { "requirements_\(id.uuidString.prefix(8))" }
    
    public let id: UUID
    public var functional: [Requirement]
    public var nonFunctional: [Requirement]
    public var acceptanceCriteria: [AcceptanceCriterion]
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        functional: [Requirement] = [],
        nonFunctional: [Requirement] = [],
        acceptanceCriteria: [AcceptanceCriterion] = []
    ) {
        self.id = id
        self.functional = functional
        self.nonFunctional = nonFunctional
        self.acceptanceCriteria = acceptanceCriteria
        self.createdAt = Date()
    }
    
    public func toMarkdown() -> String {
        var md = "# Requirements\n\n"
        
        md += "## Functional Requirements\n\n"
        for req in functional {
            md += "### \(req.id): \(req.title)\n\n"
            md += "\(req.description)\n\n"
            md += "- Priority: \(req.priority.rawValue)\n"
            md += "- Status: \(req.status.rawValue)\n\n"
        }
        
        md += "## Non-Functional Requirements\n\n"
        for req in nonFunctional {
            md += "- **\(req.id)**: \(req.description)\n"
        }
        
        return md
    }
}

public struct Requirement: Codable, Sendable, Identifiable {
    public var id: String
    public var title: String
    public var description: String
    public var priority: FeaturePriority
    public var status: RequirementStatus
    
    public init(id: String, title: String, description: String = "", priority: FeaturePriority = .medium, status: RequirementStatus = .draft) {
        self.id = id
        self.title = title
        self.description = description
        self.priority = priority
        self.status = status
    }
}

public enum RequirementStatus: String, Codable, Sendable {
    case draft, approved, implemented, verified
}

/// Architecture artifact - output of ArchitectureSynthesizer
public struct ArchitectureArtifact: Artifact {
    public static let artifactType = "architecture"
    public var artifactId: String { "architecture_\(id.uuidString.prefix(8))" }
    
    public let id: UUID
    public var pattern: ArchitecturePattern
    public var modules: [ModuleDefinition]
    public var boundaries: [BoundaryDefinition]
    public var rationale: String
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        pattern: ArchitecturePattern = .mvvm,
        modules: [ModuleDefinition] = [],
        boundaries: [BoundaryDefinition] = [],
        rationale: String = ""
    ) {
        self.id = id
        self.pattern = pattern
        self.modules = modules
        self.boundaries = boundaries
        self.rationale = rationale
        self.createdAt = Date()
    }
    
    public func toMarkdown() -> String {
        var md = "# Architecture\n\n"
        md += "## Pattern: \(pattern.rawValue.uppercased())\n\n"
        md += "\(rationale)\n\n"
        
        md += "## Modules\n\n"
        for module in modules {
            md += "### \(module.name)\n\n"
            md += "\(module.responsibility)\n\n"
            if !module.dependencies.isEmpty {
                md += "Dependencies: \(module.dependencies.joined(separator: ", "))\n\n"
            }
        }
        
        return md
    }
}

/// Task artifact - output of TaskDecomposer
public struct TaskArtifact: Artifact {
    public static let artifactType = "tasks"
    public var artifactId: String { "tasks_\(id.uuidString.prefix(8))" }
    
    public let id: UUID
    public var tasks: [ProjectTask]
    public var milestones: [ProjectMilestone]
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        tasks: [ProjectTask] = [],
        milestones: [ProjectMilestone] = []
    ) {
        self.id = id
        self.tasks = tasks
        self.milestones = milestones
        self.createdAt = Date()
    }
    
    public func toMarkdown() -> String {
        var md = "# Tasks\n\n"
        
        md += "## Summary\n\n"
        md += "- Total Tasks: \(tasks.count)\n"
        md += "- Milestones: \(milestones.count)\n\n"
        
        for milestone in milestones {
            md += "## \(milestone.name)\n\n"
            md += "\(milestone.description)\n\n"
            
            let milestoneTasks = tasks.filter { $0.milestone == milestone.name }
            for task in milestoneTasks {
                let status = task.status == .completed ? "✅" : "⏳"
                md += "- \(status) \(task.title)\n"
            }
            md += "\n"
        }
        
        return md
    }
}

/// Scope artifact - output of ScopeBoundaryEnforcer
public struct ScopeArtifact: Artifact {
    public static let artifactType = "scope"
    public var artifactId: String { "scope_\(id.uuidString.prefix(8))" }
    
    public let id: UUID
    public var mvpFeatures: [ScopedFeature]
    public var niceToHave: [ScopedFeature]
    public var outOfScope: [ScopedFeature]
    public var mvpGates: [MVPGate]
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        mvpFeatures: [ScopedFeature] = [],
        niceToHave: [ScopedFeature] = [],
        outOfScope: [ScopedFeature] = [],
        mvpGates: [MVPGate] = []
    ) {
        self.id = id
        self.mvpFeatures = mvpFeatures
        self.niceToHave = niceToHave
        self.outOfScope = outOfScope
        self.mvpGates = mvpGates
        self.createdAt = Date()
    }
    
    public func toMarkdown() -> String {
        var md = "# Scope Definition\n\n"
        
        md += "## MVP Features\n\n"
        for feature in mvpFeatures {
            md += "- **\(feature.name)**: \(feature.description)\n"
        }
        
        md += "\n## Nice to Have\n\n"
        for feature in niceToHave {
            md += "- \(feature.name): \(feature.description)\n"
        }
        
        md += "\n## Out of Scope\n\n"
        for feature in outOfScope {
            md += "- ~~\(feature.name)~~: \(feature.description)\n"
        }
        
        return md
    }
}

/// Risk artifact - output of RiskAnalyzer
public struct RiskArtifact: Artifact {
    public static let artifactType = "risks"
    public var artifactId: String { "risks_\(id.uuidString.prefix(8))" }
    
    public let id: UUID
    public var risks: [Risk]
    public var overallScore: Double
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        risks: [Risk] = [],
        overallScore: Double = 0
    ) {
        self.id = id
        self.risks = risks
        self.overallScore = overallScore
        self.createdAt = Date()
    }
    
    public func toMarkdown() -> String {
        var md = "# Risk Analysis\n\n"
        md += "Overall Risk Score: \(Int(overallScore * 100))%\n\n"
        
        for risk in risks.sorted(by: { $0.severity.rawValue > $1.severity.rawValue }) {
            let emoji = risk.severity == .critical ? "🔴" : risk.severity == .high ? "🟠" : "🟡"
            md += "## \(emoji) \(risk.description)\n\n"
            md += "- Category: \(risk.category.rawValue)\n"
            md += "- Severity: \(risk.severity.rawValue)\n"
            md += "- Mitigation: \(risk.mitigation)\n\n"
        }
        
        return md
    }
}

/// Assumption artifact - output of AssumptionTracker
public struct AssumptionArtifact: Artifact {
    public static let artifactType = "assumptions"
    public var artifactId: String { "assumptions_\(id.uuidString.prefix(8))" }
    
    public let id: UUID
    public var assumptions: [Assumption]
    public var createdAt: Date
    
    public init(id: UUID = UUID(), assumptions: [Assumption] = []) {
        self.id = id
        self.assumptions = assumptions
        self.createdAt = Date()
    }
    
    public func toMarkdown() -> String {
        var md = "# Assumptions\n\n"
        
        let grouped = Dictionary(grouping: assumptions, by: { $0.category })
        
        for category in AssumptionCategory.allCases {
            guard let items = grouped[category], !items.isEmpty else { continue }
            
            md += "## \(category.rawValue.capitalized)\n\n"
            for assumption in items {
                let confidence = Int(assumption.confidence * 100)
                let emoji = confidence > 70 ? "🟢" : confidence > 40 ? "🟡" : "🔴"
                md += "- \(emoji) \(assumption.statement) (\(confidence)% confidence)\n"
            }
            md += "\n"
        }
        
        return md
    }
}


// MARK: - Universal Capability Artifacts

/// Context artifact - output of ContextCapability
public struct ContextArtifact: Artifact {
    public static let artifactType = "context"
    public var artifactId: String { "context_\(id.uuidString.prefix(8))" }
    
    public let id: UUID
    public var constraints: [ProjectConstraint]
    public var assumptions: [Assumption]
    public var dependencies: [ProjectDependency]
    public var environment: ProjectEnvironment
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        constraints: [ProjectConstraint] = [],
        assumptions: [Assumption] = [],
        dependencies: [ProjectDependency] = [],
        environment: ProjectEnvironment = ProjectEnvironment()
    ) {
        self.id = id
        self.constraints = constraints
        self.assumptions = assumptions
        self.dependencies = dependencies
        self.environment = environment
        self.createdAt = Date()
    }
    
    public func toMarkdown() -> String {
        var md = "# Project Context\n\n"
        
        md += "## Environment\n\n"
        md += "- Platform: \(environment.platform)\n"
        md += "- Runtime: \(environment.runtime)\n"
        md += "- Tools: \(environment.tools.joined(separator: ", "))\n\n"
        
        md += "## Constraints\n\n"
        for c in constraints {
            let emoji = c.severity == .high ? "🔴" : c.severity == .medium ? "🟡" : "🟢"
            md += "- \(emoji) **\(c.type.rawValue.capitalized)**: \(c.description)\n"
        }
        
        md += "\n## Dependencies\n\n"
        for d in dependencies {
            let req = d.required ? "(required)" : "(optional)"
            md += "- \(d.name) \(req)\n"
        }
        
        return md
    }
}

public struct ProjectConstraint: Codable, Sendable {
    public var type: ConstraintType
    public var description: String
    public var severity: ConstraintSeverity
    
    public init(type: ConstraintType, description: String, severity: ConstraintSeverity = .medium) {
        self.type = type
        self.description = description
        self.severity = severity
    }
}

public enum ConstraintType: String, Codable, Sendable {
    case time, budget, technical, regulatory, resource, skill
}

public enum ConstraintSeverity: String, Codable, Sendable {
    case low, medium, high
}

public struct ProjectDependency: Codable, Sendable {
    public var name: String
    public var type: ProjectDependencyType
    public var required: Bool
    
    public init(name: String, type: ProjectDependencyType, required: Bool = true) {
        self.name = name
        self.type = type
        self.required = required
    }
}

public enum ProjectDependencyType: String, Codable, Sendable {
    case platform, library, service, tool, team
}

public struct ProjectEnvironment: Codable, Sendable {
    public var platform: String
    public var runtime: String
    public var tools: [String]
    
    public init(platform: String = "", runtime: String = "", tools: [String] = []) {
        self.platform = platform
        self.runtime = runtime
        self.tools = tools
    }
}

/// Decision artifact - output of DecisionCapability
public struct DecisionArtifact: Artifact {
    public static let artifactType = "decisions"
    public var artifactId: String { "decisions_\(id.uuidString.prefix(8))" }
    
    public let id: UUID
    public var decisions: [ProjectDecision]
    public var tradeoffs: [ProjectTradeoff]
    public var createdAt: Date
    
    public init(id: UUID = UUID(), decisions: [ProjectDecision] = [], tradeoffs: [ProjectTradeoff] = []) {
        self.id = id
        self.decisions = decisions
        self.tradeoffs = tradeoffs
        self.createdAt = Date()
    }
    
    public func toMarkdown() -> String {
        var md = "# Decision Log\n\n"
        
        if decisions.isEmpty {
            md += "_No decisions recorded yet._\n\n"
        } else {
            for d in decisions {
                md += "## \(d.title)\n\n"
                md += "**Status**: \(d.status.rawValue)\n\n"
                md += "\(d.context)\n\n"
                md += "**Decision**: \(d.decision)\n\n"
                md += "**Rationale**: \(d.rationale)\n\n"
                md += "---\n\n"
            }
        }
        
        return md
    }
}

public struct ProjectDecision: Codable, Sendable, Identifiable {
    public var id: UUID
    public var title: String
    public var context: String
    public var decision: String
    public var rationale: String
    public var alternatives: [String]
    public var status: ProjectDecisionStatus
    public var date: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        context: String = "",
        decision: String = "",
        rationale: String = "",
        alternatives: [String] = [],
        status: ProjectDecisionStatus = .proposed
    ) {
        self.id = id
        self.title = title
        self.context = context
        self.decision = decision
        self.rationale = rationale
        self.alternatives = alternatives
        self.status = status
        self.date = Date()
    }
}

public enum ProjectDecisionStatus: String, Codable, Sendable {
    case proposed, accepted, deprecated, superseded
}

public struct ProjectTradeoff: Codable, Sendable {
    public var description: String
    public var pros: [String]
    public var cons: [String]
    
    public init(description: String, pros: [String] = [], cons: [String] = []) {
        self.description = description
        self.pros = pros
        self.cons = cons
    }
}

/// Feedback artifact - output of FeedbackCapability
public struct FeedbackArtifact: Artifact {
    public static let artifactType = "feedback"
    public var artifactId: String { "feedback_\(id.uuidString.prefix(8))" }
    
    public let id: UUID
    public var loops: [ProjectFeedbackLoop]
    public var lessons: [ProjectLesson]
    public var createdAt: Date
    
    public init(id: UUID = UUID(), loops: [ProjectFeedbackLoop] = [], lessons: [ProjectLesson] = []) {
        self.id = id
        self.loops = loops
        self.lessons = lessons
        self.createdAt = Date()
    }
    
    public func toMarkdown() -> String {
        var md = "# Feedback & Learning\n\n"
        
        md += "## Feedback Loops\n\n"
        if loops.isEmpty {
            md += "_No feedback loops defined yet._\n\n"
        } else {
            for loop in loops {
                md += "### \(loop.name)\n\n"
                md += "- Trigger: \(loop.trigger)\n"
                md += "- Frequency: \(loop.frequency)\n\n"
            }
        }
        
        md += "## Lessons Learned\n\n"
        if lessons.isEmpty {
            md += "_No lessons recorded yet._\n\n"
        } else {
            for lesson in lessons {
                md += "- **\(lesson.title)**: \(lesson.insight)\n"
            }
        }
        
        return md
    }
}

public struct ProjectFeedbackLoop: Codable, Sendable {
    public var name: String
    public var trigger: String
    public var frequency: String
    public var actions: [String]
    
    public init(name: String, trigger: String, frequency: String, actions: [String] = []) {
        self.name = name
        self.trigger = trigger
        self.frequency = frequency
        self.actions = actions
    }
}

public struct ProjectLesson: Codable, Sendable {
    public var title: String
    public var insight: String
    public var date: Date
    
    public init(title: String, insight: String) {
        self.title = title
        self.insight = insight
        self.date = Date()
    }
}

/// Outcome artifact - output of OutcomeCapability
public struct OutcomeArtifact: Artifact {
    public static let artifactType = "outcome"
    public var artifactId: String { "outcome_\(id.uuidString.prefix(8))" }
    
    public let id: UUID
    public var acceptanceCriteria: [OutcomeAcceptanceCriterion]
    public var validationMethods: [OutcomeValidationMethod]
    public var successMetrics: [OutcomeSuccessMetric]
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        acceptanceCriteria: [OutcomeAcceptanceCriterion] = [],
        validationMethods: [OutcomeValidationMethod] = [],
        successMetrics: [OutcomeSuccessMetric] = []
    ) {
        self.id = id
        self.acceptanceCriteria = acceptanceCriteria
        self.validationMethods = validationMethods
        self.successMetrics = successMetrics
        self.createdAt = Date()
    }
    
    public func toMarkdown() -> String {
        var md = "# Outcome Definition\n\n"
        
        md += "## Acceptance Criteria\n\n"
        for ac in acceptanceCriteria {
            let status = ac.verified ? "✅" : "⏳"
            md += "- \(status) \(ac.description)\n"
        }
        
        md += "\n## Validation Methods\n\n"
        for vm in validationMethods {
            md += "### \(vm.name)\n\n\(vm.description)\n\n"
        }
        
        md += "## Success Metrics\n\n"
        for sm in successMetrics {
            md += "- **\(sm.name)**: \(sm.target)\n"
        }
        
        return md
    }
}

public struct OutcomeAcceptanceCriterion: Codable, Sendable {
    public var id: String
    public var description: String
    public var verified: Bool
    
    public init(id: String, description: String, verified: Bool = false) {
        self.id = id
        self.description = description
        self.verified = verified
    }
}

public struct OutcomeValidationMethod: Codable, Sendable {
    public var name: String
    public var description: String
    
    public init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}

public struct OutcomeSuccessMetric: Codable, Sendable {
    public var name: String
    public var target: String
    
    public init(name: String, target: String) {
        self.name = name
        self.target = target
    }
}

// MARK: - Extended Types for Universal Capabilities

public struct ArchitectureLayer: Codable, Sendable {
    public var name: String
    public var responsibility: String
    
    public init(name: String, responsibility: String) {
        self.name = name
        self.responsibility = responsibility
    }
}

public struct CapabilityModule: Codable, Sendable {
    public var name: String
    public var purpose: String
    public var dependencies: [String]
    
    public init(name: String, purpose: String, dependencies: [String] = []) {
        self.name = name
        self.purpose = purpose
        self.dependencies = dependencies
    }
}

public struct CapabilityBoundary: Codable, Sendable {
    public var name: String
    public var type: CapabilityBoundaryKind
    public var rules: [String]
    
    public init(name: String, type: CapabilityBoundaryKind, rules: [String] = []) {
        self.name = name
        self.type = type
        self.rules = rules
    }
}

public enum CapabilityBoundaryKind: String, Codable, Sendable {
    case external, `internal`, module
}

public struct CapabilityTask: Codable, Sendable {
    public var id: String
    public var title: String
    public var priority: CapabilityTaskPriority
    public var status: CapabilityTaskStatus
    
    public init(id: String, title: String, priority: CapabilityTaskPriority = .medium, status: CapabilityTaskStatus = .pending) {
        self.id = id
        self.title = title
        self.priority = priority
        self.status = status
    }
}

public enum CapabilityTaskPriority: String, Codable, Sendable {
    case low, medium, high, critical
}

public enum CapabilityTaskStatus: String, Codable, Sendable {
    case pending, inProgress, completed, blocked
}

public struct CapabilityMilestone: Codable, Sendable {
    public var id: String
    public var name: String
    public var tasks: [String]
    public var targetDate: Date?
    
    public init(id: String, name: String, tasks: [String] = [], targetDate: Date? = nil) {
        self.id = id
        self.name = name
        self.tasks = tasks
        self.targetDate = targetDate
    }
}

public enum CapabilityRiskProbability: String, Codable, Sendable {
    case low, medium, high
    
    var toLikelihood: RiskLikelihood {
        switch self {
        case .low: return .unlikely
        case .medium: return .possible
        case .high: return .likely
        }
    }
}

public enum CapabilityRiskImpact: String, Codable, Sendable {
    case low, medium, high
    
    var toSeverity: RiskSeverity {
        switch self {
        case .low: return .low
        case .medium: return .medium
        case .high: return .high
        }
    }
}

public enum CapabilityRiskCategory: String, Codable, Sendable {
    case scope, technical, schedule, resource
    
    var toRiskCategory: RiskCategory {
        switch self {
        case .scope: return .scope
        case .technical: return .technical
        case .schedule: return .timeline
        case .resource: return .resource
        }
    }
}
