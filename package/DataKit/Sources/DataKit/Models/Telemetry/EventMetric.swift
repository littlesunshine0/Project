//
//  EventMetric.swift
//  DataKit
//

import Foundation

/// Event-based metric
public struct EventMetric: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let category: String
    public let action: String
    public let label: String?
    public let value: Double?
    public let properties: [String: AnyCodable]
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, name: String, category: String, action: String, label: String? = nil, value: Double? = nil, properties: [String: AnyCodable] = [:]) {
        self.id = id
        self.name = name
        self.category = category
        self.action = action
        self.label = label
        self.value = value
        self.properties = properties
        self.timestamp = Date()
    }
}
