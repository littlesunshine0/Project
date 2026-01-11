//
//  ExecutionState.swift
//  DataKit
//

import Foundation

/// State of a running execution
public struct ExecutionState: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let executionId: String
    public var status: ExecutionStatus
    public var currentStep: Int
    public var totalSteps: Int
    public var progress: Double
    public var output: [AnyCodable]
    public var error: ErrorModel?
    public let startedAt: Date
    public var completedAt: Date?
    
    public init(id: String = UUID().uuidString, executionId: String, status: ExecutionStatus = .pending, currentStep: Int = 0, totalSteps: Int = 0, progress: Double = 0) {
        self.id = id
        self.executionId = executionId
        self.status = status
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.progress = progress
        self.output = []
        self.startedAt = Date()
    }
}

public enum ExecutionStatus: String, Codable, Sendable, CaseIterable {
    case pending, running, paused, completed, failed, cancelled
}
