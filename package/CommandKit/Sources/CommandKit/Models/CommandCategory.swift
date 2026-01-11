//
//  CommandCategory.swift
//  CommandKit
//

import Foundation

public enum CommandCategory: String, CaseIterable, Codable, Sendable {
    case workflow = "Workflow"
    case documentation = "Documentation"
    case analytics = "Analytics"
    case configuration = "Configuration"
    case system = "System"
    case general = "General"
    case file = "File"
    case project = "Project"
    case navigation = "Navigation"
    case editing = "Editing"
    
    public var icon: String {
        switch self {
        case .workflow: return "arrow.triangle.branch"
        case .documentation: return "doc.text"
        case .analytics: return "chart.bar"
        case .configuration: return "gearshape"
        case .system: return "terminal"
        case .general: return "command"
        case .file: return "folder"
        case .project: return "folder.badge.gearshape"
        case .navigation: return "arrow.left.arrow.right"
        case .editing: return "pencil"
        }
    }
}
