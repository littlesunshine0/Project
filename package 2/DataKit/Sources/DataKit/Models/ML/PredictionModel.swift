//
//  PredictionModel.swift
//  DataKit
//

import Foundation

/// Prediction model
public struct PredictionModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: PredictionType
    public let value: AnyCodable
    public let confidence: ConfidenceModel
    public let alternatives: [PredictionAlternative]
    public let context: MLContext?
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, type: PredictionType, value: AnyCodable, confidence: ConfidenceModel, alternatives: [PredictionAlternative] = [], context: MLContext? = nil) {
        self.id = id
        self.type = type
        self.value = value
        self.confidence = confidence
        self.alternatives = alternatives
        self.context = context
        self.timestamp = Date()
    }
}
