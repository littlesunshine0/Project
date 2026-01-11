//
//  BottomPanelTabModel.swift
//  DataKit
//
//  Bottom panel tab definitions
//

import Foundation

/// Bottom panel tab definitions
public enum BottomPanelTabModel: String, CaseIterable, Identifiable, Codable, Sendable {
    case terminal = "Terminal"
    case output = "Output"
    case problems = "Problems"
    case debug = "Debug"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .terminal: return "terminal"
        case .output: return "doc.text"
        case .problems: return "exclamationmark.triangle"
        case .debug: return "ant"
        }
    }
    
    public var title: String { rawValue }
    
    /// Color category for theming
    public var colorCategory: String {
        switch self {
        case .terminal: return "commands"
        case .output: return "info"
        case .problems: return "warning"
        case .debug: return "error"
        }
    }
}
