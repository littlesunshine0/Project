//
//  AgentKitPackage.swift
//  AgentKit
//
//  Package definition with comprehensive agents, actions, workflows
//

import SwiftUI
import DataKit

public struct AgentKitPackage {
    public static let shared = AgentKitPackage()
    
    public let info: PackageInfo
    
    private init() {
        info = PackageInfo(
            identifier: "com.flowkit.agentkit",
            name: "AgentKit",
            version: "1.0.0",
            description: "AI agents, automation, intelligent assistants, and autonomous tasks",
            icon: "cpu",
            color: "orange",
            files: Self.indexedFiles,
            dependencies: ["DataKit", "CoreKit", "AIKit"],
            exports: ["Agent", "AgentManager", "AgentEngine"],
            commandCount: Self.commands.count,
            actionCount: Self.actions.count,
            workflowCount: Self.workflows.count,
            agentCount: Self.agents.count,
            viewCount: 8,
            modelCount: 6,
            serviceCount: 4
        )
    }
    
    public func register() async {
        await PackageIndex.shared.register(info)
        await KitRegistry.shared.register(manifest)
    }
    
    public var manifest: KitManifest {
        KitManifest(
            identifier: info.identifier,
            name: info.name,
            version: info.version,
            description: info.description,
            commands: Self.commands,
            actions: Self.actions,
            shortcuts: Self.shortcuts,
            menuItems: Self.menuItems,
            contextMenus: Self.contextMenus,
            workflows: Self.workflows,
            agents: Self.agents
        )
    }
    
    // MARK: - Commands (25+)
    
    public static let commands: [KitCommand] = [
        // Core Agent Commands
        KitCommand(id: "agent.create", name: "Create Agent", description: "Create a new agent", syntax: "/agent create <name>", kit: "AgentKit", handler: "create"),
        KitCommand(id: "agent.start", name: "Start Agent", description: "Start an agent", syntax: "/agent start <name>", kit: "AgentKit", handler: "start"),
        KitCommand(id: "agent.stop", name: "Stop Agent", description: "Stop an agent", syntax: "/agent stop <name>", kit: "AgentKit", handler: "stop"),
        KitCommand(id: "agent.pause", name: "Pause Agent", description: "Pause agent execution", syntax: "/agent pause <name>", kit: "AgentKit", handler: "pause"),
        KitCommand(id: "agent.resume", name: "Resume Agent", description: "Resume paused agent", syntax: "/agent resume <name>", kit: "AgentKit", handler: "resume"),
        KitCommand(id: "agent.list", name: "List Agents", description: "List all agents", syntax: "/agents", kit: "AgentKit", handler: "list"),
        KitCommand(id: "agent.delete", name: "Delete Agent", description: "Delete an agent", syntax: "/agent delete <name>", kit: "AgentKit", handler: "delete"),
        KitCommand(id: "agent.status", name: "Agent Status", description: "Show agent status", syntax: "/agent status <name>", kit: "AgentKit", handler: "status"),
        // Configuration Commands
        KitCommand(id: "agent.config", name: "Configure Agent", description: "Configure agent settings", syntax: "/agent config <name>", kit: "AgentKit", handler: "config"),
        KitCommand(id: "agent.trigger.add", name: "Add Trigger", description: "Add agent trigger", syntax: "/agent trigger add <type>", kit: "AgentKit", handler: "addTrigger"),
        KitCommand(id: "agent.trigger.remove", name: "Remove Trigger", description: "Remove agent trigger", syntax: "/agent trigger remove <id>", kit: "AgentKit", handler: "removeTrigger"),
        KitCommand(id: "agent.action.add", name: "Add Action", description: "Add agent action", syntax: "/agent action add <type>", kit: "AgentKit", handler: "addAction"),
        KitCommand(id: "agent.action.remove", name: "Remove Action", description: "Remove agent action", syntax: "/agent action remove <id>", kit: "AgentKit", handler: "removeAction"),
        // Capability Commands
        KitCommand(id: "agent.capability.list", name: "List Capabilities", description: "List agent capabilities", syntax: "/agent capabilities <name>", kit: "AgentKit", handler: "listCapabilities"),
        KitCommand(id: "agent.capability.add", name: "Add Capability", description: "Add capability to agent", syntax: "/agent capability add <type>", kit: "AgentKit", handler: "addCapability"),
        KitCommand(id: "agent.capability.remove", name: "Remove Capability", description: "Remove capability", syntax: "/agent capability remove <type>", kit: "AgentKit", handler: "removeCapability"),
        // Memory Commands
        KitCommand(id: "agent.memory.show", name: "Show Memory", description: "Show agent memory", syntax: "/agent memory <name>", kit: "AgentKit", handler: "showMemory"),
        KitCommand(id: "agent.memory.clear", name: "Clear Memory", description: "Clear agent memory", syntax: "/agent memory clear <name>", kit: "AgentKit", handler: "clearMemory"),
        KitCommand(id: "agent.memory.export", name: "Export Memory", description: "Export agent memory", syntax: "/agent memory export <name>", kit: "AgentKit", handler: "exportMemory"),
        // Training Commands
        KitCommand(id: "agent.train", name: "Train Agent", description: "Train agent with data", syntax: "/agent train <name> <data>", kit: "AgentKit", handler: "train"),
        KitCommand(id: "agent.feedback", name: "Provide Feedback", description: "Provide feedback to agent", syntax: "/agent feedback <name> <rating>", kit: "AgentKit", handler: "feedback"),
        // Communication Commands
        KitCommand(id: "agent.ask", name: "Ask Agent", description: "Ask agent a question", syntax: "/agent ask <name> <question>", kit: "AgentKit", handler: "ask"),
        KitCommand(id: "agent.tell", name: "Tell Agent", description: "Tell agent information", syntax: "/agent tell <name> <info>", kit: "AgentKit", handler: "tell"),
        KitCommand(id: "agent.task", name: "Assign Task", description: "Assign task to agent", syntax: "/agent task <name> <task>", kit: "AgentKit", handler: "assignTask"),
        // Export/Import Commands
        KitCommand(id: "agent.export", name: "Export Agent", description: "Export agent configuration", syntax: "/agent export <name>", kit: "AgentKit", handler: "export"),
        KitCommand(id: "agent.import", name: "Import Agent", description: "Import agent from file", syntax: "/agent import <file>", kit: "AgentKit", handler: "import")
    ]
    
    // MARK: - Actions (20+)
    
    public static let actions: [KitAction] = [
        KitAction(id: "action.agent.start", name: "Start", description: "Start agent", icon: "play.fill", kit: "AgentKit", handler: "start"),
        KitAction(id: "action.agent.stop", name: "Stop", description: "Stop agent", icon: "stop.fill", kit: "AgentKit", handler: "stop"),
        KitAction(id: "action.agent.pause", name: "Pause", description: "Pause agent", icon: "pause.fill", kit: "AgentKit", handler: "pause"),
        KitAction(id: "action.agent.resume", name: "Resume", description: "Resume agent", icon: "play.fill", kit: "AgentKit", handler: "resume"),
        KitAction(id: "action.agent.edit", name: "Edit", description: "Edit agent", icon: "pencil", kit: "AgentKit", handler: "edit"),
        KitAction(id: "action.agent.delete", name: "Delete", description: "Delete agent", icon: "trash", kit: "AgentKit", handler: "delete"),
        KitAction(id: "action.agent.duplicate", name: "Duplicate", description: "Duplicate agent", icon: "plus.square.on.square", kit: "AgentKit", handler: "duplicate"),
        KitAction(id: "action.agent.share", name: "Share", description: "Share agent", icon: "square.and.arrow.up", kit: "AgentKit", handler: "share"),
        KitAction(id: "action.agent.config", name: "Configure", description: "Configure agent", icon: "gearshape", kit: "AgentKit", handler: "config"),
        KitAction(id: "action.agent.train", name: "Train", description: "Train agent", icon: "brain", kit: "AgentKit", handler: "train"),
        KitAction(id: "action.agent.test", name: "Test", description: "Test agent", icon: "testtube.2", kit: "AgentKit", handler: "test"),
        KitAction(id: "action.agent.debug", name: "Debug", description: "Debug agent", icon: "ant", kit: "AgentKit", handler: "debug"),
        KitAction(id: "action.agent.logs", name: "View Logs", description: "View agent logs", icon: "doc.text", kit: "AgentKit", handler: "viewLogs"),
        KitAction(id: "action.agent.memory", name: "View Memory", description: "View agent memory", icon: "memorychip", kit: "AgentKit", handler: "viewMemory"),
        KitAction(id: "action.agent.metrics", name: "View Metrics", description: "View agent metrics", icon: "chart.bar", kit: "AgentKit", handler: "viewMetrics"),
        KitAction(id: "action.agent.feedback", name: "Feedback", description: "Provide feedback", icon: "hand.thumbsup", kit: "AgentKit", handler: "feedback"),
        KitAction(id: "action.agent.export", name: "Export", description: "Export agent", icon: "square.and.arrow.down", kit: "AgentKit", handler: "export"),
        KitAction(id: "action.agent.import", name: "Import", description: "Import agent", icon: "square.and.arrow.up", kit: "AgentKit", handler: "import"),
        KitAction(id: "action.agent.reset", name: "Reset", description: "Reset agent", icon: "arrow.counterclockwise", kit: "AgentKit", handler: "reset"),
        KitAction(id: "action.agent.upgrade", name: "Upgrade", description: "Upgrade agent", icon: "arrow.up.circle", kit: "AgentKit", handler: "upgrade")
    ]
    
    // MARK: - Shortcuts
    
    public static let shortcuts: [KitShortcut] = [
        KitShortcut(key: "A", modifiers: [.command, .shift], action: "agent.list", description: "Show agents", kit: "AgentKit"),
        KitShortcut(key: "N", modifiers: [.command, .option], action: "agent.create", description: "New agent", kit: "AgentKit"),
        KitShortcut(key: "Return", modifiers: [.command], action: "action.agent.start", description: "Start agent", kit: "AgentKit"),
        KitShortcut(key: ".", modifiers: [.command], action: "action.agent.stop", description: "Stop agent", kit: "AgentKit"),
        KitShortcut(key: "E", modifiers: [.command], action: "action.agent.edit", description: "Edit agent", kit: "AgentKit"),
        KitShortcut(key: "T", modifiers: [.command, .shift], action: "action.agent.train", description: "Train agent", kit: "AgentKit"),
        KitShortcut(key: "L", modifiers: [.command, .shift], action: "action.agent.logs", description: "View logs", kit: "AgentKit")
    ]
    
    // MARK: - Menu Items
    
    public static let menuItems: [KitMenuItem] = [
        KitMenuItem(title: "Agents", icon: "cpu", action: "showAgents", shortcut: "⇧⌘A", kit: "AgentKit"),
        KitMenuItem(title: "New Agent", icon: "plus", action: "newAgent", kit: "AgentKit"),
        KitMenuItem(title: "Running Agents", icon: "play.circle", action: "showRunning", kit: "AgentKit"),
        KitMenuItem(title: "Agent Templates", icon: "doc.text", action: "showTemplates", kit: "AgentKit"),
        KitMenuItem(title: "Training Center", icon: "brain", action: "showTraining", kit: "AgentKit"),
        KitMenuItem(title: "Agent Metrics", icon: "chart.bar", action: "showMetrics", kit: "AgentKit"),
        KitMenuItem(title: "Import Agent", icon: "square.and.arrow.down", action: "importAgent", kit: "AgentKit"),
        KitMenuItem(title: "Export Agent", icon: "square.and.arrow.up", action: "exportAgent", kit: "AgentKit")
    ]
    
    // MARK: - Context Menus
    
    public static let contextMenus: [KitContextMenu] = [
        KitContextMenu(targetType: "Agent", items: [
            KitMenuItem(title: "Start", icon: "play.fill", action: "start", kit: "AgentKit"),
            KitMenuItem(title: "Stop", icon: "stop.fill", action: "stop", kit: "AgentKit"),
            KitMenuItem(title: "Configure", icon: "gearshape", action: "config", kit: "AgentKit"),
            KitMenuItem(title: "Train", icon: "brain", action: "train", kit: "AgentKit"),
            KitMenuItem(title: "View Logs", icon: "doc.text", action: "viewLogs", kit: "AgentKit"),
            KitMenuItem(title: "Delete", icon: "trash", action: "delete", kit: "AgentKit")
        ], kit: "AgentKit")
    ]
    
    // MARK: - Workflows (12+)
    
    public static let workflows: [KitWorkflow] = [
        KitWorkflow(name: "Create Simple Agent", description: "Create a basic agent", steps: ["New Agent", "Set name", "Add triggers", "Add actions", "Save"], kit: "AgentKit"),
        KitWorkflow(name: "Create AI Assistant", description: "Create an AI-powered assistant", steps: ["New Agent", "Select AI model", "Configure prompts", "Add capabilities", "Train", "Deploy"], kit: "AgentKit"),
        KitWorkflow(name: "Train Agent", description: "Train agent with examples", steps: ["Select agent", "Open Training", "Add examples", "Run training", "Evaluate", "Deploy"], kit: "AgentKit"),
        KitWorkflow(name: "Debug Agent", description: "Debug agent behavior", steps: ["Select agent", "Enable debug mode", "Run test", "Inspect logs", "Fix issues", "Retest"], kit: "AgentKit"),
        KitWorkflow(name: "Create Automation Agent", description: "Create task automation agent", steps: ["New Agent", "Define triggers", "Add automation steps", "Set conditions", "Test", "Enable"], kit: "AgentKit"),
        KitWorkflow(name: "Create Monitor Agent", description: "Create monitoring agent", steps: ["New Agent", "Set monitoring targets", "Define alerts", "Configure notifications", "Enable"], kit: "AgentKit"),
        KitWorkflow(name: "Import Agent Template", description: "Import from template", steps: ["Open Templates", "Select template", "Customize", "Save as new agent"], kit: "AgentKit"),
        KitWorkflow(name: "Share Agent", description: "Share agent with team", steps: ["Select agent", "Export", "Choose format", "Share link"], kit: "AgentKit"),
        KitWorkflow(name: "Upgrade Agent", description: "Upgrade agent capabilities", steps: ["Select agent", "Check updates", "Review changes", "Apply upgrade", "Test"], kit: "AgentKit"),
        KitWorkflow(name: "Create Multi-Agent System", description: "Create coordinated agents", steps: ["Create agents", "Define communication", "Set coordination rules", "Test interaction", "Deploy"], kit: "AgentKit"),
        KitWorkflow(name: "Agent Performance Review", description: "Review agent performance", steps: ["Select agent", "View metrics", "Analyze patterns", "Identify improvements", "Apply optimizations"], kit: "AgentKit"),
        KitWorkflow(name: "Backup Agent", description: "Backup agent configuration", steps: ["Select agent", "Export config", "Export memory", "Save to backup location"], kit: "AgentKit")
    ]
    
    // MARK: - Agents (10+)
    
    public static let agents: [KitAgent] = [
        KitAgent(name: "Code Assistant", description: "AI-powered coding assistant", triggers: ["code.edit", "error.detected", "user.question"], actions: ["analyze.code", "suggest.fix", "explain.code", "generate.code"], kit: "AgentKit"),
        KitAgent(name: "Task Automator", description: "Automates repetitive tasks", triggers: ["pattern.detected", "schedule.trigger", "user.request"], actions: ["execute.task", "log.action", "notify.completion"], kit: "AgentKit"),
        KitAgent(name: "Documentation Agent", description: "Generates and maintains docs", triggers: ["code.change", "api.update", "doc.request"], actions: ["analyze.code", "generate.docs", "update.readme"], kit: "AgentKit"),
        KitAgent(name: "Test Agent", description: "Generates and runs tests", triggers: ["code.change", "pr.created", "test.request"], actions: ["analyze.code", "generate.tests", "run.tests", "report.results"], kit: "AgentKit"),
        KitAgent(name: "Review Agent", description: "Code review assistant", triggers: ["pr.created", "code.push", "review.request"], actions: ["analyze.changes", "check.style", "suggest.improvements", "approve.changes"], kit: "AgentKit"),
        KitAgent(name: "Security Agent", description: "Security vulnerability scanner", triggers: ["code.change", "dependency.update", "scan.request"], actions: ["scan.vulnerabilities", "check.dependencies", "report.issues", "suggest.fixes"], kit: "AgentKit"),
        KitAgent(name: "Performance Agent", description: "Performance optimization assistant", triggers: ["build.complete", "test.slow", "perf.request"], actions: ["analyze.performance", "identify.bottlenecks", "suggest.optimizations"], kit: "AgentKit"),
        KitAgent(name: "Learning Agent", description: "Learns from user patterns", triggers: ["user.action", "feedback.received", "pattern.detected"], actions: ["learn.pattern", "update.model", "improve.suggestions"], kit: "AgentKit"),
        KitAgent(name: "Notification Agent", description: "Smart notification manager", triggers: ["event.important", "deadline.approaching", "mention.detected"], actions: ["filter.notifications", "prioritize.alerts", "deliver.notification"], kit: "AgentKit"),
        KitAgent(name: "Cleanup Agent", description: "Code and project cleanup", triggers: ["schedule.weekly", "cleanup.request", "threshold.exceeded"], actions: ["find.unused", "remove.dead.code", "organize.files", "report.changes"], kit: "AgentKit")
    ]
    
    // MARK: - File Index
    
    private static let indexedFiles: [FileInfo] = [
        FileInfo(name: "Agent.swift", path: "Models/Agent.swift", type: .model),
        FileInfo(name: "AgentKind.swift", path: "Models/AgentKind.swift", type: .model),
        FileInfo(name: "AgentFormat.swift", path: "Models/AgentFormat.swift", type: .model),
        FileInfo(name: "AgentSection.swift", path: "Models/AgentSection.swift", type: .model),
        FileInfo(name: "AgentError.swift", path: "Models/AgentError.swift", type: .model),
        FileInfo(name: "AgentManager.swift", path: "Services/AgentManager.swift", type: .service),
        FileInfo(name: "AgentEngine.swift", path: "Services/AgentEngine.swift", type: .service),
        FileInfo(name: "AgentParser.swift", path: "Services/AgentParser.swift", type: .service),
        FileInfo(name: "AgentGenerator.swift", path: "Services/AgentGenerator.swift", type: .service),
        FileInfo(name: "AgentBrowser.swift", path: "Views/AgentBrowser.swift", type: .view),
        FileInfo(name: "AgentList.swift", path: "Views/AgentList.swift", type: .view),
        FileInfo(name: "AgentRow.swift", path: "Views/AgentRow.swift", type: .view),
        FileInfo(name: "AgentCard.swift", path: "Views/AgentCard.swift", type: .view),
        FileInfo(name: "AgentGallery.swift", path: "Views/AgentGallery.swift", type: .view),
        FileInfo(name: "AgentIcon.swift", path: "Views/AgentIcon.swift", type: .view),
        FileInfo(name: "AgentViewModel.swift", path: "ViewModels/AgentViewModel.swift", type: .viewModel)
    ]
}
