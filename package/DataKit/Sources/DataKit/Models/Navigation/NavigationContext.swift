//
//  NavigationContext.swift
//  DataKit
//

import Foundation

/// Current navigation context for ML reasoning
public struct NavigationContext: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let currentRoute: String
    public let previousRoute: String?
    public let breadcrumbs: [String]
    public let depth: Int
    public let timestamp: Date
    public let metadata: [String: AnyCodable]
    
    public init(id: String = UUID().uuidString, currentRoute: String, previousRoute: String? = nil, breadcrumbs: [String] = [], depth: Int = 0, metadata: [String: AnyCodable] = [:]) {
        self.id = id
        self.currentRoute = currentRoute
        self.previousRoute = previousRoute
        self.breadcrumbs = breadcrumbs
        self.depth = depth
        self.timestamp = Date()
        self.metadata = metadata
    }
}
