//
//  DoubleSidebarSystem.swift
//  UIKit
//
//  Double sidebar layout system with left navigation and right inspector
//

import Foundation
import DataKit

// MARK: - Double Sidebar System

public struct DoubleSidebarSystem: LayoutSystemProtocol, ComposableSystem, ConfigurableSystem, StatefulSystem {
    public let id = "doubleSidebar"
    public let name = "Double Sidebar"
    public let description = "Layout with left navigation sidebar and right inspector sidebar"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iPadOS, .visionOS]
    
    public let layoutMode: LayoutMode = .adaptive
    
    // MARK: - Regions
    
    public let regions: [UIRegion] = [
        UIRegion(id: "leftSidebar", name: "Left Sidebar", position: .zero, size: .fixed(280, 0), constraints: [.init(type: .minWidth, value: 200), .init(type: .maxWidth, value: 400)], isResizable: true, isCollapsible: true),
        UIRegion(id: "mainContent", name: "Main Content", position: .zero, size: .zero, isResizable: true),
        UIRegion(id: "rightSidebar", name: "Right Sidebar", position: .zero, size: .fixed(320, 0), constraints: [.init(type: .minWidth, value: 260), .init(type: .maxWidth, value: 500)], isResizable: true, isCollapsible: true)
    ]
    
    public let constraints: [UIConstraint] = [
        .init(type: .spacing, value: 0),
        .init(type: .minWidth, value: 800),
        .init(type: .minHeight, value: 600)
    ]
    
    // MARK: - Slots
    
    public var childSystems: [any UISystemProtocol] { [] }
    
    public let slots: [UISlotDefinition] = [
        UISlotDefinition(id: "leftSidebar.primary", name: "Primary Navigation", acceptedTypes: ["navigation", "tree", "list"], isRequired: true),
        UISlotDefinition(id: "leftSidebar.secondary", name: "Secondary Navigation", acceptedTypes: ["navigation", "list"]),
        UISlotDefinition(id: "mainContent.toolbar", name: "Toolbar", acceptedTypes: ["toolbar"]),
        UISlotDefinition(id: "mainContent.breadcrumbs", name: "Breadcrumbs", acceptedTypes: ["breadcrumbs"]),
        UISlotDefinition(id: "mainContent.editor", name: "Editor", acceptedTypes: ["editor", "canvas", "viewer"], isRequired: true),
        UISlotDefinition(id: "rightSidebar.inspector", name: "Inspector", acceptedTypes: ["inspector", "properties"]),
        UISlotDefinition(id: "rightSidebar.preview", name: "Preview", acceptedTypes: ["preview", "livePreview"]),
        UISlotDefinition(id: "rightSidebar.help", name: "Quick Help", acceptedTypes: ["help", "documentation"])
    ]
    
    // MARK: - Configuration
    
    public struct Configuration: UIConfigurationProtocol {
        public let leftSidebarWidth: CGFloat
        public let rightSidebarWidth: CGFloat
        public let leftSidebarCollapsed: Bool
        public let rightSidebarCollapsed: Bool
        public let showDividers: Bool
        public let animateTransitions: Bool
        public let leftSidebarMode: SidebarMode
        public let rightSidebarMode: SidebarMode
        
        public static let `default` = Configuration(
            leftSidebarWidth: 280,
            rightSidebarWidth: 320,
            leftSidebarCollapsed: false,
            rightSidebarCollapsed: false,
            showDividers: true,
            animateTransitions: true,
            leftSidebarMode: .expanded,
            rightSidebarMode: .expanded
        )
        
        public init(leftSidebarWidth: CGFloat = 280, rightSidebarWidth: CGFloat = 320, leftSidebarCollapsed: Bool = false, rightSidebarCollapsed: Bool = false, showDividers: Bool = true, animateTransitions: Bool = true, leftSidebarMode: SidebarMode = .expanded, rightSidebarMode: SidebarMode = .expanded) {
            self.leftSidebarWidth = leftSidebarWidth
            self.rightSidebarWidth = rightSidebarWidth
            self.leftSidebarCollapsed = leftSidebarCollapsed
            self.rightSidebarCollapsed = rightSidebarCollapsed
            self.showDividers = showDividers
            self.animateTransitions = animateTransitions
            self.leftSidebarMode = leftSidebarMode
            self.rightSidebarMode = rightSidebarMode
        }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    // MARK: - State
    
    public struct State: UIStateProtocol {
        public var leftSidebarWidth: CGFloat
        public var rightSidebarWidth: CGFloat
        public var leftSidebarVisible: Bool
        public var rightSidebarVisible: Bool
        public var leftSidebarMode: SidebarMode
        public var rightSidebarMode: RightSidebarMode
        public var focusedRegion: String?
        public var isDraggingDivider: Bool
        
        public static let initial = State(
            leftSidebarWidth: 280,
            rightSidebarWidth: 320,
            leftSidebarVisible: true,
            rightSidebarVisible: true,
            leftSidebarMode: .expanded,
            rightSidebarMode: .single(.inspector),
            focusedRegion: nil,
            isDraggingDivider: false
        )
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

// MARK: - Sidebar Modes

public enum SidebarMode: String, Codable, Sendable, Hashable {
    case expanded
    case collapsed
    case iconOnly
    case hidden
}

public enum RightSidebarMode: Codable, Sendable, Hashable {
    case minimized
    case single(RightSidebarContent)
    case split(top: RightSidebarContent, bottom: RightSidebarContent)
    case triple(top: RightSidebarContent, middle: RightSidebarContent, bottom: RightSidebarContent)
}

public enum RightSidebarContent: String, Codable, Sendable, Hashable, CaseIterable {
    case inspector
    case properties
    case fileInspector
    case historyInspector
    case quickHelp
    case livePreview
    case filePreview
    case metadataPreview
    case accessibility
    case connections
    case diagnostics
    case performance
    case debug
    case notifications
    case chat
    case context
    
    public var title: String {
        switch self {
        case .inspector: return "Inspector"
        case .properties: return "Properties"
        case .fileInspector: return "File Inspector"
        case .historyInspector: return "History"
        case .quickHelp: return "Quick Help"
        case .livePreview: return "Live Preview"
        case .filePreview: return "File Preview"
        case .metadataPreview: return "Metadata"
        case .accessibility: return "Accessibility"
        case .connections: return "Connections"
        case .diagnostics: return "Diagnostics"
        case .performance: return "Performance"
        case .debug: return "Debug"
        case .notifications: return "Notifications"
        case .chat: return "Chat"
        case .context: return "Context"
        }
    }
    
    public var icon: String {
        switch self {
        case .inspector: return "slider.horizontal.3"
        case .properties: return "list.bullet.rectangle"
        case .fileInspector: return "doc.text.fill"
        case .historyInspector: return "clock.arrow.circlepath"
        case .quickHelp: return "questionmark.circle.fill"
        case .livePreview: return "play.rectangle.fill"
        case .filePreview: return "eye.fill"
        case .metadataPreview: return "info.circle.fill"
        case .accessibility: return "accessibility"
        case .connections: return "point.3.connected.trianglepath.dotted"
        case .diagnostics: return "exclamationmark.triangle.fill"
        case .performance: return "gauge.with.dots.needle.bottom.50percent"
        case .debug: return "ant.fill"
        case .notifications: return "bell.fill"
        case .chat: return "bubble.left.and.bubble.right.fill"
        case .context: return "doc.text.fill"
        }
    }
}
