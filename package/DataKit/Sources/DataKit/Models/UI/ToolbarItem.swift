//
//  ToolbarItem.swift
//  DataKit
//

import Foundation

/// Toolbar item
public struct ToolbarItem: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let action: String
    public let placement: ToolbarPlacement
    
    public init(id: String, title: String, icon: String, action: String, placement: ToolbarPlacement = .automatic) {
        self.id = id
        self.title = title
        self.icon = icon
        self.action = action
        self.placement = placement
    }
}
