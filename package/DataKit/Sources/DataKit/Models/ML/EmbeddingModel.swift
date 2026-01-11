//
//  EmbeddingModel.swift
//  DataKit
//

import Foundation

/// Embedding model for vector representations
public struct EmbeddingModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let sourceId: String
    public let sourceType: String
    public let vector: [Float]
    public let dimensions: Int
    public let modelVersion: String
    public let createdAt: Date
    
    public init(id: String = UUID().uuidString, sourceId: String, sourceType: String, vector: [Float], modelVersion: String = "1.0") {
        self.id = id
        self.sourceId = sourceId
        self.sourceType = sourceType
        self.vector = vector
        self.dimensions = vector.count
        self.modelVersion = modelVersion
        self.createdAt = Date()
    }
}
