//
//  MetricModel.swift
//  DataKit
//

import Foundation

/// Base metric model
public struct MetricModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let type: MetricType
    public let value: Double
    public let unit: String?
    public let tags: [String: String]
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, name: String, type: MetricType, value: Double, unit: String? = nil, tags: [String: String] = [:]) {
        self.id = id
        self.name = name
        self.type = type
        self.value = value
        self.unit = unit
        self.tags = tags
        self.timestamp = Date()
    }
}

public enum MetricType: String, Codable, Sendable, CaseIterable {
    case counter, gauge, histogram, summary, timer
}
