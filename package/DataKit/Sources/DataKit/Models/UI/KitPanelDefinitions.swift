//
//  KitPanelDefinitions.swift
//  DataKit
//
//  Comprehensive panel definitions for kit layouts
//  Defines inspector types, right sidebar panels, main context, and navigation
//

import Foundation

// MARK: - Inspector Type

/// Standard inspector types available across kits
public enum InspectorType: String, Codable, Sendable, CaseIterable {
    case properties       // General properties inspector
    case fileInspector    // File metadata and attributes
    case historyInspector // Version/change history
    case quickHelp        // Contextual help/documentation
    case livePreview      // Real-time preview
    case filePreview      // Static file preview
    case metadataPreview  // Metadata display
    case accessibility    // Accessibility inspector
    case connections      // Relationships/connections
    case diagnostics      // Errors/warnings/issues
    case performance      // Performance metrics
    case debug            // Debug information
    
    public var title: String {
        switch self {
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
        }
    }
    
    public var icon: String {
        switch self {
        case .properties: return "slider.horizontal.3"
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
        }
    }
}

// MARK: - Inspector Definition

/// Definition for an inspector panel
public struct InspectorDefinition: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let type: InspectorType
    public let title: String
    public let icon: String
    public let colorCategory: String
    public let priority: Int
    public let providedBy: String
    public let isDefault: Bool
    
    public init(
        id: String,
        type: InspectorType,
        title: String? = nil,
        icon: String? = nil,
        colorCategory: String = "inspector",
        priority: Int = 0,
        providedBy: String,
        isDefault: Bool = false
    ) {
        self.id = id
        self.type = type
        self.title = title ?? type.title
        self.icon = icon ?? type.icon
        self.colorCategory = colorCategory
        self.priority = priority
        self.providedBy = providedBy
        self.isDefault = isDefault
    }
}

// MARK: - Right Sidebar Panel Definition

/// Definition for a right sidebar panel (can contain inspectors or custom content)
public struct RightSidebarPanelDefinition: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let colorCategory: String
    public let priority: Int
    public let providedBy: String
    public let inspectors: [InspectorDefinition]
    public let supportsMultiple: Bool  // Can show multiple instances
    public let defaultPosition: RightSidebarPosition
    
    public init(
        id: String,
        title: String,
        icon: String,
        colorCategory: String,
        priority: Int = 0,
        providedBy: String,
        inspectors: [InspectorDefinition] = [],
        supportsMultiple: Bool = false,
        defaultPosition: RightSidebarPosition = .top
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.colorCategory = colorCategory
        self.priority = priority
        self.providedBy = providedBy
        self.inspectors = inspectors
        self.supportsMultiple = supportsMultiple
        self.defaultPosition = defaultPosition
    }
}

public enum RightSidebarPosition: String, Codable, Sendable {
    case top
    case middle
    case bottom
    case floating
}

// MARK: - Main Context Definition

/// Definition for main content area provided by a kit
public struct MainContextDefinition: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let colorCategory: String
    public let route: String
    public let providedBy: String
    public let supportedInspectors: [InspectorType]
    public let defaultRightSidebar: String?  // ID of default right sidebar panel
    public let defaultBottomPanel: String?   // ID of default bottom panel
    
    public init(
        id: String,
        title: String,
        icon: String,
        colorCategory: String,
        route: String,
        providedBy: String,
        supportedInspectors: [InspectorType] = [],
        defaultRightSidebar: String? = nil,
        defaultBottomPanel: String? = nil
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.colorCategory = colorCategory
        self.route = route
        self.providedBy = providedBy
        self.supportedInspectors = supportedInspectors
        self.defaultRightSidebar = defaultRightSidebar
        self.defaultBottomPanel = defaultBottomPanel
    }
}

// MARK: - Kit Layout Configuration

/// Complete layout configuration for a kit
public struct KitLayoutConfiguration: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let kitName: String
    public let displayName: String
    public let icon: String
    public let colorCategory: String
    
    // Navigation
    public let sidebarItems: [SidebarItemDefinition]
    
    // Bottom Panel
    public let bottomPanelTabs: [BottomPanelTabDefinition]
    
    // Right Sidebar
    public let rightSidebarPanels: [RightSidebarPanelDefinition]
    
    // Main Context
    public let mainContexts: [MainContextDefinition]
    
    // Inspectors this kit provides
    public let inspectors: [InspectorDefinition]
    
    public init(
        id: String,
        kitName: String,
        displayName: String,
        icon: String,
        colorCategory: String,
        sidebarItems: [SidebarItemDefinition] = [],
        bottomPanelTabs: [BottomPanelTabDefinition] = [],
        rightSidebarPanels: [RightSidebarPanelDefinition] = [],
        mainContexts: [MainContextDefinition] = [],
        inspectors: [InspectorDefinition] = []
    ) {
        self.id = id
        self.kitName = kitName
        self.displayName = displayName
        self.icon = icon
        self.colorCategory = colorCategory
        self.sidebarItems = sidebarItems
        self.bottomPanelTabs = bottomPanelTabs
        self.rightSidebarPanels = rightSidebarPanels
        self.mainContexts = mainContexts
        self.inspectors = inspectors
    }
}

// MARK: - Kit Layout Registry

/// Central registry for all kit layout configurations
public class KitLayoutRegistry: @unchecked Sendable {
    public static let shared = KitLayoutRegistry()
    
    private var configurations: [String: KitLayoutConfiguration] = [:]
    private let lock = NSLock()
    
    private init() {}
    
    public func register(configuration: KitLayoutConfiguration) {
        lock.lock()
        defer { lock.unlock() }
        configurations[configuration.kitName] = configuration
        
        // Also register to individual registries
        SidebarItemRegistry.shared.register(items: configuration.sidebarItems)
        BottomPanelRegistry.shared.register(tabs: configuration.bottomPanelTabs)
        RightSidebarRegistry.shared.register(panels: configuration.rightSidebarPanels)
        InspectorRegistry.shared.register(inspectors: configuration.inspectors)
        MainContextRegistry.shared.register(contexts: configuration.mainContexts)
    }
    
    public func configuration(for kit: String) -> KitLayoutConfiguration? {
        lock.lock()
        defer { lock.unlock() }
        return configurations[kit]
    }
    
    public var allConfigurations: [KitLayoutConfiguration] {
        lock.lock()
        defer { lock.unlock() }
        return Array(configurations.values)
    }
    
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        configurations.removeAll()
    }
}

// MARK: - Right Sidebar Registry

public class RightSidebarRegistry: @unchecked Sendable {
    public static let shared = RightSidebarRegistry()
    
    private var registeredPanels: [RightSidebarPanelDefinition] = []
    private let lock = NSLock()
    
    private init() {}
    
    public func register(panels: [RightSidebarPanelDefinition]) {
        lock.lock()
        defer { lock.unlock() }
        registeredPanels.append(contentsOf: panels)
        registeredPanels.sort { $0.priority > $1.priority }
    }
    
    public var allPanels: [RightSidebarPanelDefinition] {
        lock.lock()
        defer { lock.unlock() }
        return registeredPanels
    }
    
    public func panels(for kit: String) -> [RightSidebarPanelDefinition] {
        lock.lock()
        defer { lock.unlock() }
        return registeredPanels.filter { $0.providedBy == kit }
    }
    
    public func panel(withId id: String) -> RightSidebarPanelDefinition? {
        lock.lock()
        defer { lock.unlock() }
        return registeredPanels.first { $0.id == id }
    }
    
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        registeredPanels.removeAll()
    }
}

// MARK: - Inspector Registry

public class InspectorRegistry: @unchecked Sendable {
    public static let shared = InspectorRegistry()
    
    private var registeredInspectors: [InspectorDefinition] = []
    private let lock = NSLock()
    
    private init() {}
    
    public func register(inspectors: [InspectorDefinition]) {
        lock.lock()
        defer { lock.unlock() }
        registeredInspectors.append(contentsOf: inspectors)
        registeredInspectors.sort { $0.priority > $1.priority }
    }
    
    public var allInspectors: [InspectorDefinition] {
        lock.lock()
        defer { lock.unlock() }
        return registeredInspectors
    }
    
    public func inspectors(for kit: String) -> [InspectorDefinition] {
        lock.lock()
        defer { lock.unlock() }
        return registeredInspectors.filter { $0.providedBy == kit }
    }
    
    public func inspectors(ofType type: InspectorType) -> [InspectorDefinition] {
        lock.lock()
        defer { lock.unlock() }
        return registeredInspectors.filter { $0.type == type }
    }
    
    public func inspector(withId id: String) -> InspectorDefinition? {
        lock.lock()
        defer { lock.unlock() }
        return registeredInspectors.first { $0.id == id }
    }
    
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        registeredInspectors.removeAll()
    }
}

// MARK: - Main Context Registry

public class MainContextRegistry: @unchecked Sendable {
    public static let shared = MainContextRegistry()
    
    private var registeredContexts: [MainContextDefinition] = []
    private let lock = NSLock()
    
    private init() {}
    
    public func register(contexts: [MainContextDefinition]) {
        lock.lock()
        defer { lock.unlock() }
        registeredContexts.append(contentsOf: contexts)
    }
    
    public var allContexts: [MainContextDefinition] {
        lock.lock()
        defer { lock.unlock() }
        return registeredContexts
    }
    
    public func contexts(for kit: String) -> [MainContextDefinition] {
        lock.lock()
        defer { lock.unlock() }
        return registeredContexts.filter { $0.providedBy == kit }
    }
    
    public func context(withId id: String) -> MainContextDefinition? {
        lock.lock()
        defer { lock.unlock() }
        return registeredContexts.first { $0.id == id }
    }
    
    public func context(forRoute route: String) -> MainContextDefinition? {
        lock.lock()
        defer { lock.unlock() }
        return registeredContexts.first { $0.route == route }
    }
    
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        registeredContexts.removeAll()
    }
}
