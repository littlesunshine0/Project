//
//  DockItem.swift
//  DataKit
//

import Foundation

/// Dock item
public struct DockItem: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let action: String
    public let badge: String?
    
    public init(id: String, title: String, icon: String, action: String, badge: String? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.action = action
        self.badge = badge
    }
}
