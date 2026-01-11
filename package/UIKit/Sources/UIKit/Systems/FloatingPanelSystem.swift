//
//  FloatingPanelSystem.swift
//  UIKit
//
//  Floating panel system for modular, draggable panels
//

import Foundation
import DataKit

// MARK: - Floating Panel System

public struct FloatingPanelSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "floatingPanel"
    public let name = "Floating Panel"
    public let description = "Draggable, resizable floating panels with snap-to-grid"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iPadOS, .visionOS]
    
    // MARK: - Configuration
    
    public struct Configuration: UIConfigurationProtocol {
        public let cornerRadius: CGFloat
        public let shadowRadius: CGFloat
        public let borderWidth: CGFloat
        public let insetFromEdges: CGFloat
        public let minPanelSize: UISize
        public let maxPanelSize: UISize
        public let snapToGrid: Bool
        public let gridSize: CGFloat
        public let allowOverlap: Bool
        public let animateMovement: Bool
        public let showResizeHandles: Bool
        
        public static let `default` = Configuration(
            cornerRadius: 16,
            shadowRadius: 20,
            borderWidth: 1,
            insetFromEdges: 12,
            minPanelSize: UISize(width: 200, height: 150),
            maxPanelSize: UISize(width: 800, height: 600),
            snapToGrid: true,
            gridSize: 8,
            allowOverlap: false,
            animateMovement: true,
            showResizeHandles: true
        )
        
        public init(cornerRadius: CGFloat = 16, shadowRadius: CGFloat = 20, borderWidth: CGFloat = 1, insetFromEdges: CGFloat = 12, minPanelSize: UISize = UISize(width: 200, height: 150), maxPanelSize: UISize = UISize(width: 800, height: 600), snapToGrid: Bool = true, gridSize: CGFloat = 8, allowOverlap: Bool = false, animateMovement: Bool = true, showResizeHandles: Bool = true) {
            self.cornerRadius = cornerRadius
            self.shadowRadius = shadowRadius
            self.borderWidth = borderWidth
            self.insetFromEdges = insetFromEdges
            self.minPanelSize = minPanelSize
            self.maxPanelSize = maxPanelSize
            self.snapToGrid = snapToGrid
            self.gridSize = gridSize
            self.allowOverlap = allowOverlap
            self.animateMovement = animateMovement
            self.showResizeHandles = showResizeHandles
        }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    // MARK: - State
    
    public struct State: UIStateProtocol {
        public var panels: [FloatingPanel]
        public var focusedPanelId: String?
        public var isDragging: Bool
        public var isResizing: Bool
        public var zIndexOrder: [String]
        
        public static let initial = State(
            panels: [],
            focusedPanelId: nil,
            isDragging: false,
            isResizing: false,
            zIndexOrder: []
        )
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

// MARK: - Floating Panel

public struct FloatingPanel: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var title: String
    public var icon: String
    public var position: UIPosition
    public var size: UISize
    public var contentType: FloatingPanelContent
    public var isVisible: Bool
    public var isMinimized: Bool
    public var isMaximized: Bool
    public var isPinned: Bool
    public var opacity: CGFloat
    public var zIndex: Int
    
    public init(id: String, title: String, icon: String, position: UIPosition, size: UISize, contentType: FloatingPanelContent, isVisible: Bool = true, isMinimized: Bool = false, isMaximized: Bool = false, isPinned: Bool = false, opacity: CGFloat = 1.0, zIndex: Int = 0) {
        self.id = id
        self.title = title
        self.icon = icon
        self.position = position
        self.size = size
        self.contentType = contentType
        self.isVisible = isVisible
        self.isMinimized = isMinimized
        self.isMaximized = isMaximized
        self.isPinned = isPinned
        self.opacity = opacity
        self.zIndex = zIndex
    }
}

public enum FloatingPanelContent: String, Codable, Sendable, Hashable, CaseIterable {
    case chat
    case terminal
    case preview
    case inspector
    case search
    case notifications
    case debug
    case performance
    case logs
    case custom
    
    public var defaultSize: UISize {
        switch self {
        case .chat: return UISize(width: 380, height: 500)
        case .terminal: return UISize(width: 600, height: 300)
        case .preview: return UISize(width: 400, height: 400)
        case .inspector: return UISize(width: 320, height: 450)
        case .search: return UISize(width: 500, height: 400)
        case .notifications: return UISize(width: 350, height: 400)
        case .debug: return UISize(width: 500, height: 350)
        case .performance: return UISize(width: 400, height: 300)
        case .logs: return UISize(width: 600, height: 350)
        case .custom: return UISize(width: 400, height: 300)
        }
    }
    
    public var icon: String {
        switch self {
        case .chat: return "bubble.left.and.bubble.right.fill"
        case .terminal: return "terminal.fill"
        case .preview: return "eye.fill"
        case .inspector: return "slider.horizontal.3"
        case .search: return "magnifyingglass"
        case .notifications: return "bell.fill"
        case .debug: return "ant.fill"
        case .performance: return "gauge.with.dots.needle.bottom.50percent"
        case .logs: return "doc.text.fill"
        case .custom: return "square.fill"
        }
    }
}

// MARK: - Floating Grid Panel System

public struct FloatingGridPanelSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "floatingGridPanel"
    public let name = "Floating Grid Panel"
    public let description = "Grid-based floating panel layout with automatic arrangement"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let columns: Int
        public let rows: Int
        public let cellPadding: CGFloat
        public let gridPadding: CGFloat
        public let autoArrange: Bool
        public let allowFreePosition: Bool
        
        public static let `default` = Configuration(
            columns: 3,
            rows: 2,
            cellPadding: 12,
            gridPadding: 24,
            autoArrange: true,
            allowFreePosition: true
        )
        
        public init(columns: Int = 3, rows: Int = 2, cellPadding: CGFloat = 12, gridPadding: CGFloat = 24, autoArrange: Bool = true, allowFreePosition: Bool = true) {
            self.columns = columns
            self.rows = rows
            self.cellPadding = cellPadding
            self.gridPadding = gridPadding
            self.autoArrange = autoArrange
            self.allowFreePosition = allowFreePosition
        }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var panels: [FloatingPanel]
        public var gridAssignments: [String: GridPosition]
        public var focusedPanelId: String?
        
        public static let initial = State(panels: [], gridAssignments: [:], focusedPanelId: nil)
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct GridPosition: Codable, Sendable, Hashable {
    public let column: Int
    public let row: Int
    public let columnSpan: Int
    public let rowSpan: Int
    
    public init(column: Int, row: Int, columnSpan: Int = 1, rowSpan: Int = 1) {
        self.column = column
        self.row = row
        self.columnSpan = columnSpan
        self.rowSpan = rowSpan
    }
}
