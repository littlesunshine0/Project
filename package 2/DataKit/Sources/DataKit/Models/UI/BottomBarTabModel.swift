//
//  BottomBarTabModel.swift
//  DataKit
//
//  Tabs in the bottom navigation bar
//

import Foundation

/// Tabs in the bottom navigation bar
public enum BottomBarTabModel: String, CaseIterable, Identifiable, Codable, Sendable {
    case console
    case terminal
    case problems
    case output
    case debug
    case search
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .console: return "Console"
        case .terminal: return "Terminal"
        case .problems: return "Problems"
        case .output: return "Output"
        case .debug: return "Debug"
        case .search: return "Search"
        }
    }
    
    public var icon: String {
        switch self {
        case .console: return "terminal.fill"
        case .terminal: return "apple.terminal"
        case .problems: return "exclamationmark.triangle.fill"
        case .output: return "doc.text.fill"
        case .debug: return "ant.fill"
        case .search: return "magnifyingglass"
        }
    }
    
    public var colorCategory: String {
        switch self {
        case .console: return "commands"
        case .terminal: return "commands"
        case .problems: return "warning"
        case .output: return "info"
        case .debug: return "error"
        case .search: return "search"
        }
    }
}
