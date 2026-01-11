//
//  ContextPanelTypeModel.swift
//  DataKit
//
//  Defines the types of floating context panels with associated metadata
//

import Foundation

/// Types of floating context panels that can share space
public enum ContextPanelTypeModel: String, CaseIterable, Identifiable, Codable, Sendable {
    case chat
    case terminal
    case output
    case problems
    case debug
    case walkthrough
    case documentation
    case preview
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .chat: return "Chat"
        case .terminal: return "Terminal"
        case .output: return "Output"
        case .problems: return "Problems"
        case .debug: return "Debug"
        case .walkthrough: return "Walkthrough"
        case .documentation: return "Documentation"
        case .preview: return "Preview"
        }
    }
    
    public var icon: String {
        switch self {
        case .chat: return "sparkles"
        case .terminal: return "terminal"
        case .output: return "doc.text"
        case .problems: return "exclamationmark.triangle"
        case .debug: return "ant"
        case .walkthrough: return "list.bullet.clipboard"
        case .documentation: return "book"
        case .preview: return "eye"
        }
    }
    
    /// Color category for theming
    public var colorCategory: String {
        switch self {
        case .chat: return "chat"
        case .terminal: return "commands"
        case .output: return "info"
        case .problems: return "warning"
        case .debug: return "error"
        case .walkthrough: return "documentation"
        case .documentation: return "documentation"
        case .preview: return "projects"
        }
    }
    
    /// Default position preference (right side or bottom)
    public var defaultPosition: ContextPanelPositionModel {
        switch self {
        case .chat, .walkthrough, .documentation, .preview:
            return .right
        case .terminal, .output, .problems, .debug:
            return .bottom
        }
    }
}

/// Position for context panels
public enum ContextPanelPositionModel: String, Codable, Sendable {
    case right
    case bottom
    
    public var title: String {
        switch self {
        case .right: return "Right"
        case .bottom: return "Bottom"
        }
    }
}
