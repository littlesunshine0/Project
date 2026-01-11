//
//  EventSeverity.swift
//  DataKit
//

import Foundation

public enum EventSeverity: String, Codable, Sendable, CaseIterable {
    case info, warning, error, success
}
