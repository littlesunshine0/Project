//
//  ConfidenceLevel.swift
//  DataKit
//

import Foundation

public enum ConfidenceLevel: String, Codable, Sendable, CaseIterable {
    case veryLow, low, medium, high, veryHigh
    
    public static func from(score: Double) -> ConfidenceLevel {
        switch score {
        case 0..<0.2: return .veryLow
        case 0.2..<0.4: return .low
        case 0.4..<0.6: return .medium
        case 0.6..<0.8: return .high
        default: return .veryHigh
        }
    }
}
