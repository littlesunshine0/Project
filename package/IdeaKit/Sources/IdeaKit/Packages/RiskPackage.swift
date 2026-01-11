//
//  RiskPackage.swift
//  IdeaKit - Project Operating System
//
//  Kernel Package: Risk
//  Identifies and analyzes project risks
//  Produces: RiskArtifact
//

import Foundation

/// Risk Package
/// Identifies project risks early with severity and mitigation
public struct RiskPackage: CapabilityPackage {
    
    public static let packageId = "risk"
    public static let name = "Risk Package"
    public static let description = "Identify project risks early with severity ratings and mitigation strategies"
    public static let version = "1.0.0"
    public static let produces = ["RiskArtifact"]
    public static let consumes = ["IntentArtifact", "ScopeArtifact", "ArchitectureArtifact"]
    public static let isKernel = true
    
    public init() {}
    
    public func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        let risks = analyze()
        await graph.register(risks, producedBy: Self.packageId)
        try context.save(artifact: risks.toMarkdown(), as: "risks.md")
    }
    
    private func analyze() -> RiskArtifact {
        var risks: [Risk] = []
        
        // Technical risks
        risks.append(Risk(category: .technical, description: "Technology stack may not scale", severity: .medium, likelihood: .possible, mitigation: "Design for horizontal scaling"))
        risks.append(Risk(category: .technical, description: "Integration complexity", severity: .high, likelihood: .likely, mitigation: "Create abstraction layers early"))
        
        // Timeline risks
        risks.append(Risk(category: .timeline, description: "Underestimated complexity", severity: .high, likelihood: .likely, mitigation: "Add buffer time"))
        
        // Scope risks
        risks.append(Risk(category: .scope, description: "Feature creep", severity: .high, likelihood: .likely, mitigation: "Use scope enforcer"))
        
        let score = Double(risks.filter { $0.severity == .high || $0.severity == .critical }.count) / Double(risks.count)
        
        return RiskArtifact(risks: risks, overallScore: score)
    }
}
