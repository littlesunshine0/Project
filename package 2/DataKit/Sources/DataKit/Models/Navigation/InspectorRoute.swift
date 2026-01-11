//
//  InspectorRoute.swift
//  DataKit
//

import Foundation

/// Route to inspector panel content
public struct InspectorRoute: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let targetType: String
    public let targetId: String
    public let panelId: String
    public let context: [String: AnyCodable]
    
    public init(id: String = UUID().uuidString, targetType: String, targetId: String, panelId: String, context: [String: AnyCodable] = [:]) {
        self.id = id
        self.targetType = targetType
        self.targetId = targetId
        self.panelId = panelId
        self.context = context
    }
}
