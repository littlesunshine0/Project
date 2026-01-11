//
//  TaskStatus.swift
//  DataKit
//

import Foundation

public enum TaskStatus: String, Codable, Sendable, CaseIterable {
    case pending, inProgress, blocked, completed, cancelled
}
