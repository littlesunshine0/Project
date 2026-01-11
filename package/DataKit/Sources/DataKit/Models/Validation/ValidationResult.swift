//
//  ValidationResult.swift
//  DataKit
//

import Foundation

/// Result of validation
public struct ValidationResult: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let ruleId: String
    public let passed: Bool
    public let message: String?
    public let details: [String: AnyCodable]?
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, ruleId: String, passed: Bool, message: String? = nil, details: [String: AnyCodable]? = nil) {
        self.id = id
        self.ruleId = ruleId
        self.passed = passed
        self.message = message
        self.details = details
        self.timestamp = Date()
    }
    
    public static func pass(ruleId: String) -> ValidationResult {
        ValidationResult(ruleId: ruleId, passed: true)
    }
    
    public static func fail(ruleId: String, message: String) -> ValidationResult {
        ValidationResult(ruleId: ruleId, passed: false, message: message)
    }
}
