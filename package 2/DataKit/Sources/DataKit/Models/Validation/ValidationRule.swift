//
//  ValidationRule.swift
//  DataKit
//

import Foundation

/// Validation rule definition
public struct ValidationRule: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let type: ValidationRuleType
    public let severity: ValidationSeverity
    public let isRequired: Bool
    public let condition: String
    public let message: String
    
    public init(id: String, name: String, description: String = "", type: ValidationRuleType, severity: ValidationSeverity = .error, isRequired: Bool = true, condition: String, message: String) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.severity = severity
        self.isRequired = isRequired
        self.condition = condition
        self.message = message
    }
}

public enum ValidationRuleType: String, Codable, Sendable, CaseIterable {
    case fileExists, schemaValid, dependencyResolved, capabilityDeclared, testPassing, coverageMinimum
}
