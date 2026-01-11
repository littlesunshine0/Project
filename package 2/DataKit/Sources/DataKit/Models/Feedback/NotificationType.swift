//
//  NotificationType.swift
//  DataKit
//

import Foundation

public enum NotificationType: String, Codable, Sendable, CaseIterable {
    case info, success, warning, error, achievement, reminder, system
}
