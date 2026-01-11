//
//  ErrorSeverity.swift
//  DataKit
//

import Foundation

public enum ErrorSeverity: String, Codable, Sendable, CaseIterable {
    case info, warning, error, critical
}
