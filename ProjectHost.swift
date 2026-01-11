//
//  ProjectHost.swift
//  Project
//
//  The single global object that bridges UI and Kits.
//  Views talk to this. Nothing else.
//
//  Rule: App owns UI composition. Kits own logic.
//

import SwiftUI
import CoreKit
import IdeaKit
import IconKit
import ChatKit
import AIKit
import WorkProject
import AgentKit
import CommandKit
import SearchKit
import NLUKit

// MARK: - ProjectHost

/// The single bridge between the UI layer and all Kit packages.
/// This is the only object views should interact with.
@MainActor
@Observable
public final class ProjectHost {
    
    // MARK: - Singleton
    
    public static let shared = ProjectHost()
    
    // MARK: - Kit Facades
    
    /// Core node graph - the single source of truth
    public let graph: NodeGraph
    
    /// Chat session for the control plane
    public let chat: ChatSession
    
    /// Current project context
    public private(set) var currentProject: Node?
    
    /// Navigation state
    public var selectedCapability: String? = "dashboard"
    public var selectedNodeId: String?
    
    /// App state
    public var isInitialized: Bool = false
    public var isLoading: Bool = false
    public var statusMessage: String = ""
    
    // MARK: - Initialization
    
    private init() {
        self.graph = NodeGraph.shared
        self.chat = ChatSession()
    }
    
    // MARK: - Lifecycle
    
    /// Initialize the host with a project directory
    public func initialize(projectPath: String? = nil) async {
        isLoading = true
        statusMessage = "Initializing Project..."
        
        // If a path is provided, scan it
        if let path = projectPath {
            await mountDirectory(path: path)
        }
        
        isInitialized = true
        isLoading = false
        statusMessage = "Ready"
    }
    
    // MARK: - Directory Mounting
    
    /// Mount a directory and convert it to nodes
    public func mountDirectory(path: String) async {
        statusMessage = "Scanning \(path)..."
        
        // Create project node
        let projectName = (path as NSString).lastPathComponent
        let project = NodeFactory.project(path: path, name: projectName)
        await graph.add(project)
        currentProject = project
        
        // Scan directory (simplified - full implementation in DirectoryScanner)
        await scanDirectory(path: path, parentId: project.id)
        
        statusMessage = "Mounted \(projectName)"
    }
    
    private func scanDirectory(path: String, parentId: String) async {
        let fm = FileManager.default
        guard let contents = try? fm.contentsOfDirectory(atPath: path) else { return }
        
        for item in contents where !item.hasPrefix(".") {
            let itemPath = (path as NSString).appendingPathComponent(item)
            var isDir: ObjCBool = false
            
            guard fm.fileExists(atPath: itemPath, isDirectory: &isDir) else { continue }
            
            if isDir.boolValue {
                // Directory node
                var dirNode = NodeFactory.directory(path: itemPath, name: item)
                dirNode.relationships.append(RelationshipFactory.contains(targetId: parentId))
                await graph.add(dirNode)
                
                // Recurse (limit depth for performance)
                let depth = itemPath.components(separatedBy: "/").count
                if depth < 10 {
                    await scanDirectory(path: itemPath, parentId: dirNode.id)
                }
            } else {
                // File node
                var fileNode = NodeFactory.fromPath(itemPath)
                fileNode.relationships.append(RelationshipFactory.contains(targetId: parentId))
                await graph.add(fileNode)
            }
        }
    }
    
    // MARK: - Chat Actions
    
    /// Send a message through the chat control plane
    public func sendMessage(_ text: String) async {
        // Add user message
        chat.addMessage(FlowChatMessage(role: .user, content: text))
        
        // Parse intent using CoreKit
        let intent = await CoreKit.chat.parse(text)
        
        // Execute based on intent
        let response = await executeIntent(intent)
        
        // Add assistant response
        chat.addMessage(FlowChatMessage(role: .assistant, content: response))
    }
    
    private func executeIntent(_ intent: ChatIntent) async -> String {
        switch intent.type {
        case .explain:
            return await handleExplain(intent)
        case .find, .list, .show:
            return await handleQuery(intent)
        case .create:
            return await handleCreate(intent)
        case .run:
            return await handleRun(intent)
        default:
            return "I understand you want to \(intent.type.rawValue). Let me help with that."
        }
    }
    
    private func handleExplain(_ intent: ChatIntent) async -> String {
        if let target = intent.targets.first {
            switch target.type {
            case .currentNode:
                if let nodeId = selectedNodeId, let node = await graph.get(nodeId) {
                    return "**\(node.name)** is a \(node.type.rawValue) at `\(node.path)`.\n\nCapabilities: \(node.capabilities.map { $0.rawValue }.joined(separator: ", "))"
                }
            case .project:
                if let project = currentProject {
                    let stats = await graph.stats
                    return "**\(project.name)** contains \(stats.nodeCount) nodes."
                }
            default:
                break
            }
        }
        return "I can explain any file, project, or concept. Try selecting something first."
    }
    
    private func handleQuery(_ intent: ChatIntent) async -> String {
        if let target = intent.targets.first, let nodeType = target.nodeType {
            let nodes = await graph.byType(nodeType)
            if nodes.isEmpty {
                return "No \(nodeType.rawValue)s found."
            }
            let list = nodes.prefix(10).map { "• \($0.name)" }.joined(separator: "\n")
            return "Found \(nodes.count) \(nodeType.rawValue)(s):\n\n\(list)"
        }
        return "What would you like to find?"
    }
    
    private func handleCreate(_ intent: ChatIntent) async -> String {
        return "To create something, tell me what type (workflow, agent, script, document) and give it a name."
    }
    
    private func handleRun(_ intent: ChatIntent) async -> String {
        return "I can run scripts and commands. Which one would you like to execute?"
    }
    
    // MARK: - Node Operations
    
    /// Get nodes for sidebar display
    public func nodesForSidebar() async -> [SidebarSection] {
        var sections: [SidebarSection] = []
        
        // Projects
        let projects = await graph.byType(.project)
        if !projects.isEmpty {
            sections.append(SidebarSection(title: "Projects", nodes: projects))
        }
        
        // Source Files
        let sources = await graph.byType(.sourceFile)
        if !sources.isEmpty {
            sections.append(SidebarSection(title: "Source Files", nodes: Array(sources.prefix(20))))
        }
        
        // Views
        let views = await graph.byType(.view)
        if !views.isEmpty {
            sections.append(SidebarSection(title: "Views", nodes: views))
        }
        
        // Scripts
        let scripts = await graph.byType(.script)
        if !scripts.isEmpty {
            sections.append(SidebarSection(title: "Scripts", nodes: scripts))
        }
        
        // Workflows
        let workflows = await graph.byType(.workflow)
        if !workflows.isEmpty {
            sections.append(SidebarSection(title: "Workflows", nodes: workflows))
        }
        
        // Agents
        let agents = await graph.byType(.agent)
        if !agents.isEmpty {
            sections.append(SidebarSection(title: "Agents", nodes: agents))
        }
        
        return sections
    }
    
    /// Select a node
    public func selectNode(_ node: Node) {
        selectedNodeId = node.id
    }
}

// MARK: - Supporting Types

public struct SidebarSection: Identifiable {
    public let id = UUID()
    public let title: String
    public let nodes: [Node]
}

// MARK: - Chat Session

@Observable
public final class ChatSession {
    public private(set) var messages: [FlowChatMessage] = []
    
    public init() {
        // Welcome message
        messages.append(FlowChatMessage(
            role: .assistant,
            content: "Welcome to Project. I'm your project intelligence assistant.\n\nTry:\n• \"Show all views\"\n• \"Explain this project\"\n• \"Find scripts\"\n• \"Create a new workflow\""
        ))
    }
    
    public func addMessage(_ message: FlowChatMessage) {
        messages.append(message)
    }
    
    public func clear() {
        messages.removeAll()
    }
}

public struct FlowChatMessage: Identifiable {
    public let id = UUID()
    public let role: ChatRole
    public let content: String
    public let timestamp = Date()
    
    public init(role: ChatRole, content: String) {
        self.role = role
        self.content = content
    }
}

public enum ChatRole {
    case user
    case assistant
    case system
}

// MARK: - Environment Key

// Note: For Swift 6 concurrency, we pass ProjectHost.shared directly
// rather than using EnvironmentKey which has isolation issues.
