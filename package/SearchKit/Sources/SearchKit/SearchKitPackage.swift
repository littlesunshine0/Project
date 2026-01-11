//
//  SearchKitPackage.swift
//  SearchKit
//
//  Package definition with comprehensive search commands, actions, workflows
//

import SwiftUI
import DataKit

public struct SearchKitPackage: @unchecked Sendable {
    public static let shared = SearchKitPackage()
    
    public let info: PackageInfo
    
    private init() {
        info = PackageInfo(
            identifier: "com.flowkit.searchkit",
            name: "SearchKit",
            version: "1.0.0",
            description: "Full-text search, indexing, filters, and semantic search",
            icon: "magnifyingglass",
            color: "indigo",
            files: Self.indexedFiles,
            dependencies: ["DataKit", "CoreKit"],
            exports: ["SearchResult", "SearchManager", "SearchEngine"],
            commandCount: Self.commands.count,
            actionCount: Self.actions.count,
            workflowCount: Self.workflows.count,
            agentCount: Self.agents.count,
            viewCount: 5,
            modelCount: 4,
            serviceCount: 3
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
    
    // MARK: - Commands (20+)
    
    public static let commands: [KitCommand] = [
        KitCommand(id: "search.find", name: "Find", description: "Search for content", syntax: "/find <query>", kit: "SearchKit", handler: "find"),
        KitCommand(id: "search.files", name: "Search Files", description: "Search in files", syntax: "/search files <query>", kit: "SearchKit", handler: "searchFiles"),
        KitCommand(id: "search.code", name: "Search Code", description: "Search in code", syntax: "/search code <query>", kit: "SearchKit", handler: "searchCode"),
        KitCommand(id: "search.symbols", name: "Search Symbols", description: "Search symbols", syntax: "/search symbols <query>", kit: "SearchKit", handler: "searchSymbols"),
        KitCommand(id: "search.docs", name: "Search Docs", description: "Search documentation", syntax: "/search docs <query>", kit: "SearchKit", handler: "searchDocs"),
        KitCommand(id: "search.commands", name: "Search Commands", description: "Search commands", syntax: "/search commands <query>", kit: "SearchKit", handler: "searchCommands"),
        KitCommand(id: "search.workflows", name: "Search Workflows", description: "Search workflows", syntax: "/search workflows <query>", kit: "SearchKit", handler: "searchWorkflows"),
        KitCommand(id: "search.replace", name: "Find and Replace", description: "Find and replace", syntax: "/replace <find> <replace>", kit: "SearchKit", handler: "replace"),
        KitCommand(id: "search.regex", name: "Regex Search", description: "Search with regex", syntax: "/search regex <pattern>", kit: "SearchKit", handler: "regexSearch"),
        KitCommand(id: "search.semantic", name: "Semantic Search", description: "AI-powered search", syntax: "/search semantic <query>", kit: "SearchKit", handler: "semanticSearch"),
        KitCommand(id: "search.recent", name: "Recent Searches", description: "Show recent searches", syntax: "/search recent", kit: "SearchKit", handler: "recentSearches"),
        KitCommand(id: "search.saved", name: "Saved Searches", description: "Show saved searches", syntax: "/search saved", kit: "SearchKit", handler: "savedSearches"),
        KitCommand(id: "search.save", name: "Save Search", description: "Save current search", syntax: "/search save <name>", kit: "SearchKit", handler: "saveSearch"),
        KitCommand(id: "search.filter", name: "Filter Results", description: "Filter search results", syntax: "/search filter <type>", kit: "SearchKit", handler: "filter"),
        KitCommand(id: "search.scope", name: "Set Scope", description: "Set search scope", syntax: "/search scope <path>", kit: "SearchKit", handler: "setScope"),
        KitCommand(id: "search.index", name: "Rebuild Index", description: "Rebuild search index", syntax: "/search index rebuild", kit: "SearchKit", handler: "rebuildIndex"),
        KitCommand(id: "search.stats", name: "Search Stats", description: "Show search statistics", syntax: "/search stats", kit: "SearchKit", handler: "stats"),
        KitCommand(id: "search.clear", name: "Clear History", description: "Clear search history", syntax: "/search clear", kit: "SearchKit", handler: "clearHistory"),
        KitCommand(id: "search.next", name: "Next Result", description: "Go to next result", syntax: "/search next", kit: "SearchKit", handler: "nextResult"),
        KitCommand(id: "search.prev", name: "Previous Result", description: "Go to previous result", syntax: "/search prev", kit: "SearchKit", handler: "prevResult")
    ]
    
    // MARK: - Actions (12+)
    
    public static let actions: [KitAction] = [
        KitAction(id: "action.search.find", name: "Find", description: "Open search", icon: "magnifyingglass", kit: "SearchKit", handler: "find"),
        KitAction(id: "action.search.replace", name: "Replace", description: "Find and replace", icon: "arrow.left.arrow.right", kit: "SearchKit", handler: "replace"),
        KitAction(id: "action.search.next", name: "Next", description: "Next result", icon: "chevron.down", kit: "SearchKit", handler: "next"),
        KitAction(id: "action.search.prev", name: "Previous", description: "Previous result", icon: "chevron.up", kit: "SearchKit", handler: "prev"),
        KitAction(id: "action.search.all", name: "Find All", description: "Find all occurrences", icon: "list.bullet", kit: "SearchKit", handler: "findAll"),
        KitAction(id: "action.search.filter", name: "Filter", description: "Filter results", icon: "line.3.horizontal.decrease.circle", kit: "SearchKit", handler: "filter"),
        KitAction(id: "action.search.save", name: "Save Search", description: "Save search", icon: "bookmark", kit: "SearchKit", handler: "save"),
        KitAction(id: "action.search.clear", name: "Clear", description: "Clear search", icon: "xmark.circle", kit: "SearchKit", handler: "clear"),
        KitAction(id: "action.search.scope", name: "Set Scope", description: "Set search scope", icon: "folder", kit: "SearchKit", handler: "setScope"),
        KitAction(id: "action.search.regex", name: "Regex", description: "Toggle regex", icon: "asterisk", kit: "SearchKit", handler: "toggleRegex"),
        KitAction(id: "action.search.case", name: "Case Sensitive", description: "Toggle case", icon: "textformat", kit: "SearchKit", handler: "toggleCase"),
        KitAction(id: "action.search.word", name: "Whole Word", description: "Toggle whole word", icon: "textformat.abc", kit: "SearchKit", handler: "toggleWord")
    ]
    
    // MARK: - Shortcuts
    
    public static let shortcuts: [KitShortcut] = [
        KitShortcut(key: "F", modifiers: [.command], action: "action.search.find", description: "Find", kit: "SearchKit"),
        KitShortcut(key: "H", modifiers: [.command, .option], action: "action.search.replace", description: "Replace", kit: "SearchKit"),
        KitShortcut(key: "G", modifiers: [.command], action: "action.search.next", description: "Next result", kit: "SearchKit"),
        KitShortcut(key: "G", modifiers: [.command, .shift], action: "action.search.prev", description: "Previous result", kit: "SearchKit"),
        KitShortcut(key: "F", modifiers: [.command, .shift], action: "search.files", description: "Search files", kit: "SearchKit"),
        KitShortcut(key: "O", modifiers: [.command, .shift], action: "search.symbols", description: "Search symbols", kit: "SearchKit"),
        KitShortcut(key: "Escape", modifiers: [], action: "action.search.clear", description: "Clear search", kit: "SearchKit")
    ]
    
    // MARK: - Menu Items
    
    public static let menuItems: [KitMenuItem] = [
        KitMenuItem(title: "Find", icon: "magnifyingglass", action: "find", shortcut: "⌘F", kit: "SearchKit"),
        KitMenuItem(title: "Find and Replace", icon: "arrow.left.arrow.right", action: "replace", shortcut: "⌥⌘H", kit: "SearchKit"),
        KitMenuItem(title: "Find in Files", icon: "doc.text.magnifyingglass", action: "findInFiles", shortcut: "⇧⌘F", kit: "SearchKit"),
        KitMenuItem(title: "Go to Symbol", icon: "number", action: "goToSymbol", shortcut: "⇧⌘O", kit: "SearchKit"),
        KitMenuItem(title: "Recent Searches", icon: "clock", action: "recentSearches", kit: "SearchKit"),
        KitMenuItem(title: "Saved Searches", icon: "bookmark", action: "savedSearches", kit: "SearchKit")
    ]
    
    // MARK: - Context Menus
    
    public static let contextMenus: [KitContextMenu] = [
        KitContextMenu(targetType: "SearchResult", items: [
            KitMenuItem(title: "Open", icon: "doc", action: "open", kit: "SearchKit"),
            KitMenuItem(title: "Open in New Tab", icon: "plus.rectangle", action: "openNewTab", kit: "SearchKit"),
            KitMenuItem(title: "Copy Path", icon: "doc.on.doc", action: "copyPath", kit: "SearchKit"),
            KitMenuItem(title: "Reveal in Finder", icon: "folder", action: "reveal", kit: "SearchKit")
        ], kit: "SearchKit")
    ]
    
    // MARK: - Workflows (6+)
    
    public static let workflows: [KitWorkflow] = [
        KitWorkflow(name: "Quick Search", description: "Quick content search", steps: ["Open search (⌘F)", "Enter query", "Navigate results"], kit: "SearchKit"),
        KitWorkflow(name: "Find and Replace All", description: "Replace across files", steps: ["Open replace (⌥⌘H)", "Enter find/replace", "Preview changes", "Replace all"], kit: "SearchKit"),
        KitWorkflow(name: "Symbol Navigation", description: "Navigate to symbol", steps: ["Open symbols (⇧⌘O)", "Type symbol name", "Select symbol", "Jump to definition"], kit: "SearchKit"),
        KitWorkflow(name: "Regex Search", description: "Search with regex", steps: ["Open search", "Enable regex", "Enter pattern", "Review matches"], kit: "SearchKit"),
        KitWorkflow(name: "Scoped Search", description: "Search in specific folder", steps: ["Set scope", "Enter query", "Filter results", "Navigate"], kit: "SearchKit"),
        KitWorkflow(name: "Save Search Query", description: "Save search for reuse", steps: ["Perform search", "Save search", "Name query", "Access from saved"], kit: "SearchKit")
    ]
    
    // MARK: - Agents (4+)
    
    public static let agents: [KitAgent] = [
        KitAgent(name: "Index Manager", description: "Maintains search index", triggers: ["file.change", "file.create", "file.delete"], actions: ["update.index", "optimize.index", "cleanup.stale"], kit: "SearchKit"),
        KitAgent(name: "Search Suggester", description: "Suggests search queries", triggers: ["search.start", "user.typing"], actions: ["analyze.history", "suggest.queries", "rank.suggestions"], kit: "SearchKit"),
        KitAgent(name: "Result Ranker", description: "Ranks search results", triggers: ["search.complete"], actions: ["analyze.results", "apply.ranking", "personalize.order"], kit: "SearchKit"),
        KitAgent(name: "Semantic Analyzer", description: "Provides semantic search", triggers: ["semantic.search", "natural.query"], actions: ["parse.query", "expand.terms", "match.semantically"], kit: "SearchKit")
    ]
    
    // MARK: - File Index
    
    private static let indexedFiles: [FileInfo] = [
        FileInfo(name: "SearchResult.swift", path: "Models/SearchResult.swift", type: .model),
        FileInfo(name: "SearchQuery.swift", path: "Models/SearchQuery.swift", type: .model),
        FileInfo(name: "SearchSection.swift", path: "Models/SearchSection.swift", type: .model),
        FileInfo(name: "SearchError.swift", path: "Models/SearchError.swift", type: .model),
        FileInfo(name: "SearchManager.swift", path: "Services/SearchManager.swift", type: .service),
        FileInfo(name: "SearchEngine.swift", path: "Services/SearchEngine.swift", type: .service),
        FileInfo(name: "SearchBrowser.swift", path: "Views/SearchBrowser.swift", type: .view),
        FileInfo(name: "SearchResultsList.swift", path: "Views/SearchResultsList.swift", type: .view),
        FileInfo(name: "SearchCard.swift", path: "Views/SearchCard.swift", type: .view),
        FileInfo(name: "SearchViewModel.swift", path: "ViewModels/SearchViewModel.swift", type: .viewModel)
    ]
}
