//
//  MLContext.swift
//  DataKit
//

import Foundation

/// ML context for inference
public struct MLContext: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let modelId: String
    public let input: [String: AnyCodable]
    public let parameters: MLParameters
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, modelId: String, input: [String: AnyCodable] = [:], parameters: MLParameters = MLParameters()) {
        self.id = id
        self.modelId = modelId
        self.input = input
        self.parameters = parameters
        self.timestamp = Date()
    }
}
