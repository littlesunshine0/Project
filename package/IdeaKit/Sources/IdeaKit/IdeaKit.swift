//
//  IdeaKit.swift
//  IdeaKit - Project Operating System
//
//  Main entry point for the IdeaKit framework
//  A capability-centric project synthesis system
//

import Foundation

/// IdeaKit - Project Operating System
///
/// ## Architecture
///
/// IdeaKit uses a **capability-centric** design where:
/// - **Packages** represent capabilities, not documents
/// - **Artifacts** are structured outputs that packages produce and consume
/// - **ArtifactGraph** is the shared communication layer between packages
/// - **ProjectKernel** orchestrates package execution
///
/// ## Key Concepts
///
/// 1. **Packages as Capabilities**: Each package owns its logic, emits standardized
///    artifacts, and can be reused across any project.
///
/// 2. **Shared Artifact Graph**: Packages don't talk to each other directly.
///    They communicate through a shared artifact graph.
///
/// 3. **Project = Composition**: A project assembles packages, not generates files.
///    Files are views, not sources of truth.
///
/// ## Kernel Packages (Always On)
///
/// - `IntentPackage` - Convert idea → structured intent
/// - `SpecPackage` - Generate requirements and scope
/// - `ArchitecturePackage` - Generate architecture recommendations
/// - `PlanningPackage` - Decompose into tasks and milestones
/// - `RiskPackage` - Identify and analyze risks
/// - `DocsPackage` - Central documentation intelligence
///
/// ## Usage
///
/// ```swift
/// // Quick initialization with all kernel packages
/// let context = try await IdeaKit.create("MyApp", idea: "A todo app for developers")
///
/// // Custom package selection
/// let context = try await IdeaKit.create("MyApp", idea: "...", packages: [
///     IntentPackage(),
///     SpecPackage(),
///     CustomArchitecturePackage()
/// ])
/// ```
///
public struct IdeaKit {
    
    /// Current version
    public static let version = "2.0.0"
    
    // MARK: - Quick Initialization
    
    /// Create a new project with all kernel packages
    public static func create(
        _ name: String,
        idea: String,
        at path: URL = FileManager.default.temporaryDirectory
    ) async throws -> ProjectContext {
        try await ProjectKernel.create(name, idea: idea, at: path)
    }

    /// Create a new project with custom packages
    public static func create(
        _ name: String,
        idea: String,
        at path: URL = FileManager.default.temporaryDirectory,
        packages: [any CapabilityPackage]
    ) async throws -> ProjectContext {
        try await ProjectKernel.shared.initializeProject(
            name: name,
            at: path,
            idea: idea,
            packages: packages
        )
    }
    
    // MARK: - Package Access
    
    /// Get all kernel packages
    public static var kernelPackages: [any CapabilityPackage] {
        [
            IntentPackage(),
            SpecPackage(),
            ArchitecturePackage(),
            PlanningPackage(),
            RiskPackage(),
            DocsPackage()
        ]
    }
    
    /// Get package manifests
    public static var packageManifests: [PackageManifest] {
        [
            PackageManifest(from: IntentPackage.self),
            PackageManifest(from: SpecPackage.self),
            PackageManifest(from: ArchitecturePackage.self),
            PackageManifest(from: PlanningPackage.self),
            PackageManifest(from: RiskPackage.self),
            PackageManifest(from: DocsPackage.self)
        ]
    }
    
    // MARK: - Artifact Access
    
    /// Get the shared artifact graph
    public static var artifactGraph: ArtifactGraph {
        ArtifactGraph.shared
    }
    
    /// Get the project kernel
    public static var kernel: ProjectKernel {
        ProjectKernel.shared
    }
    
    // MARK: - Universal Capabilities
    
    /// Get all 8 universal capabilities
    public static var universalCapabilities: [any UniversalCapability] {
        UniversalCapabilities.all
    }
    
    // MARK: - Information
    
    /// Print system information
    public static func printInfo() {
        print("""
        ╔══════════════════════════════════════════════════════════════╗
        ║                    IdeaKit v\(version)                          ║
        ║                  Project Operating System                    ║
        ╠══════════════════════════════════════════════════════════════╣
        ║                                                              ║
        ║  8 Universal Capabilities (Domain Agnostic):                 ║
        ║    1. Intent    - Why this exists                            ║
        ║    2. Context   - Constraints & environment                  ║
        ║    3. Structure - How it's organized                         ║
        ║    4. Work      - What actions happen                        ║
        ║    5. Decisions - Why choices were made                      ║
        ║    6. Risk      - What could go wrong                        ║
        ║    7. Feedback  - How learning happens                       ║
        ║    8. Outcome   - What "done" means                          ║
        ║                                                              ║
        ║  Kernel Packages:                                            ║
        ║    ⭐ IntentPackage      - Idea → Structured Intent          ║
        ║    ⭐ SpecPackage        - Requirements & Scope              ║
        ║    ⭐ ArchitecturePackage - Architecture Recommendations     ║
        ║    ⭐ PlanningPackage    - Tasks & Milestones                ║
        ║    ⭐ RiskPackage        - Risk Analysis                     ║
        ║    ⭐ DocsPackage        - Documentation Intelligence        ║
        ║                                                              ║
        ║  Architecture:                                               ║
        ║    • Packages = Capabilities (not documents)                 ║
        ║    • Artifacts = Structured outputs                          ║
        ║    • ArtifactGraph = Shared communication layer              ║
        ║    • ProjectKernel = Orchestration                           ║
        ║                                                              ║
        ╚══════════════════════════════════════════════════════════════╝
        """)
    }
}

// MARK: - Re-exports

// Core types
public typealias Graph = ArtifactGraph
public typealias Kernel = ProjectKernel
public typealias Context = ProjectContext

// Artifact types
public typealias Intent = IntentArtifact
public typealias Requirements = RequirementsArtifact
public typealias Architecture = ArchitectureArtifact
public typealias Tasks = TaskArtifact
public typealias Scope = ScopeArtifact
public typealias Risks = RiskArtifact
public typealias Assumptions = AssumptionArtifact

// Universal Capability types
public typealias Capabilities = UniversalCapabilities
