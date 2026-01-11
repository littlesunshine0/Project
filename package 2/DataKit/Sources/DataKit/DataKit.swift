//
//  DataKit.swift
//  DataKit
//
//  Central data infrastructure for the Package Operating System
//  Provides: Schemas, Orchestrator, UI Generation, ML Indexing, Package Generation
//

import Foundation

// MARK: - DataKit Public API

/// Bootstrap the entire package system
public func bootstrapPackageSystem() async {
    // The orchestrator is ready - packages can now attach
    print("📦 Package Operating System initialized")
    print("   - PackageOrchestrator: Ready")
    print("   - UIGenerator: Ready")
    print("   - MLIndexer: Ready")
    print("   - EventBus: Ready")
}

/// Run the package system after all packages are attached
public func runPackageSystem() async throws {
    try await PackageOrchestrator.shared.run()
    print("🚀 Package Operating System running")
    
    let packages = await PackageOrchestrator.shared.getAllPackages()
    let commands = await PackageOrchestrator.shared.getCommands()
    let actions = await PackageOrchestrator.shared.getActions()
    let agents = await PackageOrchestrator.shared.getAgents()
    let workflows = await PackageOrchestrator.shared.getWorkflows()
    
    print("   - Packages: \(packages.count)")
    print("   - Commands: \(commands.count)")
    print("   - Actions: \(actions.count)")
    print("   - Agents: \(agents.count)")
    print("   - Workflows: \(workflows.count)")
}

// MARK: - Re-exports

// Schemas (using Schema suffix types from PackageSchemas.swift)
public typealias Manifest = PackageManifestSchema
public typealias Capabilities = PackageCapabilities
public typealias StateSchema = PackageStateSchema
public typealias Actions = PackageActions
public typealias UI = PackageUI
public typealias Agents = PackageAgents
public typealias Workflows = PackageWorkflows
public typealias Contract = PackageContract

// Orchestrator
public typealias Orchestrator = PackageOrchestrator

// UI
public typealias Generator = UIGenerator

// ML
public typealias Indexer = MLIndexer

// MARK: - Convenience Extensions

public extension PackageContract {
    /// Create a minimal contract for quick prototyping
    static func minimal(
        id: String,
        name: String,
        category: PackageCategory = .utility
    ) -> PackageContract {
        PackageGenerator.generate(
            id: id,
            name: name,
            category: category,
            description: "\(name) package"
        )
    }
}

public extension PackageOrchestrator {
    /// Quick attach a minimal package
    func attachMinimal(id: String, name: String, category: PackageCategory = .utility) async throws {
        let contract = PackageContract.minimal(id: id, name: name, category: category)
        try await attachPackage(contract)
    }
}

// MARK: - Stats

public struct PackageSystemStats: Sendable {
    public let packageCount: Int
    public let commandCount: Int
    public let actionCount: Int
    public let agentCount: Int
    public let workflowCount: Int
    public let menuCount: Int
    
    public var totalCapabilities: Int {
        commandCount + actionCount + agentCount + workflowCount
    }
}

public func getPackageSystemStats() async -> PackageSystemStats {
    let packages = await PackageOrchestrator.shared.getAllPackages()
    let commands = await PackageOrchestrator.shared.getCommands()
    let actions = await PackageOrchestrator.shared.getActions()
    let agents = await PackageOrchestrator.shared.getAgents()
    let workflows = await PackageOrchestrator.shared.getWorkflows()
    let menus = await PackageOrchestrator.shared.getMenus(type: .main)
    
    return PackageSystemStats(
        packageCount: packages.count,
        commandCount: commands.count,
        actionCount: actions.count,
        agentCount: agents.count,
        workflowCount: workflows.count,
        menuCount: menus.count
    )
}
