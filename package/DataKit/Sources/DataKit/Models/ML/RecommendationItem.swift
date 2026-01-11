//
//  RecommendationItem.swift
//  DataKit
//

import Foundation

public struct RecommendationItem: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let itemId: String
    public let itemType: String
    public let title: String
    public let score: Double
    public let reason: String?
    
    public init(id: String = UUID().uuidString, itemId: String, itemType: String, title: String, score: Double, reason: String? = nil) {
        self.id = id
        self.itemId = itemId
        self.itemType = itemType
        self.title = title
        self.score = score
        self.reason = reason
    }
}
