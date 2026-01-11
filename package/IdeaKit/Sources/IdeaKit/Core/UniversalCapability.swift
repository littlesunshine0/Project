//
//  UniversalCapability.swift
//  IdeaKit - Project Operating System
//
//  Universal Capability Packages - Domain Agnostic
//  These 8 capabilities exist in EVERY project, regardless of domain
//
//  A project is "a composition of reusable reasoning capabilities
//  that transform intent into outcomes under constraints"
//

import Foundation

// MARK: - Universal Capability Protocol

/// A capability is a reusable reasoning pattern that transforms intent into outcomes
/// These are invariant across all projects: software, research, writing, business, personal
public protocol UniversalCapability: Sendable {
    /// Unique identifier
    static var capabilityId: String { get }
    
    /// Human-readable name
    static var name: String { get }
    
    /// Core question this capability answers
    static var coreQuestion: String { get }
    
    /// Artifacts this capability produces
    static var artifacts: [String] { get }
    
    /// Execute the capability
    func execute(graph: ArtifactGraph, context: ProjectContext) async throws
}

// MARK: - Capability Error

public enum CapabilityError: Error, LocalizedError {
    case missingInput(String)
    case missingArtifact(String)
    case invalidState(String)
    
    public var errorDescription: String? {
        switch self {
        case .missingInput(let input): return "Missing required input: \(input)"
        case .missingArtifact(let artifact): return "Missing required artifact: \(artifact)"
        case .invalidState(let reason): return "Invalid state: \(reason)"
        }
    }
}

// MARK: - The 8 Universal Capabilities

// ═══════════════════════════════════════════════════════════════════════════════
// 1. INTENT - Why this exists
// ═══════════════════════════════════════════════════════════════════════════════

/// Answers: What problem? For whom? What success looks like?
public struct IntentCapability: UniversalCapability {
    public static let capabilityId = "intent"
    public static let name = "Intent"
    public static let coreQuestion = "Why does this project exist?"
    public static let artifacts = ["purpose.md", "success_criteria.md", "non_goals.md"]
    
    public init() {}
    
    public func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        guard let idea = context.getMetadata("idea") else {
            throw CapabilityError.missingInput("idea")
        }
        
        let artifact = IntentArtifact(
            problemStatement: extractProblem(from: idea),
            targetUser: extractTarget(from: idea),
            valueProposition: extractValue(from: idea),
            projectType: classifyType(from: idea),
            successCriteria: generateCriteria(from: idea)
        )
        
        await graph.register(artifact, producedBy: Self.capabilityId)
        try context.save(artifact: artifact.toMarkdown(), as: "purpose.md")
    }
    
    private func extractProblem(from idea: String) -> String {
        idea.components(separatedBy: ". ").first ?? idea
    }
    
    private func extractTarget(from idea: String) -> String {
        let keywords = ["user", "developer", "customer", "team", "people", "anyone"]
        for kw in keywords where idea.lowercased().contains(kw) {
            return kw.capitalized + "s"
        }
        return "Stakeholders"
    }
    
    private func extractValue(from idea: String) -> String {
        let valueWords = ["help", "enable", "allow", "make", "provide", "simplify"]
        let sentences = idea.components(separatedBy: ". ")
        for s in sentences where valueWords.contains(where: { s.lowercased().contains($0) }) {
            return s
        }
        return idea
    }
    
    private func classifyType(from idea: String) -> ProjectType {
        let l = idea.lowercased()
        if l.contains("app") { return .app }
        if l.contains("library") || l.contains("package") { return .library }
        return .other
    }
    
    private func generateCriteria(from idea: String) -> [String] {
        ["Core objective achieved", "Stakeholders satisfied", "Quality standards met", "Delivered on time"]
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 2. CONTEXT - Constraints & Environment
// ═══════════════════════════════════════════════════════════════════════════════

/// Answers: What constraints exist? What's the environment? What dependencies?
public struct ContextCapability: UniversalCapability {
    public static let capabilityId = "context"
    public static let name = "Context"
    public static let coreQuestion = "What are the constraints and environment?"
    public static let artifacts = ["constraints.md", "assumptions.md", "dependencies.md"]
    
    public init() {}
    
    public func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        // Get intent artifact to derive context
        guard let intent: IntentArtifact = await graph.get(ofType: IntentArtifact.self) else {
            throw CapabilityError.missingArtifact("IntentArtifact")
        }
        
        let contextArtifact = ContextArtifact(
            constraints: deriveConstraints(from: intent),
            assumptions: deriveAssumptions(from: intent),
            dependencies: deriveDependencies(from: intent),
            environment: deriveEnvironment(from: context)
        )
        
        await graph.register(contextArtifact, producedBy: Self.capabilityId)
        await graph.declareDependency(from: Self.capabilityId, to: IntentCapability.capabilityId)
        try context.save(artifact: contextArtifact.toMarkdown(), as: "context.md")
    }
    
    private func deriveConstraints(from intent: IntentArtifact) -> [ProjectConstraint] {
        var constraints: [ProjectConstraint] = []
        constraints.append(ProjectConstraint(type: .time, description: "Project timeline", severity: .medium))
        constraints.append(ProjectConstraint(type: .budget, description: "Resource allocation", severity: .medium))
        constraints.append(ProjectConstraint(type: .technical, description: "Platform requirements", severity: .high))
        return constraints
    }
    
    private func deriveAssumptions(from intent: IntentArtifact) -> [Assumption] {
        [
            Assumption(category: .technical, statement: "Target platform supports required features", confidence: 0.8),
            Assumption(category: .userBehavior, statement: "Users understand core workflow", confidence: 0.6),
            Assumption(category: .timeline, statement: "No major scope changes", confidence: 0.5)
        ]
    }
    
    private func deriveDependencies(from intent: IntentArtifact) -> [ProjectDependency] {
        [ProjectDependency(name: "Core Platform", type: .platform, required: true)]
    }
    
    private func deriveEnvironment(from context: ProjectContext) -> ProjectEnvironment {
        ProjectEnvironment(platform: "macOS", runtime: "Swift", tools: ["Xcode", "SPM"])
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 3. STRUCTURE - How it's organized
// ═══════════════════════════════════════════════════════════════════════════════

/// Answers: How is the project organized? What parts exist? How do they relate?
public struct StructureCapability: UniversalCapability {
    public static let capabilityId = "structure"
    public static let name = "Structure"
    public static let coreQuestion = "How is the project organized?"
    public static let artifacts = ["architecture.md", "modules.md", "boundaries.md"]
    
    public init() {}
    
    public func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        guard let intent: IntentArtifact = await graph.get(ofType: IntentArtifact.self) else {
            throw CapabilityError.missingArtifact("IntentArtifact")
        }
        
        let modules = generateModules(from: intent)
        let boundaries = defineBoundaries(from: intent)
        let architecture = ArchitectureArtifact(
            pattern: recommendPattern(for: intent.projectType),
            modules: modules.map { ModuleDefinition(name: $0.name, responsibility: $0.purpose, dependencies: $0.dependencies) },
            boundaries: boundaries.map { BoundaryDefinition(name: $0.name, type: $0.type == .external ? .layer : .feature, modules: []) },
            rationale: "Generated by StructureCapability"
        )
        
        await graph.register(architecture, producedBy: Self.capabilityId)
        await graph.declareDependency(from: Self.capabilityId, to: IntentCapability.capabilityId)
        try context.save(artifact: architecture.toMarkdown(), as: "architecture.md")
    }
    
    private func recommendPattern(for type: ProjectType) -> ArchitecturePattern {
        switch type {
        case .app: return .mvvm
        case .library: return .modular
        case .cli: return .clean
        case .api: return .hexagonal
        case .framework: return .modular
        case .saas: return .microservices
        case .plugin: return .modular
        case .other: return .mvc
        }
    }
    
    private func generateLayers(for type: ProjectType) -> [ArchitectureLayer] {
        switch type {
        case .app:
            return [
                ArchitectureLayer(name: "Presentation", responsibility: "UI and user interaction"),
                ArchitectureLayer(name: "Domain", responsibility: "Business logic"),
                ArchitectureLayer(name: "Data", responsibility: "Data access and persistence")
            ]
        default:
            return [
                ArchitectureLayer(name: "Public API", responsibility: "External interface"),
                ArchitectureLayer(name: "Core", responsibility: "Core logic")
            ]
        }
    }
    
    private func generateModules(from intent: IntentArtifact) -> [CapabilityModule] {
        [CapabilityModule(name: "Core", purpose: "Core functionality", dependencies: [])]
    }
    
    private func defineBoundaries(from intent: IntentArtifact) -> [CapabilityBoundary] {
        [CapabilityBoundary(name: "Public API", type: .external, rules: ["Stable interface", "Versioned"])]
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 4. WORK - What actions happen
// ═══════════════════════════════════════════════════════════════════════════════

/// Answers: What actions must happen? In what order? Who performs them?
public struct WorkCapability: UniversalCapability {
    public static let capabilityId = "work"
    public static let name = "Work"
    public static let coreQuestion = "What tasks must be done?"
    public static let artifacts = ["tasks.md", "milestones.md", "roadmap.json"]
    
    public init() {}
    
    public func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        guard let intent: IntentArtifact = await graph.get(ofType: IntentArtifact.self) else {
            throw CapabilityError.missingArtifact("IntentArtifact")
        }
        
        let generatedTasks = generateTasks(from: intent)
        let generatedMilestones = generateMilestones(from: intent)
        
        let tasks = TaskArtifact(
            tasks: generatedTasks.map { ProjectTask(id: UUID(), title: $0.title, status: $0.status == .completed ? .completed : .pending) },
            milestones: generatedMilestones.map { ProjectMilestone(name: $0.name, targetDate: $0.targetDate) }
        )
        
        await graph.register(tasks, producedBy: Self.capabilityId)
        await graph.declareDependency(from: Self.capabilityId, to: IntentCapability.capabilityId)
        try context.save(artifact: tasks.toMarkdown(), as: "tasks.md")
    }
    
    private func generateTasks(from intent: IntentArtifact) -> [CapabilityTask] {
        [
            CapabilityTask(id: "T1", title: "Setup project structure", priority: .high, status: .pending),
            CapabilityTask(id: "T2", title: "Implement core functionality", priority: .high, status: .pending),
            CapabilityTask(id: "T3", title: "Add tests", priority: .medium, status: .pending),
            CapabilityTask(id: "T4", title: "Documentation", priority: .medium, status: .pending)
        ]
    }
    
    private func generateMilestones(from intent: IntentArtifact) -> [CapabilityMilestone] {
        [
            CapabilityMilestone(id: "M1", name: "Foundation", tasks: ["T1"], targetDate: nil),
            CapabilityMilestone(id: "M2", name: "Core Complete", tasks: ["T2", "T3"], targetDate: nil),
            CapabilityMilestone(id: "M3", name: "Release Ready", tasks: ["T4"], targetDate: nil)
        ]
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 5. DECISIONS - Why choices were made
// ═══════════════════════════════════════════════════════════════════════════════

/// Answers: What choices were made? Why these over alternatives?
public struct DecisionCapability: UniversalCapability {
    public static let capabilityId = "decisions"
    public static let name = "Decisions"
    public static let coreQuestion = "Why were these choices made?"
    public static let artifacts = ["decisions.md", "tradeoffs.md"]
    
    public init() {}
    
    public func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        let decisions = DecisionArtifact(decisions: [], tradeoffs: [])
        await graph.register(decisions, producedBy: Self.capabilityId)
        try context.save(artifact: decisions.toMarkdown(), as: "decisions.md")
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 6. RISK - What could go wrong
// ═══════════════════════════════════════════════════════════════════════════════

/// Answers: What could fail? How bad? How to mitigate?
public struct RiskCapability: UniversalCapability {
    public static let capabilityId = "risk"
    public static let name = "Risk"
    public static let coreQuestion = "What could go wrong?"
    public static let artifacts = ["risks.md", "mitigations.md"]
    
    public init() {}
    
    public func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        guard let intent: IntentArtifact = await graph.get(ofType: IntentArtifact.self) else {
            throw CapabilityError.missingArtifact("IntentArtifact")
        }
        
        let risks = RiskArtifact(
            risks: identifyRisks(from: intent),
            overallScore: 0.3
        )
        
        await graph.register(risks, producedBy: Self.capabilityId)
        await graph.declareDependency(from: Self.capabilityId, to: IntentCapability.capabilityId)
        try context.save(artifact: risks.toMarkdown(), as: "risks.md")
    }
    
    private func identifyRisks(from intent: IntentArtifact) -> [Risk] {
        [
            Risk(category: .scope, description: "Scope creep", severity: .high, likelihood: .possible),
            Risk(category: .technical, description: "Technical complexity", severity: .medium, likelihood: .possible),
            Risk(category: .timeline, description: "Timeline pressure", severity: .medium, likelihood: .likely)
        ]
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 7. FEEDBACK - How learning happens
// ═══════════════════════════════════════════════════════════════════════════════

/// Answers: How do we know if we're wrong? How do we adapt?
public struct FeedbackCapability: UniversalCapability {
    public static let capabilityId = "feedback"
    public static let name = "Feedback"
    public static let coreQuestion = "How do we learn and improve?"
    public static let artifacts = ["feedback.md", "lessons_learned.md"]
    
    public init() {}
    
    public func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        let feedback = FeedbackArtifact(loops: [], lessons: [])
        await graph.register(feedback, producedBy: Self.capabilityId)
        try context.save(artifact: feedback.toMarkdown(), as: "feedback.md")
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 8. OUTCOME - What "done" means
// ═══════════════════════════════════════════════════════════════════════════════

/// Answers: What does "finished" mean? How do we validate success?
public struct OutcomeCapability: UniversalCapability {
    public static let capabilityId = "outcome"
    public static let name = "Outcome"
    public static let coreQuestion = "What does success look like?"
    public static let artifacts = ["acceptance_criteria.md", "validation.md"]
    
    public init() {}
    
    public func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        guard let intent: IntentArtifact = await graph.get(ofType: IntentArtifact.self) else {
            throw CapabilityError.missingArtifact("IntentArtifact")
        }
        
        let outcome = OutcomeArtifact(
            acceptanceCriteria: deriveAcceptanceCriteria(from: intent),
            validationMethods: deriveValidationMethods(from: intent),
            successMetrics: deriveMetrics(from: intent)
        )
        
        await graph.register(outcome, producedBy: Self.capabilityId)
        await graph.declareDependency(from: Self.capabilityId, to: IntentCapability.capabilityId)
        try context.save(artifact: outcome.toMarkdown(), as: "outcome.md")
    }
    
    private func deriveAcceptanceCriteria(from intent: IntentArtifact) -> [OutcomeAcceptanceCriterion] {
        intent.successCriteria.enumerated().map { index, criterion in
            OutcomeAcceptanceCriterion(id: "AC\(index + 1)", description: criterion, verified: false)
        }
    }
    
    private func deriveValidationMethods(from intent: IntentArtifact) -> [OutcomeValidationMethod] {
        [
            OutcomeValidationMethod(name: "Functional Testing", description: "Verify core functionality works"),
            OutcomeValidationMethod(name: "User Acceptance", description: "Stakeholder sign-off")
        ]
    }
    
    private func deriveMetrics(from intent: IntentArtifact) -> [OutcomeSuccessMetric] {
        [
            OutcomeSuccessMetric(name: "Completion", target: "100% of acceptance criteria met"),
            OutcomeSuccessMetric(name: "Quality", target: "No critical defects")
        ]
    }
}

// MARK: - Universal Capabilities Collection

/// All 8 universal capabilities
public struct UniversalCapabilities {
    public static let all: [any UniversalCapability] = [
        IntentCapability(),
        ContextCapability(),
        StructureCapability(),
        WorkCapability(),
        DecisionCapability(),
        RiskCapability(),
        FeedbackCapability(),
        OutcomeCapability()
    ]
    
    public static func capability(for id: String) -> (any UniversalCapability)? {
        all.first { type(of: $0).capabilityId == id }
    }
}
