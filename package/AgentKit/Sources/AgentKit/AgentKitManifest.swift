//
//  AgentKitManifest.swift
//  AgentKit
//
//  Kit manifest with commands, actions, shortcuts, menus
//

import Foundation
import DataKit

public struct AgentKitManifest {
    public static let shared = AgentKitManifest()
    
    public let manifest: KitManifest
    
    private init() {
        manifest = KitManifest(
            identifier: "com.flowkit.agentkit",
            name: "AgentKit",
            version: "1.0.0",
            description: "Autonomous agent creation and management",
            commands: Self.commands,
            actions: Self.actions,
            shortcuts: Self.shortcuts,
            menuItems: Self.menuItems,
            contextMenus: Self.contextMenus,
            workflows: Self.workflows,
            agents: Self.agents
        )
    }
    
    // MARK: - Commands
    
    private static let commands: [KitCommand] = [
        KitCommand(id: "agent.list", name: "List Agents", description: "List all agents", syntax: "/agents", kit: "AgentKit", handler: "AgentManager.list"),
        KitCommand(id: "agent.start", name: "Start Agent", description: "Start an agent", syntax: "/agent start <name>", kit: "AgentKit", handler: "AgentManager.start"),
        KitCommand(id: "agent.stop", name: "Stop Agent", description: "Stop an agent", syntax: "/agent stop <name>", kit: "AgentKit", handler: "AgentManager.stop"),
        KitCommand(id: "agent.status", name: "Agent Status", description: "Show agent status", syntax: "/agent status [name]", kit: "AgentKit", handler: "AgentManager.status"),
        KitCommand(id: "agent.create", name: "Create Agent", description: "Create new agent", syntax: "/agent new <name>", kit: "AgentKit", handler: "AgentManager.create"),
        KitCommand(id: "agent.logs", name: "Agent Logs", description: "Show agent logs", syntax: "/agent logs <name>", kit: "AgentKit", handler: "AgentManager.logs")
    ]
    
    // MARK: - Actions
    
    private static let actions: [KitAction] = [
        KitAction(id: "action.agent.start", name: "Start Agent", description: "Start the selected agent", icon: "play.fill", kit: "AgentKit", handler: "startAgent"),
        KitAction(id: "action.agent.stop", name: "Stop Agent", description: "Stop the selected agent", icon: "stop.fill", kit: "AgentKit", handler: "stopAgent"),
        KitAction(id: "action.agent.restart", name: "Restart Agent", description: "Restart the selected agent", icon: "arrow.clockwise", kit: "AgentKit", handler: "restartAgent"),
        KitAction(id: "action.agent.edit", name: "Edit Agent", description: "Edit agent configuration", icon: "pencil", kit: "AgentKit", handler: "editAgent"),
        KitAction(id: "action.agent.delete", name: "Delete Agent", description: "Delete agent", icon: "trash", kit: "AgentKit", handler: "deleteAgent"),
        KitAction(id: "action.agent.logs", name: "View Logs", description: "View agent logs", icon: "doc.text", kit: "AgentKit", handler: "viewLogs")
    ]
    
    // MARK: - Shortcuts
    
    private static let shortcuts: [KitShortcut] = [
        KitShortcut(key: "A", modifiers: [.command, .shift], action: "action.agent.browser", description: "Open agent browser", kit: "AgentKit"),
        KitShortcut(key: "S", modifiers: [.command, .option], action: "action.agent.start", description: "Start agent", kit: "AgentKit"),
        KitShortcut(key: "X", modifiers: [.command, .option], action: "action.agent.stop", description: "Stop agent", kit: "AgentKit")
    ]
    
    // MARK: - Menu Items
    
    private static let menuItems: [KitMenuItem] = [
        KitMenuItem(title: "Agents", icon: "cpu", action: "showAgents", shortcut: "⇧⌘A", kit: "AgentKit"),
        KitMenuItem(title: "New Agent", icon: "plus", action: "newAgent", kit: "AgentKit"),
        KitMenuItem(title: "Running Agents", icon: "play.circle", action: "showRunning", kit: "AgentKit"),
        KitMenuItem(title: "Agent Logs", icon: "doc.text", action: "showLogs", kit: "AgentKit"),
        KitMenuItem(title: "Stop All Agents", icon: "stop.circle", action: "stopAll", kit: "AgentKit")
    ]
    
    // MARK: - Context Menus
    
    private static let contextMenus: [KitContextMenu] = [
        KitContextMenu(targetType: "Agent", items: [
            KitMenuItem(title: "Start", icon: "play.fill", action: "startAgent", kit: "AgentKit"),
            KitMenuItem(title: "Stop", icon: "stop.fill", action: "stopAgent", kit: "AgentKit"),
            KitMenuItem(title: "Restart", icon: "arrow.clockwise", action: "restartAgent", kit: "AgentKit"),
            KitMenuItem(title: "View Logs", icon: "doc.text", action: "viewLogs", kit: "AgentKit"),
            KitMenuItem(title: "Edit", icon: "pencil", action: "editAgent", kit: "AgentKit"),
            KitMenuItem(title: "Delete", icon: "trash", action: "deleteAgent", kit: "AgentKit")
        ], kit: "AgentKit")
    ]
    
    // MARK: - Workflows
    
    private static let workflows: [KitWorkflow] = [
        KitWorkflow(name: "Create Monitor Agent", description: "Create a file monitoring agent", steps: ["Define triggers", "Set actions", "Configure schedule", "Deploy"], kit: "AgentKit"),
        KitWorkflow(name: "Deploy Agent Fleet", description: "Deploy multiple agents", steps: ["Select agents", "Configure", "Deploy all", "Verify"], kit: "AgentKit")
    ]
    
    // MARK: - Agents
    
    private static let agents: [KitAgent] = [
        KitAgent(name: "Agent Health Monitor", description: "Monitors agent health", triggers: ["agent.error", "agent.timeout"], actions: ["restart.agent", "notify.admin"], kit: "AgentKit"),
        KitAgent(name: "Resource Monitor", description: "Monitors agent resource usage", triggers: ["timer.1min"], actions: ["check.resources", "scale.agents"], kit: "AgentKit")
    ]
    
    public func register() async {
        await KitRegistry.shared.register(manifest)
    }
}
