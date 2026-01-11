//
//  PredictionAlternative.swift
//  DataKit
//

import Foundation

public struct PredictionAlternative: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let value: AnyCodable
    public let score: Double
    
    public init(id: String = UUID().uuidString, value: AnyCodable, score: Double) {
        self.id = id
        self.value = value
        self.score = score
    }
}
