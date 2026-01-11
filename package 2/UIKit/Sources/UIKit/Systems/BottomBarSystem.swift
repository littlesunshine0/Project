//
//  BottomBarSystem.swift
//  UIKit
//
//  Bottom bar and bottom panel systems
//

import Foundation
import DataKit

// MARK: - Bottom Bar System

public struct BottomBarSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "bottomBar"
    public let name = "Bottom Bar"
    public let description = "Full-width bottom status bar with tabs and status items"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iPadOS, .iOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let height: CGFloat
        public let showTabs: Bool
        public let showStatusItems: Bool
        public let showProgressIndicator: Bool
        public let tabPosition: TabPosition
        public let statusPosition: StatusPosition
        
        public static let `default` = Configuration(
            height: 28,
            showTabs: true,
            showStatusItems: true,
            showProgressIndicator: true,
            tabPosition: .leading,
            statusPosition: .trailing
        )
        
        public init(height: CGFloat = 28, showTabs: Bool = true, showStatusItems: Bool = true, showProgressIndicator: Bool = true, tabPosition: TabPosition = .leading, statusPosition: StatusPosition = .trailing) {
            self.height = height
            self.showTabs = showTabs
            self.showStatusItems = showStatusItems
            self.showProgressIndicator = showProgressIndicator
            self.tabPosition = tabPosition
            self.statusPosition = statusPosition
        }
        
        public enum TabPosition: String, Codable, Sendable { case leading, center, trailing }
        public enum StatusPosition: String, Codable, Sendable { case leading, center, trailing }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var tabs: [BottomBarTab]
        public var selectedTabId: String?
        public var statusItems: [StatusItem]
        public var isProgressVisible: Bool
        public var progressValue: Double
        public var progressMessage: String?
        
        public static let initial = State(
            tabs: [],
            selectedTabId: nil,
            statusItems: [],
            isProgressVisible: false,
            progressValue: 0,
            progressMessage: nil
        )
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

// MARK: - Bottom Panel System

public struct BottomPanelSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "bottomPanel"
    public let name = "Bottom Panel"
    public let description = "Expandable bottom panel with tabs for terminal, output, problems, etc."
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iPadOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let minHeight: CGFloat
        public let maxHeight: CGFloat
        public let defaultHeight: CGFloat
        public let cornerRadius: CGFloat
        public let showTabBar: Bool
        public let allowResize: Bool
        public let allowMaximize: Bool
        public let animateTransitions: Bool
        
        public static let `default` = Configuration(
            minHeight: 150,
            maxHeight: 500,
            defaultHeight: 250,
            cornerRadius: 12,
            showTabBar: true,
            allowResize: true,
            allowMaximize: true,
            animateTransitions: true
        )
        
        public init(minHeight: CGFloat = 150, maxHeight: CGFloat = 500, defaultHeight: CGFloat = 250, cornerRadius: CGFloat = 12, showTabBar: Bool = true, allowResize: Bool = true, allowMaximize: Bool = true, animateTransitions: Bool = true) {
            self.minHeight = minHeight
            self.maxHeight = maxHeight
            self.defaultHeight = defaultHeight
            self.cornerRadius = cornerRadius
            self.showTabBar = showTabBar
            self.allowResize = allowResize
            self.allowMaximize = allowMaximize
            self.animateTransitions = animateTransitions
        }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var isVisible: Bool
        public var isMaximized: Bool
        public var height: CGFloat
        public var tabs: [BottomPanelTab]
        public var selectedTabId: String?
        public var layoutMode: BottomPanelLayoutMode
        public var openPanels: [OpenPanelInstance]
        
        public static let initial = State(
            isVisible: false,
            isMaximized: false,
            height: 250,
            tabs: [],
            selectedTabId: nil,
            layoutMode: .single,
            openPanels: []
        )
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

// MARK: - Supporting Types

public struct BottomBarTab: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let badge: String?
    public let isClosable: Bool
    
    public init(id: String, title: String, icon: String, badge: String? = nil, isClosable: Bool = true) {
        self.id = id
        self.title = title
        self.icon = icon
        self.badge = badge
        self.isClosable = isClosable
    }
}

public struct BottomPanelTab: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let colorCategory: String
    public let hasInput: Bool
    public let placeholder: String
    public let badge: String?
    public let priority: Int
    public let providedBy: String
    
    public init(id: String, title: String, icon: String, colorCategory: String = "default", hasInput: Bool = false, placeholder: String = "", badge: String? = nil, priority: Int = 0, providedBy: String = "system") {
        self.id = id
        self.title = title
        self.icon = icon
        self.colorCategory = colorCategory
        self.hasInput = hasInput
        self.placeholder = placeholder
        self.badge = badge
        self.priority = priority
        self.providedBy = providedBy
    }
}

public struct StatusItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let icon: String?
    public let text: String
    public let tooltip: String?
    public let action: String?
    
    public init(id: String, icon: String? = nil, text: String, tooltip: String? = nil, action: String? = nil) {
        self.id = id
        self.icon = icon
        self.text = text
        self.tooltip = tooltip
        self.action = action
    }
}

public struct OpenPanelInstance: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let tabId: String
    public let instanceId: String
    public var position: PanelPosition
    public var isFocused: Bool
    
    public init(id: String = UUID().uuidString, tabId: String, instanceId: String = UUID().uuidString, position: PanelPosition = .main, isFocused: Bool = false) {
        self.id = id
        self.tabId = tabId
        self.instanceId = instanceId
        self.position = position
        self.isFocused = isFocused
    }
    
    public enum PanelPosition: String, Codable, Sendable {
        case main, stacked, overflow, tabGroup
    }
}

public enum BottomPanelLayoutMode: String, Codable, Sendable {
    case single           // One panel visible
    case stacked          // Two panels stacked vertically
    case stackedWithTabs  // Stacked with tab overflow
    case layeredGroup     // Multiple of same type layered
}
