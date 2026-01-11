//
//  ValidationState.swift
//  DataKit
//

import Foundation

/// Validation state for forms/inputs
public struct ValidationState: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public var isValid: Bool
    public var isDirty: Bool
    public var issues: [ValidationIssue]
    public var validatedAt: Date?
    
    public init(id: String = UUID().uuidString, isValid: Bool = true, isDirty: Bool = false, issues: [ValidationIssue] = []) {
        self.id = id
        self.isValid = isValid
        self.isDirty = isDirty
        self.issues = issues
    }
    
    public var hasErrors: Bool {
        issues.contains { $0.severity == .error }
    }
    
    public var hasWarnings: Bool {
        issues.contains { $0.severity == .warning }
    }
}
