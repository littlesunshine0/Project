//
//  ErrorState.swift
//  DataKit
//

import Foundation

/// Error state with recovery options
public struct ErrorState: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let error: ErrorModel
    public var isRecoverable: Bool
    public var recoveryAttempts: Int
    public var isRecovering: Bool
    public let occurredAt: Date
    
    public init(id: String = UUID().uuidString, error: ErrorModel, isRecoverable: Bool = true, recoveryAttempts: Int = 0) {
        self.id = id
        self.error = error
        self.isRecoverable = isRecoverable
        self.recoveryAttempts = recoveryAttempts
        self.isRecovering = false
        self.occurredAt = Date()
    }
}
