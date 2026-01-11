//
//  KitRegistry.swift
//  DataKit
//
//  Central registry for all Kit capabilities
//

import Foundation

// MARK: - Kit Registry

public actor KitRegistry {
    public static let shared = KitRegistry()
    
    private var registeredKits: [String: KitManifest] = [:]
    private var commands: [String: KitCommand] = [:]
    private var actions: [String: KitAction] = [:]
    private var shortcuts: [String: KitShortcut] = [:]
    private var menuItems: [String: [KitMenuItem]] = [:]
    private var contextMenus: [String: [KitContextMenu]] = [:]
    
    private init() {}
    
    // MARK: - Kit Registration
    
    public func register(_ manifest: KitManifest) {
        registeredKits[manifest.identifier] = manifest
        
        // Register commands
        for command in manifest.commands {
            commands[command.id] = command
        }
        
        // Register actions
        for action in manifest.actions {
            actions[action.id] = action
        }
        
        // Register shortcuts
        for shortcut in manifest.shortcuts {
            shortcuts[shortcut.key] = shortcut
        }
        
        // Register menu items
        menuItems[manifest.identifier] = manifest.menuItems
        
        // Register context menus
        contextMenus[manifest.identifier] = manifest.contextMenus
    }
    
    // MARK: - Queries
    
    public func getAllKits() -> [KitManifest] {
        Array(registeredKits.values)
    }
    
    public func getKit(_ identifier: String) -> KitManifest? {
        registeredKits[identifier]
    }
    
    public func getAllCommands() -> [KitCommand] {
        Array(commands.values)
    }
    
    public func getCommand(_ id: String) -> KitCommand? {
        commands[id]
    }
    
    public func getAllActions() -> [KitAction] {
        Array(actions.values)
    }
    
    public func getAction(_ id: String) -> KitAction? {
        actions[id]
    }
    
    public func getShortcut(for key: String) -> KitShortcut? {
        shortcuts[key]
    }
    
    public func getAllShortcuts() -> [KitShortcut] {
        Array(shortcuts.values)
    }
    
    public func getMenuItems(for kit: String) -> [KitMenuItem] {
        menuItems[kit] ?? []
    }
    
    public func getAllMenuItems() -> [KitMenuItem] {
        menuItems.values.flatMap { $0 }
    }
    
    public func getContextMenus(for kit: String) -> [KitContextMenu] {
        contextMenus[kit] ?? []
    }
}

// MARK: - Kit Manifest

public struct KitManifest: Identifiable, Sendable {
    public let id: UUID
    public let identifier: String
    public let name: String
    public let version: String
    public let description: String
    public let commands: [KitCommand]
    public let actions: [KitAction]
    public let shortcuts: [KitShortcut]
    public let menuItems: [KitMenuItem]
    public let contextMenus: [KitContextMenu]
    public let workflows: [KitWorkflow]
    public let agents: [KitAgent]
    
    public init(
        id: UUID = UUID(),
        identifier: String,
        name: String,
        version: String = "1.0.0",
        description: String = "",
        commands: [KitCommand] = [],
        actions: [KitAction] = [],
        shortcuts: [KitShortcut] = [],
        menuItems: [KitMenuItem] = [],
        contextMenus: [KitContextMenu] = [],
        workflows: [KitWorkflow] = [],
        agents: [KitAgent] = []
    ) {
        self.id = id
        self.identifier = identifier
        self.name = name
        self.version = version
        self.description = description
        self.commands = commands
        self.actions = actions
        self.shortcuts = shortcuts
        self.menuItems = menuItems
        self.contextMenus = contextMenus
        self.workflows = workflows
        self.agents = agents
    }
}

// MARK: - Kit Command

public struct KitCommand: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let syntax: String
    public let kit: String
    public let handler: String
    
    public init(id: String, name: String, description: String, syntax: String, kit: String, handler: String) {
        self.id = id
        self.name = name
        self.description = description
        self.syntax = syntax
        self.kit = kit
        self.handler = handler
    }
}

// MARK: - Kit Action

public struct KitAction: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let icon: String
    public let kit: String
    public let handler: String
    public let isEnabled: Bool
    
    public init(id: String, name: String, description: String, icon: String, kit: String, handler: String, isEnabled: Bool = true) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.kit = kit
        self.handler = handler
        self.isEnabled = isEnabled
    }
}

// MARK: - Kit Shortcut

public struct KitShortcut: Identifiable, Sendable {
    public let id: UUID
    public let key: String
    public let modifiers: [KeyModifier]
    public let action: String
    public let description: String
    public let kit: String
    
    public init(id: UUID = UUID(), key: String, modifiers: [KeyModifier], action: String, description: String, kit: String) {
        self.id = id
        self.key = key
        self.modifiers = modifiers
        self.action = action
        self.description = description
        self.kit = kit
    }
    
    public enum KeyModifier: String, Sendable {
        case command, option, shift, control
    }
}

// MARK: - Kit Menu Item

public struct KitMenuItem: Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let icon: String?
    public let action: String
    public let shortcut: String?
    public let submenu: [KitMenuItem]?
    public let kit: String
    
    public init(id: UUID = UUID(), title: String, icon: String? = nil, action: String, shortcut: String? = nil, submenu: [KitMenuItem]? = nil, kit: String) {
        self.id = id
        self.title = title
        self.icon = icon
        self.action = action
        self.shortcut = shortcut
        self.submenu = submenu
        self.kit = kit
    }
}

// MARK: - Kit Context Menu

public struct KitContextMenu: Identifiable, Sendable {
    public let id: UUID
    public let targetType: String
    public let items: [KitMenuItem]
    public let kit: String
    
    public init(id: UUID = UUID(), targetType: String, items: [KitMenuItem], kit: String) {
        self.id = id
        self.targetType = targetType
        self.items = items
        self.kit = kit
    }
}

// MARK: - Kit Workflow

public struct KitWorkflow: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let description: String
    public let steps: [String]
    public let kit: String
    
    public init(id: UUID = UUID(), name: String, description: String, steps: [String], kit: String) {
        self.id = id
        self.name = name
        self.description = description
        self.steps = steps
        self.kit = kit
    }
}

// MARK: - Kit Agent

public struct KitAgent: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let description: String
    public let triggers: [String]
    public let actions: [String]
    public let kit: String
    
    public init(id: UUID = UUID(), name: String, description: String, triggers: [String], actions: [String], kit: String) {
        self.id = id
        self.name = name
        self.description = description
        self.triggers = triggers
        self.actions = actions
        self.kit = kit
    }
}
