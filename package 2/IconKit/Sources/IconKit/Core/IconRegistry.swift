//
//  IconRegistry.swift
//  IconKit
//
//  Central registry for managing icons
//

import Foundation

/// Central registry for all icons in the system
public actor IconRegistry {
    
    public static let shared = IconRegistry()
    
    private var icons: [String: IconDefinition] = [:]
    private var iconSets: [String: IconSet] = [:]
    private var isInitialized = false
    
    private init() {}
    
    /// Ensure default icons are registered
    private func ensureInitialized() {
        guard !isInitialized else { return }
        isInitialized = true
        registerDefaultCapabilityIconsSync()
    }
    
    private func registerDefaultCapabilityIconsSync() {
        let capabilities: [(String, String, IconStyle)] = [
            ("intent", "Intent", .lightbulb),
            ("context", "Context", .layers),
            ("structure", "Structure", .grid),
            ("work", "Work", .gear),
            ("decisions", "Decisions", .diamond),
            ("risk", "Risk", .badge),
            ("feedback", "Feedback", .circuit),
            ("outcome", "Outcome", .star)
        ]
        
        for (id, name, style) in capabilities {
            let icon = IconDefinition(
                id: "capability_\(id)",
                name: name,
                category: .capability,
                style: style,
                label: name
            )
            icons[icon.id] = icon
        }
    }
    
    // MARK: - Registration
    
    /// Register an icon definition
    public func register(_ icon: IconDefinition) {
        ensureInitialized()
        icons[icon.id] = icon
    }
    
    /// Register an icon set
    public func register(_ iconSet: IconSet) {
        iconSets[iconSet.id] = iconSet
        icons[iconSet.definition.id] = iconSet.definition
    }
    
    /// Register multiple icons
    public func register(_ iconList: [IconDefinition]) {
        for icon in iconList {
            icons[icon.id] = icon
        }
    }
    
    // MARK: - Retrieval
    
    /// Get an icon by ID
    public func get(_ id: String) -> IconDefinition? {
        ensureInitialized()
        return icons[id]
    }
    
    /// Get an icon set by ID
    public func getSet(_ id: String) -> IconSet? {
        iconSets[id]
    }
    
    /// Get all icons for a category
    public func icons(for category: IconKit.IconCategory) -> [IconDefinition] {
        ensureInitialized()
        return icons.values.filter { $0.category == category }
    }
    
    /// Get all registered icons
    public func allIcons() -> [IconDefinition] {
        ensureInitialized()
        return Array(icons.values)
    }
    
    /// Get all icon sets
    public func allIconSets() -> [IconSet] {
        ensureInitialized()
        return Array(iconSets.values)
    }
    
    /// Count of registered icons
    public func count() -> Int {
        ensureInitialized()
        return icons.count
    }
    
    // MARK: - Bulk Operations
    
    /// Clear all registered icons
    public func clear() {
        icons.removeAll()
        iconSets.removeAll()
        isInitialized = false
        ensureInitialized()
    }
    
    /// Remove an icon by ID
    public func remove(_ id: String) {
        ensureInitialized()
        icons.removeValue(forKey: id)
        iconSets.removeValue(forKey: id)
    }
}
