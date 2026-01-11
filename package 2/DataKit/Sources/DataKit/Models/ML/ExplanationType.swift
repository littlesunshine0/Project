//
//  ExplanationType.swift
//  DataKit
//

import Foundation

public enum ExplanationType: String, Codable, Sendable, CaseIterable {
    case featureImportance, counterfactual, example, rule, attention
}
