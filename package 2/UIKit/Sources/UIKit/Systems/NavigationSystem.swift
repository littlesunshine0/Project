//
//  NavigationSystem.swift
//  UIKit
//
//  Navigation systems including sidebar navigation, outline, and tree views
//

import Foundation
import DataKit

// MARK: - Navigation System

public struct NavigationSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "navigation"
    public let name = "Navigation"
    public let description = "Hierarchical navigation system with sidebar and outline views"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let style: NavigationStyle
        public let showIcons: Bool
        public let showBadges: Bool
        public let allowCollapse: Bool
        public let allowReordering: Bool
        public let allowMultipleSelection: Bool
        public let indentationWidth: CGFloat
        public let rowHeight: CGFloat
        
        public static let `default` = Configuration(
            style: .sidebar,
            showIcons: true,
            showBadges: true,
            allowCollapse: true,
            allowReordering: false,
            allowMultipleSelection: false,
            indentationWidth: 16,
            rowHeight: 28
        )
        
        public init(style: NavigationStyle = .sidebar, showIcons: Bool = true, showBadges: Bool = true, allowCollapse: Bool = true, allowReordering: Bool = false, allowMultipleSelection: Bool = false, indentationWidth: CGFloat = 16, rowHeight: CGFloat = 28) {
            self.style = style
            self.showIcons = showIcons
            self.showBadges = showBadges
            self.allowCollapse = allowCollapse
            self.allowReordering = allowReordering
            self.allowMultipleSelection = allowMultipleSelection
            self.indentationWidth = indentationWidth
            self.rowHeight = rowHeight
        }
        
        public enum NavigationStyle: String, Codable, Sendable { case sidebar, outline, tree, list, grid }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var items: [NavigationItem]
        public var selectedIds: Set<String>
        public var expandedIds: Set<String>
        public var hoveredId: String?
        public var focusedId: String?
        public var searchQuery: String
        public var filteredItems: [NavigationItem]?
        
        public static let initial = State(
            items: [],
            selectedIds: [],
            expandedIds: [],
            hoveredId: nil,
            focusedId: nil,
            searchQuery: "",
            filteredItems: nil
        )
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

// MARK: - Navigation Item

public struct NavigationItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    public let iconColor: String?
    public let route: String
    public let badge: NavigationBadge?
    public let children: [NavigationItem]?
    public let isExpandable: Bool
    public let isSelectable: Bool
    public let isDraggable: Bool
    public let contextMenuItems: [NavigationContextMenuItem]?
    public let metadata: [String: String]?
    
    public init(id: String, title: String, icon: String? = nil, iconColor: String? = nil, route: String, badge: NavigationBadge? = nil, children: [NavigationItem]? = nil, isExpandable: Bool = true, isSelectable: Bool = true, isDraggable: Bool = false, contextMenuItems: [NavigationContextMenuItem]? = nil, metadata: [String: String]? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.route = route
        self.badge = badge
        self.children = children
        self.isExpandable = isExpandable
        self.isSelectable = isSelectable
        self.isDraggable = isDraggable
        self.contextMenuItems = contextMenuItems
        self.metadata = metadata
    }
}

public struct NavigationBadge: Codable, Sendable, Hashable {
    public let text: String
    public let style: BadgeStyle
    public let color: String?
    
    public init(text: String, style: BadgeStyle = .count, color: String? = nil) {
        self.text = text
        self.style = style
        self.color = color
    }
    
    public enum BadgeStyle: String, Codable, Sendable { case count, dot, text, icon }
}

public struct NavigationContextMenuItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    public let action: String
    public let shortcut: String?
    public let isDestructive: Bool
    public let children: [NavigationContextMenuItem]?
    
    public init(id: String, title: String, icon: String? = nil, action: String, shortcut: String? = nil, isDestructive: Bool = false, children: [NavigationContextMenuItem]? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.action = action
        self.shortcut = shortcut
        self.isDestructive = isDestructive
        self.children = children
    }
}

// MARK: - Outline System

public struct OutlineSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "outline"
    public let name = "Outline"
    public let description = "Hierarchical outline view for documents and structures"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iPadOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let showDisclosureIndicators: Bool
        public let showLineNumbers: Bool
        public let showIcons: Bool
        public let allowEditing: Bool
        public let allowDragDrop: Bool
        public let indentationWidth: CGFloat
        
        public static let `default` = Configuration(
            showDisclosureIndicators: true,
            showLineNumbers: false,
            showIcons: true,
            allowEditing: false,
            allowDragDrop: false,
            indentationWidth: 20
        )
        
        public init(showDisclosureIndicators: Bool = true, showLineNumbers: Bool = false, showIcons: Bool = true, allowEditing: Bool = false, allowDragDrop: Bool = false, indentationWidth: CGFloat = 20) {
            self.showDisclosureIndicators = showDisclosureIndicators
            self.showLineNumbers = showLineNumbers
            self.showIcons = showIcons
            self.allowEditing = allowEditing
            self.allowDragDrop = allowDragDrop
            self.indentationWidth = indentationWidth
        }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var items: [OutlineItem]
        public var selectedIds: Set<String>
        public var expandedIds: Set<String>
        public var editingId: String?
        
        public static let initial = State(items: [], selectedIds: [], expandedIds: [], editingId: nil)
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct OutlineItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    public let level: Int
    public let children: [OutlineItem]?
    public let metadata: [String: String]?
    
    public init(id: String, title: String, icon: String? = nil, level: Int = 0, children: [OutlineItem]? = nil, metadata: [String: String]? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.level = level
        self.children = children
        self.metadata = metadata
    }
}

// MARK: - File Tree System

public struct FileTreeSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "fileTree"
    public let name = "File Tree"
    public let description = "File system tree view with icons and actions"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iPadOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let showHiddenFiles: Bool
        public let showFileExtensions: Bool
        public let showFileSize: Bool
        public let showModifiedDate: Bool
        public let sortBy: SortOption
        public let sortAscending: Bool
        public let groupFoldersFirst: Bool
        
        public static let `default` = Configuration(
            showHiddenFiles: false,
            showFileExtensions: true,
            showFileSize: false,
            showModifiedDate: false,
            sortBy: .name,
            sortAscending: true,
            groupFoldersFirst: true
        )
        
        public init(showHiddenFiles: Bool = false, showFileExtensions: Bool = true, showFileSize: Bool = false, showModifiedDate: Bool = false, sortBy: SortOption = .name, sortAscending: Bool = true, groupFoldersFirst: Bool = true) {
            self.showHiddenFiles = showHiddenFiles
            self.showFileExtensions = showFileExtensions
            self.showFileSize = showFileSize
            self.showModifiedDate = showModifiedDate
            self.sortBy = sortBy
            self.sortAscending = sortAscending
            self.groupFoldersFirst = groupFoldersFirst
        }
        
        public enum SortOption: String, Codable, Sendable { case name, date, size, type }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var rootPath: String
        public var items: [FileTreeItem]
        public var selectedPaths: Set<String>
        public var expandedPaths: Set<String>
        public var renamingPath: String?
        
        public static let initial = State(rootPath: "/", items: [], selectedPaths: [], expandedPaths: [], renamingPath: nil)
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct FileTreeItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let path: String
    public let isDirectory: Bool
    public let icon: String
    public let iconColor: String?
    public let size: Int64?
    public let modifiedDate: Date?
    public let children: [FileTreeItem]?
    
    public init(id: String, name: String, path: String, isDirectory: Bool, icon: String, iconColor: String? = nil, size: Int64? = nil, modifiedDate: Date? = nil, children: [FileTreeItem]? = nil) {
        self.id = id
        self.name = name
        self.path = path
        self.isDirectory = isDirectory
        self.icon = icon
        self.iconColor = iconColor
        self.size = size
        self.modifiedDate = modifiedDate
        self.children = children
    }
}
