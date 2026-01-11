//
//  ProjectKernel.swift
//  IdeaKit - Project Operating System
//
//  The Project Kernel - orchestrates package execution
//  Projects assemble packages, packages produce artifacts
//

import Foundation

/// The Project Kernel - orchestrates package execution
/// This is the "operating system" for projects
public actor ProjectKernel {
    
    // MARK: - Singleton
    
    public static let shared = ProjectKernel()
    
    // MARK: - State
    
    private var activePackages: [String: any CapabilityPackage] = [:]
    private var executionOrder: [String] = []
    
    private init() {}
    
    // MARK: - Project Initialization
    
    /// Initialize a new project with kernel packages
    public func initializeProject(
        name: String,
        at path: URL,
        idea: String
    ) async throws -> ProjectContext {
        let context = ProjectContext(name: name, path: path)
        try context.setupDirectories()
        context.setMetadata(idea, for: "idea")
        
        // Clear artifact graph for new project
        await ArtifactGraph.shared.clear()
        
        // Execute kernel packages in order
        try await executeKernelPackages(context: context)
        
        return context
    }
    
    /// Initialize with custom package selection
    public func initializeProject(
        name: String,
        at path: URL,
        idea: String,
        packages: [any CapabilityPackage]
    ) async throws -> ProjectContext {
        let context = ProjectContext(name: name, path: path)
        try context.setupDirectories()
        context.setMetadata(idea, for: "idea")
        
        await ArtifactGraph.shared.clear()
        
        // Execute provided packages
        for package in packages {
            try await execute(package: package, context: context)
        }
        
        return context
    }

    // MARK: - Package Execution
    
    /// Execute kernel packages in dependency order
    private func executeKernelPackages(context: ProjectContext) async throws {
        // Kernel packages in execution order
        let kernelPackages: [any CapabilityPackage] = [
            IntentPackage(),
            SpecPackage(),
            ArchitecturePackage(),
            PlanningPackage(),
            RiskPackage(),
            DocsPackage()
        ]
        
        for package in kernelPackages {
            try await execute(package: package, context: context)
        }
    }
    
    /// Execute a single package
    private func execute(package: any CapabilityPackage, context: ProjectContext) async throws {
        let packageId = type(of: package).packageId
        
        // Track execution
        activePackages[packageId] = package
        executionOrder.append(packageId)
        
        // Execute
        try await package.execute(graph: ArtifactGraph.shared, context: context)
    }
    
    // MARK: - Package Management
    
    /// Add a package to the active set
    public func use(_ package: any CapabilityPackage) {
        let packageId = type(of: package).packageId
        activePackages[packageId] = package
    }
    
    /// Remove a package
    public func remove(packageId: String) {
        activePackages.removeValue(forKey: packageId)
    }
    
    /// Get active packages
    public func getActivePackages() -> [String: any CapabilityPackage] {
        activePackages
    }
    
    /// Get execution order
    public func getExecutionOrder() -> [String] {
        executionOrder
    }
    
    // MARK: - Artifact Access
    
    /// Get an artifact from the graph
    public func getArtifact<T: Artifact>(ofType type: T.Type) async -> T? {
        await ArtifactGraph.shared.get(ofType: type)
    }
    
    /// Get all artifacts of a type
    public func getAllArtifacts<T: Artifact>(ofType type: T.Type) async -> [T] {
        await ArtifactGraph.shared.getAll(ofType: type)
    }
    
    // MARK: - Status
    
    /// Generate execution summary
    public func executionSummary() async -> String {
        var summary = "# Project Kernel Execution Summary\n\n"
        
        summary += "## Packages Executed (\(executionOrder.count))\n\n"
        for (index, packageId) in executionOrder.enumerated() {
            summary += "\(index + 1). \(packageId)\n"
        }
        
        summary += "\n## Artifact Graph\n\n"
        summary += await ArtifactGraph.shared.toMarkdown()
        
        return summary
    }
}

// MARK: - Convenience Extensions

extension ProjectKernel {
    
    /// Quick project initialization
    public static func create(
        _ name: String,
        idea: String,
        at path: URL = FileManager.default.temporaryDirectory
    ) async throws -> ProjectContext {
        try await shared.initializeProject(name: name, at: path, idea: idea)
    }
}
