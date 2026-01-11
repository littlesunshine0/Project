//
//  SessionModel.swift
//  DataKit
//

import Foundation

/// User session model for analytics
public struct SessionModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let userId: String?
    public let deviceId: String
    public let startedAt: Date
    public var endedAt: Date?
    public var duration: TimeInterval
    public var eventCount: Int
    public var isActive: Bool
    public let metadata: [String: String]
    
    public init(id: String = UUID().uuidString, userId: String? = nil, deviceId: String, metadata: [String: String] = [:]) {
        self.id = id
        self.userId = userId
        self.deviceId = deviceId
        self.startedAt = Date()
        self.duration = 0
        self.eventCount = 0
        self.isActive = true
        self.metadata = metadata
    }
    
    public mutating func end() {
        endedAt = Date()
        duration = endedAt!.timeIntervalSince(startedAt)
        isActive = false
    }
}
