//
//  SidebarItem.swift
//  DataKit
//

import Foundation

/// Sidebar navigation item
public struct SidebarItem: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let route: String
    public let badge: String?
    public var isSelected: Bool
    public let isEnabled: Bool
    
    public init(id: String, title: String, icon: String, route: String, badge: String? = nil, isSelected: Bool = false, isEnabled: Bool = true) {
        self.id = id
        self.title = title
        self.icon = icon
        self.route = route
        self.badge = badge
        self.isSelected = isSelected
        self.isEnabled = isEnabled
    }
}
