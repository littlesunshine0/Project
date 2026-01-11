//
//  DocKitManifest.swift
//  DocKit
//
//  Kit manifest with commands, actions, shortcuts, menus
//

import Foundation
import DataKit

public struct DocKitManifest {
    public static let shared = DocKitManifest()
    
    public let manifest: KitManifest
    
    private init() {
        manifest = KitManifest(
            identifier: "com.flowkit.dockit",
            name: "DocKit",
            version: "1.0.0",
            description: "Documentation generation and management",
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
        KitCommand(id: "doc.search", name: "Search Docs", description: "Search documentation", syntax: "/docs <query>", kit: "DocKit", handler: "DocManager.search"),
        KitCommand(id: "doc.generate", name: "Generate Docs", description: "Generate documentation", syntax: "/docs generate [type]", kit: "DocKit", handler: "DocManager.generate"),
        KitCommand(id: "doc.readme", name: "Generate README", description: "Generate README", syntax: "/readme", kit: "DocKit", handler: "DocManager.generateReadme"),
        KitCommand(id: "doc.api", name: "Generate API Docs", description: "Generate API docs", syntax: "/api-docs", kit: "DocKit", handler: "DocManager.generateAPI"),
        KitCommand(id: "doc.changelog", name: "Generate Changelog", description: "Generate changelog", syntax: "/changelog", kit: "DocKit", handler: "DocManager.generateChangelog"),
        KitCommand(id: "doc.open", name: "Open Doc", description: "Open documentation", syntax: "/doc open <name>", kit: "DocKit", handler: "DocManager.open")
    ]
    
    // MARK: - Actions
    
    private static let actions: [KitAction] = [
        KitAction(id: "action.doc.generate", name: "Generate Docs", description: "Generate documentation", icon: "doc.badge.gearshape", kit: "DocKit", handler: "generateDocs"),
        KitAction(id: "action.doc.preview", name: "Preview Doc", description: "Preview documentation", icon: "eye", kit: "DocKit", handler: "previewDoc"),
        KitAction(id: "action.doc.export", name: "Export Doc", description: "Export documentation", icon: "square.and.arrow.up", kit: "DocKit", handler: "exportDoc"),
        KitAction(id: "action.doc.edit", name: "Edit Doc", description: "Edit documentation", icon: "pencil", kit: "DocKit", handler: "editDoc"),
        KitAction(id: "action.doc.delete", name: "Delete Doc", description: "Delete documentation", icon: "trash", kit: "DocKit", handler: "deleteDoc")
    ]
    
    // MARK: - Shortcuts
    
    private static let shortcuts: [KitShortcut] = [
        KitShortcut(key: "D", modifiers: [.command, .shift], action: "action.doc.browser", description: "Open doc browser", kit: "DocKit"),
        KitShortcut(key: "G", modifiers: [.command, .shift], action: "action.doc.generate", description: "Generate docs", kit: "DocKit"),
        KitShortcut(key: "P", modifiers: [.command, .option], action: "action.doc.preview", description: "Preview doc", kit: "DocKit")
    ]
    
    // MARK: - Menu Items
    
    private static let menuItems: [KitMenuItem] = [
        KitMenuItem(title: "Documentation", icon: "doc.text", action: "showDocs", shortcut: "⇧⌘D", kit: "DocKit"),
        KitMenuItem(title: "Generate README", icon: "doc.badge.plus", action: "generateReadme", kit: "DocKit"),
        KitMenuItem(title: "Generate API Docs", icon: "network", action: "generateAPI", kit: "DocKit"),
        KitMenuItem(title: "Generate Changelog", icon: "clock.arrow.circlepath", action: "generateChangelog", kit: "DocKit"),
        KitMenuItem(title: "Export All", icon: "square.and.arrow.up", action: "exportAll", kit: "DocKit")
    ]
    
    // MARK: - Context Menus
    
    private static let contextMenus: [KitContextMenu] = [
        KitContextMenu(targetType: "Document", items: [
            KitMenuItem(title: "Preview", icon: "eye", action: "previewDoc", kit: "DocKit"),
            KitMenuItem(title: "Edit", icon: "pencil", action: "editDoc", kit: "DocKit"),
            KitMenuItem(title: "Export", icon: "square.and.arrow.up", action: "exportDoc", kit: "DocKit"),
            KitMenuItem(title: "Delete", icon: "trash", action: "deleteDoc", kit: "DocKit")
        ], kit: "DocKit"),
        KitContextMenu(targetType: "File", items: [
            KitMenuItem(title: "Generate Docs", icon: "doc.badge.gearshape", action: "generateForFile", kit: "DocKit")
        ], kit: "DocKit")
    ]
    
    // MARK: - Workflows
    
    private static let workflows: [KitWorkflow] = [
        KitWorkflow(name: "Full Doc Generation", description: "Generate all documentation", steps: ["Analyze code", "Generate README", "Generate API docs", "Generate changelog"], kit: "DocKit"),
        KitWorkflow(name: "Doc Review", description: "Review and update docs", steps: ["Check outdated", "Update content", "Regenerate", "Publish"], kit: "DocKit")
    ]
    
    // MARK: - Agents
    
    private static let agents: [KitAgent] = [
        KitAgent(name: "Doc Watcher", description: "Watches for code changes to update docs", triggers: ["file.changed"], actions: ["analyze.changes", "update.docs"], kit: "DocKit"),
        KitAgent(name: "Doc Validator", description: "Validates documentation accuracy", triggers: ["doc.generated", "timer.daily"], actions: ["validate.links", "check.accuracy"], kit: "DocKit")
    ]
    
    public func register() async {
        await KitRegistry.shared.register(manifest)
    }
}
