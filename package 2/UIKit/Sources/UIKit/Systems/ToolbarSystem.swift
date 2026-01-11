//
//  ToolbarSystem.swift
//  UIKit
//
//  Toolbar and action bar systems
//

import Foundation
import DataKit

// MARK: - Toolbar System

public struct ToolbarSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "toolbar"
    public let name = "Toolbar"
    public let description = "Customizable toolbar with actions, segments, and controls"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let height: CGFloat
        public let style: ToolbarStyle
        public let position: ToolbarPosition
        public let showDivider: Bool
        public let allowCustomization: Bool
        public let showLabels: Bool
        public let iconSize: IconSize
        
        public static let `default` = Configuration(
            height: 52,
            style: .unified,
            position: .top,
            showDivider: true,
            allowCustomization: true,
            showLabels: false,
            iconSize: .medium
        )
        
        public init(height: CGFloat = 52, style: ToolbarStyle = .unified, position: ToolbarPosition = .top, showDivider: Bool = true, allowCustomization: Bool = true, showLabels: Bool = false, iconSize: IconSize = .medium) {
            self.height = height
            self.style = style
            self.position = position
            self.showDivider = showDivider
            self.allowCustomization = allowCustomization
            self.showLabels = showLabels
            self.iconSize = iconSize
        }
        
        public enum ToolbarStyle: String, Codable, Sendable { case unified, expanded, compact, automatic }
        public enum ToolbarPosition: String, Codable, Sendable { case top, bottom, leading, trailing }
        public enum IconSize: String, Codable, Sendable { case small, medium, large }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var items: [ToolbarItem]
        public var leadingItems: [ToolbarItem]
        public var trailingItems: [ToolbarItem]
        public var centerItems: [ToolbarItem]
        public var isCustomizing: Bool
        public var hiddenItemIds: Set<String>
        
        public static let initial = State(
            items: [],
            leadingItems: [],
            trailingItems: [],
            centerItems: [],
            isCustomizing: false,
            hiddenItemIds: []
        )
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

// MARK: - Toolbar Item

public struct ToolbarItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let type: ToolbarItemType
    public let title: String
    public let icon: String?
    public let action: String?
    public let isEnabled: Bool
    public let isVisible: Bool
    public let tooltip: String?
    public let shortcut: String?
    public let menu: [ToolbarMenuItem]?
    
    public init(id: String, type: ToolbarItemType, title: String, icon: String? = nil, action: String? = nil, isEnabled: Bool = true, isVisible: Bool = true, tooltip: String? = nil, shortcut: String? = nil, menu: [ToolbarMenuItem]? = nil) {
        self.id = id
        self.type = type
        self.title = title
        self.icon = icon
        self.action = action
        self.isEnabled = isEnabled
        self.isVisible = isVisible
        self.tooltip = tooltip
        self.shortcut = shortcut
        self.menu = menu
    }
}

public enum ToolbarItemType: String, Codable, Sendable {
    case button
    case toggle
    case menu
    case segmentedControl
    case searchField
    case slider
    case colorPicker
    case spacer
    case flexibleSpacer
    case divider
    case custom
}

public struct ToolbarMenuItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    public let action: String
    public let shortcut: String?
    public let isEnabled: Bool
    public let children: [ToolbarMenuItem]?
    
    public init(id: String, title: String, icon: String? = nil, action: String, shortcut: String? = nil, isEnabled: Bool = true, children: [ToolbarMenuItem]? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.action = action
        self.shortcut = shortcut
        self.isEnabled = isEnabled
        self.children = children
    }
}

// MARK: - Action Bar System

public struct ActionBarSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "actionBar"
    public let name = "Action Bar"
    public let description = "Contextual action bar that appears based on selection"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let height: CGFloat
        public let cornerRadius: CGFloat
        public let position: ActionBarPosition
        public let autoHide: Bool
        public let autoHideDelay: TimeInterval
        
        public static let `default` = Configuration(
            height: 44,
            cornerRadius: 12,
            position: .floating,
            autoHide: true,
            autoHideDelay: 3.0
        )
        
        public init(height: CGFloat = 44, cornerRadius: CGFloat = 12, position: ActionBarPosition = .floating, autoHide: Bool = true, autoHideDelay: TimeInterval = 3.0) {
            self.height = height
            self.cornerRadius = cornerRadius
            self.position = position
            self.autoHide = autoHide
            self.autoHideDelay = autoHideDelay
        }
        
        public enum ActionBarPosition: String, Codable, Sendable { case top, bottom, floating }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var isVisible: Bool
        public var actions: [ActionBarAction]
        public var contextType: String?
        
        public static let initial = State(isVisible: false, actions: [], contextType: nil)
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct ActionBarAction: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let action: String
    public let style: ActionStyle
    
    public init(id: String, title: String, icon: String, action: String, style: ActionStyle = .default) {
        self.id = id
        self.title = title
        self.icon = icon
        self.action = action
        self.style = style
    }
    
    public enum ActionStyle: String, Codable, Sendable { case `default`, primary, destructive }
}
