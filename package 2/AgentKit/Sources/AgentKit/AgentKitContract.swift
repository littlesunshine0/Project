//
//  AgentKitContract.swift
//  AgentKit
//
//  Package contract - loads from canonical JSON files
//

import Foundation
import DataKit

public struct AgentKitContract: @unchecked Sendable {
    public static let shared = AgentKitContract()
    
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
        let actions = loadJSON(PackageActions.self, "Package.actions", bundle) ?? defaultActions
        let ui = loadJSON(PackageUI.self, "Package.ui", bundle) ?? PackageUI()
        let agents = loadJSON(PackageAgents.self, "Package.agents", bundle) ?? defaultAgents
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
        id: "com.flowkit.agentkit",
        name: "AgentKit",
        category: .ai,
        dependencies: ["DataKit", "CoreKit", "AIKit"]
    )
    
    private static let defaultActions = PackageActions(actions: [
        PackageActions.ActionDefinition(id: "agent.create", name: "Create Agent", description: "Create a new agent", icon: "plus", output: "Agent", category: .create),
        PackageActions.ActionDefinition(id: "agent.start", name: "Start Agent", description: "Start an agent", icon: "play.fill", input: [PackageActions.ParameterDefinition(name: "agentId", type: .string)], output: "Bool", category: .execute),
        PackageActions.ActionDefinition(id: "agent.stop", name: "Stop Agent", description: "Stop an agent", icon: "stop.fill", input: [PackageActions.ParameterDefinition(name: "agentId", type: .string)], output: "Bool", category: .execute),
        PackageActions.ActionDefinition(id: "agent.list", name: "List Agents", description: "List all agents", icon: "list.bullet", output: "[Agent]", category: .read)
    ])
    
    private static let defaultAgents = PackageAgents(agents: [
        PackageAgents.AgentDefinition(id: "code.assistant", name: "Code Assistant", description: "AI coding assistant", triggers: [PackageAgents.TriggerDefinition(type: .event, condition: "code.edit")], actions: ["analyze.code", "suggest.fix"], config: PackageAgents.AgentConfig(autoStart: true, priority: .high))
    ])
}
