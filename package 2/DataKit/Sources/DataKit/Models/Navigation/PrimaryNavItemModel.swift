//
//  PrimaryNavItemModel.swift
//  DataKit
//
//  Primary navigation items for the icon rail
//

import Foundation

/// Primary navigation items for the icon rail
public enum PrimaryNavItemModel: String, CaseIterable, Identifiable, Codable, Sendable {
    case dashboard
    case aiAssistant
    case inventory
    case workflows
    case agents
    case projects
    case commands
    case documentation
    case files
    case mlTemplates
    case mlArchitect
    case settings
    case search
    case indexedDocs
    case indexedCode
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .dashboard: return "square.grid.2x2.fill"
        case .aiAssistant: return "brain.head.profile"
        case .inventory: return "shippingbox.fill"
        case .workflows: return "arrow.triangle.branch"
        case .agents: return "cpu.fill"
        case .projects: return "folder.fill"
        case .commands: return "terminal.fill"
        case .documentation: return "doc.text.fill"
        case .files: return "externaldrive.fill"
        case .mlTemplates: return "wand.and.stars"
        case .mlArchitect: return "cube.transparent"
        case .settings: return "gearshape.fill"
        case .search: return "magnifyingglass"
        case .indexedDocs: return "doc.text.magnifyingglass"
        case .indexedCode: return "chevron.left.forwardslash.chevron.right"
        }
    }
    
    public var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .aiAssistant: return "AI Assistant"
        case .inventory: return "Inventory"
        case .workflows: return "Workflows"
        case .agents: return "Agents"
        case .projects: return "Projects"
        case .commands: return "Commands"
        case .documentation: return "Docs"
        case .files: return "Files"
        case .mlTemplates: return "ML Templates"
        case .mlArchitect: return "ML Architect"
        case .settings: return "Settings"
        case .search: return "Search"
        case .indexedDocs: return "Documents"
        case .indexedCode: return "Code"
        }
    }
    
    /// Color category for theming
    public var colorCategory: String {
        rawValue
    }
    
    public var badge: Int? { nil }
}
