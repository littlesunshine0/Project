//
//  ValidationIssue.swift
//  DataKit
//

import Foundation

/// Validation issue for form/input validation
public struct ValidationIssue: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let field: String
    public let message: String
    public let severity: ValidationSeverity
    public let code: String?
    public let suggestion: String?
    
    public init(id: String = UUID().uuidString, field: String, message: String, severity: ValidationSeverity = .error, code: String? = nil, suggestion: String? = nil) {
        self.id = id
        self.field = field
        self.message = message
        self.severity = severity
        self.code = code
        self.suggestion = suggestion
    }
}
