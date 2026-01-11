//
//  WorkspacePanelSystem.swift
//  DataKit
//
//  Complete workspace panel system covering:
//  - CRUD operations (Create, Read, Update, Delete)
//  - Execution (commands, scripts, builds, tests)
//  - Editing (code, text, visual)
//  - Metadata (properties, tags, history)
//  - Navigation (files, symbols, references)
//  - Communication (chat, notifications, collaboration)
//

import Foundation

// MARK: - Panel Categories

/// High-level categories that organize panel functionality
public enum PanelCategory: String, CaseIterable, Codable, Sendable {
    case assistant      // AI, chat, help
    case execution      // Terminal, output, debug
    case inspection     // Properties, preview, diff
    case navigation     // Files, symbols, search
    case diagnostics    // Problems, logs, performance
    case collaboration  // Git, sharing, comments
}

// MARK: - Right Panel (Contextual/Assistive)

/// Right sidebar panels - contextual assistance and inspection
public enum RightPanel: String, CaseIterable, Codable, Sendable, Identifiable {
    // === ASSISTANT ===
    case chat                   // AI chat assistant
    case quickHelp              // Context-sensitive documentation
    case suggestions            // AI suggestions for current context
    
    // === INSPECTION ===
    case inspector              // Selected item properties (CRUD metadata)
    case preview                // Live preview (SwiftUI, Markdown, HTML, images)
    case diff                   // File changes/comparison
    case history                // File/item version history
    
    // === NAVIGATION ===
    case symbols                // Document outline/symbols
    case references             // Find usages/references
    case bookmarks              // Saved locations
    
    // === NOTIFICATIONS ===
    case activity               // Activity feed, notifications
    case tasks                  // Running tasks, background jobs
    
    // === LEARNING ===
    case documentation          // Documentation browser
    case walkthrough            // Step-by-step guides
    case snippets               // Code snippets library
    
    public var id: String { rawValue }
    
    public var category: PanelCategory {
        switch self {
        case .chat, .quickHelp, .suggestions: return .assistant
        case .inspector, .preview, .diff, .history: return .inspection
        case .symbols, .references, .bookmarks: return .navigation
        case .activity, .tasks: return .collaboration
        case .documentation, .walkthrough, .snippets: return .assistant
        }
    }
    
    public var title: String {
        switch self {
        case .chat: return "Chat"
        case .quickHelp: return "Quick Help"
        case .suggestions: return "Suggestions"
        case .inspector: return "Inspector"
        case .preview: return "Preview"
        case .diff: return "Changes"
        case .history: return "History"
        case .symbols: return "Symbols"
        case .references: return "References"
        case .bookmarks: return "Bookmarks"
        case .activity: return "Activity"
        case .tasks: return "Tasks"
        case .documentation: return "Docs"
        case .walkthrough: return "Guide"
        case .snippets: return "Snippets"
        }
    }
    
    public var icon: String {
        switch self {
        case .chat: return "bubble.left.and.bubble.right.fill"
        case .quickHelp: return "questionmark.circle.fill"
        case .suggestions: return "lightbulb.fill"
        case .inspector: return "info.circle.fill"
        case .preview: return "eye.fill"
        case .diff: return "arrow.left.arrow.right"
        case .history: return "clock.arrow.circlepath"
        case .symbols: return "list.bullet.indent"
        case .references: return "link"
        case .bookmarks: return "bookmark.fill"
        case .activity: return "bell.fill"
        case .tasks: return "checklist"
        case .documentation: return "book.fill"
        case .walkthrough: return "list.bullet.clipboard.fill"
        case .snippets: return "doc.on.clipboard.fill"
        }
    }
    
    public var colorCategory: String {
        switch self {
        case .chat, .suggestions: return "chat"
        case .quickHelp, .documentation, .walkthrough: return "documentation"
        case .inspector, .history: return "neutral"
        case .preview: return "projects"
        case .diff: return "agents"
        case .symbols, .references, .bookmarks: return "info"
        case .activity: return "warning"
        case .tasks: return "workflows"
        case .snippets: return "commands"
        }
    }
    
    /// Operations this panel supports
    public var supportedOperations: Set<PanelOperation> {
        switch self {
        case .chat: return [.read, .create, .execute]
        case .quickHelp: return [.read]
        case .suggestions: return [.read, .execute]
        case .inspector: return [.read, .update, .metadata]
        case .preview: return [.read, .refresh]
        case .diff: return [.read, .compare, .revert]
        case .history: return [.read, .compare, .revert]
        case .symbols: return [.read, .navigate]
        case .references: return [.read, .navigate]
        case .bookmarks: return [.read, .create, .delete, .navigate]
        case .activity: return [.read, .dismiss]
        case .tasks: return [.read, .cancel, .retry]
        case .documentation: return [.read, .search, .navigate]
        case .walkthrough: return [.read, .navigate]
        case .snippets: return [.read, .create, .update, .delete, .execute]
        }
    }
    
    /// Minimum height in split mode
    public var minHeight: Double {
        switch self {
        case .chat: return 200
        case .preview: return 200
        case .inspector: return 150
        case .diff, .history: return 180
        default: return 120
        }
    }
    
    /// Natural pairings for split view
    public var naturalPairings: [RightPanel] {
        switch self {
        case .chat: return [.activity, .documentation, .quickHelp, .suggestions]
        case .quickHelp: return [.chat, .inspector]
        case .suggestions: return [.chat]
        case .inspector: return [.preview, .history, .quickHelp]
        case .preview: return [.inspector, .symbols, .documentation]
        case .diff: return [.chat, .history]
        case .history: return [.diff, .inspector]
        case .symbols: return [.preview, .documentation]
        case .references: return [.chat, .inspector]
        case .bookmarks: return [.documentation]
        case .activity: return [.chat, .tasks]
        case .tasks: return [.activity, .chat]
        case .documentation: return [.chat, .preview, .symbols]
        case .walkthrough: return [.chat]
        case .snippets: return [.chat, .documentation]
        }
    }
}

// MARK: - Bottom Panel (Execution/Output)

/// Bottom panel tabs - execution, output, and diagnostics
public enum BottomPanel: String, CaseIterable, Codable, Sendable, Identifiable {
    // === EXECUTION ===
    case terminal               // Interactive shell
    case output                 // Build/run output
    case console                // Application logs
    
    // === DIAGNOSTICS ===
    case problems               // Errors, warnings, hints
    case debug                  // Debugger
    case performance            // Performance metrics
    
    // === SEARCH ===
    case search                 // Global search results
    case findReplace            // Find and replace
    
    // === VERSION CONTROL ===
    case git                    // Git operations
    case commits                // Commit history
    case stash                  // Stashed changes
    
    // === TESTING ===
    case tests                  // Test runner
    case coverage               // Code coverage
    
    // === DATA ===
    case database               // Database browser/queries
    case network                // Network requests
    
    public var id: String { rawValue }
    
    public var category: PanelCategory {
        switch self {
        case .terminal, .output, .console: return .execution
        case .problems, .debug, .performance: return .diagnostics
        case .search, .findReplace: return .navigation
        case .git, .commits, .stash: return .collaboration
        case .tests, .coverage: return .diagnostics
        case .database, .network: return .inspection
        }
    }
    
    public var title: String {
        switch self {
        case .terminal: return "Terminal"
        case .output: return "Output"
        case .console: return "Console"
        case .problems: return "Problems"
        case .debug: return "Debug"
        case .performance: return "Performance"
        case .search: return "Search"
        case .findReplace: return "Find & Replace"
        case .git: return "Source Control"
        case .commits: return "Commits"
        case .stash: return "Stash"
        case .tests: return "Tests"
        case .coverage: return "Coverage"
        case .database: return "Database"
        case .network: return "Network"
        }
    }
    
    public var icon: String {
        switch self {
        case .terminal: return "terminal.fill"
        case .output: return "doc.text.fill"
        case .console: return "text.alignleft"
        case .problems: return "exclamationmark.triangle.fill"
        case .debug: return "ant.fill"
        case .performance: return "gauge.with.dots.needle.bottom.50percent"
        case .search: return "magnifyingglass"
        case .findReplace: return "arrow.left.arrow.right.square"
        case .git: return "arrow.triangle.branch"
        case .commits: return "clock.arrow.circlepath"
        case .stash: return "tray.full.fill"
        case .tests: return "checkmark.seal.fill"
        case .coverage: return "chart.bar.fill"
        case .database: return "cylinder.fill"
        case .network: return "network"
        }
    }
    
    public var colorCategory: String {
        switch self {
        case .terminal: return "commands"
        case .output: return "info"
        case .console: return "neutral"
        case .problems: return "warning"
        case .debug: return "error"
        case .performance: return "info"
        case .search, .findReplace: return "search"
        case .git, .commits, .stash: return "agents"
        case .tests: return "success"
        case .coverage: return "info"
        case .database: return "projects"
        case .network: return "workflows"
        }
    }
    
    /// Operations this panel supports
    public var supportedOperations: Set<PanelOperation> {
        switch self {
        case .terminal: return [.read, .create, .execute, .clear]
        case .output: return [.read, .clear, .copy, .save]
        case .console: return [.read, .clear, .filter, .copy]
        case .problems: return [.read, .navigate, .filter, .fix]
        case .debug: return [.read, .execute, .step, .inspect]
        case .performance: return [.read, .record, .analyze]
        case .search: return [.read, .navigate, .filter, .replace]
        case .findReplace: return [.read, .search, .replace, .replaceAll]
        case .git: return [.read, .stage, .commit, .push, .pull, .revert]
        case .commits: return [.read, .navigate, .compare, .revert, .cherryPick]
        case .stash: return [.read, .create, .apply, .delete]
        case .tests: return [.read, .execute, .filter, .navigate]
        case .coverage: return [.read, .navigate, .analyze]
        case .database: return [.read, .create, .update, .delete, .execute]
        case .network: return [.read, .filter, .copy, .replay]
        }
    }
    
    /// Badge source for this panel
    public var badgeSource: PanelBadgeSource {
        switch self {
        case .problems: return .count(.errors)
        case .tests: return .count(.failedTests)
        case .git: return .count(.uncommittedChanges)
        case .search: return .count(.searchResults)
        case .network: return .count(.pendingRequests)
        case .console: return .count(.unreadLogs)
        default: return .none
        }
    }
    
    /// Whether this panel supports input
    public var hasInput: Bool {
        switch self {
        case .terminal, .console, .debug, .search, .findReplace, .database:
            return true
        default:
            return false
        }
    }
}

// MARK: - Panel Operations

/// Operations that panels can perform
public enum PanelOperation: String, Codable, Sendable {
    // CRUD
    case create
    case read
    case update
    case delete
    
    // Navigation
    case navigate
    case search
    case filter
    
    // Execution
    case execute
    case cancel
    case retry
    case step
    
    // Editing
    case copy
    case paste
    case replace
    case replaceAll
    case clear
    case save
    
    // Inspection
    case inspect
    case compare
    case analyze
    case metadata
    case refresh
    
    // Version Control
    case stage
    case commit
    case push
    case pull
    case revert
    case cherryPick
    case apply
    
    // Diagnostics
    case fix
    case dismiss
    case record
    case replay
}

// MARK: - Panel Badge Source

/// What drives badge counts on panels
public enum PanelBadgeSource: Codable, Sendable, Equatable {
    case none
    case count(BadgeCountType)
    case status(BadgeStatusType)
    
    public enum BadgeCountType: String, Codable, Sendable {
        case errors
        case warnings
        case hints
        case failedTests
        case passedTests
        case uncommittedChanges
        case searchResults
        case pendingRequests
        case unreadLogs
        case unreadNotifications
        case runningTasks
    }
    
    public enum BadgeStatusType: String, Codable, Sendable {
        case running
        case success
        case failure
        case warning
    }
}

// MARK: - Panel State

/// Complete state of the workspace panel system
public struct WorkspacePanelState: Codable, Sendable, Equatable {
    // Right Panel
    public var rightPanelMode: RightPanelDisplayMode
    public var rightPanelWidth: Double
    public var rightSplitRatio: Double
    
    // Bottom Panel
    public var bottomPanelVisible: Bool
    public var bottomPanelHeight: Double
    public var bottomPanelTab: BottomPanel
    public var bottomPanelMaximized: Bool
    
    // Panel Badges
    public var badges: [String: Int]
    
    // User Preferences
    public var pinnedRightPanels: [RightPanel]
    public var pinnedBottomPanels: [BottomPanel]
    public var recentRightPanels: [RightPanel]
    public var recentBottomPanels: [BottomPanel]
    
    public init(
        rightPanelMode: RightPanelDisplayMode = .hidden,
        rightPanelWidth: Double = 380,
        rightSplitRatio: Double = 0.5,
        bottomPanelVisible: Bool = false,
        bottomPanelHeight: Double = 200,
        bottomPanelTab: BottomPanel = .terminal,
        bottomPanelMaximized: Bool = false,
        badges: [String: Int] = [:],
        pinnedRightPanels: [RightPanel] = [],
        pinnedBottomPanels: [BottomPanel] = [.terminal, .problems],
        recentRightPanels: [RightPanel] = [],
        recentBottomPanels: [BottomPanel] = []
    ) {
        self.rightPanelMode = rightPanelMode
        self.rightPanelWidth = rightPanelWidth
        self.rightSplitRatio = rightSplitRatio
        self.bottomPanelVisible = bottomPanelVisible
        self.bottomPanelHeight = bottomPanelHeight
        self.bottomPanelTab = bottomPanelTab
        self.bottomPanelMaximized = bottomPanelMaximized
        self.badges = badges
        self.pinnedRightPanels = pinnedRightPanels
        self.pinnedBottomPanels = pinnedBottomPanels
        self.recentRightPanels = recentRightPanels
        self.recentBottomPanels = recentBottomPanels
    }
}

/// Right panel display modes
public enum RightPanelDisplayMode: Codable, Sendable, Equatable {
    case hidden
    case single(RightPanel)
    case split(top: RightPanel, bottom: RightPanel)
    case fullChat  // Chat with integrated input
    
    public var isVisible: Bool {
        if case .hidden = self { return false }
        return true
    }
    
    public var panels: [RightPanel] {
        switch self {
        case .hidden: return []
        case .single(let p): return [p]
        case .split(let t, let b): return [t, b]
        case .fullChat: return [.chat]
        }
    }
}

// MARK: - Context-Aware Panel Triggers

/// Events that can trigger panel changes
public enum PanelTriggerEvent: String, Codable, Sendable {
    // File Events
    case fileOpened
    case fileSaved
    case fileDeleted
    case fileRenamed
    case fileModified
    
    // Build Events
    case buildStarted
    case buildSucceeded
    case buildFailed
    
    // Test Events
    case testsStarted
    case testsPassed
    case testsFailed
    
    // Debug Events
    case debugStarted
    case breakpointHit
    case debugStopped
    
    // Git Events
    case gitStatusChanged
    case gitConflict
    case gitPushCompleted
    
    // Search Events
    case searchStarted
    case searchCompleted
    
    // Error Events
    case errorDetected
    case warningDetected
    
    // User Events
    case helpRequested
    case commandExecuted
    case selectionChanged
}

/// Automatic panel response to events
public struct PanelTriggerRule: Codable, Sendable, Identifiable {
    public let id: String
    public let event: PanelTriggerEvent
    public let rightPanelAction: RightPanelAction?
    public let bottomPanelAction: BottomPanelAction?
    public let condition: TriggerCondition?
    public var enabled: Bool
    
    public init(
        id: String = UUID().uuidString,
        event: PanelTriggerEvent,
        rightPanelAction: RightPanelAction? = nil,
        bottomPanelAction: BottomPanelAction? = nil,
        condition: TriggerCondition? = nil,
        enabled: Bool = true
    ) {
        self.id = id
        self.event = event
        self.rightPanelAction = rightPanelAction
        self.bottomPanelAction = bottomPanelAction
        self.condition = condition
        self.enabled = enabled
    }
}

public enum RightPanelAction: Codable, Sendable {
    case show(RightPanel)
    case showSplit(top: RightPanel, bottom: RightPanel)
    case hide
    case toggle(RightPanel)
}

public enum BottomPanelAction: Codable, Sendable {
    case show(BottomPanel)
    case hide
    case toggle(BottomPanel)
    case maximize
    case restore
}

public enum TriggerCondition: Codable, Sendable {
    case fileType(String)           // Only for specific file types
    case hasErrors                  // Only if errors exist
    case hasWarnings                // Only if warnings exist
    case panelNotVisible(String)    // Only if panel not already visible
    case userPreference(String)     // Based on user setting
}

// MARK: - Default Trigger Rules

public extension PanelTriggerRule {
    static var defaults: [PanelTriggerRule] {
        [
            // Build failed -> show problems
            PanelTriggerRule(
                event: .buildFailed,
                bottomPanelAction: .show(.problems)
            ),
            // Tests failed -> show tests
            PanelTriggerRule(
                event: .testsFailed,
                bottomPanelAction: .show(.tests)
            ),
            // Breakpoint hit -> show debug
            PanelTriggerRule(
                event: .breakpointHit,
                rightPanelAction: .show(.inspector),
                bottomPanelAction: .show(.debug)
            ),
            // Search completed -> show search
            PanelTriggerRule(
                event: .searchCompleted,
                bottomPanelAction: .show(.search)
            ),
            // Git conflict -> show git
            PanelTriggerRule(
                event: .gitConflict,
                rightPanelAction: .show(.diff),
                bottomPanelAction: .show(.git)
            ),
            // Help requested -> show chat
            PanelTriggerRule(
                event: .helpRequested,
                rightPanelAction: .show(.chat)
            ),
            // Error detected -> show problems (if not visible)
            PanelTriggerRule(
                event: .errorDetected,
                bottomPanelAction: .show(.problems),
                condition: .panelNotVisible("problems")
            )
        ]
    }
}

// MARK: - Workspace Presets

/// Predefined workspace configurations
public enum WorkspacePreset: String, CaseIterable, Codable, Sendable {
    case coding
    case debugging
    case testing
    case reviewing
    case learning
    case focused
    case presenting
    
    public var title: String {
        switch self {
        case .coding: return "Coding"
        case .debugging: return "Debugging"
        case .testing: return "Testing"
        case .reviewing: return "Code Review"
        case .learning: return "Learning"
        case .focused: return "Focused"
        case .presenting: return "Presenting"
        }
    }
    
    public var icon: String {
        switch self {
        case .coding: return "chevron.left.forwardslash.chevron.right"
        case .debugging: return "ant.fill"
        case .testing: return "checkmark.seal.fill"
        case .reviewing: return "arrow.left.arrow.right"
        case .learning: return "book.fill"
        case .focused: return "rectangle.center.inset.filled"
        case .presenting: return "play.rectangle.fill"
        }
    }
    
    public var state: WorkspacePanelState {
        switch self {
        case .coding:
            return WorkspacePanelState(
                rightPanelMode: .hidden,
                bottomPanelVisible: true,
                bottomPanelHeight: 200,
                bottomPanelTab: .terminal
            )
        case .debugging:
            return WorkspacePanelState(
                rightPanelMode: .split(top: .inspector, bottom: .chat),
                bottomPanelVisible: true,
                bottomPanelHeight: 250,
                bottomPanelTab: .debug
            )
        case .testing:
            return WorkspacePanelState(
                rightPanelMode: .single(.inspector),
                bottomPanelVisible: true,
                bottomPanelHeight: 300,
                bottomPanelTab: .tests
            )
        case .reviewing:
            return WorkspacePanelState(
                rightPanelMode: .split(top: .diff, bottom: .chat),
                bottomPanelVisible: true,
                bottomPanelTab: .git
            )
        case .learning:
            return WorkspacePanelState(
                rightPanelMode: .split(top: .documentation, bottom: .chat),
                bottomPanelVisible: false
            )
        case .focused:
            return WorkspacePanelState(
                rightPanelMode: .hidden,
                bottomPanelVisible: false
            )
        case .presenting:
            return WorkspacePanelState(
                rightPanelMode: .single(.preview),
                rightPanelWidth: 500,
                bottomPanelVisible: false
            )
        }
    }
}
