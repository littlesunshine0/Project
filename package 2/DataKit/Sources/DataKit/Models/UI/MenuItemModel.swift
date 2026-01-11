//
//  MenuItemModel.swift
//  DataKit
//

import Foundation

public struct MenuItemModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    public let action: String
    public let shortcut: String?
    public let isEnabled: Bool
    public let children: [MenuItemModel]?
    
    public init(id: String, title: String, icon: String? = nil, action: String, shortcut: String? = nil, isEnabled: Bool = true, children: [MenuItemModel]? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.action = action
        self.shortcut = shortcut
        self.isEnabled = isEnabled
        self.children = children
    }
}
