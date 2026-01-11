//
//  ExplanationModel.swift
//  DataKit
//

import Foundation

/// Explanation model for ML transparency
public struct ExplanationModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let predictionId: String
    public let type: ExplanationType
    public let summary: String
    public let factors: [ExplanationFactor]
    public let visualizations: [String]?
    
    public init(id: String = UUID().uuidString, predictionId: String, type: ExplanationType, summary: String, factors: [ExplanationFactor] = [], visualizations: [String]? = nil) {
        self.id = id
        self.predictionId = predictionId
        self.type = type
        self.summary = summary
        self.factors = factors
        self.visualizations = visualizations
    }
}
