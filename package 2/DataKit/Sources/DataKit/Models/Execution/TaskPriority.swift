//
//  TaskPriority.swift
//  DataKit
//

import Foundation

public enum TaskPriority: String, Codable, Sendable, CaseIterable {
    case low, normal, high, critical
}
