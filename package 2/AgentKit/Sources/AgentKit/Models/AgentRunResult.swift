//
//  AgentRunResult.swift
//  AgentKit
//
//  Agent execution results
//

import Foundation

// MARK: - Agent Run Result

public struct AgentRunResult: Identifiable, Codable, Sendable {
    public let id: UUID
    public let agentId: UUID
    public let startTime: Date
    public let endTime: Date
    public let status: RunStatus
    public let output: String
    public let error: String?
    public let actionResults: [ActionResult]
    
    public init(
        id: UUID = UUID(),
        agentId: UUID,
        startTime: Date,
        endTime: Date,
        status: RunStatus,
        output: String,
        error: String?,
        actionResults: [ActionResult]
    ) {
        self.id = id
        self.agentId = agentId
        self.startTime = startTime
        self.endTime = endTime
        self.status = status
        self.output = output
        self.error = error
        self.actionResults = actionResults
    }
    
    public var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    public enum RunStatus: String, Codable, Sendable {
        case success = "Success"
        case failure = "Failure"
        case partial = "Partial"
        case cancelled = "Cancelled"
        case timeout = "Timeout"
    }
    
    public struct ActionResult: Identifiable, Codable, Sendable {
        public let id: UUID
        public let actionId: UUID
        public let actionName: String
        public let success: Bool
        public let output: String
        public let error: String?
        public let duration: TimeInterval
        
        public init(
            id: UUID = UUID(),
            actionId: UUID,
            actionName: String,
            success: Bool,
            output: String,
            error: String?,
            duration: TimeInterval
        ) {
            self.id = id
            self.actionId = actionId
            self.actionName = actionName
            self.success = success
            self.output = output
            self.error = error
            self.duration = duration
        }
    }
}
