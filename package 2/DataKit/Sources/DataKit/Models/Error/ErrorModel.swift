//
//  ErrorModel.swift
//  DataKit
//

import Foundation

/// Universal error model
public struct ErrorModel: Codable, Sendable, Identifiable, Hashable, Error {
    public let id: String
    public let code: String
    public let message: String
    public let category: ErrorCategory
    public let severity: ErrorSeverity
    public let recoveryActions: [RecoveryAction]
    public let context: [String: String]
    
    public init(id: String = UUID().uuidString, code: String, message: String, category: ErrorCategory = .unknown, severity: ErrorSeverity = .error, recoveryActions: [RecoveryAction] = [], context: [String: String] = [:]) {
        self.id = id
        self.code = code
        self.message = message
        self.category = category
        self.severity = severity
        self.recoveryActions = recoveryActions
        self.context = context
    }
}
