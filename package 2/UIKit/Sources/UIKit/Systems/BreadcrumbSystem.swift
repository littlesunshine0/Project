//
//  BreadcrumbSystem.swift
//  UIKit
//
//  Breadcrumb navigation system
//

import Foundation
import DataKit

// MARK: - Breadcrumb System

public struct BreadcrumbSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "breadcrumb"
    public let name = "Breadcrumb"
    public let description = "Hierarchical navigation breadcrumb trail"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let height: CGFloat
        public let separator: BreadcrumbSeparator
        public let showIcons: Bool
        public let showHomeIcon: Bool
        public let maxVisibleItems: Int
        public let collapseMode: CollapseMode
        public let allowNavigation: Bool
        public let showDropdownOnHover: Bool
        
        public static let `default` = Configuration(
            height: 32,
            separator: .chevron,
            showIcons: true,
            showHomeIcon: true,
            maxVisibleItems: 5,
            collapseMode: .ellipsis,
            allowNavigation: true,
            showDropdownOnHover: true
        )
        
        public init(height: CGFloat = 32, separator: BreadcrumbSeparator = .chevron, showIcons: Bool = true, showHomeIcon: Bool = true, maxVisibleItems: Int = 5, collapseMode: CollapseMode = .ellipsis, allowNavigation: Bool = true, showDropdownOnHover: Bool = true) {
            self.height = height
            self.separator = separator
            self.showIcons = showIcons
            self.showHomeIcon = showHomeIcon
            self.maxVisibleItems = maxVisibleItems
            self.collapseMode = collapseMode
            self.allowNavigation = allowNavigation
            self.showDropdownOnHover = showDropdownOnHover
        }
        
        public enum BreadcrumbSeparator: String, Codable, Sendable { case chevron, slash, arrow, dot }
        public enum CollapseMode: String, Codable, Sendable { case ellipsis, dropdown, scroll }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var items: [BreadcrumbItem]
        public var hoveredItemId: String?
        public var isDropdownOpen: Bool
        public var dropdownItemId: String?
        
        public static let initial = State(items: [], hoveredItemId: nil, isDropdownOpen: false, dropdownItemId: nil)
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

// MARK: - Breadcrumb Item

public struct BreadcrumbItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    public let route: String
    public let isCurrentPage: Bool
    public let children: [BreadcrumbItem]?
    public let metadata: [String: String]?
    
    public init(id: String, title: String, icon: String? = nil, route: String, isCurrentPage: Bool = false, children: [BreadcrumbItem]? = nil, metadata: [String: String]? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.route = route
        self.isCurrentPage = isCurrentPage
        self.children = children
        self.metadata = metadata
    }
}

// MARK: - Path Bar System

public struct PathBarSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "pathBar"
    public let name = "Path Bar"
    public let description = "File system style path bar with editable path"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let height: CGFloat
        public let style: PathBarStyle
        public let showIcon: Bool
        public let allowEditing: Bool
        public let showGoButton: Bool
        
        public static let `default` = Configuration(
            height: 28,
            style: .segmented,
            showIcon: true,
            allowEditing: true,
            showGoButton: false
        )
        
        public init(height: CGFloat = 28, style: PathBarStyle = .segmented, showIcon: Bool = true, allowEditing: Bool = true, showGoButton: Bool = false) {
            self.height = height
            self.style = style
            self.showIcon = showIcon
            self.allowEditing = allowEditing
            self.showGoButton = showGoButton
        }
        
        public enum PathBarStyle: String, Codable, Sendable { case segmented, textField, hybrid }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var path: String
        public var segments: [PathSegment]
        public var isEditing: Bool
        public var editText: String
        
        public static let initial = State(path: "/", segments: [], isEditing: false, editText: "")
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct PathSegment: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let icon: String?
    public let path: String
    public let isLast: Bool
    
    public init(id: String, name: String, icon: String? = nil, path: String, isLast: Bool = false) {
        self.id = id
        self.name = name
        self.icon = icon
        self.path = path
        self.isLast = isLast
    }
}
