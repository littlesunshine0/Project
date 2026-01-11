//
//  HealthCheck.swift
//  DataKit
//

import Foundation

public struct HealthCheck: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let status: HealthStatus
    public let message: String?
    public let duration: TimeInterval
    
    public init(id: String, name: String, status: HealthStatus, message: String? = nil, duration: TimeInterval = 0) {
        self.id = id
        self.name = name
        self.status = status
        self.message = message
        self.duration = duration
    }
}
