//
//  SidebarSection.swift
//  DataKit
//

import Foundation

/// Sidebar section grouping
public struct SidebarSection: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    public let items: [SidebarItem]
    public let isCollapsible: Bool
    public var isExpanded: Bool
    public let order: Int
    
    public init(id: String, title: String, icon: String? = nil, items: [SidebarItem] = [], isCollapsible: Bool = true, isExpanded: Bool = true, order: Int = 0) {
        self.id = id
        self.title = title
        self.icon = icon
        self.items = items
        self.isCollapsible = isCollapsible
        self.isExpanded = isExpanded
        self.order = order
    }
}
