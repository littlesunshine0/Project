//
//  IconSize.swift
//  DataKit
//

import Foundation

public enum IconSize: String, Codable, Sendable, CaseIterable {
    case small, medium, large, extraLarge
    
    public var points: Double {
        switch self {
        case .small: return 16
        case .medium: return 24
        case .large: return 32
        case .extraLarge: return 48
        }
    }
}
