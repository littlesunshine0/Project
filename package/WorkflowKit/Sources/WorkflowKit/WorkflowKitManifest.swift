//
//  WorkflowKitManifest.swift
//  WorkflowKit
//
//  Kit manifest with commands, actions, shortcuts, menus
//

import Foundation
import DataKit

public struct WorkflowKitManifest {
    public static let shared = WorkflowKitManifest()
    
    public let manifest: KitManifest
    
    private init() {
        manifest = KitManifest(
            identifier: "com.flowkit.workflowkit",
            name: "WorkflowKit",
            version: "1.0.0",
            description: "Workflow creation, execution, and management",
            commands: Self.commands,
            actions: Self.actions,
            shortcuts: Self.shortcuts,
            menuItems: Self.menuItems,
            contextMenus: Self.contextMenus,
            workflows: Self.workflows,
            agents: Self.agents
        )
    }
    
    // MARK: - Commands
    
    private static let commands: [KitCommand] = [
        KitCommand(id: "wf.run", name: "Run Workflow", description: "Execute a workflow", syntax: "/workflow <name>", kit: "WorkflowKit", handler: "WorkflowManager.run"),
        KitCommand(id: "wf.list", name: "List Workflows", description: "List all workflows", syntax: "/workflows", kit: "WorkflowKit", handler: "WorkflowManager.list"),
        KitCommand(id: "wf.create", name: "Create Workflow", description: "Create new workflow", syntax: "/workflow new <name>", kit: "WorkflowKit", handler: "WorkflowManager.create"),
        KitCommand(id: "wf.pause", name: "Pause Workflow", description: "Pause running workflow", syntax: "/pause [name]", kit: "WorkflowKit", handler: "WorkflowManager.pause"),
        KitCommand(id: "wf.resume", name: "Resume Workflow", description: "Resume paused workflow", syntax: "/resume [name]", kit: "WorkflowKit", handler: "WorkflowManager.resume"),
        KitCommand(id: "wf.cancel", name: "Cancel Workflow", description: "Cancel running workflow", syntax: "/cancel [name]", kit: "WorkflowKit", handler: "WorkflowManager.cancel"),
        KitCommand(id: "wf.status", name: "Workflow Status", description: "Show workflow status", syntax: "/status [name]", kit: "WorkflowKit", handler: "WorkflowManager.status")
    ]
    
    // MARK: - Actions
    
    private static let actions: [KitAction] = [
        KitAction(id: "action.wf.run", name: "Run Workflow", description: "Execute the selected workflow", icon: "play.fill", kit: "WorkflowKit", handler: "runWorkflow"),
        KitAction(id: "action.wf.pause", name: "Pause Workflow", description: "Pause running workflow", icon: "pause.fill", kit: "WorkflowKit", handler: "pauseWorkflow"),
        KitAction(id: "action.wf.stop", name: "Stop Workflow", description: "Stop running workflow", icon: "stop.fill", kit: "WorkflowKit", handler: "stopWorkflow"),
        KitAction(id: "action.wf.edit", name: "Edit Workflow", description: "Edit workflow", icon: "pencil", kit: "WorkflowKit", handler: "editWorkflow"),
        KitAction(id: "action.wf.duplicate", name: "Duplicate Workflow", description: "Duplicate workflow", icon: "plus.square.on.square", kit: "WorkflowKit", handler: "duplicateWorkflow"),
        KitAction(id: "action.wf.delete", name: "Delete Workflow", description: "Delete workflow", icon: "trash", kit: "WorkflowKit", handler: "deleteWorkflow"),
        KitAction(id: "action.wf.export", name: "Export Workflow", description: "Export workflow", icon: "square.and.arrow.up", kit: "WorkflowKit", handler: "exportWorkflow")
    ]
    
    // MARK: - Shortcuts
    
    private static let shortcuts: [KitShortcut] = [
        KitShortcut(key: "W", modifiers: [.command, .shift], action: "action.wf.browser", description: "Open workflow browser", kit: "WorkflowKit"),
        KitShortcut(key: "R", modifiers: [.command], action: "action.wf.run", description: "Run workflow", kit: "WorkflowKit"),
        KitShortcut(key: "N", modifiers: [.command, .shift], action: "action.wf.new", description: "New workflow", kit: "WorkflowKit"),
        KitShortcut(key: ".", modifiers: [.command], action: "action.wf.stop", description: "Stop workflow", kit: "WorkflowKit")
    ]
    
    // MARK: - Menu Items
    
    private static let menuItems: [KitMenuItem] = [
        KitMenuItem(title: "Workflows", icon: "arrow.triangle.branch", action: "showWorkflows", shortcut: "⇧⌘W", kit: "WorkflowKit"),
        KitMenuItem(title: "New Workflow", icon: "plus", action: "newWorkflow", shortcut: "⇧⌘N", kit: "WorkflowKit"),
        KitMenuItem(title: "Running Workflows", icon: "play.circle", action: "showRunning", kit: "WorkflowKit"),
        KitMenuItem(title: "Workflow History", icon: "clock.arrow.circlepath", action: "showHistory", kit: "WorkflowKit"),
        KitMenuItem(title: "Import Workflow", icon: "square.and.arrow.down", action: "importWorkflow", kit: "WorkflowKit")
    ]
    
    // MARK: - Context Menus
    
    private static let contextMenus: [KitContextMenu] = [
        KitContextMenu(targetType: "Workflow", items: [
            KitMenuItem(title: "Run", icon: "play.fill", action: "runWorkflow", kit: "WorkflowKit"),
            KitMenuItem(title: "Edit", icon: "pencil", action: "editWorkflow", kit: "WorkflowKit"),
            KitMenuItem(title: "Duplicate", icon: "plus.square.on.square", action: "duplicateWorkflow", kit: "WorkflowKit"),
            KitMenuItem(title: "Export", icon: "square.and.arrow.up", action: "exportWorkflow", kit: "WorkflowKit"),
            KitMenuItem(title: "Delete", icon: "trash", action: "deleteWorkflow", kit: "WorkflowKit")
        ], kit: "WorkflowKit")
    ]
    
    // MARK: - Workflows
    
    private static let workflows: [KitWorkflow] = [
        KitWorkflow(name: "Build & Test", description: "Build project and run tests", steps: ["swift build", "swift test"], kit: "WorkflowKit"),
        KitWorkflow(name: "Git Commit", description: "Stage and commit changes", steps: ["git add .", "git commit -m 'Update'"], kit: "WorkflowKit"),
        KitWorkflow(name: "Deploy", description: "Build and deploy", steps: ["swift build -c release", "./deploy.sh"], kit: "WorkflowKit")
    ]
    
    // MARK: - Agents
    
    private static let agents: [KitAgent] = [
        KitAgent(name: "Workflow Monitor", description: "Monitors running workflows", triggers: ["workflow.started", "workflow.completed"], actions: ["update.status", "notify.user"], kit: "WorkflowKit"),
        KitAgent(name: "Auto-Retry Agent", description: "Retries failed workflows", triggers: ["workflow.failed"], actions: ["analyze.failure", "retry.workflow"], kit: "WorkflowKit")
    ]
    
    public func register() async {
        await KitRegistry.shared.register(manifest)
    }
}
