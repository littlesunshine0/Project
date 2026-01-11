//
//  ContextMenuSystem.swift
//  UIKit
//
//  Context menu and command palette systems
//

import Foundation
import DataKit

// MARK: - Context Menu System

public struct ContextMenuSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "contextMenu"
    public let name = "Context Menu"
    public let description = "Right-click context menus with nested items"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let showIcons: Bool
        public let showShortcuts: Bool
        public let maxWidth: CGFloat
        public let cornerRadius: CGFloat
        public let shadowRadius: CGFloat
        
        public static let `default` = Configuration(
            showIcons: true,
            showShortcuts: true,
            maxWidth: 280,
            cornerRadius: 8,
            shadowRadius: 16
        )
        
        public init(showIcons: Bool = true, showShortcuts: Bool = true, maxWidth: CGFloat = 280, cornerRadius: CGFloat = 8, shadowRadius: CGFloat = 16) {
            self.showIcons = showIcons
            self.showShortcuts = showShortcuts
            self.maxWidth = maxWidth
            self.cornerRadius = cornerRadius
            self.shadowRadius = shadowRadius
        }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var isVisible: Bool
        public var position: UIPosition
        public var items: [ContextMenuItem]
        public var hoveredItemId: String?
        public var expandedSubmenuId: String?
        
        public static let initial = State(isVisible: false, position: .zero, items: [], hoveredItemId: nil, expandedSubmenuId: nil)
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

// MARK: - Context Menu Item

public struct ContextMenuItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let type: ContextMenuItemType
    public let title: String?
    public let icon: String?
    public let shortcut: String?
    public let action: String?
    public let isEnabled: Bool
    public let isDestructive: Bool
    public let children: [ContextMenuItem]?
    
    public init(id: String, type: ContextMenuItemType = .action, title: String? = nil, icon: String? = nil, shortcut: String? = nil, action: String? = nil, isEnabled: Bool = true, isDestructive: Bool = false, children: [ContextMenuItem]? = nil) {
        self.id = id
        self.type = type
        self.title = title
        self.icon = icon
        self.shortcut = shortcut
        self.action = action
        self.isEnabled = isEnabled
        self.isDestructive = isDestructive
        self.children = children
    }
    
    public static func action(_ id: String, title: String, icon: String? = nil, shortcut: String? = nil, action: String) -> ContextMenuItem {
        ContextMenuItem(id: id, type: .action, title: title, icon: icon, shortcut: shortcut, action: action)
    }
    
    public static func submenu(_ id: String, title: String, icon: String? = nil, children: [ContextMenuItem]) -> ContextMenuItem {
        ContextMenuItem(id: id, type: .submenu, title: title, icon: icon, children: children)
    }
    
    public static var separator: ContextMenuItem {
        ContextMenuItem(id: UUID().uuidString, type: .separator)
    }
}

public enum ContextMenuItemType: String, Codable, Sendable {
    case action
    case submenu
    case separator
    case header
    case toggle
}

// MARK: - Command Palette System

public struct CommandPaletteSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "commandPalette"
    public let name = "Command Palette"
    public let description = "Spotlight-style command palette for quick actions"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let width: CGFloat
        public let maxHeight: CGFloat
        public let cornerRadius: CGFloat
        public let showIcons: Bool
        public let showShortcuts: Bool
        public let showCategories: Bool
        public let maxResults: Int
        public let fuzzySearch: Bool
        public let showRecentCommands: Bool
        public let recentCommandsLimit: Int
        
        public static let `default` = Configuration(
            width: 600,
            maxHeight: 400,
            cornerRadius: 16,
            showIcons: true,
            showShortcuts: true,
            showCategories: true,
            maxResults: 20,
            fuzzySearch: true,
            showRecentCommands: true,
            recentCommandsLimit: 5
        )
        
        public init(width: CGFloat = 600, maxHeight: CGFloat = 400, cornerRadius: CGFloat = 16, showIcons: Bool = true, showShortcuts: Bool = true, showCategories: Bool = true, maxResults: Int = 20, fuzzySearch: Bool = true, showRecentCommands: Bool = true, recentCommandsLimit: Int = 5) {
            self.width = width
            self.maxHeight = maxHeight
            self.cornerRadius = cornerRadius
            self.showIcons = showIcons
            self.showShortcuts = showShortcuts
            self.showCategories = showCategories
            self.maxResults = maxResults
            self.fuzzySearch = fuzzySearch
            self.showRecentCommands = showRecentCommands
            self.recentCommandsLimit = recentCommandsLimit
        }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var isVisible: Bool
        public var query: String
        public var commands: [Command]
        public var filteredCommands: [Command]
        public var selectedIndex: Int
        public var recentCommands: [Command]
        public var mode: CommandPaletteMode
        
        public static let initial = State(
            isVisible: false,
            query: "",
            commands: [],
            filteredCommands: [],
            selectedIndex: 0,
            recentCommands: [],
            mode: .commands
        )
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public enum CommandPaletteMode: String, Codable, Sendable {
    case commands    // > prefix or default
    case files       // no prefix
    case symbols     // @ prefix
    case lines       // : prefix
    case actions     // / prefix
}

// MARK: - Command

public struct Command: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let icon: String?
    public let category: String?
    public let shortcut: String?
    public let action: String
    public let keywords: [String]?
    public let isEnabled: Bool
    public let providedBy: String?
    
    public init(id: String, title: String, subtitle: String? = nil, icon: String? = nil, category: String? = nil, shortcut: String? = nil, action: String, keywords: [String]? = nil, isEnabled: Bool = true, providedBy: String? = nil) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.category = category
        self.shortcut = shortcut
        self.action = action
        self.keywords = keywords
        self.isEnabled = isEnabled
        self.providedBy = providedBy
    }
}

// MARK: - Quick Actions System

public struct QuickActionsSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "quickActions"
    public let name = "Quick Actions"
    public let description = "Contextual quick action suggestions"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let maxActions: Int
        public let showIcons: Bool
        public let style: QuickActionStyle
        
        public static let `default` = Configuration(
            maxActions: 5,
            showIcons: true,
            style: .pill
        )
        
        public init(maxActions: Int = 5, showIcons: Bool = true, style: QuickActionStyle = .pill) {
            self.maxActions = maxActions
            self.showIcons = showIcons
            self.style = style
        }
        
        public enum QuickActionStyle: String, Codable, Sendable { case pill, button, chip }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var actions: [QuickAction]
        public var isVisible: Bool
        
        public static let initial = State(actions: [], isVisible: false)
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct QuickAction: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    public let action: String
    public let style: QuickActionItemStyle
    
    public init(id: String, title: String, icon: String? = nil, action: String, style: QuickActionItemStyle = .default) {
        self.id = id
        self.title = title
        self.icon = icon
        self.action = action
        self.style = style
    }
    
    public enum QuickActionItemStyle: String, Codable, Sendable { case `default`, primary, secondary }
}
