//
//  ExecutionContext.swift
//  DataKit
//

import Foundation

/// Execution context
public struct ExecutionContext: Codable, Sendable {
    public let id: String
    public let workflowId: String?
    public let userId: String?
    public let environment: [String: String]
    public let startedAt: Date
    public var state: [String: AnyCodable]
    
    public init(id: String = UUID().uuidString, workflowId: String? = nil, userId: String? = nil, environment: [String: String] = [:]) {
        self.id = id
        self.workflowId = workflowId
        self.userId = userId
        self.environment = environment
        self.startedAt = Date()
        self.state = [:]
    }
}
