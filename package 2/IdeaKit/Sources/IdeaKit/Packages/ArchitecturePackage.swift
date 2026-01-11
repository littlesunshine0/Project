//
//  ArchitecturePackage.swift
//  IdeaKit - Project Operating System
//
//  Kernel Package: Architecture
//  Generates architecture recommendations
//  Produces: ArchitectureArtifact
//

import Foundation

/// Architecture Package
/// Generates architecture recommendations from requirements
public struct ArchitecturePackage: CapabilityPackage {
    
    public static let packageId = "architecture"
    public static let name = "Architecture Package"
    public static let description = "Generate architecture recommendations with patterns and module boundaries"
    public static let version = "1.0.0"
    public static let produces = ["ArchitectureArtifact"]
    public static let consumes = ["RequirementsArtifact", "IntentArtifact"]
    public static let isKernel = true
    
    public init() {}
    
    public func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        guard let intent: IntentArtifact = await graph.get(ofType: IntentArtifact.self) else {
            throw PackageError.missingArtifact("IntentArtifact")
        }
        
        let architecture = synthesize(from: intent)
        await graph.register(architecture, producedBy: Self.packageId)
        await graph.declareDependency(from: architecture.artifactId, to: intent.artifactId)
        
        try context.save(artifact: architecture.toMarkdown(), as: "architecture.md")
    }

    private func synthesize(from intent: IntentArtifact) -> ArchitectureArtifact {
        let pattern = recommendPattern(for: intent.projectType)
        let modules = generateModules(for: pattern)
        let boundaries = generateBoundaries(for: pattern)
        
        return ArchitectureArtifact(
            pattern: pattern,
            modules: modules,
            boundaries: boundaries,
            rationale: "The \(pattern.rawValue.uppercased()) pattern was selected based on project type (\(intent.projectType.rawValue)). This pattern provides clear separation of concerns and testability."
        )
    }
    
    private func recommendPattern(for type: ProjectType) -> ArchitecturePattern {
        switch type {
        case .app: return .mvvm
        case .library, .framework: return .modular
        case .api, .saas: return .clean
        case .cli: return .modular
        default: return .mvvm
        }
    }
    
    private func generateModules(for pattern: ArchitecturePattern) -> [ModuleDefinition] {
        switch pattern {
        case .mvvm:
            return [
                ModuleDefinition(name: "Models", responsibility: "Data structures and business logic"),
                ModuleDefinition(name: "Views", responsibility: "UI components", dependencies: ["ViewModels"]),
                ModuleDefinition(name: "ViewModels", responsibility: "Presentation logic", dependencies: ["Models", "Services"]),
                ModuleDefinition(name: "Services", responsibility: "Business operations", dependencies: ["Models"])
            ]
        case .clean:
            return [
                ModuleDefinition(name: "Entities", responsibility: "Core business objects"),
                ModuleDefinition(name: "UseCases", responsibility: "Application rules", dependencies: ["Entities"]),
                ModuleDefinition(name: "Adapters", responsibility: "Interface adapters", dependencies: ["UseCases"]),
                ModuleDefinition(name: "Frameworks", responsibility: "External frameworks", dependencies: ["Adapters"])
            ]
        default:
            return [
                ModuleDefinition(name: "Core", responsibility: "Shared utilities"),
                ModuleDefinition(name: "Features", responsibility: "Feature modules", dependencies: ["Core"]),
                ModuleDefinition(name: "UI", responsibility: "Shared UI", dependencies: ["Core"])
            ]
        }
    }
    
    private func generateBoundaries(for pattern: ArchitecturePattern) -> [BoundaryDefinition] {
        switch pattern {
        case .mvvm:
            return [
                BoundaryDefinition(name: "Presentation", type: .layer, modules: ["Views", "ViewModels"]),
                BoundaryDefinition(name: "Domain", type: .layer, modules: ["Models", "Services"])
            ]
        case .clean:
            return [
                BoundaryDefinition(name: "Domain", type: .domain, modules: ["Entities", "UseCases"]),
                BoundaryDefinition(name: "Infrastructure", type: .infrastructure, modules: ["Adapters", "Frameworks"])
            ]
        default:
            return [BoundaryDefinition(name: "Application", type: .layer, modules: ["Core", "Features", "UI"])]
        }
    }
}
