//
//  RecommendationModel.swift
//  DataKit
//

import Foundation

/// Recommendation model
public struct RecommendationModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: RecommendationType
    public let items: [RecommendationItem]
    public let reason: String?
    public let confidence: ConfidenceModel
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, type: RecommendationType, items: [RecommendationItem], reason: String? = nil, confidence: ConfidenceModel) {
        self.id = id
        self.type = type
        self.items = items
        self.reason = reason
        self.confidence = confidence
        self.timestamp = Date()
    }
}
