//
//  BreadcrumbModel.swift
//  DataKit
//

import Foundation

/// Breadcrumb navigation
public struct BreadcrumbModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let items: [BreadcrumbItem]
    
    public init(id: String = UUID().uuidString, items: [BreadcrumbItem] = []) {
        self.id = id
        self.items = items
    }
}
