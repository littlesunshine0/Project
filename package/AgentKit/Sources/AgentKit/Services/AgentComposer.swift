//
//  AgentComposer.swift
//  AgentKit
//
//  Visual agent composition and template system
//

import Foundation

// MARK: - Agent Composer

@MainActor
public class AgentComposer: ObservableObject {
    public static let shared = AgentComposer()
    
    @Published public var composedAgents: [Agent] = []
    @Published public var templates: [AgentTemplate] = []
    @Published public var draftAgent: AgentDraft?
    
    private init() {
        loadTemplates()
    }
    
    // MARK: - Composition
    
    /// Start composing a new agent
    public func startComposition(from template: AgentTemplate? = nil) -> AgentDraft {
        let draft = AgentDraft(template: template)
        draftAgent = draft
        return draft
    }
    
    /// Add an action to the current draft
    public func addAction(_ action: AgentAction) {
        draftAgent?.actions.append(action)
    }
    
    /// Add a trigger to the current draft
    public func addTrigger(_ trigger: AgentTrigger) {
        draftAgent?.triggers.append(trigger)
    }
    
    /// Finalize and create the agent
    public func finalize() -> Agent? {
        guard let draft = draftAgent else { return nil }
        
        let agent = Agent(
            name: draft.name,
            description: draft.description,
            type: draft.type,
            capabilities: draft.capabilities,
            triggers: draft.triggers,
            actions: draft.actions
        )
        
        composedAgents.append(agent)
        draftAgent = nil
        saveComposedAgents()
        
        return agent
    }
    
    /// Cancel composition
    public func cancelComposition() {
        draftAgent = nil
    }
    
    // MARK: - Templates
    
    /// Create agent from template
    public func createFromTemplate(_ template: AgentTemplate) -> Agent {
        return Agent(
            name: template.name,
            description: template.description,
            type: template.type,
            capabilities: template.capabilities,
            triggers: template.defaultTriggers,
            actions: template.defaultActions
        )
    }
    
    /// Get templates by category
    public func templates(for category: AgentType) -> [AgentTemplate] {
        templates.filter { $0.type == category }
    }
    
    // MARK: - Persistence
    
    private func loadTemplates() {
        templates = AgentTemplate.builtInTemplates
    }
    
    private func saveComposedAgents() {
        // Save to UserDefaults or file
    }
}

// MARK: - Agent Draft

public struct AgentDraft {
    public var name: String
    public var description: String
    public var type: AgentType
    public var capabilities: [AgentCapability]
    public var triggers: [AgentTrigger]
    public var actions: [AgentAction]
    
    public init(template: AgentTemplate? = nil) {
        if let template = template {
            self.name = template.name
            self.description = template.description
            self.type = template.type
            self.capabilities = template.capabilities
            self.triggers = template.defaultTriggers
            self.actions = template.defaultActions
        } else {
            self.name = "New Agent"
            self.description = ""
            self.type = .task
            self.capabilities = []
            self.triggers = []
            self.actions = []
        }
    }
}

// MARK: - Agent Template

public struct AgentTemplate: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let description: String
    public let type: AgentType
    public let capabilities: [AgentCapability]
    public let defaultTriggers: [AgentTrigger]
    public let defaultActions: [AgentAction]
    public let icon: String
    public let category: String
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        type: AgentType,
        capabilities: [AgentCapability],
        defaultTriggers: [AgentTrigger] = [],
        defaultActions: [AgentAction] = [],
        icon: String = "cpu",
        category: String = "General"
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.capabilities = capabilities
        self.defaultTriggers = defaultTriggers
        self.defaultActions = defaultActions
        self.icon = icon
        self.category = category
    }
    
    // MARK: - Built-in Templates
    
    public static let builtInTemplates: [AgentTemplate] = [
        AgentTemplate(
            name: "File Watcher",
            description: "Watches files for changes and triggers actions",
            type: .watcher,
            capabilities: [.readFiles, .notifications],
            defaultTriggers: [
                AgentTrigger(type: .fileChange, condition: "*.swift")
            ],
            defaultActions: [
                AgentAction(name: "Notify", type: .notification, command: "File changed")
            ],
            icon: "eye",
            category: "Automation"
        ),
        AgentTemplate(
            name: "Build Agent",
            description: "Builds and compiles your project",
            type: .builder,
            capabilities: [.buildOperations, .executeCommands, .notifications],
            defaultTriggers: [
                AgentTrigger(type: .manual, condition: "On demand")
            ],
            defaultActions: [
                AgentAction(name: "Build", type: .buildCommand, command: "swift build")
            ],
            icon: "hammer",
            category: "Development"
        ),
        AgentTemplate(
            name: "Test Runner",
            description: "Runs tests and reports results",
            type: .task,
            capabilities: [.executeCommands, .notifications],
            defaultTriggers: [
                AgentTrigger(type: .manual, condition: "On demand")
            ],
            defaultActions: [
                AgentAction(name: "Run Tests", type: .shellCommand, command: "swift test")
            ],
            icon: "checkmark.circle",
            category: "Testing"
        ),
        AgentTemplate(
            name: "Git Sync",
            description: "Syncs with remote git repository",
            type: .automation,
            capabilities: [.gitOperations, .notifications],
            defaultTriggers: [
                AgentTrigger(type: .schedule, condition: "Every hour")
            ],
            defaultActions: [
                AgentAction(name: "Pull", type: .gitCommand, command: "git pull"),
                AgentAction(name: "Push", type: .gitCommand, command: "git push", order: 1)
            ],
            icon: "arrow.triangle.2.circlepath",
            category: "Git"
        ),
        AgentTemplate(
            name: "System Monitor",
            description: "Monitors system resources",
            type: .monitor,
            capabilities: [.systemMonitoring, .notifications],
            defaultTriggers: [
                AgentTrigger(type: .schedule, condition: "Every 5 minutes")
            ],
            defaultActions: [
                AgentAction(name: "Check CPU", type: .shellCommand, command: "top -l 1 | head -n 10")
            ],
            icon: "gauge",
            category: "System"
        ),
        AgentTemplate(
            name: "Deploy Agent",
            description: "Deploys your application",
            type: .deployer,
            capabilities: [.deployOperations, .executeCommands, .notifications],
            defaultTriggers: [
                AgentTrigger(type: .manual, condition: "On demand")
            ],
            defaultActions: [
                AgentAction(name: "Build Release", type: .buildCommand, command: "swift build -c release"),
                AgentAction(name: "Deploy", type: .shellCommand, command: "echo 'Deploying...'", order: 1)
            ],
            icon: "arrow.up.doc",
            category: "Deployment"
        )
    ]
}
