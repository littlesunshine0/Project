//
//  TabModel.swift
//  DataKit
//

import Foundation

/// Tab navigation model
public struct TabModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let route: String
    public let badge: String?
    public var isSelected: Bool
    public let order: Int
    
    public init(id: String, title: String, icon: String, route: String, badge: String? = nil, isSelected: Bool = false, order: Int = 0) {
        self.id = id
        self.title = title
        self.icon = icon
        self.route = route
        self.badge = badge
        self.isSelected = isSelected
        self.order = order
    }
}
