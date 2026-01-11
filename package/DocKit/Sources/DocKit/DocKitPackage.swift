//
//  DocKitPackage.swift
//  DocKit
//
//  Package definition with comprehensive documentation commands, actions, workflows
//

import SwiftUI
import DataKit

public struct DocKitPackage {
    public static let shared = DocKitPackage()
    
    public let info: PackageInfo
    
    private init() {
        info = PackageInfo(
            identifier: "com.flowkit.dockit",
            name: "DocKit",
            version: "1.0.0",
            description: "Documentation generation, management, search, and publishing",
            icon: "doc.text",
            color: "green",
            files: Self.indexedFiles,
            dependencies: ["DataKit", "CoreKit"],
            exports: ["Document", "DocManager", "DocGenerator"],
            commandCount: Self.commands.count,
            actionCount: Self.actions.count,
            workflowCount: Self.workflows.count,
            agentCount: Self.agents.count,
            viewCount: 6,
            modelCount: 5,
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
        // Core Doc Commands
        KitCommand(id: "doc.create", name: "Create Document", description: "Create a new document", syntax: "/doc create <name>", kit: "DocKit", handler: "create"),
        KitCommand(id: "doc.open", name: "Open Document", description: "Open a document", syntax: "/doc open <name>", kit: "DocKit", handler: "open"),
        KitCommand(id: "doc.save", name: "Save Document", description: "Save current document", syntax: "/doc save", kit: "DocKit", handler: "save"),
        KitCommand(id: "doc.delete", name: "Delete Document", description: "Delete a document", syntax: "/doc delete <name>", kit: "DocKit", handler: "delete"),
        KitCommand(id: "doc.list", name: "List Documents", description: "List all documents", syntax: "/docs", kit: "DocKit", handler: "list"),
        KitCommand(id: "doc.search", name: "Search Documents", description: "Search in documents", syntax: "/doc search <query>", kit: "DocKit", handler: "search"),
        // Generation Commands
        KitCommand(id: "doc.generate", name: "Generate Docs", description: "Generate documentation", syntax: "/doc generate <source>", kit: "DocKit", handler: "generate"),
        KitCommand(id: "doc.generate.api", name: "Generate API Docs", description: "Generate API documentation", syntax: "/doc generate api", kit: "DocKit", handler: "generateAPI"),
        KitCommand(id: "doc.generate.readme", name: "Generate README", description: "Generate README file", syntax: "/doc generate readme", kit: "DocKit", handler: "generateReadme"),
        KitCommand(id: "doc.generate.changelog", name: "Generate Changelog", description: "Generate changelog", syntax: "/doc generate changelog", kit: "DocKit", handler: "generateChangelog"),
        // Template Commands
        KitCommand(id: "doc.template.list", name: "List Templates", description: "List doc templates", syntax: "/doc templates", kit: "DocKit", handler: "listTemplates"),
        KitCommand(id: "doc.template.apply", name: "Apply Template", description: "Apply a template", syntax: "/doc template <name>", kit: "DocKit", handler: "applyTemplate"),
        KitCommand(id: "doc.template.create", name: "Create Template", description: "Create new template", syntax: "/doc template create <name>", kit: "DocKit", handler: "createTemplate"),
        // Export Commands
        KitCommand(id: "doc.export.pdf", name: "Export PDF", description: "Export as PDF", syntax: "/doc export pdf", kit: "DocKit", handler: "exportPDF"),
        KitCommand(id: "doc.export.html", name: "Export HTML", description: "Export as HTML", syntax: "/doc export html", kit: "DocKit", handler: "exportHTML"),
        KitCommand(id: "doc.export.md", name: "Export Markdown", description: "Export as Markdown", syntax: "/doc export md", kit: "DocKit", handler: "exportMarkdown"),
        // Publishing Commands
        KitCommand(id: "doc.publish", name: "Publish Docs", description: "Publish documentation", syntax: "/doc publish", kit: "DocKit", handler: "publish"),
        KitCommand(id: "doc.preview", name: "Preview Docs", description: "Preview documentation", syntax: "/doc preview", kit: "DocKit", handler: "preview"),
        KitCommand(id: "doc.deploy", name: "Deploy Docs", description: "Deploy to hosting", syntax: "/doc deploy <target>", kit: "DocKit", handler: "deploy"),
        // Version Commands
        KitCommand(id: "doc.version", name: "Version Docs", description: "Create doc version", syntax: "/doc version <tag>", kit: "DocKit", handler: "version"),
        KitCommand(id: "doc.versions", name: "List Versions", description: "List doc versions", syntax: "/doc versions", kit: "DocKit", handler: "listVersions"),
        // Validation Commands
        KitCommand(id: "doc.validate", name: "Validate Docs", description: "Validate documentation", syntax: "/doc validate", kit: "DocKit", handler: "validate"),
        KitCommand(id: "doc.lint", name: "Lint Docs", description: "Lint documentation", syntax: "/doc lint", kit: "DocKit", handler: "lint"),
        KitCommand(id: "doc.check.links", name: "Check Links", description: "Check broken links", syntax: "/doc check links", kit: "DocKit", handler: "checkLinks"),
        KitCommand(id: "doc.stats", name: "Doc Statistics", description: "Show doc statistics", syntax: "/doc stats", kit: "DocKit", handler: "stats")
    ]
    
    // MARK: - Actions (18+)
    
    public static let actions: [KitAction] = [
        KitAction(id: "action.doc.create", name: "Create", description: "Create document", icon: "plus", kit: "DocKit", handler: "create"),
        KitAction(id: "action.doc.open", name: "Open", description: "Open document", icon: "doc", kit: "DocKit", handler: "open"),
        KitAction(id: "action.doc.save", name: "Save", description: "Save document", icon: "square.and.arrow.down", kit: "DocKit", handler: "save"),
        KitAction(id: "action.doc.delete", name: "Delete", description: "Delete document", icon: "trash", kit: "DocKit", handler: "delete"),
        KitAction(id: "action.doc.edit", name: "Edit", description: "Edit document", icon: "pencil", kit: "DocKit", handler: "edit"),
        KitAction(id: "action.doc.duplicate", name: "Duplicate", description: "Duplicate document", icon: "plus.square.on.square", kit: "DocKit", handler: "duplicate"),
        KitAction(id: "action.doc.share", name: "Share", description: "Share document", icon: "square.and.arrow.up", kit: "DocKit", handler: "share"),
        KitAction(id: "action.doc.generate", name: "Generate", description: "Generate docs", icon: "wand.and.stars", kit: "DocKit", handler: "generate"),
        KitAction(id: "action.doc.preview", name: "Preview", description: "Preview document", icon: "eye", kit: "DocKit", handler: "preview"),
        KitAction(id: "action.doc.publish", name: "Publish", description: "Publish docs", icon: "paperplane", kit: "DocKit", handler: "publish"),
        KitAction(id: "action.doc.export", name: "Export", description: "Export document", icon: "square.and.arrow.up.on.square", kit: "DocKit", handler: "export"),
        KitAction(id: "action.doc.print", name: "Print", description: "Print document", icon: "printer", kit: "DocKit", handler: "print"),
        KitAction(id: "action.doc.search", name: "Search", description: "Search docs", icon: "magnifyingglass", kit: "DocKit", handler: "search"),
        KitAction(id: "action.doc.validate", name: "Validate", description: "Validate docs", icon: "checkmark.seal", kit: "DocKit", handler: "validate"),
        KitAction(id: "action.doc.format", name: "Format", description: "Format document", icon: "textformat", kit: "DocKit", handler: "format"),
        KitAction(id: "action.doc.toc", name: "Table of Contents", description: "Generate TOC", icon: "list.bullet", kit: "DocKit", handler: "generateTOC"),
        KitAction(id: "action.doc.index", name: "Index", description: "Generate index", icon: "list.number", kit: "DocKit", handler: "generateIndex"),
        KitAction(id: "action.doc.refresh", name: "Refresh", description: "Refresh docs", icon: "arrow.clockwise", kit: "DocKit", handler: "refresh")
    ]
    
    // MARK: - Shortcuts
    
    public static let shortcuts: [KitShortcut] = [
        KitShortcut(key: "D", modifiers: [.command, .shift], action: "doc.list", description: "Show documents", kit: "DocKit"),
        KitShortcut(key: "N", modifiers: [.command], action: "doc.create", description: "New document", kit: "DocKit"),
        KitShortcut(key: "O", modifiers: [.command], action: "doc.open", description: "Open document", kit: "DocKit"),
        KitShortcut(key: "S", modifiers: [.command], action: "doc.save", description: "Save document", kit: "DocKit"),
        KitShortcut(key: "G", modifiers: [.command, .shift], action: "action.doc.generate", description: "Generate docs", kit: "DocKit"),
        KitShortcut(key: "P", modifiers: [.command, .shift], action: "action.doc.preview", description: "Preview", kit: "DocKit"),
        KitShortcut(key: "E", modifiers: [.command, .shift], action: "action.doc.export", description: "Export", kit: "DocKit")
    ]
    
    // MARK: - Menu Items
    
    public static let menuItems: [KitMenuItem] = [
        KitMenuItem(title: "Documents", icon: "doc.text", action: "showDocuments", shortcut: "⇧⌘D", kit: "DocKit"),
        KitMenuItem(title: "New Document", icon: "plus", action: "newDocument", shortcut: "⌘N", kit: "DocKit"),
        KitMenuItem(title: "Generate Docs", icon: "wand.and.stars", action: "generateDocs", shortcut: "⇧⌘G", kit: "DocKit"),
        KitMenuItem(title: "Templates", icon: "doc.text", action: "showTemplates", kit: "DocKit"),
        KitMenuItem(title: "Preview", icon: "eye", action: "preview", shortcut: "⇧⌘P", kit: "DocKit"),
        KitMenuItem(title: "Publish", icon: "paperplane", action: "publish", kit: "DocKit"),
        KitMenuItem(title: "Export", icon: "square.and.arrow.up", action: "export", shortcut: "⇧⌘E", kit: "DocKit"),
        KitMenuItem(title: "Validate", icon: "checkmark.seal", action: "validate", kit: "DocKit")
    ]
    
    // MARK: - Context Menus
    
    public static let contextMenus: [KitContextMenu] = [
        KitContextMenu(targetType: "Document", items: [
            KitMenuItem(title: "Open", icon: "doc", action: "open", kit: "DocKit"),
            KitMenuItem(title: "Edit", icon: "pencil", action: "edit", kit: "DocKit"),
            KitMenuItem(title: "Preview", icon: "eye", action: "preview", kit: "DocKit"),
            KitMenuItem(title: "Export", icon: "square.and.arrow.up", action: "export", kit: "DocKit"),
            KitMenuItem(title: "Duplicate", icon: "plus.square.on.square", action: "duplicate", kit: "DocKit"),
            KitMenuItem(title: "Delete", icon: "trash", action: "delete", kit: "DocKit")
        ], kit: "DocKit")
    ]
    
    // MARK: - Workflows (10+)
    
    public static let workflows: [KitWorkflow] = [
        KitWorkflow(name: "Create Documentation", description: "Create new documentation", steps: ["New Document", "Select template", "Add content", "Format", "Save"], kit: "DocKit"),
        KitWorkflow(name: "Generate API Docs", description: "Generate API documentation", steps: ["Select source", "Configure options", "Generate", "Review", "Publish"], kit: "DocKit"),
        KitWorkflow(name: "Publish Documentation", description: "Publish docs to hosting", steps: ["Validate docs", "Build", "Preview", "Deploy", "Verify"], kit: "DocKit"),
        KitWorkflow(name: "Update Documentation", description: "Update existing docs", steps: ["Open document", "Make changes", "Validate", "Save", "Publish"], kit: "DocKit"),
        KitWorkflow(name: "Create README", description: "Create project README", steps: ["New README", "Add sections", "Add badges", "Add examples", "Save"], kit: "DocKit"),
        KitWorkflow(name: "Generate Changelog", description: "Generate changelog from commits", steps: ["Select range", "Configure format", "Generate", "Review", "Save"], kit: "DocKit"),
        KitWorkflow(name: "Export Documentation", description: "Export docs to various formats", steps: ["Select docs", "Choose format", "Configure options", "Export", "Verify"], kit: "DocKit"),
        KitWorkflow(name: "Validate Documentation", description: "Validate all documentation", steps: ["Run validation", "Check links", "Fix issues", "Re-validate"], kit: "DocKit"),
        KitWorkflow(name: "Version Documentation", description: "Create versioned docs", steps: ["Select version", "Tag docs", "Archive", "Update latest"], kit: "DocKit"),
        KitWorkflow(name: "Search and Replace", description: "Search and replace in docs", steps: ["Enter search term", "Enter replacement", "Preview changes", "Apply"], kit: "DocKit")
    ]
    
    // MARK: - Agents (6+)
    
    public static let agents: [KitAgent] = [
        KitAgent(name: "Doc Generator", description: "Auto-generates documentation from code", triggers: ["code.change", "api.update", "doc.request"], actions: ["analyze.code", "extract.comments", "generate.docs"], kit: "DocKit"),
        KitAgent(name: "Link Checker", description: "Monitors and fixes broken links", triggers: ["doc.save", "schedule.daily", "check.request"], actions: ["scan.links", "verify.links", "report.broken", "suggest.fixes"], kit: "DocKit"),
        KitAgent(name: "Style Enforcer", description: "Enforces documentation style", triggers: ["doc.save", "doc.create"], actions: ["check.style", "suggest.fixes", "auto.format"], kit: "DocKit"),
        KitAgent(name: "Translation Agent", description: "Manages doc translations", triggers: ["doc.update", "translation.request"], actions: ["detect.changes", "queue.translation", "sync.versions"], kit: "DocKit"),
        KitAgent(name: "Search Indexer", description: "Maintains search index", triggers: ["doc.save", "doc.delete", "schedule.hourly"], actions: ["index.content", "update.search", "optimize.index"], kit: "DocKit"),
        KitAgent(name: "Freshness Monitor", description: "Monitors doc freshness", triggers: ["schedule.weekly", "code.change"], actions: ["check.freshness", "identify.stale", "notify.owners"], kit: "DocKit")
    ]
    
    // MARK: - File Index
    
    private static let indexedFiles: [FileInfo] = [
        FileInfo(name: "Document.swift", path: "Models/Document.swift", type: .model),
        FileInfo(name: "DocCategory.swift", path: "Models/DocCategory.swift", type: .model),
        FileInfo(name: "DocKind.swift", path: "Models/DocKind.swift", type: .model),
        FileInfo(name: "DocSection.swift", path: "Models/DocSection.swift", type: .model),
        FileInfo(name: "DocError.swift", path: "Models/DocError.swift", type: .model),
        FileInfo(name: "DocManager.swift", path: "Services/DocManager.swift", type: .service),
        FileInfo(name: "DocGenerator.swift", path: "Services/DocGenerator.swift", type: .service),
        FileInfo(name: "DocParser.swift", path: "Services/DocParser.swift", type: .service),
        FileInfo(name: "DocBrowser.swift", path: "Views/DocBrowser.swift", type: .view),
        FileInfo(name: "DocList.swift", path: "Views/DocList.swift", type: .view),
        FileInfo(name: "DocRow.swift", path: "Views/DocRow.swift", type: .view),
        FileInfo(name: "DocIcon.swift", path: "Views/DocIcon.swift", type: .view),
        FileInfo(name: "DocViewModel.swift", path: "ViewModels/DocViewModel.swift", type: .viewModel)
    ]
}
