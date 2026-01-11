//
//  AlertType.swift
//  DataKit
//

import Foundation

public enum AlertType: String, Codable, Sendable, CaseIterable {
    case info, success, warning, error, confirmation, destructive
}
