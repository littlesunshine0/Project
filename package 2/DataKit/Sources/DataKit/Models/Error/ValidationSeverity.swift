//
//  ValidationSeverity.swift
//  DataKit
//

import Foundation

public enum ValidationSeverity: String, Codable, Sendable, CaseIterable {
    case info, warning, error
}
