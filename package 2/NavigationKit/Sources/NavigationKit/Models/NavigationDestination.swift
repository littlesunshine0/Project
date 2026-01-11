//
//  NavigationDestination.swift
//  NavigationKit
//
//  Navigation destination enum with associated values for sections
//

import Foundation

public enum NavigationDestination: Hashable, Sendable, Identifiable {
    // Main destinations
    case dashboard(section: DashboardSection? = nil)
    case workflows(section: WorkflowSection? = nil)
    case agents(section: AgentSection? = nil)
    case commands(section: CommandSection? = nil)
    case projects(section: ProjectSection? = nil)
    case documentation(section: DocumentationSection? = nil)
    case search(query: String? = nil)
    case knowledge(section: KnowledgeSection? = nil)
    case learn(section: LearnSection? = nil)
    case settings(section: SettingsSection? = nil)
    case chat(conversationId: UUID? = nil)
    case files(path: String? = nil)
    
    // Creation destinations
    case newWorkflow
    case newAgent
    case newProject(template: String? = nil)
    case newDocument
    
    // Action destinations
    case addInventoryItem
    case exportData
    
    public var id: String {
        switch self {
        case .dashboard(let section): return "dashboard-\(section?.rawValue ?? "main")"
        case .workflows(let section): return "workflows-\(section?.rawValue ?? "main")"
        case .agents(let section): return "agents-\(section?.rawValue ?? "main")"
        case .commands(let section): return "commands-\(section?.rawValue ?? "main")"
        case .projects(let section): return "projects-\(section?.rawValue ?? "main")"
        case .documentation(let section): return "documentation-\(section?.rawValue ?? "main")"
        case .search(let query): return "search-\(query ?? "empty")"
        case .knowledge(let section): return "knowledge-\(section?.rawValue ?? "main")"
        case .learn(let section): return "learn-\(section?.rawValue ?? "main")"
        case .settings(let section): return "settings-\(section?.rawValue ?? "main")"
        case .chat(let id): return "chat-\(id?.uuidString ?? "new")"
        case .files(let path): return "files-\(path ?? "root")"
        case .newWorkflow: return "new-workflow"
        case .newAgent: return "new-agent"
        case .newProject(let template): return "new-project-\(template ?? "blank")"
        case .newDocument: return "new-document"
        case .addInventoryItem: return "add-inventory"
        case .exportData: return "export-data"
        }
    }
    
    public var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .workflows: return "Workflows"
        case .agents: return "Agents"
        case .commands: return "Commands"
        case .projects: return "Projects"
        case .documentation: return "Documentation"
        case .search: return "Search"
        case .knowledge: return "Knowledge"
        case .learn: return "Learn"
        case .settings: return "Settings"
        case .chat: return "Chat"
        case .files: return "Files"
        case .newWorkflow: return "New Workflow"
        case .newAgent: return "New Agent"
        case .newProject: return "New Project"
        case .newDocument: return "New Document"
        case .addInventoryItem: return "Add Inventory"
        case .exportData: return "Export Data"
        }
    }
    
    public var icon: String {
        switch self {
        case .dashboard: return "square.grid.2x2"
        case .workflows: return "arrow.triangle.branch"
        case .agents: return "cpu"
        case .commands: return "terminal"
        case .projects: return "folder"
        case .documentation: return "book.closed"
        case .search: return "magnifyingglass"
        case .knowledge: return "brain"
        case .learn: return "graduationcap"
        case .settings: return "gearshape"
        case .chat: return "bubble.left.and.bubble.right"
        case .files: return "doc.text"
        case .newWorkflow: return "plus"
        case .newAgent: return "plus"
        case .newProject: return "folder.badge.plus"
        case .newDocument: return "doc.badge.plus"
        case .addInventoryItem: return "shippingbox.fill"
        case .exportData: return "square.and.arrow.up"
        }
    }
}

// MARK: - Section Enums

public enum DashboardSection: String, Sendable {
    case overview, quickactions, systemstatus, recentactivity, analytics, resources
}

public enum WorkflowSection: String, Sendable {
    case list, composer, history, templates
}

public enum AgentSection: String, Sendable {
    case list, running, composer, logs
}

public enum CommandSection: String, Sendable {
    case list, history, favorites
}

public enum ProjectSection: String, Sendable {
    case list, templates, recent
}

public enum DocumentationSection: String, Sendable {
    case browse, search, favorites, recent
}

public enum KnowledgeSection: String, Sendable {
    case browse, search, add
}

public enum LearnSection: String, Sendable {
    case courses, tutorials, guides
}

public enum SettingsSection: String, Sendable {
    case general, appearance, shortcuts, integrations, advanced
}
