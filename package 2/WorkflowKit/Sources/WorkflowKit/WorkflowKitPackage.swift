//
//  WorkflowKitPackage.swift
//  WorkflowKit
//
//  Package definition with comprehensive workflows, actions, agents
//

import SwiftUI
import DataKit

public struct WorkflowKitPackage {
    public static let shared = WorkflowKitPackage()
    
    public let info: PackageInfo
    
    private init() {
        info = PackageInfo(
            identifier: "com.flowkit.workflowkit",
            name: "WorkflowKit",
            version: "1.0.0",
            description: "Workflow creation, execution, templates, and automation",
            icon: "arrow.triangle.branch",
            color: "purple",
            files: Self.indexedFiles,
            dependencies: ["DataKit", "CoreKit"],
            exports: ["Workflow", "WorkflowManager", "WorkflowEngine"],
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
        // Core Workflow Commands
        KitCommand(id: "wf.create", name: "Create Workflow", description: "Create a new workflow", syntax: "/workflow create <name>", kit: "WorkflowKit", handler: "create"),
        KitCommand(id: "wf.run", name: "Run Workflow", description: "Execute a workflow", syntax: "/workflow run <name>", kit: "WorkflowKit", handler: "run"),
        KitCommand(id: "wf.stop", name: "Stop Workflow", description: "Stop running workflow", syntax: "/workflow stop <id>", kit: "WorkflowKit", handler: "stop"),
        KitCommand(id: "wf.pause", name: "Pause Workflow", description: "Pause workflow execution", syntax: "/workflow pause <id>", kit: "WorkflowKit", handler: "pause"),
        KitCommand(id: "wf.resume", name: "Resume Workflow", description: "Resume paused workflow", syntax: "/workflow resume <id>", kit: "WorkflowKit", handler: "resume"),
        KitCommand(id: "wf.list", name: "List Workflows", description: "List all workflows", syntax: "/workflows", kit: "WorkflowKit", handler: "list"),
        KitCommand(id: "wf.delete", name: "Delete Workflow", description: "Delete a workflow", syntax: "/workflow delete <name>", kit: "WorkflowKit", handler: "delete"),
        KitCommand(id: "wf.duplicate", name: "Duplicate Workflow", description: "Duplicate a workflow", syntax: "/workflow duplicate <name>", kit: "WorkflowKit", handler: "duplicate"),
        // Step Commands
        KitCommand(id: "wf.step.add", name: "Add Step", description: "Add step to workflow", syntax: "/workflow step add <type>", kit: "WorkflowKit", handler: "addStep"),
        KitCommand(id: "wf.step.remove", name: "Remove Step", description: "Remove step from workflow", syntax: "/workflow step remove <index>", kit: "WorkflowKit", handler: "removeStep"),
        KitCommand(id: "wf.step.move", name: "Move Step", description: "Move step position", syntax: "/workflow step move <from> <to>", kit: "WorkflowKit", handler: "moveStep"),
        KitCommand(id: "wf.step.edit", name: "Edit Step", description: "Edit step configuration", syntax: "/workflow step edit <index>", kit: "WorkflowKit", handler: "editStep"),
        // Template Commands
        KitCommand(id: "wf.template.list", name: "List Templates", description: "List workflow templates", syntax: "/workflow templates", kit: "WorkflowKit", handler: "listTemplates"),
        KitCommand(id: "wf.template.apply", name: "Apply Template", description: "Create workflow from template", syntax: "/workflow template <name>", kit: "WorkflowKit", handler: "applyTemplate"),
        KitCommand(id: "wf.template.save", name: "Save as Template", description: "Save workflow as template", syntax: "/workflow save-template <name>", kit: "WorkflowKit", handler: "saveTemplate"),
        // Trigger Commands
        KitCommand(id: "wf.trigger.add", name: "Add Trigger", description: "Add workflow trigger", syntax: "/workflow trigger add <type>", kit: "WorkflowKit", handler: "addTrigger"),
        KitCommand(id: "wf.trigger.remove", name: "Remove Trigger", description: "Remove workflow trigger", syntax: "/workflow trigger remove <id>", kit: "WorkflowKit", handler: "removeTrigger"),
        KitCommand(id: "wf.trigger.list", name: "List Triggers", description: "List workflow triggers", syntax: "/workflow triggers", kit: "WorkflowKit", handler: "listTriggers"),
        // Schedule Commands
        KitCommand(id: "wf.schedule", name: "Schedule Workflow", description: "Schedule workflow execution", syntax: "/workflow schedule <name> <cron>", kit: "WorkflowKit", handler: "schedule"),
        KitCommand(id: "wf.unschedule", name: "Unschedule Workflow", description: "Remove workflow schedule", syntax: "/workflow unschedule <name>", kit: "WorkflowKit", handler: "unschedule"),
        // Export/Import Commands
        KitCommand(id: "wf.export", name: "Export Workflow", description: "Export workflow to file", syntax: "/workflow export <name>", kit: "WorkflowKit", handler: "export"),
        KitCommand(id: "wf.import", name: "Import Workflow", description: "Import workflow from file", syntax: "/workflow import <file>", kit: "WorkflowKit", handler: "import"),
        // Status Commands
        KitCommand(id: "wf.status", name: "Workflow Status", description: "Show workflow status", syntax: "/workflow status <name>", kit: "WorkflowKit", handler: "status"),
        KitCommand(id: "wf.history", name: "Workflow History", description: "Show execution history", syntax: "/workflow history <name>", kit: "WorkflowKit", handler: "history"),
        KitCommand(id: "wf.logs", name: "Workflow Logs", description: "Show workflow logs", syntax: "/workflow logs <name>", kit: "WorkflowKit", handler: "logs")
    ]
    
    // MARK: - Actions (20+)
    
    public static let actions: [KitAction] = [
        KitAction(id: "action.wf.run", name: "Run", description: "Run workflow", icon: "play.fill", kit: "WorkflowKit", handler: "run"),
        KitAction(id: "action.wf.stop", name: "Stop", description: "Stop workflow", icon: "stop.fill", kit: "WorkflowKit", handler: "stop"),
        KitAction(id: "action.wf.pause", name: "Pause", description: "Pause workflow", icon: "pause.fill", kit: "WorkflowKit", handler: "pause"),
        KitAction(id: "action.wf.resume", name: "Resume", description: "Resume workflow", icon: "play.fill", kit: "WorkflowKit", handler: "resume"),
        KitAction(id: "action.wf.edit", name: "Edit", description: "Edit workflow", icon: "pencil", kit: "WorkflowKit", handler: "edit"),
        KitAction(id: "action.wf.delete", name: "Delete", description: "Delete workflow", icon: "trash", kit: "WorkflowKit", handler: "delete"),
        KitAction(id: "action.wf.duplicate", name: "Duplicate", description: "Duplicate workflow", icon: "plus.square.on.square", kit: "WorkflowKit", handler: "duplicate"),
        KitAction(id: "action.wf.share", name: "Share", description: "Share workflow", icon: "square.and.arrow.up", kit: "WorkflowKit", handler: "share"),
        KitAction(id: "action.wf.favorite", name: "Favorite", description: "Toggle favorite", icon: "star", kit: "WorkflowKit", handler: "favorite"),
        KitAction(id: "action.wf.schedule", name: "Schedule", description: "Schedule workflow", icon: "calendar", kit: "WorkflowKit", handler: "schedule"),
        KitAction(id: "action.wf.addStep", name: "Add Step", description: "Add new step", icon: "plus.circle", kit: "WorkflowKit", handler: "addStep"),
        KitAction(id: "action.wf.removeStep", name: "Remove Step", description: "Remove step", icon: "minus.circle", kit: "WorkflowKit", handler: "removeStep"),
        KitAction(id: "action.wf.addTrigger", name: "Add Trigger", description: "Add trigger", icon: "bolt.badge.plus", kit: "WorkflowKit", handler: "addTrigger"),
        KitAction(id: "action.wf.viewLogs", name: "View Logs", description: "View execution logs", icon: "doc.text", kit: "WorkflowKit", handler: "viewLogs"),
        KitAction(id: "action.wf.viewHistory", name: "View History", description: "View history", icon: "clock.arrow.circlepath", kit: "WorkflowKit", handler: "viewHistory"),
        KitAction(id: "action.wf.export", name: "Export", description: "Export workflow", icon: "square.and.arrow.down", kit: "WorkflowKit", handler: "export"),
        KitAction(id: "action.wf.import", name: "Import", description: "Import workflow", icon: "square.and.arrow.up", kit: "WorkflowKit", handler: "import"),
        KitAction(id: "action.wf.validate", name: "Validate", description: "Validate workflow", icon: "checkmark.seal", kit: "WorkflowKit", handler: "validate"),
        KitAction(id: "action.wf.debug", name: "Debug", description: "Debug workflow", icon: "ant", kit: "WorkflowKit", handler: "debug"),
        KitAction(id: "action.wf.test", name: "Test", description: "Test workflow", icon: "testtube.2", kit: "WorkflowKit", handler: "test")
    ]
    
    // MARK: - Shortcuts
    
    public static let shortcuts: [KitShortcut] = [
        KitShortcut(key: "W", modifiers: [.command, .shift], action: "wf.list", description: "Show workflows", kit: "WorkflowKit"),
        KitShortcut(key: "N", modifiers: [.command, .shift], action: "wf.create", description: "New workflow", kit: "WorkflowKit"),
        KitShortcut(key: "R", modifiers: [.command, .shift], action: "action.wf.run", description: "Run workflow", kit: "WorkflowKit"),
        KitShortcut(key: ".", modifiers: [.command], action: "action.wf.stop", description: "Stop workflow", kit: "WorkflowKit"),
        KitShortcut(key: "E", modifiers: [.command], action: "action.wf.edit", description: "Edit workflow", kit: "WorkflowKit"),
        KitShortcut(key: "D", modifiers: [.command], action: "action.wf.duplicate", description: "Duplicate", kit: "WorkflowKit"),
        KitShortcut(key: "L", modifiers: [.command, .shift], action: "action.wf.viewLogs", description: "View logs", kit: "WorkflowKit"),
        KitShortcut(key: "T", modifiers: [.command, .shift], action: "wf.template.list", description: "Templates", kit: "WorkflowKit")
    ]
    
    // MARK: - Menu Items
    
    public static let menuItems: [KitMenuItem] = [
        KitMenuItem(title: "Workflows", icon: "arrow.triangle.branch", action: "showWorkflows", shortcut: "⇧⌘W", kit: "WorkflowKit"),
        KitMenuItem(title: "New Workflow", icon: "plus", action: "newWorkflow", shortcut: "⇧⌘N", kit: "WorkflowKit"),
        KitMenuItem(title: "Run Workflow", icon: "play.fill", action: "runWorkflow", shortcut: "⇧⌘R", kit: "WorkflowKit"),
        KitMenuItem(title: "Templates", icon: "doc.text", action: "showTemplates", kit: "WorkflowKit"),
        KitMenuItem(title: "Scheduled", icon: "calendar", action: "showScheduled", kit: "WorkflowKit"),
        KitMenuItem(title: "Running", icon: "play.circle", action: "showRunning", kit: "WorkflowKit"),
        KitMenuItem(title: "History", icon: "clock.arrow.circlepath", action: "showHistory", kit: "WorkflowKit"),
        KitMenuItem(title: "Import Workflow", icon: "square.and.arrow.down", action: "importWorkflow", kit: "WorkflowKit"),
        KitMenuItem(title: "Export Workflow", icon: "square.and.arrow.up", action: "exportWorkflow", kit: "WorkflowKit")
    ]
    
    // MARK: - Context Menus
    
    public static let contextMenus: [KitContextMenu] = [
        KitContextMenu(targetType: "Workflow", items: [
            KitMenuItem(title: "Run", icon: "play.fill", action: "run", kit: "WorkflowKit"),
            KitMenuItem(title: "Edit", icon: "pencil", action: "edit", kit: "WorkflowKit"),
            KitMenuItem(title: "Duplicate", icon: "plus.square.on.square", action: "duplicate", kit: "WorkflowKit"),
            KitMenuItem(title: "Schedule", icon: "calendar", action: "schedule", kit: "WorkflowKit"),
            KitMenuItem(title: "Export", icon: "square.and.arrow.up", action: "export", kit: "WorkflowKit"),
            KitMenuItem(title: "Delete", icon: "trash", action: "delete", kit: "WorkflowKit")
        ], kit: "WorkflowKit"),
        KitContextMenu(targetType: "WorkflowStep", items: [
            KitMenuItem(title: "Edit Step", icon: "pencil", action: "editStep", kit: "WorkflowKit"),
            KitMenuItem(title: "Duplicate Step", icon: "plus.square.on.square", action: "duplicateStep", kit: "WorkflowKit"),
            KitMenuItem(title: "Move Up", icon: "arrow.up", action: "moveUp", kit: "WorkflowKit"),
            KitMenuItem(title: "Move Down", icon: "arrow.down", action: "moveDown", kit: "WorkflowKit"),
            KitMenuItem(title: "Delete Step", icon: "trash", action: "deleteStep", kit: "WorkflowKit")
        ], kit: "WorkflowKit")
    ]
    
    // MARK: - Workflows (15+)
    
    public static let workflows: [KitWorkflow] = [
        KitWorkflow(name: "Create Simple Workflow", description: "Create a basic workflow", steps: ["New Workflow", "Add steps", "Configure", "Save"], kit: "WorkflowKit"),
        KitWorkflow(name: "Create Automated Workflow", description: "Create workflow with triggers", steps: ["New Workflow", "Add trigger", "Add steps", "Configure conditions", "Enable"], kit: "WorkflowKit"),
        KitWorkflow(name: "Schedule Workflow", description: "Schedule workflow execution", steps: ["Select workflow", "Open scheduler", "Set schedule", "Confirm"], kit: "WorkflowKit"),
        KitWorkflow(name: "Debug Workflow", description: "Debug a failing workflow", steps: ["Open workflow", "Enable debug mode", "Run step-by-step", "Inspect variables", "Fix issues"], kit: "WorkflowKit"),
        KitWorkflow(name: "Import External Workflow", description: "Import workflow from file", steps: ["Open Import", "Select file", "Review workflow", "Resolve conflicts", "Import"], kit: "WorkflowKit"),
        KitWorkflow(name: "Create Workflow Template", description: "Save workflow as template", steps: ["Open workflow", "Save as Template", "Add description", "Set parameters", "Save"], kit: "WorkflowKit"),
        KitWorkflow(name: "Chain Workflows", description: "Connect multiple workflows", steps: ["Open first workflow", "Add workflow step", "Select target workflow", "Map outputs to inputs", "Save"], kit: "WorkflowKit"),
        KitWorkflow(name: "Add Conditional Logic", description: "Add branching to workflow", steps: ["Open workflow", "Add condition step", "Define condition", "Add branches", "Configure each branch"], kit: "WorkflowKit"),
        KitWorkflow(name: "Add Error Handling", description: "Add error handling to workflow", steps: ["Open workflow", "Add try-catch", "Configure error handler", "Add fallback steps", "Test"], kit: "WorkflowKit"),
        KitWorkflow(name: "Parallel Execution", description: "Run steps in parallel", steps: ["Open workflow", "Add parallel block", "Add parallel steps", "Configure join", "Save"], kit: "WorkflowKit"),
        KitWorkflow(name: "Add Approval Step", description: "Add manual approval", steps: ["Open workflow", "Add approval step", "Configure approvers", "Set timeout", "Save"], kit: "WorkflowKit"),
        KitWorkflow(name: "Version Workflow", description: "Create workflow version", steps: ["Open workflow", "Create version", "Add version notes", "Save"], kit: "WorkflowKit"),
        KitWorkflow(name: "Rollback Workflow", description: "Rollback to previous version", steps: ["Open workflow", "View versions", "Select version", "Rollback", "Confirm"], kit: "WorkflowKit"),
        KitWorkflow(name: "Share Workflow", description: "Share workflow with team", steps: ["Open workflow", "Share", "Select recipients", "Set permissions", "Send"], kit: "WorkflowKit"),
        KitWorkflow(name: "Monitor Workflow", description: "Monitor running workflow", steps: ["Open Running", "Select workflow", "View progress", "Check logs", "Handle issues"], kit: "WorkflowKit")
    ]
    
    // MARK: - Agents (8+)
    
    public static let agents: [KitAgent] = [
        KitAgent(name: "Workflow Suggester", description: "Suggests workflows based on context", triggers: ["context.change", "task.start"], actions: ["analyze.context", "suggest.workflows", "rank.suggestions"], kit: "WorkflowKit"),
        KitAgent(name: "Execution Monitor", description: "Monitors workflow execution", triggers: ["workflow.started", "step.completed", "workflow.failed"], actions: ["track.progress", "log.events", "alert.issues"], kit: "WorkflowKit"),
        KitAgent(name: "Error Recovery Agent", description: "Handles workflow errors", triggers: ["step.failed", "workflow.error"], actions: ["analyze.error", "suggest.fix", "auto.retry"], kit: "WorkflowKit"),
        KitAgent(name: "Schedule Optimizer", description: "Optimizes workflow schedules", triggers: ["schedule.conflict", "resource.constraint"], actions: ["analyze.schedules", "suggest.times", "resolve.conflicts"], kit: "WorkflowKit"),
        KitAgent(name: "Template Recommender", description: "Recommends workflow templates", triggers: ["workflow.create", "task.describe"], actions: ["match.templates", "rank.templates", "suggest.customizations"], kit: "WorkflowKit"),
        KitAgent(name: "Performance Analyzer", description: "Analyzes workflow performance", triggers: ["workflow.completed", "periodic.analysis"], actions: ["collect.metrics", "identify.bottlenecks", "suggest.optimizations"], kit: "WorkflowKit"),
        KitAgent(name: "Dependency Resolver", description: "Resolves workflow dependencies", triggers: ["workflow.validate", "step.add"], actions: ["check.dependencies", "resolve.conflicts", "suggest.order"], kit: "WorkflowKit"),
        KitAgent(name: "Auto-Documentation Agent", description: "Auto-generates workflow docs", triggers: ["workflow.save", "workflow.publish"], actions: ["extract.info", "generate.docs", "update.readme"], kit: "WorkflowKit")
    ]
    
    // MARK: - File Index
    
    private static let indexedFiles: [FileInfo] = [
        FileInfo(name: "Workflow.swift", path: "Models/Workflow.swift", type: .model),
        FileInfo(name: "WorkflowStep.swift", path: "Models/WorkflowStep.swift", type: .model),
        FileInfo(name: "WorkflowStatus.swift", path: "Models/WorkflowStatus.swift", type: .model),
        FileInfo(name: "WorkflowKind.swift", path: "Models/WorkflowKind.swift", type: .model),
        FileInfo(name: "WorkflowFormat.swift", path: "Models/WorkflowFormat.swift", type: .model),
        FileInfo(name: "WorkflowSection.swift", path: "Models/WorkflowSection.swift", type: .model),
        FileInfo(name: "WorkflowManager.swift", path: "Services/WorkflowManager.swift", type: .service),
        FileInfo(name: "WorkflowEngine.swift", path: "Services/WorkflowEngine.swift", type: .service),
        FileInfo(name: "WorkflowParser.swift", path: "Services/WorkflowParser.swift", type: .service),
        FileInfo(name: "WorkflowGenerator.swift", path: "Services/WorkflowGenerator.swift", type: .service),
        FileInfo(name: "WorkflowBrowser.swift", path: "Views/WorkflowBrowser.swift", type: .view),
        FileInfo(name: "WorkflowList.swift", path: "Views/WorkflowList.swift", type: .view),
        FileInfo(name: "WorkflowRow.swift", path: "Views/WorkflowRow.swift", type: .view),
        FileInfo(name: "WorkflowCard.swift", path: "Views/WorkflowCard.swift", type: .view),
        FileInfo(name: "WorkflowGallery.swift", path: "Views/WorkflowGallery.swift", type: .view),
        FileInfo(name: "WorkflowIcon.swift", path: "Views/WorkflowIcon.swift", type: .view),
        FileInfo(name: "WorkflowViewModel.swift", path: "ViewModels/WorkflowViewModel.swift", type: .viewModel)
    ]
}
