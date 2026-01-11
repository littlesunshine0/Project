//
//  PredictionType.swift
//  DataKit
//

import Foundation

public enum PredictionType: String, Codable, Sendable, CaseIterable {
    case classification, regression, generation, completion, extraction, ranking
}
