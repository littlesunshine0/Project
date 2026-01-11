//
//  CommandFormat.swift
//  CommandKit
//

import Foundation

public enum CommandFormat: String, CaseIterable, Codable, Sendable {
    case slash = "Slash Command"
    case natural = "Natural Language"
    case shortcut = "Keyboard Shortcut"
    case alias = "Alias"
    case script = "Script"
    
    public var icon: String {
        switch self {
        case .slash: return "slash.circle"
        case .natural: return "text.bubble"
        case .shortcut: return "keyboard"
        case .alias: return "link"
        case .script: return "doc.text.fill"
        }
    }
    
    public var prefix: String {
        switch self {
        case .slash: return "/"
        case .natural: return ""
        case .shortcut: return "⌘"
        case .alias: return "@"
        case .script: return "#!"
        }
    }
}
