//
//  HealthModel.swift
//  DataKit
//

import Foundation

/// Health model for diagnostics
public struct HealthModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let status: HealthStatus
    public let checks: [HealthCheck]
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, status: HealthStatus, checks: [HealthCheck] = []) {
        self.id = id
        self.status = status
        self.checks = checks
        self.timestamp = Date()
    }
    
    public static func aggregate(checks: [HealthCheck]) -> HealthModel {
        let status: HealthStatus
        if checks.allSatisfy({ $0.status == .healthy }) {
            status = .healthy
        } else if checks.contains(where: { $0.status == .unhealthy }) {
            status = .unhealthy
        } else {
            status = .degraded
        }
        return HealthModel(status: status, checks: checks)
    }
}
