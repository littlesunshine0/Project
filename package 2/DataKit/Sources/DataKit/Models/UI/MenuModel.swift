//
//  MenuModel.swift
//  DataKit
//

import Foundation

/// Menu definition
public struct MenuModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: MenuType
    public let items: [MenuItemModel]
    
    public init(id: String, type: MenuType, items: [MenuItemModel] = []) {
        self.id = id
        self.type = type
        self.items = items
    }
}
