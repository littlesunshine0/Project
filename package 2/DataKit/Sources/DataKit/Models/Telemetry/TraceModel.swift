//
//  TraceModel.swift
//  DataKit
//

import Foundation

/// Distributed trace model
public struct TraceModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let traceId: String
    public let spanId: String
    public let parentSpanId: String?
    public let operationName: String
    public let serviceName: String
    public let status: TraceStatus
    public let startedAt: Date
    public var endedAt: Date?
    public let tags: [String: String]
    public var logs: [TraceLog]
    
    public init(id: String = UUID().uuidString, traceId: String, spanId: String, parentSpanId: String? = nil, operationName: String, serviceName: String, status: TraceStatus = .ok, tags: [String: String] = [:]) {
        self.id = id
        self.traceId = traceId
        self.spanId = spanId
        self.parentSpanId = parentSpanId
        self.operationName = operationName
        self.serviceName = serviceName
        self.status = status
        self.startedAt = Date()
        self.tags = tags
        self.logs = []
    }
}

public enum TraceStatus: String, Codable, Sendable, CaseIterable {
    case ok, error, unset
}

public struct TraceLog: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let message: String
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, message: String) {
        self.id = id
        self.message = message
        self.timestamp = Date()
    }
}
