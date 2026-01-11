//
//  EventModel.swift
//  DataKit
//

import Foundation

/// Universal event model
public struct EventModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let severity: EventSeverity
    public let timestamp: Date
    public let source: String
    public let data: [String: AnyCodable]
    
    public init(id: String = UUID().uuidString, name: String, severity: EventSeverity = .info, timestamp: Date = Date(), source: String = "", data: [String: AnyCodable] = [:]) {
        self.id = id
        self.name = name
        self.severity = severity
        self.timestamp = timestamp
        self.source = source
        self.data = data
    }
}
