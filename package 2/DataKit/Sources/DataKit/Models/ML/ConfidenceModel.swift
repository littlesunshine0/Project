//
//  ConfidenceModel.swift
//  DataKit
//

import Foundation

/// Confidence model for trust scoring
public struct ConfidenceModel: Codable, Sendable, Hashable {
    public let score: Double
    public let level: ConfidenceLevel
    public let factors: [String: Double]?
    
    public init(score: Double, factors: [String: Double]? = nil) {
        self.score = score
        self.level = ConfidenceLevel.from(score: score)
        self.factors = factors
    }
}
