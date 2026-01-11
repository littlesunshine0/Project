//
//  BreadcrumbItem.swift
//  DataKit
//

import Foundation

public struct BreadcrumbItem: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    public let action: String?
    
    public init(id: String, title: String, icon: String? = nil, action: String? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.action = action
    }
}
