//
//  InputPanelTabModel.swift
//  DataKit
//
//  Types of input/interaction in the bottom panel
//

import Foundation

/// Types of input/interaction in the bottom panel
public enum InputPanelTabModel: String, CaseIterable, Identifiable, Codable, Sendable {
    case chatInput
    case terminal
    case output
    case problems
    case debug
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .chatInput: return "Chat"
        case .terminal: return "Terminal"
        case .output: return "Output"
        case .problems: return "Problems"
        case .debug: return "Debug"
        }
    }
    
    public var icon: String {
        switch self {
        case .chatInput: return "text.bubble"
        case .terminal: return "terminal"
        case .output: return "doc.text"
        case .problems: return "exclamationmark.triangle"
        case .debug: return "ant"
        }
    }
    
    /// Color category for theming
    public var colorCategory: String {
        switch self {
        case .chatInput: return "chat"
        case .terminal: return "commands"
        case .output: return "info"
        case .problems: return "warning"
        case .debug: return "error"
        }
    }
    
    public var placeholder: String {
        switch self {
        case .chatInput: return "Type a message..."
        case .terminal: return "Enter command..."
        case .output: return ""
        case .problems: return ""
        case .debug: return "Debug expression..."
        }
    }
    
    public var hasInput: Bool {
        switch self {
        case .chatInput, .terminal, .debug: return true
        case .output, .problems: return false
        }
    }
}
