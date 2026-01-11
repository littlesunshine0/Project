//
//  AppGenerator.swift
//  AppIdeaKit - Automated App Generation
//

import Foundation

// MARK: - App Generator

public actor AppGenerator {
    public static let shared = AppGenerator()
    
    private init() {}
    
    // MARK: - Generation
    
    public func generate(from idea: AppIdea) async -> GenerationResult {
        // Enrich idea with ML analysis
        let enrichedIdea = await IdeaAnalyzer.shared.enrichIdea(idea)
        
        // Generate project structure
        let structure = generateStructure(for: enrichedIdea)
        
        // Generate specs
        let specs = generateSpecs(for: enrichedIdea)
        
        // Generate tasks
        let tasks = generateTasks(for: enrichedIdea)
        
        // Determine required kits
        let kits = determineKits(for: enrichedIdea)
        
        // Generate Package.swift
        let packageSwift = generatePackageSwift(for: enrichedIdea, kits: kits)
        
        // Generate main source file
        let mainSource = generateMainSource(for: enrichedIdea)
        
        return GenerationResult(
            idea: enrichedIdea,
            structure: structure,
            specs: specs,
            tasks: tasks,
            requiredKits: kits,
            files: [
                GeneratedFile(path: "Package.swift", content: packageSwift),
                GeneratedFile(path: "Sources/\(enrichedIdea.name)/\(enrichedIdea.name).swift", content: mainSource),
                GeneratedFile(path: "README.md", content: generateReadme(for: enrichedIdea)),
                GeneratedFile(path: ".kiro/specs/\(enrichedIdea.name.lowercased())/requirements.md", content: specs.requirements),
                GeneratedFile(path: ".kiro/specs/\(enrichedIdea.name.lowercased())/design.md", content: specs.design),
                GeneratedFile(path: ".kiro/specs/\(enrichedIdea.name.lowercased())/tasks.md", content: specs.tasks)
            ]
        )
    }
    
    // MARK: - Structure Generation
    
    private func generateStructure(for idea: AppIdea) -> ProjectStructure {
        var directories: [String] = [
            "Sources/\(idea.name)",
            "Sources/\(idea.name)/Models",
            "Sources/\(idea.name)/Services",
            "Tests/\(idea.name)Tests",
            ".kiro/specs/\(idea.name.lowercased())"
        ]
        
        // Add kind-specific directories
        switch idea.kind {
        case .cli:
            directories.append("Sources/\(idea.name)CLI")
        case .service:
            directories.append("Sources/\(idea.name)/Handlers")
        case .plugin:
            directories.append("Sources/\(idea.name)/Extensions")
        default:
            break
        }
        
        // Add feature directories
        for feature in idea.features {
            directories.append("Sources/\(idea.name)/Features/\(feature.name)")
        }
        
        return ProjectStructure(
            name: idea.name,
            directories: directories,
            kind: idea.kind
        )
    }
    
    // MARK: - Specs Generation
    
    private func generateSpecs(for idea: AppIdea) -> GeneratedSpecs {
        let requirements = """
        # \(idea.name) Requirements
        
        ## Overview
        \(idea.description)
        
        ## Problem Statement
        \(idea.context.problemStatement.isEmpty ? "To be defined" : idea.context.problemStatement)
        
        ## Target Audience
        \(idea.context.targetAudience.isEmpty ? "To be defined" : idea.context.targetAudience)
        
        ## Functional Requirements
        
        \(idea.features.enumerated().map { "### FR\($0.offset + 1): \($0.element.name)\n\($0.element.description)" }.joined(separator: "\n\n"))
        
        ## Non-Functional Requirements
        
        ### NFR1: Performance
        - Response time < 100ms for core operations
        
        ### NFR2: Reliability
        - 99.9% uptime for services
        
        ## Use Cases
        \(idea.context.useCases.enumerated().map { "- UC\($0.offset + 1): \($0.element)" }.joined(separator: "\n"))
        
        ## Constraints
        \(idea.context.constraints.map { "- \($0)" }.joined(separator: "\n"))
        """
        
        let design = """
        # \(idea.name) Design Document
        
        ## Architecture
        
        ### Type: \(idea.type.rawValue)
        ### Kind: \(idea.kind.rawValue)
        ### Category: \(idea.category.rawValue)
        
        ## Components
        
        ### Core Module
        Main \(idea.name) implementation
        
        ### Models
        Data structures and types
        
        ### Services
        Business logic and integrations
        
        ## Kit Dependencies
        
        \(idea.suggestedKits.map { "- \($0)" }.joined(separator: "\n"))
        
        ## Data Flow
        
        ```
        Input → Processing → Output
              ↓
           Storage (ContentHub)
              ↓
           Indexing (SearchKit)
        ```
        
        ## Integration Points
        
        - BridgeKit for Kit orchestration
        - ContentHub for storage
        - DocKit for documentation
        """
        
        let tasks = """
        # \(idea.name) Tasks
        
        ## Phase 1: Setup
        - [ ] Initialize project structure
        - [ ] Configure Package.swift
        - [ ] Set up CI/CD
        
        ## Phase 2: Core Implementation
        \(idea.features.filter { $0.priority == .critical || $0.priority == .high }.map { "- [ ] Implement \($0.name)" }.joined(separator: "\n"))
        
        ## Phase 3: Integration
        - [ ] Integrate required Kits
        - [ ] Connect to ContentHub
        - [ ] Set up BridgeKit automation
        
        ## Phase 4: Testing
        - [ ] Unit tests
        - [ ] Integration tests
        - [ ] Performance tests
        
        ## Phase 5: Documentation
        - [ ] API documentation
        - [ ] README
        - [ ] Usage examples
        
        ## Estimated Complexity: \(idea.complexity.rawValue)
        ## Estimated Duration: \(idea.complexity.estimatedDays.lowerBound)-\(idea.complexity.estimatedDays.upperBound) days
        """
        
        return GeneratedSpecs(requirements: requirements, design: design, tasks: tasks)
    }
    
    // MARK: - Tasks Generation
    
    private func generateTasks(for idea: AppIdea) -> [GeneratedTask] {
        var tasks: [GeneratedTask] = []
        
        // Setup tasks
        tasks.append(GeneratedTask(name: "Project Setup", phase: "Setup", priority: .critical, estimatedHours: 2))
        tasks.append(GeneratedTask(name: "Configure Dependencies", phase: "Setup", priority: .critical, estimatedHours: 1))
        
        // Feature tasks
        for feature in idea.features {
            tasks.append(GeneratedTask(
                name: "Implement \(feature.name)",
                phase: "Implementation",
                priority: feature.priority,
                estimatedHours: estimateHours(for: feature)
            ))
        }
        
        // Integration tasks
        for kit in idea.suggestedKits.prefix(5) {
            tasks.append(GeneratedTask(
                name: "Integrate \(kit)",
                phase: "Integration",
                priority: .high,
                estimatedHours: 2
            ))
        }
        
        // Testing tasks
        tasks.append(GeneratedTask(name: "Write Unit Tests", phase: "Testing", priority: .high, estimatedHours: 4))
        tasks.append(GeneratedTask(name: "Integration Testing", phase: "Testing", priority: .medium, estimatedHours: 3))
        
        // Documentation
        tasks.append(GeneratedTask(name: "Write Documentation", phase: "Documentation", priority: .medium, estimatedHours: 2))
        
        return tasks
    }
    
    private func estimateHours(for feature: Feature) -> Int {
        switch feature.priority {
        case .critical: return 8
        case .high: return 6
        case .medium: return 4
        case .low: return 2
        case .nice: return 1
        }
    }
    
    // MARK: - Kit Determination
    
    private func determineKits(for idea: AppIdea) -> [String] {
        var kits = Set<String>()
        
        // Always include core kits
        kits.insert("IdeaKit")
        kits.insert("IconKit")
        kits.insert("ContentHub")
        kits.insert("BridgeKit")
        kits.insert("DocKit")
        
        // Add suggested kits
        for kit in idea.suggestedKits {
            kits.insert(kit)
        }
        
        // Add required kits
        for kit in idea.requiredKits {
            kits.insert(kit)
        }
        
        // Add feature-required kits
        for feature in idea.features {
            for kit in feature.requiredKits {
                kits.insert(kit)
            }
        }
        
        return Array(kits).sorted()
    }
    
    // MARK: - Code Generation
    
    private func generatePackageSwift(for idea: AppIdea, kits: [String]) -> String {
        """
        // swift-tools-version: 6.0
        import PackageDescription
        
        let package = Package(
            name: "\(idea.name)",
            platforms: [.macOS(.v14), .iOS(.v17)],
            products: [
                .library(name: "\(idea.name)", targets: ["\(idea.name)"])
            ],
            dependencies: [
                // Kit dependencies would be added here
            ],
            targets: [
                .target(name: "\(idea.name)"),
                .testTarget(name: "\(idea.name)Tests", dependencies: ["\(idea.name)"])
            ]
        )
        
        // Required Kits: \(kits.joined(separator: ", "))
        """
    }
    
    private func generateMainSource(for idea: AppIdea) -> String {
        """
        //
        //  \(idea.name).swift
        //  \(idea.name) - \(idea.description)
        //
        //  Category: \(idea.category.rawValue)
        //  Kind: \(idea.kind.rawValue)
        //  Type: \(idea.type.rawValue)
        //
        
        import Foundation
        
        // MARK: - \(idea.name)
        
        public actor \(idea.name) {
            public static let shared = \(idea.name)()
            
            private init() {}
            
            // TODO: Implement core functionality
        }
        """
    }
    
    private func generateReadme(for idea: AppIdea) -> String {
        """
        # \(idea.name)
        
        \(idea.description)
        
        ## Category
        \(idea.category.rawValue)
        
        ## Type
        \(idea.type.rawValue) (\(idea.kind.rawValue))
        
        ## Features
        
        \(idea.features.map { "- **\($0.name)**: \($0.description)" }.joined(separator: "\n"))
        
        ## Required Kits
        
        \(idea.suggestedKits.map { "- \($0)" }.joined(separator: "\n"))
        
        ## Installation
        
        ```swift
        // Add to Package.swift dependencies
        .package(path: "../\(idea.name)")
        ```
        
        ## Usage
        
        ```swift
        import \(idea.name)
        
        // Initialize
        let instance = await \(idea.name).shared
        ```
        
        ## Complexity
        
        **\(idea.complexity.rawValue)** - Estimated \(idea.complexity.estimatedDays.lowerBound)-\(idea.complexity.estimatedDays.upperBound) days
        
        ---
        Generated by AppIdeaKit
        """
    }
}

// MARK: - Generation Types

public struct GenerationResult: Sendable {
    public let idea: AppIdea
    public let structure: ProjectStructure
    public let specs: GeneratedSpecs
    public let tasks: [GeneratedTask]
    public let requiredKits: [String]
    public let files: [GeneratedFile]
}

public struct ProjectStructure: Sendable {
    public let name: String
    public let directories: [String]
    public let kind: AppKind
}

public struct GeneratedSpecs: Sendable {
    public let requirements: String
    public let design: String
    public let tasks: String
}

public struct GeneratedTask: Sendable {
    public let name: String
    public let phase: String
    public let priority: Priority
    public let estimatedHours: Int
}

public struct GeneratedFile: Sendable {
    public let path: String
    public let content: String
}
