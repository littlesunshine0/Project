//
//  WorkflowKitContract.swift
//  WorkflowKit
//
//  Package contract - loads from canonical JSON files
//

import Foundation
import DataKit

public struct WorkflowKitContract: @unchecked Sendable {
    public static let shared = WorkflowKitContract()
    
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
        
        let manifest = loadJSON(PackageManifestSchema.self, "Package.manifest", bundle) ?? defaultManifest
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
    
    private static let defaultManifest = PackageManifestSchema(
        id: "com.flowkit.workflowkit",
        name: "WorkflowKit",
        category: PackageCategory.automation,
        dependencies: ["DataKit", "CoreKit"]
    )
}
