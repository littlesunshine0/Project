//
//  SheetDestination.swift
//  NavigationKit
//
//  Sheet presentation destinations
//

import Foundation

public enum SheetDestination: Identifiable, Sendable {
    case workflowComposer(workflowId: UUID?)
    case agentComposer(agentId: UUID?)
    case commandComposer
    case documentComposer(documentId: UUID?)
    case knowledgeComposer
    case projectComposer(template: String?)
    case settings
    case help
    case search
    case marketplaceConnection
    case exportOptions
    
    public var id: String {
        switch self {
        case .workflowComposer(let id): return "workflow-\(id?.uuidString ?? "new")"
        case .agentComposer(let id): return "agent-\(id?.uuidString ?? "new")"
        case .commandComposer: return "command-new"
        case .documentComposer(let id): return "document-\(id?.uuidString ?? "new")"
        case .knowledgeComposer: return "knowledge-new"
        case .projectComposer(let template): return "project-\(template ?? "new")"
        case .settings: return "settings"
        case .help: return "help"
        case .search: return "search"
        case .marketplaceConnection: return "marketplace-connection"
        case .exportOptions: return "export-options"
        }
    }
    
    public var title: String {
        switch self {
        case .workflowComposer(let id): return id == nil ? "New Workflow" : "Edit Workflow"
        case .agentComposer(let id): return id == nil ? "New Agent" : "Edit Agent"
        case .commandComposer: return "New Command"
        case .documentComposer(let id): return id == nil ? "New Document" : "Edit Document"
        case .knowledgeComposer: return "Add Knowledge"
        case .projectComposer(let template): return template == nil ? "New Project" : "New \(template!) Project"
        case .settings: return "Settings"
        case .help: return "Help"
        case .search: return "Search"
        case .marketplaceConnection: return "Connect Marketplace"
        case .exportOptions: return "Export Options"
        }
    }
}
