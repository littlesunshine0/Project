//
//  ExecutionResult.swift
//  DataKit
//

import Foundation

/// Execution result
public struct ExecutionResult: Codable, Sendable {
    public let id: String
    public let contextId: String
    public let success: Bool
    public let output: AnyCodable?
    public let error: ErrorModel?
    public let duration: TimeInterval
    public let completedAt: Date
    
    public init(id: String = UUID().uuidString, contextId: String, success: Bool, output: AnyCodable? = nil, error: ErrorModel? = nil, duration: TimeInterval = 0) {
        self.id = id
        self.contextId = contextId
        self.success = success
        self.output = output
        self.error = error
        self.duration = duration
        self.completedAt = Date()
    }
}
