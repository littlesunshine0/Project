//
//  QualityGate.swift
//  DataKit
//

import Foundation

/// Quality gate for CI/CD
public struct QualityGate: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let type: QualityGateType
    public let threshold: Double
    public let actual: Double
    public let passed: Bool
    public let isBlocking: Bool
    
    public init(id: String, name: String, type: QualityGateType, threshold: Double, actual: Double, isBlocking: Bool = true) {
        self.id = id
        self.name = name
        self.type = type
        self.threshold = threshold
        self.actual = actual
        self.passed = actual >= threshold
        self.isBlocking = isBlocking
    }
}

public enum QualityGateType: String, Codable, Sendable, CaseIterable {
    case coverage, testPass, lintErrors, securityIssues, performance, accessibility
}
