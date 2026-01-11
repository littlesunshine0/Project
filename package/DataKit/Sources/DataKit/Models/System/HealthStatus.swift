//
//  HealthStatus.swift
//  DataKit
//

import Foundation

public enum HealthStatus: String, Codable, Sendable, CaseIterable {
    case healthy, degraded, unhealthy, unknown
}
