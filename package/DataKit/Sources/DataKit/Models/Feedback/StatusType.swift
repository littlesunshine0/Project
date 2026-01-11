//
//  StatusType.swift
//  DataKit
//

import Foundation

public enum StatusType: String, Codable, Sendable, CaseIterable {
    case idle, loading, success, warning, error, info
    
    public var defaultIcon: String {
        switch self {
        case .idle: return "circle"
        case .loading: return "arrow.clockwise"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    public var defaultColor: String {
        switch self {
        case .idle: return "gray"
        case .loading: return "blue"
        case .success: return "green"
        case .warning: return "orange"
        case .error: return "red"
        case .info: return "blue"
        }
    }
}
