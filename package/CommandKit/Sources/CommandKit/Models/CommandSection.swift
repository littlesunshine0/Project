//
//  CommandSection.swift
//  CommandKit
//

import Foundation

public enum CommandSection: String, CaseIterable, Sendable {
    case all = "All Commands"
    case favorites = "Favorites"
    case recent = "Recent"
    case templates = "Templates"
    case custom = "Custom"
    
    public var icon: String {
        switch self {
        case .all: return "command"
        case .favorites: return "star"
        case .recent: return "clock"
        case .templates: return "doc.on.doc"
        case .custom: return "wand.and.stars"
        }
    }
}
