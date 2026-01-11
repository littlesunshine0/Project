//
//  PanelItemDefinitions.swift
//  DataKit
//
//  Shared definitions for sidebar and bottom panel items
//  Each kit provides its own items using these definitions
//

import Foundation

// MARK: - Bottom Panel Tab Definition

/// Definition for a bottom panel tab provided by a kit
public struct BottomPanelTabDefinition: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let colorCategory: String
    public let hasInput: Bool
    public let placeholder: String
    public let priority: Int
    public let providedBy: String
    
    public init(
        id: String,
        title: String,
        icon: String,
        colorCategory: String,
        hasInput: Bool = false,
        placeholder: String = "",
        priority: Int = 0,
        providedBy: String
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.colorCategory = colorCategory
        self.hasInput = hasInput
        self.placeholder = placeholder
        self.priority = priority
        self.providedBy = providedBy
    }
}

// MARK: - Sidebar Item Definition

/// Definition for a sidebar item provided by a kit
public struct SidebarItemDefinition: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let colorCategory: String
    public let route: String
    public let priority: Int
    public let providedBy: String
    public let badge: String?
    public let children: [SidebarItemDefinition]
    
    public init(
        id: String,
        title: String,
        icon: String,
        colorCategory: String,
        route: String,
        priority: Int = 0,
        providedBy: String,
        badge: String? = nil,
        children: [SidebarItemDefinition] = []
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.colorCategory = colorCategory
        self.route = route
        self.priority = priority
        self.providedBy = providedBy
        self.badge = badge
        self.children = children
    }
}

// MARK: - Bottom Panel Registry

/// Registry for bottom panel tabs from all kits
public class BottomPanelRegistry: @unchecked Sendable {
    public static let shared = BottomPanelRegistry()
    
    private var registeredTabs: [BottomPanelTabDefinition] = []
    private let lock = NSLock()
    
    private init() {}
    
    public func register(tabs: [BottomPanelTabDefinition]) {
        lock.lock()
        defer { lock.unlock() }
        registeredTabs.append(contentsOf: tabs)
        registeredTabs.sort { $0.priority > $1.priority }
    }
    
    public func register(tab: BottomPanelTabDefinition) {
        register(tabs: [tab])
    }
    
    public var allTabs: [BottomPanelTabDefinition] {
        lock.lock()
        defer { lock.unlock() }
        return registeredTabs
    }
    
    public func tabs(for kit: String) -> [BottomPanelTabDefinition] {
        lock.lock()
        defer { lock.unlock() }
        return registeredTabs.filter { $0.providedBy == kit }
    }
    
    public func tab(withId id: String) -> BottomPanelTabDefinition? {
        lock.lock()
        defer { lock.unlock() }
        return registeredTabs.first { $0.id == id }
    }
    
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        registeredTabs.removeAll()
    }
}

// MARK: - Sidebar Item Registry

/// Registry for sidebar items from all kits
public class SidebarItemRegistry: @unchecked Sendable {
    public static let shared = SidebarItemRegistry()
    
    private var registeredItems: [SidebarItemDefinition] = []
    private let lock = NSLock()
    
    private init() {}
    
    public func register(items: [SidebarItemDefinition]) {
        lock.lock()
        defer { lock.unlock() }
        registeredItems.append(contentsOf: items)
        registeredItems.sort { $0.priority > $1.priority }
    }
    
    public func register(item: SidebarItemDefinition) {
        register(items: [item])
    }
    
    public var allItems: [SidebarItemDefinition] {
        lock.lock()
        defer { lock.unlock() }
        return registeredItems
    }
    
    public func items(for kit: String) -> [SidebarItemDefinition] {
        lock.lock()
        defer { lock.unlock() }
        return registeredItems.filter { $0.providedBy == kit }
    }
    
    public func item(withId id: String) -> SidebarItemDefinition? {
        lock.lock()
        defer { lock.unlock() }
        return findItem(withId: id, in: registeredItems)
    }
    
    private func findItem(withId id: String, in items: [SidebarItemDefinition]) -> SidebarItemDefinition? {
        for item in items {
            if item.id == id { return item }
            if let found = findItem(withId: id, in: item.children) {
                return found
            }
        }
        return nil
    }
    
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        registeredItems.removeAll()
    }
}
