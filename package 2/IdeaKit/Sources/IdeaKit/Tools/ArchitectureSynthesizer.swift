//
//  ArchitectureSynthesizer.swift
//  IdeaKit - Project Operating System
//
//  Tool: ArchitectureSynthesizer
//  Phase: Architecture
//  Purpose: Generate first-pass architecture recommendations
//  Outputs: architecture.md, diagram.json
//

import Foundation

/// Synthesizes architecture recommendations from specifications
public final class ArchitectureSynthesizer: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "architecture_synthesizer"
    public static let name = "Architecture Synthesizer"
    public static let description = "Generate architecture recommendations with patterns, modules, and boundaries"
    public static let phase = ProjectPhase.architecture
    public static let outputs = ["architecture.md", "diagram.json"]
    public static let inputs = ["requirements.md", "functional_spec.md"]
    public static let isDefault = true
    
    // MARK: - Singleton
    
    public static let shared = ArchitectureSynthesizer()
    private init() {}
    
    // MARK: - Synthesis
    
    /// Synthesize architecture from specification
    public func synthesize(from spec: Specification) async throws -> ArchitectureRecommendation {
        // Analyze spec to determine best pattern
        let pattern = recommendPattern(from: spec)
        
        // Generate modules
        let modules = generateModules(for: pattern)
        
        // Define boundaries
        let boundaries = defineBoundaries(for: pattern, modules: modules)
        
        // Generate rationale
        let rationale = generateRationale(pattern: pattern, spec: spec)
        
        return ArchitectureRecommendation(
            pattern: pattern,
            modules: modules,
            boundaries: boundaries,
            rationale: rationale
        )
    }
    
    /// Generate architecture markdown
    public func generateMarkdown(from architecture: ArchitectureRecommendation) -> String {
        """
        # Architecture Document
        
        ## Overview
        
        **Pattern**: \(architecture.pattern.rawValue.uppercased())
        
        \(architecture.rationale)
        
        ## Architecture Diagram
        
        ```
        \(generateASCIIDiagram(for: architecture))
        ```
        
        ## Modules
        
        \(architecture.modules.map { moduleSection($0) }.joined(separator: "\n"))
        
        ## Boundaries
        
        \(architecture.boundaries.map { boundarySection($0) }.joined(separator: "\n"))
        
        ## Key Principles
        
        1. **Separation of Concerns**: Each module has a single responsibility
        2. **Dependency Inversion**: High-level modules don't depend on low-level modules
        3. **Interface Segregation**: Clients only depend on interfaces they use
        4. **Testability**: All modules can be tested in isolation
        
        ## Data Flow
        
        ```
        User Input → View → ViewModel → Service → Repository → Database
                  ←      ←           ←         ←            ←
        ```
        
        ## Technology Stack
        
        | Layer | Technology |
        |-------|------------|
        | UI | SwiftUI |
        | State | Combine / Observation |
        | Persistence | SQLite / Core Data |
        | Networking | URLSession |
        
        ## Decision Log
        
        | Decision | Rationale | Alternatives Considered |
        |----------|-----------|------------------------|
        | \(architecture.pattern.rawValue.uppercased()) | \(patternRationale(architecture.pattern)) | \(alternativePatterns(architecture.pattern)) |
        """
    }
    
    /// Generate diagram JSON
    public func generateDiagramJSON(from architecture: ArchitectureRecommendation) -> [String: Any] {
        [
            "pattern": architecture.pattern.rawValue,
            "modules": architecture.modules.map { module in
                [
                    "id": module.id.uuidString,
                    "name": module.name,
                    "responsibility": module.responsibility,
                    "dependencies": module.dependencies
                ]
            },
            "boundaries": architecture.boundaries.map { boundary in
                [
                    "id": boundary.id.uuidString,
                    "name": boundary.name,
                    "type": boundary.type.rawValue,
                    "modules": boundary.modules
                ]
            },
            "connections": generateConnections(from: architecture)
        ]
    }
    
    // MARK: - Private Methods
    
    private func recommendPattern(from spec: Specification) -> ArchitecturePattern {
        // Simple heuristic based on spec content
        let content = spec.requirements.lowercased() + spec.functional.lowercased()
        
        if content.contains("microservice") || content.contains("distributed") {
            return .microservices
        } else if content.contains("clean") || content.contains("hexagonal") {
            return .clean
        } else if content.contains("modular") {
            return .modular
        }
        
        // Default to MVVM for most apps
        return .mvvm
    }
    
    private func generateModules(for pattern: ArchitecturePattern) -> [ModuleDefinition] {
        switch pattern {
        case .mvvm:
            return [
                ModuleDefinition(name: "Models", responsibility: "Data structures and business logic", dependencies: []),
                ModuleDefinition(name: "Views", responsibility: "UI components and layouts", dependencies: ["ViewModels"]),
                ModuleDefinition(name: "ViewModels", responsibility: "Presentation logic and state", dependencies: ["Models", "Services"]),
                ModuleDefinition(name: "Services", responsibility: "Business operations and data access", dependencies: ["Models"])
            ]
        case .clean:
            return [
                ModuleDefinition(name: "Entities", responsibility: "Core business objects", dependencies: []),
                ModuleDefinition(name: "UseCases", responsibility: "Application business rules", dependencies: ["Entities"]),
                ModuleDefinition(name: "Adapters", responsibility: "Interface adapters", dependencies: ["UseCases"]),
                ModuleDefinition(name: "Frameworks", responsibility: "External frameworks and drivers", dependencies: ["Adapters"])
            ]
        case .modular:
            return [
                ModuleDefinition(name: "Core", responsibility: "Shared utilities and types", dependencies: []),
                ModuleDefinition(name: "Features", responsibility: "Feature modules", dependencies: ["Core"]),
                ModuleDefinition(name: "UI", responsibility: "Shared UI components", dependencies: ["Core"]),
                ModuleDefinition(name: "Data", responsibility: "Data layer", dependencies: ["Core"])
            ]
        default:
            return [
                ModuleDefinition(name: "App", responsibility: "Application entry point", dependencies: ["Features"]),
                ModuleDefinition(name: "Features", responsibility: "Feature implementations", dependencies: ["Core"]),
                ModuleDefinition(name: "Core", responsibility: "Core functionality", dependencies: [])
            ]
        }
    }
    
    private func defineBoundaries(for pattern: ArchitecturePattern, modules: [ModuleDefinition]) -> [BoundaryDefinition] {
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
            return [
                BoundaryDefinition(name: "Application", type: .layer, modules: modules.map { $0.name })
            ]
        }
    }
    
    private func generateRationale(pattern: ArchitecturePattern, spec: Specification) -> String {
        "The \(pattern.rawValue.uppercased()) pattern was selected based on the project requirements. This pattern provides clear separation of concerns, testability, and maintainability suitable for the project scope."
    }
    
    private func generateASCIIDiagram(for architecture: ArchitectureRecommendation) -> String {
        switch architecture.pattern {
        case .mvvm:
            return """
            ┌─────────────────────────────────────┐
            │              Views                  │
            │  (SwiftUI Views, UI Components)     │
            └─────────────┬───────────────────────┘
                          │ binds
            ┌─────────────▼───────────────────────┐
            │           ViewModels                │
            │  (State, Presentation Logic)        │
            └─────────────┬───────────────────────┘
                          │ uses
            ┌─────────────▼───────────────────────┐
            │            Services                 │
            │  (Business Logic, Data Access)      │
            └─────────────┬───────────────────────┘
                          │ persists
            ┌─────────────▼───────────────────────┐
            │            Models                   │
            │  (Data Structures, Entities)        │
            └─────────────────────────────────────┘
            """
        case .clean:
            return """
            ┌─────────────────────────────────────┐
            │           Frameworks                │
            │  (UI, Database, Network)            │
            └─────────────┬───────────────────────┘
                          │
            ┌─────────────▼───────────────────────┐
            │            Adapters                 │
            │  (Controllers, Presenters, Gateways)│
            └─────────────┬───────────────────────┘
                          │
            ┌─────────────▼───────────────────────┐
            │           Use Cases                 │
            │  (Application Business Rules)       │
            └─────────────┬───────────────────────┘
                          │
            ┌─────────────▼───────────────────────┐
            │           Entities                  │
            │  (Enterprise Business Rules)        │
            └─────────────────────────────────────┘
            """
        default:
            return """
            ┌─────────────────────────────────────┐
            │              App                    │
            └─────────────┬───────────────────────┘
                          │
            ┌─────────────▼───────────────────────┐
            │           Features                  │
            └─────────────┬───────────────────────┘
                          │
            ┌─────────────▼───────────────────────┐
            │             Core                    │
            └─────────────────────────────────────┘
            """
        }
    }
    
    private func moduleSection(_ module: ModuleDefinition) -> String {
        """
        ### \(module.name)
        
        **Responsibility**: \(module.responsibility)
        
        **Dependencies**: \(module.dependencies.isEmpty ? "None" : module.dependencies.joined(separator: ", "))
        
        """
    }
    
    private func boundarySection(_ boundary: BoundaryDefinition) -> String {
        """
        ### \(boundary.name) (\(boundary.type.rawValue.capitalized))
        
        **Modules**: \(boundary.modules.joined(separator: ", "))
        
        """
    }
    
    private func patternRationale(_ pattern: ArchitecturePattern) -> String {
        switch pattern {
        case .mvvm: return "Good for SwiftUI apps with reactive state"
        case .clean: return "Maximum separation and testability"
        case .modular: return "Scalable feature-based organization"
        default: return "Suitable for project requirements"
        }
    }
    
    private func alternativePatterns(_ pattern: ArchitecturePattern) -> String {
        let all = ArchitecturePattern.allCases.filter { $0 != pattern }
        return all.prefix(2).map { $0.rawValue.uppercased() }.joined(separator: ", ")
    }
    
    private func generateConnections(from architecture: ArchitectureRecommendation) -> [[String: String]] {
        var connections: [[String: String]] = []
        
        for module in architecture.modules {
            for dep in module.dependencies {
                connections.append([
                    "from": module.name,
                    "to": dep,
                    "type": "depends_on"
                ])
            }
        }
        
        return connections
    }
}
