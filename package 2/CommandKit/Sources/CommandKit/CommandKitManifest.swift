//
//  CommandKitManifest.swift
//  CommandKit
//
//  Kit manifest with commands, actions, shortcuts, menus
//

import Foundation
import DataKit

public struct CommandKitManifest {
    public static let shared = CommandKitManifest()
    
    public let manifest: KitManifest
    
    private init() {
        manifest = KitManifest(
            identifier: "com.flowkit.commandkit",
            name: "CommandKit",
            version: "1.0.0",
            description: "Command parsing, autocomplete, and execution",
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
        KitCommand(id: "cmd.run", name: "Run Command", description: "Execute a command", syntax: "/run <command>", kit: "CommandKit", handler: "CommandManager.execute"),
        KitCommand(id: "cmd.list", name: "List Commands", description: "List all commands", syntax: "/commands", kit: "CommandKit", handler: "CommandManager.list"),
        KitCommand(id: "cmd.help", name: "Command Help", description: "Show command help", syntax: "/help <command>", kit: "CommandKit", handler: "CommandManager.help"),
        KitCommand(id: "cmd.history", name: "Command History", description: "Show command history", syntax: "/history", kit: "CommandKit", handler: "CommandManager.history"),
        KitCommand(id: "cmd.alias", name: "Create Alias", description: "Create command alias", syntax: "/alias <name> <command>", kit: "CommandKit", handler: "CommandManager.alias"),
        KitCommand(id: "cmd.clear", name: "Clear", description: "Clear screen", syntax: "/clear", kit: "CommandKit", handler: "CommandManager.clear")
    ]
    
    // MARK: - Actions
    
    private static let actions: [KitAction] = [
        KitAction(id: "action.cmd.execute", name: "Execute Command", description: "Execute the selected command", icon: "play.fill", kit: "CommandKit", handler: "executeCommand"),
        KitAction(id: "action.cmd.copy", name: "Copy Command", description: "Copy command to clipboard", icon: "doc.on.doc", kit: "CommandKit", handler: "copyCommand"),
        KitAction(id: "action.cmd.favorite", name: "Toggle Favorite", description: "Add/remove from favorites", icon: "star", kit: "CommandKit", handler: "toggleFavorite"),
        KitAction(id: "action.cmd.edit", name: "Edit Command", description: "Edit custom command", icon: "pencil", kit: "CommandKit", handler: "editCommand"),
        KitAction(id: "action.cmd.delete", name: "Delete Command", description: "Delete custom command", icon: "trash", kit: "CommandKit", handler: "deleteCommand")
    ]
    
    // MARK: - Shortcuts
    
    private static let shortcuts: [KitShortcut] = [
        KitShortcut(key: "K", modifiers: [.command], action: "action.cmd.palette", description: "Open command palette", kit: "CommandKit"),
        KitShortcut(key: "P", modifiers: [.command, .shift], action: "action.cmd.palette", description: "Open command palette", kit: "CommandKit"),
        KitShortcut(key: "Return", modifiers: [.command], action: "action.cmd.execute", description: "Execute command", kit: "CommandKit"),
        KitShortcut(key: "H", modifiers: [.command, .shift], action: "action.cmd.history", description: "Show history", kit: "CommandKit"),
        KitShortcut(key: "L", modifiers: [.command], action: "action.cmd.clear", description: "Clear screen", kit: "CommandKit")
    ]
    
    // MARK: - Menu Items
    
    private static let menuItems: [KitMenuItem] = [
        KitMenuItem(title: "Commands", icon: "command", action: "showCommands", shortcut: "⌘K", kit: "CommandKit"),
        KitMenuItem(title: "Command History", icon: "clock.arrow.circlepath", action: "showHistory", shortcut: "⇧⌘H", kit: "CommandKit"),
        KitMenuItem(title: "New Command", icon: "plus", action: "newCommand", kit: "CommandKit"),
        KitMenuItem(title: "Import Commands", icon: "square.and.arrow.down", action: "importCommands", kit: "CommandKit"),
        KitMenuItem(title: "Export Commands", icon: "square.and.arrow.up", action: "exportCommands", kit: "CommandKit")
    ]
    
    // MARK: - Context Menus
    
    private static let contextMenus: [KitContextMenu] = [
        KitContextMenu(targetType: "Command", items: [
            KitMenuItem(title: "Execute", icon: "play.fill", action: "executeCommand", kit: "CommandKit"),
            KitMenuItem(title: "Copy", icon: "doc.on.doc", action: "copyCommand", kit: "CommandKit"),
            KitMenuItem(title: "Edit", icon: "pencil", action: "editCommand", kit: "CommandKit"),
            KitMenuItem(title: "Delete", icon: "trash", action: "deleteCommand", kit: "CommandKit")
        ], kit: "CommandKit")
    ]
    
    // MARK: - Workflows
    
    private static let workflows: [KitWorkflow] = [
        KitWorkflow(name: "Quick Command", description: "Execute a quick command", steps: ["Open palette", "Type command", "Execute"], kit: "CommandKit"),
        KitWorkflow(name: "Create Custom Command", description: "Create a new custom command", steps: ["Open composer", "Define command", "Add parameters", "Save"], kit: "CommandKit")
    ]
    
    // MARK: - Agents
    
    private static let agents: [KitAgent] = [
        KitAgent(name: "Command Suggester", description: "Suggests commands based on context", triggers: ["user.typing", "context.change"], actions: ["suggest.commands"], kit: "CommandKit"),
        KitAgent(name: "History Tracker", description: "Tracks command usage", triggers: ["command.executed"], actions: ["record.history", "update.frequency"], kit: "CommandKit")
    ]
    
    // MARK: - Registration
    
    public func register() async {
        await KitRegistry.shared.register(manifest)
    }
}
