//
//  CommandType.swift
//  CommandKit
//

import Foundation

public enum CommandType: String, CaseIterable, Codable, Sendable {
    case workflow = "Workflow"
    case docs = "Documentation"
    case analytics = "Analytics"
    case config = "Configuration"
    case help = "Help"
    case history = "History"
    case pause = "Pause"
    case resume = "Resume"
    case cancel = "Cancel"
    case list = "List"
    case clear = "Clear"
    case run = "Run"
    case create = "Create"
    case delete = "Delete"
    case search = "Search"
    case open = "Open"
    case close = "Close"
    case save = "Save"
    case export = "Export"
    case `import` = "Import"
    
    public var icon: String {
        switch self {
        case .workflow: return "arrow.triangle.branch"
        case .docs: return "doc.text"
        case .analytics: return "chart.bar"
        case .config: return "gearshape"
        case .help: return "questionmark.circle"
        case .history: return "clock.arrow.circlepath"
        case .pause: return "pause.circle"
        case .resume: return "play.circle"
        case .cancel: return "xmark.circle"
        case .list: return "list.bullet"
        case .clear: return "trash"
        case .run: return "play"
        case .create: return "plus.circle"
        case .delete: return "minus.circle"
        case .search: return "magnifyingglass"
        case .open: return "folder"
        case .close: return "xmark"
        case .save: return "square.and.arrow.down"
        case .export: return "square.and.arrow.up"
        case .import: return "square.and.arrow.down.on.square"
        }
    }
    
    public var description: String {
        switch self {
        case .workflow: return "Execute or manage workflows"
        case .docs: return "Search documentation"
        case .analytics: return "View analytics"
        case .config: return "Configure settings"
        case .help: return "Show help"
        case .history: return "View history"
        case .pause: return "Pause workflow"
        case .resume: return "Resume workflow"
        case .cancel: return "Cancel workflow"
        case .list: return "List items"
        case .clear: return "Clear screen"
        case .run: return "Run command"
        case .create: return "Create item"
        case .delete: return "Delete item"
        case .search: return "Search"
        case .open: return "Open file or project"
        case .close: return "Close current item"
        case .save: return "Save changes"
        case .export: return "Export data"
        case .import: return "Import data"
        }
    }
    
    public var syntax: String { "/\(rawValue.lowercased()) [args...]" }
}
