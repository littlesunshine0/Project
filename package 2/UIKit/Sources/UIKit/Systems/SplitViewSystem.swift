//
//  SplitViewSystem.swift
//  UIKit
//
//  Split view and pane systems
//

import Foundation
import DataKit

// MARK: - Split View System

public struct SplitViewSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "splitView"
    public let name = "Split View"
    public let description = "Resizable split view with multiple panes"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let orientation: SplitOrientation
        public let dividerStyle: DividerStyle
        public let dividerWidth: CGFloat
        public let allowCollapse: Bool
        public let collapseThreshold: CGFloat
        public let animateResize: Bool
        public let showDividerOnHover: Bool
        
        public static let `default` = Configuration(
            orientation: .horizontal,
            dividerStyle: .thin,
            dividerWidth: 1,
            allowCollapse: true,
            collapseThreshold: 50,
            animateResize: true,
            showDividerOnHover: true
        )
        
        public init(orientation: SplitOrientation = .horizontal, dividerStyle: DividerStyle = .thin, dividerWidth: CGFloat = 1, allowCollapse: Bool = true, collapseThreshold: CGFloat = 50, animateResize: Bool = true, showDividerOnHover: Bool = true) {
            self.orientation = orientation
            self.dividerStyle = dividerStyle
            self.dividerWidth = dividerWidth
            self.allowCollapse = allowCollapse
            self.collapseThreshold = collapseThreshold
            self.animateResize = animateResize
            self.showDividerOnHover = showDividerOnHover
        }
        
        public enum SplitOrientation: String, Codable, Sendable { case horizontal, vertical }
        public enum DividerStyle: String, Codable, Sendable { case thin, thick, paneSplitter, invisible }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var panes: [SplitPane]
        public var dividerPositions: [CGFloat]
        public var collapsedPaneIds: Set<String>
        public var isDraggingDivider: Bool
        public var draggingDividerIndex: Int?
        
        public static let initial = State(
            panes: [],
            dividerPositions: [],
            collapsedPaneIds: [],
            isDraggingDivider: false,
            draggingDividerIndex: nil
        )
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

// MARK: - Split Pane

public struct SplitPane: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var size: CGFloat
    public var minSize: CGFloat
    public var maxSize: CGFloat?
    public var isCollapsible: Bool
    public var isCollapsed: Bool
    public var contentType: String
    
    public init(id: String, size: CGFloat, minSize: CGFloat = 100, maxSize: CGFloat? = nil, isCollapsible: Bool = true, isCollapsed: Bool = false, contentType: String) {
        self.id = id
        self.size = size
        self.minSize = minSize
        self.maxSize = maxSize
        self.isCollapsible = isCollapsible
        self.isCollapsed = isCollapsed
        self.contentType = contentType
    }
}

// MARK: - Grid System

public struct GridSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "grid"
    public let name = "Grid"
    public let description = "Flexible grid layout system"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let columns: GridColumns
        public let spacing: CGFloat
        public let padding: CGFloat
        public let alignment: GridAlignment
        public let itemSize: GridItemSize
        
        public static let `default` = Configuration(
            columns: .adaptive(minWidth: 200),
            spacing: 16,
            padding: 16,
            alignment: .center,
            itemSize: .flexible
        )
        
        public init(columns: GridColumns = .adaptive(minWidth: 200), spacing: CGFloat = 16, padding: CGFloat = 16, alignment: GridAlignment = .center, itemSize: GridItemSize = .flexible) {
            self.columns = columns
            self.spacing = spacing
            self.padding = padding
            self.alignment = alignment
            self.itemSize = itemSize
        }
        
        public enum GridAlignment: String, Codable, Sendable { case leading, center, trailing }
        public enum GridItemSize: String, Codable, Sendable { case fixed, flexible, adaptive }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var items: [GridItem]
        public var selectedIds: Set<String>
        public var hoveredId: String?
        
        public static let initial = State(items: [], selectedIds: [], hoveredId: nil)
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public enum GridColumns: Codable, Sendable, Hashable {
    case fixed(Int)
    case adaptive(minWidth: CGFloat)
    case flexible(min: Int, max: Int)
}

public struct GridItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let contentType: String
    public var columnSpan: Int
    public var rowSpan: Int
    
    public init(id: String, contentType: String, columnSpan: Int = 1, rowSpan: Int = 1) {
        self.id = id
        self.contentType = contentType
        self.columnSpan = columnSpan
        self.rowSpan = rowSpan
    }
}

// MARK: - Card System

public struct CardSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "card"
    public let name = "Card"
    public let description = "Card-based content containers"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let cornerRadius: CGFloat
        public let shadowRadius: CGFloat
        public let borderWidth: CGFloat
        public let padding: CGFloat
        public let style: CardStyle
        public let isInteractive: Bool
        
        public static let `default` = Configuration(
            cornerRadius: 16,
            shadowRadius: 8,
            borderWidth: 1,
            padding: 16,
            style: .elevated,
            isInteractive: true
        )
        
        public init(cornerRadius: CGFloat = 16, shadowRadius: CGFloat = 8, borderWidth: CGFloat = 1, padding: CGFloat = 16, style: CardStyle = .elevated, isInteractive: Bool = true) {
            self.cornerRadius = cornerRadius
            self.shadowRadius = shadowRadius
            self.borderWidth = borderWidth
            self.padding = padding
            self.style = style
            self.isInteractive = isInteractive
        }
        
        public enum CardStyle: String, Codable, Sendable { case flat, elevated, outlined, filled }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var cards: [Card]
        public var selectedId: String?
        public var hoveredId: String?
        public var expandedId: String?
        
        public static let initial = State(cards: [], selectedId: nil, hoveredId: nil, expandedId: nil)
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct Card: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String?
    public let subtitle: String?
    public let icon: String?
    public let image: String?
    public let contentType: String
    public let actions: [CardAction]?
    public let isExpandable: Bool
    public let metadata: [String: String]?
    
    public init(id: String, title: String? = nil, subtitle: String? = nil, icon: String? = nil, image: String? = nil, contentType: String, actions: [CardAction]? = nil, isExpandable: Bool = false, metadata: [String: String]? = nil) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.image = image
        self.contentType = contentType
        self.actions = actions
        self.isExpandable = isExpandable
        self.metadata = metadata
    }
}

public struct CardAction: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    public let action: String
    
    public init(id: String, title: String, icon: String? = nil, action: String) {
        self.id = id
        self.title = title
        self.icon = icon
        self.action = action
    }
}

// MARK: - List System

public struct ListSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "list"
    public let name = "List"
    public let description = "Flexible list view system"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let style: ListStyle
        public let rowHeight: RowHeight
        public let showSeparators: Bool
        public let allowSelection: Bool
        public let allowMultipleSelection: Bool
        public let allowReordering: Bool
        public let showSectionHeaders: Bool
        
        public static let `default` = Configuration(
            style: .plain,
            rowHeight: .automatic,
            showSeparators: true,
            allowSelection: true,
            allowMultipleSelection: false,
            allowReordering: false,
            showSectionHeaders: true
        )
        
        public init(style: ListStyle = .plain, rowHeight: RowHeight = .automatic, showSeparators: Bool = true, allowSelection: Bool = true, allowMultipleSelection: Bool = false, allowReordering: Bool = false, showSectionHeaders: Bool = true) {
            self.style = style
            self.rowHeight = rowHeight
            self.showSeparators = showSeparators
            self.allowSelection = allowSelection
            self.allowMultipleSelection = allowMultipleSelection
            self.allowReordering = allowReordering
            self.showSectionHeaders = showSectionHeaders
        }
        
        public enum ListStyle: String, Codable, Sendable { case plain, inset, grouped, insetGrouped, sidebar }
        public enum RowHeight: Codable, Sendable, Hashable { case automatic, fixed(CGFloat), compact, regular, large }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var sections: [ListSection]
        public var selectedIds: Set<String>
        public var hoveredId: String?
        public var editingId: String?
        
        public static let initial = State(sections: [], selectedIds: [], hoveredId: nil, editingId: nil)
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct ListSection: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let header: String?
    public let footer: String?
    public let items: [ListItem]
    public let isCollapsible: Bool
    public var isCollapsed: Bool
    
    public init(id: String, header: String? = nil, footer: String? = nil, items: [ListItem], isCollapsible: Bool = false, isCollapsed: Bool = false) {
        self.id = id
        self.header = header
        self.footer = footer
        self.items = items
        self.isCollapsible = isCollapsible
        self.isCollapsed = isCollapsed
    }
}

public struct ListItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let icon: String?
    public let iconColor: String?
    public let accessory: ListAccessory?
    public let action: String?
    public let isSelectable: Bool
    public let isDraggable: Bool
    
    public init(id: String, title: String, subtitle: String? = nil, icon: String? = nil, iconColor: String? = nil, accessory: ListAccessory? = nil, action: String? = nil, isSelectable: Bool = true, isDraggable: Bool = false) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.accessory = accessory
        self.action = action
        self.isSelectable = isSelectable
        self.isDraggable = isDraggable
    }
}

public enum ListAccessory: Codable, Sendable, Hashable {
    case disclosureIndicator
    case checkmark
    case detailButton
    case detailDisclosureButton
    case badge(String)
    case toggle(Bool)
    case custom(String)
}
