//
//  FeedbackKitContract.swift
//  FeedbackKit
//

import Foundation
import DataKit

public struct FeedbackKitContract: @unchecked Sendable {
    public static let shared = FeedbackKitContract()
    public let contract: PackageContract
    
    private init() { contract = Self.loadContract() }
    
    public func register() async {
        try? await PackageOrchestrator.shared.attachPackage(contract)
        await MLIndexer.shared.indexPackage(contract)
    }
    
    private static func loadContract() -> PackageContract {
        let bundle = Bundle.module
        return PackageContract(
            manifest: loadJSON(PackageManifestSchema.self, "Package.manifest", bundle) ?? PackageManifestSchema(id: "com.flowkit.feedbackkit", name: "FeedbackKit", category: PackageCategory.social),
            capabilities: loadJSON(PackageCapabilities.self, "Package.capabilities", bundle) ?? PackageCapabilities(),
            state: loadJSON(PackageStateSchema.self, "Package.state", bundle) ?? PackageStateSchema(),
            actions: loadJSON(PackageActions.self, "Package.actions", bundle) ?? PackageActions(),
            ui: loadJSON(PackageUI.self, "Package.ui", bundle) ?? PackageUI(),
            agents: loadJSON(PackageAgents.self, "Package.agents", bundle) ?? PackageAgents(),
            workflows: loadJSON(PackageWorkflows.self, "Package.workflows", bundle) ?? PackageWorkflows()
        )
    }
    
    private static func loadJSON<T: Decodable>(_ type: T.Type, _ name: String, _ bundle: Bundle) -> T? {
        guard let url = bundle.url(forResource: name, withExtension: "json"), let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
