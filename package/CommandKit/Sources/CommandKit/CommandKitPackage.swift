//
//  CommandKitPackage.swift
//  CommandKit
//
//  Package definition with comprehensive commands, actions, workflows, agents
//

import SwiftUI
import DataKit

// MARK: - Package Definition

public struct CommandKitPackage {
    public static let shared = CommandKitPackage()
    
    public let info: PackageInfo
    
    private init() {
        info = PackageInfo(
            identifier: "com.flowkit.commandkit",
            name: "CommandKit",
            version: "1.0.0",
            description: "Command parsing, autocomplete, execution, and template system",
            icon: "command",
            color: "blue",
            files: Self.indexedFiles,
            dependencies: ["DataKit"],
            exports: ["Command", "CommandManager", "CommandParser", "CommandViewModel"],
            commandCount: Self.commands.count,
            actionCount: Self.actions.count,
            workflowCount: Self.workflows.count,
            agentCount: Self.agents.count,
            viewCount: 10,
            modelCount: 8,
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

    
    // MARK: - Commands (30+)
    
    public static let commands: [KitCommand] = [
        // Core Commands
        KitCommand(id: "cmd.run", name: "Run", description: "Execute a command", syntax: "/run <command>", kit: "CommandKit", handler: "execute"),
        KitCommand(id: "cmd.list", name: "List Commands", description: "List all available commands", syntax: "/commands", kit: "CommandKit", handler: "list"),
        KitCommand(id: "cmd.help", name: "Help", description: "Show command help", syntax: "/help <command>", kit: "CommandKit", handler: "help"),
        KitCommand(id: "cmd.history", name: "History", description: "Show command history", syntax: "/history [count]", kit: "CommandKit", handler: "history"),
        KitCommand(id: "cmd.clear", name: "Clear", description: "Clear the screen", syntax: "/clear", kit: "CommandKit", handler: "clear"),
        KitCommand(id: "cmd.alias", name: "Alias", description: "Create command alias", syntax: "/alias <name> <command>", kit: "CommandKit", handler: "alias"),
        KitCommand(id: "cmd.unalias", name: "Unalias", description: "Remove command alias", syntax: "/unalias <name>", kit: "CommandKit", handler: "unalias"),
        // Search Commands
        KitCommand(id: "cmd.search", name: "Search", description: "Search commands", syntax: "/search <query>", kit: "CommandKit", handler: "search"),
        KitCommand(id: "cmd.find", name: "Find", description: "Find command by name", syntax: "/find <name>", kit: "CommandKit", handler: "find"),
        KitCommand(id: "cmd.filter", name: "Filter", description: "Filter commands by category", syntax: "/filter <category>", kit: "CommandKit", handler: "filter"),
        // Template Commands
        KitCommand(id: "cmd.template.list", name: "List Templates", description: "List command templates", syntax: "/templates", kit: "CommandKit", handler: "listTemplates"),
        KitCommand(id: "cmd.template.create", name: "Create Template", description: "Create new template", syntax: "/template create <name>", kit: "CommandKit", handler: "createTemplate"),
        KitCommand(id: "cmd.template.apply", name: "Apply Template", description: "Apply a template", syntax: "/template apply <name>", kit: "CommandKit", handler: "applyTemplate"),
        KitCommand(id: "cmd.template.delete", name: "Delete Template", description: "Delete a template", syntax: "/template delete <name>", kit: "CommandKit", handler: "deleteTemplate"),
        // Batch Commands
        KitCommand(id: "cmd.batch", name: "Batch Execute", description: "Execute multiple commands", syntax: "/batch <commands...>", kit: "CommandKit", handler: "batch"),
        KitCommand(id: "cmd.queue", name: "Queue Command", description: "Add command to queue", syntax: "/queue <command>", kit: "CommandKit", handler: "queue"),
        KitCommand(id: "cmd.queue.run", name: "Run Queue", description: "Execute queued commands", syntax: "/queue run", kit: "CommandKit", handler: "runQueue"),
        KitCommand(id: "cmd.queue.clear", name: "Clear Queue", description: "Clear command queue", syntax: "/queue clear", kit: "CommandKit", handler: "clearQueue"),
        // Export/Import Commands
        KitCommand(id: "cmd.export", name: "Export", description: "Export commands to file", syntax: "/export <file>", kit: "CommandKit", handler: "export"),
        KitCommand(id: "cmd.import", name: "Import", description: "Import commands from file", syntax: "/import <file>", kit: "CommandKit", handler: "import"),
        // Favorites Commands
        KitCommand(id: "cmd.favorite", name: "Favorite", description: "Add to favorites", syntax: "/favorite <command>", kit: "CommandKit", handler: "favorite"),
        KitCommand(id: "cmd.unfavorite", name: "Unfavorite", description: "Remove from favorites", syntax: "/unfavorite <command>", kit: "CommandKit", handler: "unfavorite"),
        KitCommand(id: "cmd.favorites", name: "List Favorites", description: "Show favorite commands", syntax: "/favorites", kit: "CommandKit", handler: "listFavorites"),
        // Macro Commands
        KitCommand(id: "cmd.macro.record", name: "Record Macro", description: "Start recording macro", syntax: "/macro record <name>", kit: "CommandKit", handler: "recordMacro"),
        KitCommand(id: "cmd.macro.stop", name: "Stop Recording", description: "Stop recording macro", syntax: "/macro stop", kit: "CommandKit", handler: "stopMacro"),
        KitCommand(id: "cmd.macro.play", name: "Play Macro", description: "Play recorded macro", syntax: "/macro play <name>", kit: "CommandKit", handler: "playMacro"),
        KitCommand(id: "cmd.macro.list", name: "List Macros", description: "List all macros", syntax: "/macros", kit: "CommandKit", handler: "listMacros"),
        // Utility Commands
        KitCommand(id: "cmd.echo", name: "Echo", description: "Echo text", syntax: "/echo <text>", kit: "CommandKit", handler: "echo"),
        KitCommand(id: "cmd.version", name: "Version", description: "Show version", syntax: "/version", kit: "CommandKit", handler: "version"),
        KitCommand(id: "cmd.stats", name: "Stats", description: "Show command statistics", syntax: "/stats", kit: "CommandKit", handler: "stats")
    ]

    
    // MARK: - Actions (20+)
    
    public static let actions: [KitAction] = [
        KitAction(id: "action.cmd.execute", name: "Execute", description: "Execute selected command", icon: "play.fill", kit: "CommandKit", handler: "execute"),
        KitAction(id: "action.cmd.copy", name: "Copy", description: "Copy command to clipboard", icon: "doc.on.doc", kit: "CommandKit", handler: "copy"),
        KitAction(id: "action.cmd.paste", name: "Paste", description: "Paste from clipboard", icon: "doc.on.clipboard", kit: "CommandKit", handler: "paste"),
        KitAction(id: "action.cmd.favorite", name: "Favorite", description: "Toggle favorite", icon: "star", kit: "CommandKit", handler: "toggleFavorite"),
        KitAction(id: "action.cmd.edit", name: "Edit", description: "Edit command", icon: "pencil", kit: "CommandKit", handler: "edit"),
        KitAction(id: "action.cmd.delete", name: "Delete", description: "Delete command", icon: "trash", kit: "CommandKit", handler: "delete"),
        KitAction(id: "action.cmd.duplicate", name: "Duplicate", description: "Duplicate command", icon: "plus.square.on.square", kit: "CommandKit", handler: "duplicate"),
        KitAction(id: "action.cmd.share", name: "Share", description: "Share command", icon: "square.and.arrow.up", kit: "CommandKit", handler: "share"),
        KitAction(id: "action.cmd.pin", name: "Pin", description: "Pin command", icon: "pin", kit: "CommandKit", handler: "pin"),
        KitAction(id: "action.cmd.unpin", name: "Unpin", description: "Unpin command", icon: "pin.slash", kit: "CommandKit", handler: "unpin"),
        KitAction(id: "action.cmd.refresh", name: "Refresh", description: "Refresh commands", icon: "arrow.clockwise", kit: "CommandKit", handler: "refresh"),
        KitAction(id: "action.cmd.sort", name: "Sort", description: "Sort commands", icon: "arrow.up.arrow.down", kit: "CommandKit", handler: "sort"),
        KitAction(id: "action.cmd.group", name: "Group", description: "Group commands", icon: "folder", kit: "CommandKit", handler: "group"),
        KitAction(id: "action.cmd.ungroup", name: "Ungroup", description: "Ungroup commands", icon: "folder.badge.minus", kit: "CommandKit", handler: "ungroup"),
        KitAction(id: "action.cmd.expand", name: "Expand", description: "Expand all", icon: "arrow.down.right.and.arrow.up.left", kit: "CommandKit", handler: "expand"),
        KitAction(id: "action.cmd.collapse", name: "Collapse", description: "Collapse all", icon: "arrow.up.left.and.arrow.down.right", kit: "CommandKit", handler: "collapse"),
        KitAction(id: "action.cmd.preview", name: "Preview", description: "Preview command", icon: "eye", kit: "CommandKit", handler: "preview"),
        KitAction(id: "action.cmd.info", name: "Info", description: "Show command info", icon: "info.circle", kit: "CommandKit", handler: "info"),
        KitAction(id: "action.cmd.history", name: "History", description: "Show history", icon: "clock.arrow.circlepath", kit: "CommandKit", handler: "showHistory"),
        KitAction(id: "action.cmd.palette", name: "Palette", description: "Open command palette", icon: "command", kit: "CommandKit", handler: "openPalette")
    ]
    
    // MARK: - Shortcuts (15+)
    
    public static let shortcuts: [KitShortcut] = [
        KitShortcut(key: "K", modifiers: [.command], action: "action.cmd.palette", description: "Open command palette", kit: "CommandKit"),
        KitShortcut(key: "P", modifiers: [.command, .shift], action: "action.cmd.palette", description: "Open command palette", kit: "CommandKit"),
        KitShortcut(key: "Return", modifiers: [.command], action: "action.cmd.execute", description: "Execute command", kit: "CommandKit"),
        KitShortcut(key: "C", modifiers: [.command], action: "action.cmd.copy", description: "Copy command", kit: "CommandKit"),
        KitShortcut(key: "V", modifiers: [.command], action: "action.cmd.paste", description: "Paste command", kit: "CommandKit"),
        KitShortcut(key: "D", modifiers: [.command], action: "action.cmd.duplicate", description: "Duplicate command", kit: "CommandKit"),
        KitShortcut(key: "Delete", modifiers: [.command], action: "action.cmd.delete", description: "Delete command", kit: "CommandKit"),
        KitShortcut(key: "E", modifiers: [.command], action: "action.cmd.edit", description: "Edit command", kit: "CommandKit"),
        KitShortcut(key: "F", modifiers: [.command], action: "cmd.search", description: "Search commands", kit: "CommandKit"),
        KitShortcut(key: "H", modifiers: [.command, .shift], action: "action.cmd.history", description: "Show history", kit: "CommandKit"),
        KitShortcut(key: "L", modifiers: [.command], action: "cmd.clear", description: "Clear screen", kit: "CommandKit"),
        KitShortcut(key: "R", modifiers: [.command], action: "action.cmd.refresh", description: "Refresh", kit: "CommandKit"),
        KitShortcut(key: "S", modifiers: [.command, .shift], action: "action.cmd.share", description: "Share command", kit: "CommandKit"),
        KitShortcut(key: "I", modifiers: [.command], action: "action.cmd.info", description: "Show info", kit: "CommandKit"),
        KitShortcut(key: "Space", modifiers: [.command], action: "action.cmd.preview", description: "Quick preview", kit: "CommandKit")
    ]

    
    // MARK: - Menu Items (15+)
    
    public static let menuItems: [KitMenuItem] = [
        KitMenuItem(title: "Commands", icon: "command", action: "showCommands", shortcut: "⌘K", kit: "CommandKit"),
        KitMenuItem(title: "Command History", icon: "clock.arrow.circlepath", action: "showHistory", shortcut: "⇧⌘H", kit: "CommandKit"),
        KitMenuItem(title: "New Command", icon: "plus", action: "newCommand", shortcut: "⌘N", kit: "CommandKit"),
        KitMenuItem(title: "Edit Command", icon: "pencil", action: "editCommand", shortcut: "⌘E", kit: "CommandKit"),
        KitMenuItem(title: "Delete Command", icon: "trash", action: "deleteCommand", shortcut: "⌘⌫", kit: "CommandKit"),
        KitMenuItem(title: "Duplicate Command", icon: "plus.square.on.square", action: "duplicateCommand", shortcut: "⌘D", kit: "CommandKit"),
        KitMenuItem(title: "Import Commands", icon: "square.and.arrow.down", action: "importCommands", kit: "CommandKit"),
        KitMenuItem(title: "Export Commands", icon: "square.and.arrow.up", action: "exportCommands", kit: "CommandKit"),
        KitMenuItem(title: "Templates", icon: "doc.text", action: "showTemplates", kit: "CommandKit"),
        KitMenuItem(title: "Macros", icon: "repeat", action: "showMacros", kit: "CommandKit"),
        KitMenuItem(title: "Favorites", icon: "star", action: "showFavorites", kit: "CommandKit"),
        KitMenuItem(title: "Recent Commands", icon: "clock", action: "showRecent", kit: "CommandKit"),
        KitMenuItem(title: "Command Statistics", icon: "chart.bar", action: "showStats", kit: "CommandKit"),
        KitMenuItem(title: "Preferences", icon: "gearshape", action: "showPreferences", kit: "CommandKit"),
        KitMenuItem(title: "Help", icon: "questionmark.circle", action: "showHelp", kit: "CommandKit")
    ]
    
    // MARK: - Context Menus (5+)
    
    public static let contextMenus: [KitContextMenu] = [
        KitContextMenu(targetType: "Command", items: [
            KitMenuItem(title: "Execute", icon: "play.fill", action: "execute", kit: "CommandKit"),
            KitMenuItem(title: "Copy", icon: "doc.on.doc", action: "copy", kit: "CommandKit"),
            KitMenuItem(title: "Edit", icon: "pencil", action: "edit", kit: "CommandKit"),
            KitMenuItem(title: "Duplicate", icon: "plus.square.on.square", action: "duplicate", kit: "CommandKit"),
            KitMenuItem(title: "Add to Favorites", icon: "star", action: "favorite", kit: "CommandKit"),
            KitMenuItem(title: "Delete", icon: "trash", action: "delete", kit: "CommandKit")
        ], kit: "CommandKit"),
        KitContextMenu(targetType: "CommandGroup", items: [
            KitMenuItem(title: "Expand All", icon: "arrow.down.right.and.arrow.up.left", action: "expandAll", kit: "CommandKit"),
            KitMenuItem(title: "Collapse All", icon: "arrow.up.left.and.arrow.down.right", action: "collapseAll", kit: "CommandKit"),
            KitMenuItem(title: "Rename Group", icon: "pencil", action: "renameGroup", kit: "CommandKit"),
            KitMenuItem(title: "Delete Group", icon: "trash", action: "deleteGroup", kit: "CommandKit")
        ], kit: "CommandKit"),
        KitContextMenu(targetType: "Template", items: [
            KitMenuItem(title: "Apply Template", icon: "doc.badge.plus", action: "applyTemplate", kit: "CommandKit"),
            KitMenuItem(title: "Edit Template", icon: "pencil", action: "editTemplate", kit: "CommandKit"),
            KitMenuItem(title: "Duplicate Template", icon: "plus.square.on.square", action: "duplicateTemplate", kit: "CommandKit"),
            KitMenuItem(title: "Delete Template", icon: "trash", action: "deleteTemplate", kit: "CommandKit")
        ], kit: "CommandKit"),
        KitContextMenu(targetType: "Macro", items: [
            KitMenuItem(title: "Play Macro", icon: "play.fill", action: "playMacro", kit: "CommandKit"),
            KitMenuItem(title: "Edit Macro", icon: "pencil", action: "editMacro", kit: "CommandKit"),
            KitMenuItem(title: "Delete Macro", icon: "trash", action: "deleteMacro", kit: "CommandKit")
        ], kit: "CommandKit"),
        KitContextMenu(targetType: "History", items: [
            KitMenuItem(title: "Re-execute", icon: "play.fill", action: "reexecute", kit: "CommandKit"),
            KitMenuItem(title: "Copy", icon: "doc.on.doc", action: "copyHistory", kit: "CommandKit"),
            KitMenuItem(title: "Clear History", icon: "trash", action: "clearHistory", kit: "CommandKit")
        ], kit: "CommandKit")
    ]

    
    // MARK: - Workflows (10+)
    
    public static let workflows: [KitWorkflow] = [
        KitWorkflow(name: "Quick Command Execution", description: "Execute a command quickly", steps: ["Open palette (⌘K)", "Type command", "Press Enter"], kit: "CommandKit"),
        KitWorkflow(name: "Create Custom Command", description: "Create a new custom command", steps: ["Open New Command", "Define name and syntax", "Add parameters", "Set handler", "Save"], kit: "CommandKit"),
        KitWorkflow(name: "Record Macro", description: "Record a sequence of commands", steps: ["Start recording", "Execute commands", "Stop recording", "Name macro"], kit: "CommandKit"),
        KitWorkflow(name: "Batch Execution", description: "Execute multiple commands at once", steps: ["Select commands", "Add to queue", "Review queue", "Execute all"], kit: "CommandKit"),
        KitWorkflow(name: "Import Commands", description: "Import commands from file", steps: ["Open Import", "Select file", "Review commands", "Confirm import"], kit: "CommandKit"),
        KitWorkflow(name: "Export Commands", description: "Export commands to file", steps: ["Select commands", "Choose format", "Set destination", "Export"], kit: "CommandKit"),
        KitWorkflow(name: "Create Template", description: "Create a command template", steps: ["Open Templates", "New Template", "Define structure", "Add placeholders", "Save"], kit: "CommandKit"),
        KitWorkflow(name: "Command Alias Setup", description: "Set up command aliases", steps: ["Open Aliases", "Create alias", "Map to command", "Test alias"], kit: "CommandKit"),
        KitWorkflow(name: "Organize Commands", description: "Organize commands into groups", steps: ["Select commands", "Create group", "Drag to group", "Rename group"], kit: "CommandKit"),
        KitWorkflow(name: "Command Search", description: "Find commands efficiently", steps: ["Open search (⌘F)", "Enter query", "Filter results", "Select command"], kit: "CommandKit")
    ]
    
    // MARK: - Agents (5+)
    
    public static let agents: [KitAgent] = [
        KitAgent(name: "Command Suggester", description: "Suggests commands based on context and history", triggers: ["user.typing", "context.change", "file.open"], actions: ["analyze.context", "suggest.commands", "rank.suggestions"], kit: "CommandKit"),
        KitAgent(name: "History Tracker", description: "Tracks command usage and patterns", triggers: ["command.executed", "command.failed"], actions: ["record.history", "update.frequency", "analyze.patterns"], kit: "CommandKit"),
        KitAgent(name: "Autocomplete Agent", description: "Provides intelligent autocomplete", triggers: ["user.typing", "parameter.focus"], actions: ["fetch.completions", "rank.completions", "show.suggestions"], kit: "CommandKit"),
        KitAgent(name: "Error Recovery Agent", description: "Helps recover from command errors", triggers: ["command.failed", "syntax.error"], actions: ["analyze.error", "suggest.fix", "offer.alternatives"], kit: "CommandKit"),
        KitAgent(name: "Command Optimizer", description: "Optimizes command sequences", triggers: ["batch.created", "macro.recorded"], actions: ["analyze.sequence", "suggest.optimizations", "apply.optimizations"], kit: "CommandKit")
    ]
    
    // MARK: - File Index
    
    private static let indexedFiles: [FileInfo] = [
        FileInfo(name: "Command.swift", path: "Models/Command.swift", type: .model, symbols: [
            SymbolInfo(name: "Command", type: .struct, file: "Command.swift", line: 10),
            SymbolInfo(name: "CommandParameter", type: .struct, file: "Command.swift", line: 60)
        ]),
        FileInfo(name: "CommandCategory.swift", path: "Models/CommandCategory.swift", type: .model),
        FileInfo(name: "CommandType.swift", path: "Models/CommandType.swift", type: .model),
        FileInfo(name: "CommandFormat.swift", path: "Models/CommandFormat.swift", type: .model),
        FileInfo(name: "CommandSection.swift", path: "Models/CommandSection.swift", type: .model),
        FileInfo(name: "CommandError.swift", path: "Models/CommandError.swift", type: .model),
        FileInfo(name: "ExecutionResult.swift", path: "Models/ExecutionResult.swift", type: .model),
        FileInfo(name: "CommandManager.swift", path: "Services/CommandManager.swift", type: .service),
        FileInfo(name: "CommandParser.swift", path: "Services/CommandParser.swift", type: .service),
        FileInfo(name: "CommandGenerator.swift", path: "Services/CommandGenerator.swift", type: .service),
        FileInfo(name: "CommandComposer.swift", path: "Services/CommandComposer.swift", type: .service),
        FileInfo(name: "CommandBrowser.swift", path: "Views/CommandBrowser.swift", type: .view),
        FileInfo(name: "CommandList.swift", path: "Views/CommandList.swift", type: .view),
        FileInfo(name: "CommandRow.swift", path: "Views/CommandRow.swift", type: .view),
        FileInfo(name: "CommandCard.swift", path: "Views/CommandCard.swift", type: .view),
        FileInfo(name: "CommandGallery.swift", path: "Views/CommandGallery.swift", type: .view),
        FileInfo(name: "CommandTable.swift", path: "Views/CommandTable.swift", type: .view),
        FileInfo(name: "CommandIcon.swift", path: "Views/CommandIcon.swift", type: .view),
        FileInfo(name: "CommandColumn.swift", path: "Views/CommandColumn.swift", type: .view),
        FileInfo(name: "CommandViewModel.swift", path: "ViewModels/CommandViewModel.swift", type: .viewModel),
        FileInfo(name: "commands.json", path: "Resources/commands.json", type: .resource)
    ]
}
