//
//  DurationMetric.swift
//  DataKit
//

import Foundation

/// Duration/timing metric
public struct DurationMetric: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let duration: TimeInterval
    public let startedAt: Date
    public let endedAt: Date
    public let tags: [String: String]
    
    public init(id: String = UUID().uuidString, name: String, duration: TimeInterval, startedAt: Date, endedAt: Date, tags: [String: String] = [:]) {
        self.id = id
        self.name = name
        self.duration = duration
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.tags = tags
    }
    
    public init(id: String = UUID().uuidString, name: String, startedAt: Date, tags: [String: String] = [:]) {
        self.id = id
        self.name = name
        self.startedAt = startedAt
        self.endedAt = Date()
        self.duration = endedAt.timeIntervalSince(startedAt)
        self.tags = tags
    }
}
