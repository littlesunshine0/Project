//
//  CommandKitContract.swift
//  CommandKit
//
//  Gold standard package contract - loads from canonical JSON files
//

import Foundation
import DataKit

// MARK: - CommandKit Contract

public struct CommandKitContract: @unchecked Sendable {
    public static let shared = CommandKitContract()
    
    public let contract: PackageContract
    
    private init() {
        // Load from JSON files or use defaults
        contract = Self.loadContract()
    }
    
    /// Register with the orchestrator
    public func register() async {
        try? await PackageOrchestrator.shared.attachPackage(contract)
        await MLIndexer.shared.indexPackage(contract)
    }
    
    // MARK: - Contract Loading
    
    private static func loadContract() -> PackageContract {
        let bundle = Bundle.module
        
        // Load manifest
        let manifest = loadJSON(PackageManifestSchema.self, from: "Package.manifest", bundle: bundle) ?? defaultManifest
        
        // Load capabilities
        let capabilities = loadJSON(PackageCapabilities.self, from: "Package.capabilities", bundle: bundle) ?? defaultCapabilities
        
        // Load state
        let state = loadJSON(PackageStateSchema.self, from: "Package.state", bundle: bundle) ?? PackageStateSchema()
        
        // Load actions
        let actions = loadJSON(PackageActions.self, from: "Package.actions", bundle: bundle) ?? defaultActions
        
        // Load UI
        let ui = loadJSON(PackageUI.self, from: "Package.ui", bundle: bundle) ?? defaultUI
        
        // Load agents
        let agents = loadJSON(PackageAgents.self, from: "Package.agents", bundle: bundle) ?? defaultAgents
        
        // Load workflows
        let workflows = loadJSON(PackageWorkflows.self, from: "Package.workflows", bundle: bundle) ?? defaultWorkflows
        
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
    
    private static func loadJSON<T: Decodable>(_ type: T.Type, from filename: String, bundle: Bundle) -> T? {
        guard let url = bundle.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    // MARK: - Default Values (Fallback)
    
    private static let defaultManifest = PackageManifestSchema(
        id: "com.flowkit.commandkit",
        name: "CommandKit",
        version: "1.0.0",
        category: PackageCategory.core,
        platforms: [Platform.macOS, Platform.iOS, Platform.visionOS],
        dependencies: ["DataKit", "CoreKit"]
    )
    
    private static let defaultCapabilities = PackageCapabilities(
        nodes: ["Command", "CommandTemplate", "CommandHistory", "Macro"],
        actions: ["command.create", "command.execute", "command.delete", "command.list", "command.search"],
        agents: ["CommandSuggester", "HistoryTracker"],
        commands: ["/run", "/commands", "/help", "/history"],
        ui: [.browser, .list, .editor],
        ml: [.prediction, .recommendation, .search]
    )
    
    private static let defaultActions = PackageActions(actions: [
        PackageActions.ActionDefinition(
            id: "command.create",
            name: "Create Command",
            description: "Create a new command",
            icon: "plus",
            input: [
                PackageActions.ParameterDefinition(name: "name", type: .string),
                PackageActions.ParameterDefinition(name: "syntax", type: .string)
            ],
            output: "Command",
            shortcut: "⌘N",
            category: .create
        ),
        PackageActions.ActionDefinition(
            id: "command.execute",
            name: "Execute Command",
            description: "Execute a command",
            icon: "play.fill",
            input: [PackageActions.ParameterDefinition(name: "commandId", type: .string)],
            output: "ExecutionResult",
            shortcut: "⌘↩",
            category: .execute
        ),
        PackageActions.ActionDefinition(
            id: "command.list",
            name: "List Commands",
            description: "List all commands",
            icon: "list.bullet",
            output: "[Command]",
            category: .read
        ),
        PackageActions.ActionDefinition(
            id: "command.search",
            name: "Search Commands",
            description: "Search commands",
            icon: "magnifyingglass",
            input: [PackageActions.ParameterDefinition(name: "query", type: .string)],
            output: "[Command]",
            shortcut: "⌘F",
            category: .read
        ),
        PackageActions.ActionDefinition(
            id: "command.delete",
            name: "Delete Command",
            description: "Delete a command",
            icon: "trash",
            input: [PackageActions.ParameterDefinition(name: "commandId", type: .string)],
            output: "Bool",
            shortcut: "⌘⌫",
            category: .delete
        )
    ])
    
    private static let defaultUI = PackageUI(
        menus: [
            PackageUI.MenuDefinition(id: "command.main", type: .main, items: [
                PackageUI.MenuItemDefinition(id: "cmd.new", title: "New Command", icon: "plus", action: "command.create", shortcut: "⌘N"),
                PackageUI.MenuItemDefinition(id: "cmd.palette", title: "Command Palette", icon: "command", action: "command.palette.open", shortcut: "⌘K")
            ])
        ],
        views: [
            PackageUI.ViewDefinition(id: "command.browser", type: .browser, title: "Commands", icon: "command"),
            PackageUI.ViewDefinition(id: "command.list", type: .list, title: "Command List", icon: "list.bullet")
        ],
        icons: [
            PackageUI.IconDefinition(id: "command.main", systemName: "command"),
            PackageUI.IconDefinition(id: "command.item", systemName: "terminal")
        ]
    )
    
    private static let defaultAgents = PackageAgents(agents: [
        PackageAgents.AgentDefinition(
            id: "command.suggester",
            name: "Command Suggester",
            description: "Suggests commands based on context",
            triggers: [
                PackageAgents.TriggerDefinition(type: .event, condition: "user.typing"),
                PackageAgents.TriggerDefinition(type: .event, condition: "context.change")
            ],
            actions: ["analyze.context", "suggest.commands"],
            config: PackageAgents.AgentConfig(autoStart: true, priority: .high)
        ),
        PackageAgents.AgentDefinition(
            id: "command.history.tracker",
            name: "History Tracker",
            description: "Tracks command usage",
            triggers: [
                PackageAgents.TriggerDefinition(type: .event, condition: "command.executed")
            ],
            actions: ["record.execution", "update.frequency"],
            config: PackageAgents.AgentConfig(autoStart: true)
        )
    ])
    
    private static let defaultWorkflows = PackageWorkflows(workflows: [
        PackageWorkflows.WorkflowDefinition(
            id: "command.quick.execute",
            name: "Quick Command Execution",
            description: "Execute a command via palette",
            steps: [
                PackageWorkflows.StepDefinition(id: "1", action: "command.palette.open"),
                PackageWorkflows.StepDefinition(id: "2", action: "command.search"),
                PackageWorkflows.StepDefinition(id: "3", action: "command.execute")
            ],
            triggers: ["shortcut.⌘K"]
        )
    ])
}

// MARK: - Quick Access

public extension CommandKitContract {
    /// Get all registered commands
    var commands: [String] {
        contract.capabilities.commands
    }
    
    /// Get all actions
    var actions: [PackageActions.ActionDefinition] {
        contract.actions.actions
    }
    
    /// Get all agents
    var agents: [PackageAgents.AgentDefinition] {
        contract.agents.agents
    }
    
    /// Get all workflows
    var workflows: [PackageWorkflows.WorkflowDefinition] {
        contract.workflows.workflows
    }
    
    /// Get main menu
    var mainMenu: PackageUI.MenuDefinition? {
        contract.ui.menus.first { $0.type == .main }
    }
    
    /// Get context menu
    var contextMenu: PackageUI.MenuDefinition? {
        contract.ui.menus.first { $0.type == .context }
    }
}
