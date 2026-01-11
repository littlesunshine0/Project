//
//  SpecPackage.swift
//  IdeaKit - Project Operating System
//
//  Kernel Package: Specification
//  Generates living specs from intent
//  Produces: RequirementsArtifact, ScopeArtifact
//

import Foundation

/// Specification Package
/// Generates requirements and scope from intent
public struct SpecPackage: CapabilityPackage {
    
    // MARK: - Package Identity
    
    public static let packageId = "spec"
    public static let name = "Specification Package"
    public static let description = "Generate living specifications and scope definitions from project intent"
    public static let version = "1.0.0"
    public static let produces = ["RequirementsArtifact", "ScopeArtifact"]
    public static let consumes = ["IntentArtifact"]
    public static let isKernel = true
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Execution
    
    public func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        // Get intent artifact
        guard let intent: IntentArtifact = await graph.get(ofType: IntentArtifact.self) else {
            throw PackageError.missingArtifact("IntentArtifact")
        }
        
        // Generate requirements
        let requirements = generateRequirements(from: intent)
        await graph.register(requirements, producedBy: Self.packageId)
        
        // Declare dependency
        await graph.declareDependency(from: requirements.artifactId, to: intent.artifactId)
        
        // Generate scope
        let scope = generateScope(from: intent)
        await graph.register(scope, producedBy: Self.packageId)
        
        // Save rendered outputs
        try context.save(artifact: requirements.toMarkdown(), as: "requirements.md")
        try context.save(artifact: scope.toMarkdown(), as: "scope.md")
        try context.save(artifact: generateMVPMarkdown(from: scope), as: "mvp_definition.md")
    }
    
    // MARK: - Generation Logic
    
    private func generateRequirements(from intent: IntentArtifact) -> RequirementsArtifact {
        var functional: [Requirement] = []
        var nonFunctional: [Requirement] = []
        
        // Core functional requirements
        functional.append(Requirement(
            id: "FR-001",
            title: "Primary User Workflow",
            description: "Implement the main user workflow that delivers the core value proposition",
            priority: .critical,
            status: .draft
        ))
        
        functional.append(Requirement(
            id: "FR-002",
            title: "Data Persistence",
            description: "Save and load user data reliably",
            priority: .high,
            status: .draft
        ))
        
        functional.append(Requirement(
            id: "FR-003",
            title: "User Feedback",
            description: "Provide clear feedback for user actions",
            priority: .high,
            status: .draft
        ))
        
        // Non-functional requirements
        nonFunctional.append(Requirement(
            id: "NFR-001",
            title: "Performance",
            description: "Response time < 200ms for common operations",
            priority: .high,
            status: .draft
        ))
        
        nonFunctional.append(Requirement(
            id: "NFR-002",
            title: "Reliability",
            description: "No data loss on crash or unexpected termination",
            priority: .critical,
            status: .draft
        ))
        
        nonFunctional.append(Requirement(
            id: "NFR-003",
            title: "Accessibility",
            description: "WCAG 2.1 AA compliance",
            priority: .medium,
            status: .draft
        ))
        
        // Generate acceptance criteria from success criteria
        let acceptanceCriteria = intent.successCriteria.enumerated().map { index, criterion in
            AcceptanceCriterion(
                feature: "Success Criterion \(index + 1)",
                given: "The system is operational",
                when: "User completes the workflow",
                then: criterion
            )
        }
        
        return RequirementsArtifact(
            functional: functional,
            nonFunctional: nonFunctional,
            acceptanceCriteria: acceptanceCriteria
        )
    }
    
    private func generateScope(from intent: IntentArtifact) -> ScopeArtifact {
        // MVP features
        let mvpFeatures = [
            ScopedFeature(name: "Core Workflow", description: "Primary user workflow", priority: .critical, effort: .large),
            ScopedFeature(name: "Data Persistence", description: "Save and load data", priority: .critical, effort: .medium),
            ScopedFeature(name: "Basic UI", description: "Essential user interface", priority: .high, effort: .medium)
        ]
        
        // Nice to have
        let niceToHave = [
            ScopedFeature(name: "Advanced Settings", description: "Customization options", priority: .medium, effort: .small),
            ScopedFeature(name: "Export Options", description: "Multiple export formats", priority: .low, effort: .medium)
        ]
        
        // Out of scope
        let outOfScope = [
            ScopedFeature(name: "Multi-user Collaboration", description: "Real-time collaboration", priority: .low, effort: .epic),
            ScopedFeature(name: "Mobile App", description: "Native mobile application", priority: .low, effort: .epic)
        ]
        
        // MVP gates
        let mvpGates = [
            MVPGate(name: "Core Complete", criteria: "All critical features implemented"),
            MVPGate(name: "Quality Gate", criteria: "No critical bugs, 80% test coverage"),
            MVPGate(name: "Documentation Gate", criteria: "User documentation complete")
        ]
        
        return ScopeArtifact(
            mvpFeatures: mvpFeatures,
            niceToHave: niceToHave,
            outOfScope: outOfScope,
            mvpGates: mvpGates
        )
    }
    
    private func generateMVPMarkdown(from scope: ScopeArtifact) -> String {
        """
        # MVP Definition
        
        ## What is MVP?
        
        The Minimum Viable Product includes only the features necessary to:
        1. Solve the core problem
        2. Validate the value proposition
        3. Gather user feedback
        
        ## MVP Features
        
        \(scope.mvpFeatures.enumerated().map { index, feature in "\\(index + 1). **\\(feature.name)**: \\(feature.description)" }.joined(separator: "\n"))
        
        ## MVP Completion Criteria
        
        \(scope.mvpGates.map { "- [ ] \($0.name): \($0.criteria)" }.joined(separator: "\n"))
        
        ## What MVP is NOT
        
        - Not a prototype or proof of concept
        - Not feature-complete
        - Not the final product
        
        MVP is the smallest thing we can build that delivers real value.
        """
    }
}
