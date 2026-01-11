//
//  KitOrchestratorContract.swift
//  KitOrchestrator
//
//  Package contract - loads from canonical JSON files
//

import Foundation
import DataKit

public struct KitOrchestratorContract: @unchecked Sendable {
    public static let shared = KitOrchestratorContract()
    
    public let contract: PackageContract
    
    private init() {
        contract = Self.loadContract()
    }
    
    public func register() async {
        try? await PackageOrchestrator.shared.attachPackage(contract)
        await MLIndexer.shared.indexPackage(contract)
    }
    
    private static func loadContract() -> PackageContract {
        let bundle = Bundle.module
        
        guard let manifestURL = bundle.url(forResource: "Package.manifest", withExtension: "json"),
              let manifestData = try? Data(contentsOf: manifestURL),
              let manifest = try? JSONDecoder().decode(PackageManifestSchema.self, from: manifestData) else {
            return PackageGenerator.generate(
                id: "com.flowkit.kitorchestrator",
                name: "KitOrchestrator",
                category: PackageCategory.core,
                description: "Central package orchestrator"
            )
        }
        
        let capabilities = loadJSON(PackageCapabilities.self, "Package.capabilities", bundle) ?? PackageCapabilities()
        let state = loadJSON(PackageStateSchema.self, "Package.state", bundle) ?? PackageStateSchema()
        let actions = loadJSON(PackageActions.self, "Package.actions", bundle) ?? PackageActions()
        let ui = loadJSON(PackageUI.self, "Package.ui", bundle) ?? PackageUI()
        let agents = loadJSON(PackageAgents.self, "Package.agents", bundle) ?? PackageAgents()
        let workflows = loadJSON(PackageWorkflows.self, "Package.workflows", bundle) ?? PackageWorkflows()
        
        return PackageContract(
            manifest: manifest,
            capabilities: capabilities,
            state: state,
            actions: actions,
            ui: ui,
            agents: agents,
            workflows: workflows
        )
    }
    
    private static func loadJSON<T: Decodable>(_ type: T.Type, _ name: String, _ bundle: Bundle) -> T? {
        guard let url = bundle.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
