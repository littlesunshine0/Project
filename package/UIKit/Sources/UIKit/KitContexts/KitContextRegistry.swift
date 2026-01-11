//
//  KitContextRegistry.swift
//  UIKit
//
//  Registry for kit-specific UI contexts
//

import Foundation
import DataKit

// MARK: - Kit Context Registry

public class KitContextRegistry: @unchecked Sendable {
    public static let shared = KitContextRegistry()
    
    private var contexts: [String: KitUIContext] = [:]
    private let lock = NSLock()
    
    private init() {}
    
    public func register(context: KitUIContext) {
        lock.lock()
        defer { lock.unlock() }
        contexts[context.kitId] = context
    }
    
    public func context(for kitId: String) -> KitUIContext? {
        lock.lock()
        defer { lock.unlock() }
        return contexts[kitId]
    }
    
    public var allContexts: [KitUIContext] {
        lock.lock()
        defer { lock.unlock() }
        return Array(contexts.values).sorted { $0.priority > $1.priority }
    }
    
    public func registerAll() {
        // Register all kit contexts
        register(context: KitUIContext.chat)
        register(context: KitUIContext.file)
        register(context: KitUIContext.search)
        register(context: KitUIContext.agent)
        register(context: KitUIContext.workflow)
        register(context: KitUIContext.doc)
        register(context: KitUIContext.error)
        register(context: KitUIContext.command)
        register(context: KitUIContext.design)
        register(context: KitUIContext.analytics)
        register(context: KitUIContext.ai)
        register(context: KitUIContext.learn)
        register(context: KitUIContext.knowledge)
        register(context: KitUIContext.collaboration)
        register(context: KitUIContext.notification)
        register(context: KitUIContext.navigation)
        register(context: KitUIContext.feedback)
        register(context: KitUIContext.export)
        register(context: KitUIContext.user)
        register(context: KitUIContext.indexer)
        register(context: KitUIContext.nlu)
        register(context: KitUIContext.activity)
        register(context: KitUIContext.appIdea)
        register(context: KitUIContext.asset)
        register(context: KitUIContext.bridge)
        register(context: KitUIContext.core)
        register(context: KitUIContext.icon)
        register(context: KitUIContext.idea)
        register(context: KitUIContext.marketplace)
        register(context: KitUIContext.network)
        register(context: KitUIContext.parse)
        register(context: KitUIContext.syntax)
        register(context: KitUIContext.system)
        register(context: KitUIContext.web)
        register(context: KitUIContext.contentHub)
        register(context: KitUIContext.orchestrator)
        register(context: KitUIContext.scaffold)
    }
    
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        contexts.removeAll()
    }
}

// MARK: - Kit UI Context

public struct KitUIContext: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let kitId: String
    public let displayName: String
    public let icon: String
    public let colorCategory: String
    public let priority: Int
    
    // Navigation
    public let sidebarItems: [SidebarItemConfig]
    
    // Bottom Panel
    public let bottomPanelTabs: [BottomPanelTabConfig]
    
    // Right Sidebar / Inspector
    public let inspectorTabs: [InspectorTabConfig]
    
    // Main Context
    public let mainContexts: [MainContextConfig]
    
    // Supported Systems
    public let supportedSystems: [String]
    
    // Default Layout
    public let defaultLayoutTemplate: String?
    
    public init(
        id: String,
        kitId: String,
        displayName: String,
        icon: String,
        colorCategory: String,
        priority: Int = 0,
        sidebarItems: [SidebarItemConfig] = [],
        bottomPanelTabs: [BottomPanelTabConfig] = [],
        inspectorTabs: [InspectorTabConfig] = [],
        mainContexts: [MainContextConfig] = [],
        supportedSystems: [String] = [],
        defaultLayoutTemplate: String? = nil
    ) {
        self.id = id
        self.kitId = kitId
        self.displayName = displayName
        self.icon = icon
        self.colorCategory = colorCategory
        self.priority = priority
        self.sidebarItems = sidebarItems
        self.bottomPanelTabs = bottomPanelTabs
        self.inspectorTabs = inspectorTabs
        self.mainContexts = mainContexts
        self.supportedSystems = supportedSystems
        self.defaultLayoutTemplate = defaultLayoutTemplate
    }
}

// MARK: - Config Types

public struct SidebarItemConfig: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let route: String
    public let badge: String?
    public let children: [SidebarItemConfig]
    
    public init(id: String, title: String, icon: String, route: String, badge: String? = nil, children: [SidebarItemConfig] = []) {
        self.id = id
        self.title = title
        self.icon = icon
        self.route = route
        self.badge = badge
        self.children = children
    }
}

public struct BottomPanelTabConfig: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let hasInput: Bool
    public let placeholder: String
    
    public init(id: String, title: String, icon: String, hasInput: Bool = false, placeholder: String = "") {
        self.id = id
        self.title = title
        self.icon = icon
        self.hasInput = hasInput
        self.placeholder = placeholder
    }
}

public struct InspectorTabConfig: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let type: String
    public let isDefault: Bool
    
    public init(id: String, title: String, icon: String, type: String, isDefault: Bool = false) {
        self.id = id
        self.title = title
        self.icon = icon
        self.type = type
        self.isDefault = isDefault
    }
}

public struct MainContextConfig: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let route: String
    public let defaultInspector: String?
    public let defaultBottomPanel: String?
    
    public init(id: String, title: String, route: String, defaultInspector: String? = nil, defaultBottomPanel: String? = nil) {
        self.id = id
        self.title = title
        self.route = route
        self.defaultInspector = defaultInspector
        self.defaultBottomPanel = defaultBottomPanel
    }
}
