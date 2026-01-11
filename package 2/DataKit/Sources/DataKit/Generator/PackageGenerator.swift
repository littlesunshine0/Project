//
//  PackageGenerator.swift
//  DataKit
//
//  Generates complete package structure from templates
//  Creates all canonical files automatically
//

import Foundation

// MARK: - Package Generator

public struct PackageGenerator {
    
    /// Generate a complete package contract from minimal input
    public static func generate(
        id: String,
        name: String,
        category: PackageCategory,
        description: String,
        nodes: [String] = [],
        dependencies: [String] = ["DataKit"]
    ) -> PackageContract {
        
        let manifest = PackageManifestSchema(
            id: id,
            name: name,
            category: category,
            dependencies: dependencies
        )
        
        let capabilities = PackageCapabilities(
            nodes: nodes,
            actions: generateDefaultActions(for: name),
            agents: ["\(name)Agent"],
            commands: generateDefaultCommands(for: name),
            ui: [.browser, .list, .editor],
            ml: [.search, .recommendation]
        )
        
        let state = PackageStateSchema()
        
        let actions = PackageActions(
            actions: generateActionDefinitions(for: name, nodes: nodes)
        )
        
        let ui = PackageUI(
            menus: generateMenuDefinitions(for: name),
            views: generateViewDefinitions(for: name),
            icons: generateIconDefinitions(for: name)
        )
        
        let agents = PackageAgents(
            agents: generateAgentDefinitions(for: name)
        )
        
        let workflows = PackageWorkflows(
            workflows: generateWorkflowDefinitions(for: name, nodes: nodes)
        )
        
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
    
    // MARK: - Default Generators
    
    private static func generateDefaultActions(for name: String) -> [String] {
        let prefix = name.lowercased().replacingOccurrences(of: "kit", with: "")
        return [
            "\(prefix).create",
            "\(prefix).read",
            "\(prefix).update",
            "\(prefix).delete",
            "\(prefix).list",
            "\(prefix).search",
            "\(prefix).export",
            "\(prefix).import"
        ]
    }
    
    private static func generateDefaultCommands(for name: String) -> [String] {
        let prefix = name.lowercased().replacingOccurrences(of: "kit", with: "")
        return [
            "/\(prefix) create",
            "/\(prefix) list",
            "/\(prefix) search",
            "/\(prefix) delete"
        ]
    }
    
    private static func generateActionDefinitions(for name: String, nodes: [String]) -> [PackageActions.ActionDefinition] {
        let prefix = name.lowercased().replacingOccurrences(of: "kit", with: "")
        let nodeName = nodes.first ?? prefix.capitalized
        
        return [
            PackageActions.ActionDefinition(
                id: "\(prefix).create",
                name: "Create \(nodeName)",
                description: "Create a new \(nodeName.lowercased())",
                icon: "plus",
                input: [
                    PackageActions.ParameterDefinition(name: "name", type: .string),
                    PackageActions.ParameterDefinition(name: "description", type: .string, required: false)
                ],
                output: nodeName,
                shortcut: "⌘N",
                category: .create
            ),
            PackageActions.ActionDefinition(
                id: "\(prefix).read",
                name: "Get \(nodeName)",
                description: "Get a \(nodeName.lowercased()) by ID",
                icon: "doc",
                input: [
                    PackageActions.ParameterDefinition(name: "id", type: .string)
                ],
                output: nodeName,
                category: .read
            ),
            PackageActions.ActionDefinition(
                id: "\(prefix).update",
                name: "Update \(nodeName)",
                description: "Update an existing \(nodeName.lowercased())",
                icon: "pencil",
                input: [
                    PackageActions.ParameterDefinition(name: "id", type: .string),
                    PackageActions.ParameterDefinition(name: "changes", type: .object)
                ],
                output: nodeName,
                shortcut: "⌘S",
                category: .update
            ),
            PackageActions.ActionDefinition(
                id: "\(prefix).delete",
                name: "Delete \(nodeName)",
                description: "Delete a \(nodeName.lowercased())",
                icon: "trash",
                input: [
                    PackageActions.ParameterDefinition(name: "id", type: .string)
                ],
                output: "Bool",
                shortcut: "⌘⌫",
                category: .delete
            ),
            PackageActions.ActionDefinition(
                id: "\(prefix).list",
                name: "List \(nodeName)s",
                description: "List all \(nodeName.lowercased())s",
                icon: "list.bullet",
                output: "[\(nodeName)]",
                category: .read
            ),
            PackageActions.ActionDefinition(
                id: "\(prefix).search",
                name: "Search \(nodeName)s",
                description: "Search \(nodeName.lowercased())s",
                icon: "magnifyingglass",
                input: [
                    PackageActions.ParameterDefinition(name: "query", type: .string)
                ],
                output: "[\(nodeName)]",
                shortcut: "⌘F",
                category: .read
            ),
            PackageActions.ActionDefinition(
                id: "\(prefix).export",
                name: "Export \(nodeName)",
                description: "Export \(nodeName.lowercased()) to file",
                icon: "square.and.arrow.up",
                input: [
                    PackageActions.ParameterDefinition(name: "id", type: .string),
                    PackageActions.ParameterDefinition(name: "format", type: .string, required: false, defaultValue: "json")
                ],
                output: "URL",
                category: .export
            ),
            PackageActions.ActionDefinition(
                id: "\(prefix).import",
                name: "Import \(nodeName)",
                description: "Import \(nodeName.lowercased()) from file",
                icon: "square.and.arrow.down",
                input: [
                    PackageActions.ParameterDefinition(name: "file", type: .file)
                ],
                output: nodeName,
                category: .create
            ),
            PackageActions.ActionDefinition(
                id: "\(prefix).duplicate",
                name: "Duplicate \(nodeName)",
                description: "Duplicate a \(nodeName.lowercased())",
                icon: "plus.square.on.square",
                input: [
                    PackageActions.ParameterDefinition(name: "id", type: .string)
                ],
                output: nodeName,
                shortcut: "⌘D",
                category: .create
            ),
            PackageActions.ActionDefinition(
                id: "\(prefix).share",
                name: "Share \(nodeName)",
                description: "Share a \(nodeName.lowercased())",
                icon: "square.and.arrow.up",
                input: [
                    PackageActions.ParameterDefinition(name: "id", type: .string)
                ],
                output: "URL",
                category: .share
            )
        ]
    }
    
    private static func generateMenuDefinitions(for name: String) -> [PackageUI.MenuDefinition] {
        let prefix = name.lowercased().replacingOccurrences(of: "kit", with: "")
        
        return [
            PackageUI.MenuDefinition(
                id: "\(prefix).main",
                type: .main,
                items: [
                    PackageUI.MenuItemDefinition(id: "\(prefix).new", title: "New", icon: "plus", action: "\(prefix).create", shortcut: "⌘N"),
                    PackageUI.MenuItemDefinition(id: "\(prefix).open", title: "Open", icon: "doc", action: "\(prefix).read", shortcut: "⌘O"),
                    PackageUI.MenuItemDefinition(id: "\(prefix).save", title: "Save", icon: "square.and.arrow.down", action: "\(prefix).update", shortcut: "⌘S"),
                    PackageUI.MenuItemDefinition(id: "\(prefix).delete", title: "Delete", icon: "trash", action: "\(prefix).delete", shortcut: "⌘⌫")
                ]
            ),
            PackageUI.MenuDefinition(
                id: "\(prefix).context",
                type: .context,
                items: [
                    PackageUI.MenuItemDefinition(id: "\(prefix).ctx.open", title: "Open", icon: "doc", action: "\(prefix).read"),
                    PackageUI.MenuItemDefinition(id: "\(prefix).ctx.edit", title: "Edit", icon: "pencil", action: "\(prefix).update"),
                    PackageUI.MenuItemDefinition(id: "\(prefix).ctx.duplicate", title: "Duplicate", icon: "plus.square.on.square", action: "\(prefix).duplicate"),
                    PackageUI.MenuItemDefinition(id: "\(prefix).ctx.share", title: "Share", icon: "square.and.arrow.up", action: "\(prefix).share"),
                    PackageUI.MenuItemDefinition(id: "\(prefix).ctx.delete", title: "Delete", icon: "trash", action: "\(prefix).delete")
                ]
            ),
            PackageUI.MenuDefinition(
                id: "\(prefix).help",
                type: .help,
                items: [
                    PackageUI.MenuItemDefinition(id: "\(prefix).help.docs", title: "Documentation", icon: "book", action: "showDocs"),
                    PackageUI.MenuItemDefinition(id: "\(prefix).help.shortcuts", title: "Keyboard Shortcuts", icon: "keyboard", action: "showShortcuts"),
                    PackageUI.MenuItemDefinition(id: "\(prefix).help.about", title: "About \(name)", icon: "info.circle", action: "showAbout")
                ]
            )
        ]
    }
    
    private static func generateViewDefinitions(for name: String) -> [PackageUI.ViewDefinition] {
        let prefix = name.lowercased().replacingOccurrences(of: "kit", with: "")
        
        return [
            PackageUI.ViewDefinition(id: "\(prefix).browser", type: .browser, title: name, icon: "folder"),
            PackageUI.ViewDefinition(id: "\(prefix).list", type: .list, title: "\(name) List", icon: "list.bullet"),
            PackageUI.ViewDefinition(id: "\(prefix).editor", type: .editor, title: "Editor", icon: "pencil"),
            PackageUI.ViewDefinition(id: "\(prefix).settings", type: .settings, title: "Settings", icon: "gearshape")
        ]
    }
    
    private static func generateIconDefinitions(for name: String) -> [PackageUI.IconDefinition] {
        let prefix = name.lowercased().replacingOccurrences(of: "kit", with: "")
        
        return [
            PackageUI.IconDefinition(id: "\(prefix).main", systemName: "folder"),
            PackageUI.IconDefinition(id: "\(prefix).item", systemName: "doc"),
            PackageUI.IconDefinition(id: "\(prefix).add", systemName: "plus"),
            PackageUI.IconDefinition(id: "\(prefix).edit", systemName: "pencil"),
            PackageUI.IconDefinition(id: "\(prefix).delete", systemName: "trash")
        ]
    }
    
    private static func generateAgentDefinitions(for name: String) -> [PackageAgents.AgentDefinition] {
        let prefix = name.lowercased().replacingOccurrences(of: "kit", with: "")
        
        return [
            PackageAgents.AgentDefinition(
                id: "\(prefix).suggester",
                name: "\(name) Suggester",
                description: "Suggests \(prefix)s based on context",
                triggers: [
                    PackageAgents.TriggerDefinition(type: .event, condition: "context.change"),
                    PackageAgents.TriggerDefinition(type: .event, condition: "user.typing")
                ],
                actions: ["analyze.context", "suggest.\(prefix)s", "rank.suggestions"]
            ),
            PackageAgents.AgentDefinition(
                id: "\(prefix).optimizer",
                name: "\(name) Optimizer",
                description: "Optimizes \(prefix) operations",
                triggers: [
                    PackageAgents.TriggerDefinition(type: .schedule, condition: "daily"),
                    PackageAgents.TriggerDefinition(type: .event, condition: "\(prefix).created")
                ],
                actions: ["analyze.\(prefix)s", "suggest.improvements", "auto.optimize"]
            ),
            PackageAgents.AgentDefinition(
                id: "\(prefix).monitor",
                name: "\(name) Monitor",
                description: "Monitors \(prefix) health and usage",
                triggers: [
                    PackageAgents.TriggerDefinition(type: .schedule, condition: "hourly")
                ],
                actions: ["check.health", "collect.metrics", "alert.issues"],
                config: PackageAgents.AgentConfig(autoStart: true)
            )
        ]
    }
    
    private static func generateWorkflowDefinitions(for name: String, nodes: [String]) -> [PackageWorkflows.WorkflowDefinition] {
        let prefix = name.lowercased().replacingOccurrences(of: "kit", with: "")
        let nodeName = nodes.first ?? prefix.capitalized
        
        return [
            PackageWorkflows.WorkflowDefinition(
                id: "\(prefix).create.workflow",
                name: "Create \(nodeName)",
                description: "Create a new \(nodeName.lowercased())",
                steps: [
                    PackageWorkflows.StepDefinition(id: "1", action: "\(prefix).create"),
                    PackageWorkflows.StepDefinition(id: "2", action: "\(prefix).update", condition: "hasChanges"),
                    PackageWorkflows.StepDefinition(id: "3", action: "notify.success")
                ]
            ),
            PackageWorkflows.WorkflowDefinition(
                id: "\(prefix).import.workflow",
                name: "Import \(nodeName)s",
                description: "Import \(nodeName.lowercased())s from file",
                steps: [
                    PackageWorkflows.StepDefinition(id: "1", action: "file.select"),
                    PackageWorkflows.StepDefinition(id: "2", action: "\(prefix).import"),
                    PackageWorkflows.StepDefinition(id: "3", action: "\(prefix).list"),
                    PackageWorkflows.StepDefinition(id: "4", action: "notify.success")
                ]
            ),
            PackageWorkflows.WorkflowDefinition(
                id: "\(prefix).export.workflow",
                name: "Export \(nodeName)s",
                description: "Export \(nodeName.lowercased())s to file",
                steps: [
                    PackageWorkflows.StepDefinition(id: "1", action: "\(prefix).list"),
                    PackageWorkflows.StepDefinition(id: "2", action: "select.items"),
                    PackageWorkflows.StepDefinition(id: "3", action: "\(prefix).export"),
                    PackageWorkflows.StepDefinition(id: "4", action: "notify.success")
                ]
            ),
            PackageWorkflows.WorkflowDefinition(
                id: "\(prefix).cleanup.workflow",
                name: "Cleanup \(nodeName)s",
                description: "Clean up unused \(nodeName.lowercased())s",
                steps: [
                    PackageWorkflows.StepDefinition(id: "1", action: "\(prefix).list"),
                    PackageWorkflows.StepDefinition(id: "2", action: "filter.unused"),
                    PackageWorkflows.StepDefinition(id: "3", action: "confirm.delete"),
                    PackageWorkflows.StepDefinition(id: "4", action: "\(prefix).delete"),
                    PackageWorkflows.StepDefinition(id: "5", action: "notify.success")
                ],
                triggers: ["schedule.weekly"]
            )
        ]
    }
    
    // MARK: - JSON Export
    
    /// Export package contract to JSON files
    public static func exportToJSON(_ contract: PackageContract, directory: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        // manifest.json
        let manifestData = try encoder.encode(contract.manifest)
        try manifestData.write(to: directory.appendingPathComponent("Package.manifest.json"))
        
        // capabilities.json
        let capabilitiesData = try encoder.encode(contract.capabilities)
        try capabilitiesData.write(to: directory.appendingPathComponent("Package.capabilities.json"))
        
        // state.json
        let stateData = try encoder.encode(contract.state)
        try stateData.write(to: directory.appendingPathComponent("Package.state.json"))
        
        // actions.json
        let actionsData = try encoder.encode(contract.actions)
        try actionsData.write(to: directory.appendingPathComponent("Package.actions.json"))
        
        // ui.json
        let uiData = try encoder.encode(contract.ui)
        try uiData.write(to: directory.appendingPathComponent("Package.ui.json"))
        
        // agents.json
        let agentsData = try encoder.encode(contract.agents)
        try agentsData.write(to: directory.appendingPathComponent("Package.agents.json"))
        
        // workflows.json
        let workflowsData = try encoder.encode(contract.workflows)
        try workflowsData.write(to: directory.appendingPathComponent("Package.workflows.json"))
    }
    
    /// Import package contract from JSON files
    public static func importFromJSON(directory: URL) throws -> PackageContract {
        let decoder = JSONDecoder()
        
        let manifestData = try Data(contentsOf: directory.appendingPathComponent("Package.manifest.json"))
        let manifest = try decoder.decode(PackageManifestSchema.self, from: manifestData)
        
        let capabilitiesData = try Data(contentsOf: directory.appendingPathComponent("Package.capabilities.json"))
        let capabilities = try decoder.decode(PackageCapabilities.self, from: capabilitiesData)
        
        let stateData = try Data(contentsOf: directory.appendingPathComponent("Package.state.json"))
        let state = try decoder.decode(PackageStateSchema.self, from: stateData)
        
        let actionsData = try Data(contentsOf: directory.appendingPathComponent("Package.actions.json"))
        let actions = try decoder.decode(PackageActions.self, from: actionsData)
        
        let uiData = try Data(contentsOf: directory.appendingPathComponent("Package.ui.json"))
        let ui = try decoder.decode(PackageUI.self, from: uiData)
        
        let agentsData = try Data(contentsOf: directory.appendingPathComponent("Package.agents.json"))
        let agents = try decoder.decode(PackageAgents.self, from: agentsData)
        
        let workflowsData = try Data(contentsOf: directory.appendingPathComponent("Package.workflows.json"))
        let workflows = try decoder.decode(PackageWorkflows.self, from: workflowsData)
        
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
}
