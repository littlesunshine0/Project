//
//  TabSystem.swift
//  UIKit
//
//  Tab and tab bar systems
//

import Foundation
import DataKit

// MARK: - Tab System

public struct TabSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "tab"
    public let name = "Tab System"
    public let description = "Flexible tab system for document tabs, settings tabs, etc."
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let style: TabStyle
        public let position: TabPosition
        public let allowReordering: Bool
        public let allowClosing: Bool
        public let allowPinning: Bool
        public let showCloseOnHover: Bool
        public let maxVisibleTabs: Int?
        public let tabWidth: TabWidth
        public let showNewTabButton: Bool
        
        public static let `default` = Configuration(
            style: .document,
            position: .top,
            allowReordering: true,
            allowClosing: true,
            allowPinning: true,
            showCloseOnHover: true,
            maxVisibleTabs: nil,
            tabWidth: .flexible,
            showNewTabButton: true
        )
        
        public init(style: TabStyle = .document, position: TabPosition = .top, allowReordering: Bool = true, allowClosing: Bool = true, allowPinning: Bool = true, showCloseOnHover: Bool = true, maxVisibleTabs: Int? = nil, tabWidth: TabWidth = .flexible, showNewTabButton: Bool = true) {
            self.style = style
            self.position = position
            self.allowReordering = allowReordering
            self.allowClosing = allowClosing
            self.allowPinning = allowPinning
            self.showCloseOnHover = showCloseOnHover
            self.maxVisibleTabs = maxVisibleTabs
            self.tabWidth = tabWidth
            self.showNewTabButton = showNewTabButton
        }
        
        public enum TabStyle: String, Codable, Sendable { case document, segment, pill, underline, card }
        public enum TabPosition: String, Codable, Sendable { case top, bottom, leading, trailing }
        public enum TabWidth: String, Codable, Sendable { case fixed, flexible, compact }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var tabs: [Tab]
        public var selectedTabId: String?
        public var pinnedTabIds: Set<String>
        public var hoveredTabId: String?
        public var draggingTabId: String?
        public var overflowTabs: [Tab]
        
        public static let initial = State(
            tabs: [],
            selectedTabId: nil,
            pinnedTabIds: [],
            hoveredTabId: nil,
            draggingTabId: nil,
            overflowTabs: []
        )
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

// MARK: - Tab

public struct Tab: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var title: String
    public var icon: String?
    public var iconColor: String?
    public var isModified: Bool
    public var isPinned: Bool
    public var isClosable: Bool
    public var badge: String?
    public var tooltip: String?
    public var contextMenuItems: [TabContextMenuItem]?
    public var metadata: [String: String]?
    
    public init(id: String, title: String, icon: String? = nil, iconColor: String? = nil, isModified: Bool = false, isPinned: Bool = false, isClosable: Bool = true, badge: String? = nil, tooltip: String? = nil, contextMenuItems: [TabContextMenuItem]? = nil, metadata: [String: String]? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.isModified = isModified
        self.isPinned = isPinned
        self.isClosable = isClosable
        self.badge = badge
        self.tooltip = tooltip
        self.contextMenuItems = contextMenuItems
        self.metadata = metadata
    }
}

public struct TabContextMenuItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    public let action: String
    public let shortcut: String?
    public let isDestructive: Bool
    
    public init(id: String, title: String, icon: String? = nil, action: String, shortcut: String? = nil, isDestructive: Bool = false) {
        self.id = id
        self.title = title
        self.icon = icon
        self.action = action
        self.shortcut = shortcut
        self.isDestructive = isDestructive
    }
}

// MARK: - Segmented Control System

public struct SegmentedControlSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "segmentedControl"
    public let name = "Segmented Control"
    public let description = "Segmented control for switching between views or options"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let style: SegmentStyle
        public let size: SegmentSize
        public let allowMultipleSelection: Bool
        public let showIcons: Bool
        public let showLabels: Bool
        
        public static let `default` = Configuration(
            style: .automatic,
            size: .regular,
            allowMultipleSelection: false,
            showIcons: true,
            showLabels: true
        )
        
        public init(style: SegmentStyle = .automatic, size: SegmentSize = .regular, allowMultipleSelection: Bool = false, showIcons: Bool = true, showLabels: Bool = true) {
            self.style = style
            self.size = size
            self.allowMultipleSelection = allowMultipleSelection
            self.showIcons = showIcons
            self.showLabels = showLabels
        }
        
        public enum SegmentStyle: String, Codable, Sendable { case automatic, bordered, plain }
        public enum SegmentSize: String, Codable, Sendable { case small, regular, large }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var segments: [Segment]
        public var selectedIds: Set<String>
        
        public static let initial = State(segments: [], selectedIds: [])
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct Segment: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    public let isEnabled: Bool
    
    public init(id: String, title: String, icon: String? = nil, isEnabled: Bool = true) {
        self.id = id
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
    }
}
