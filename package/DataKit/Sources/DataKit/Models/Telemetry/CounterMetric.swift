//
//  CounterMetric.swift
//  DataKit
//

import Foundation

/// Counter metric (monotonically increasing)
public struct CounterMetric: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public var count: Int
    public let tags: [String: String]
    public let createdAt: Date
    public var updatedAt: Date
    
    public init(id: String = UUID().uuidString, name: String, count: Int = 0, tags: [String: String] = [:]) {
        self.id = id
        self.name = name
        self.count = count
        self.tags = tags
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    public mutating func increment(by value: Int = 1) {
        count += value
        updatedAt = Date()
    }
}
