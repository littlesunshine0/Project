//
//  WorkspaceLayoutMode.swift
//  DataKit
//
//  Overall workspace layout configuration
//

import Foundation

/// Overall workspace layout configuration
public enum WorkspaceLayoutMode: String, CaseIterable, Codable, Sendable {
    case standard       // Normal IDE layout
    case focused        // Minimal distractions, editor focused
    case presentation   // Large preview/output
    case split          // Side-by-side editing
    
    public var title: String {
        switch self {
        case .standard: return "Standard"
        case .focused: return "Focused"
        case .presentation: return "Presentation"
        case .split: return "Split"
        }
    }
    
    public var icon: String {
        switch self {
        case .standard: return "rectangle.split.3x1"
        case .focused: return "rectangle.center.inset.filled"
        case .presentation: return "rectangle.expand.vertical"
        case .split: return "rectangle.split.2x1"
        }
    }
}
