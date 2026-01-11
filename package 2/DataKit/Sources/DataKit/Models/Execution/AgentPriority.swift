//
//  AgentPriority.swift
//  DataKit
//

import Foundation

public enum AgentPriority: String, Codable, Sendable, CaseIterable {
    case low, normal, high, critical
}
