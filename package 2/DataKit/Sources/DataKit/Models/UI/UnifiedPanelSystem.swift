//
//  UnifiedPanelSystem.swift
//  DataKit
//
//  Unified panel system for right sidebar and bottom panel
//  Designed as a cohesive unit that adapts to user behavior
//

import Foundation

// MARK: - Right Sidebar Panel Types

/// All possible content types for the right sidebar
public enum RightPanelType: String, CaseIterable, Codable, Sendable, Identifiable {
    // AI & Communication
    case chat               // AI Assistant chat
    case notifications      // Activity feed, alerts
    
    // Context & Help
    case documentation      // Docs browser
    case quickHelp          // Context-sensitive help
    case walkthrough        // Step-by-step guides
    
    // Inspection & Preview
    case inspector          // Selected item properties
    case preview            // Live preview (SwiftUI, Markdown, etc.)
    case diff               // File diff view
    
    // Actions & Tools
    case quickActions       // Contextual actions
    case snippets           // Code snippets library
    case symbols            // Symbol outline
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .chat: return "Chat"
        case .notifications: return "Activity"
        case .documentation: return "Docs"
        case .quickHelp: return "Quick Help"
        case .walkthrough: return "Guide"
        case .inspector: return "Inspector"
        case .preview: return "Preview"
        case .diff: return "Changes"
        case .quickActions: return "Actions"
        case .snippets: return "Snippets"
        case .symbols: return "Symbols"
        }
    }
    
    public var icon: String {
        switch self {
        case .chat: return "bubble.left.and.bubble.right.fill"
        case .notifications: return "bell.fill"
        case .documentation: return "book.fill"
        case .quickHelp: return "questionmark.circle.fill"
        case .walkthrough: return "list.bullet.clipboard.fill"
        case .inspector: return "sidebar.right"
        case .preview: return "eye.fill"
        case .diff: return "arrow.left.arrow.right"
        case .quickActions: return "bolt.fill"
        case .snippets: return "doc.on.clipboard.fill"
        case .symbols: return "list.bullet.indent"
        }
    }
    
    public var colorCategory: String {
        switch self {
        case .chat: return "chat"
        case .notifications: return "warning"
        case .documentation: return "documentation"
        case .quickHelp: return "info"
        case .walkthrough: return "info"
        case .inspector: return "neutral"
        case .preview: return "projects"
        case .diff: return "agents"
        case .quickActions: return "commands"
        case .snippets: return "commands"
        case .symbols: return "neutral"
        }
    }
    
    /// Minimum height when in split mode
    public var minHeight: Double {
        switch self {
        case .chat: return 200
        case .notifications: return 120
        case .documentation: return 150
        case .quickHelp: return 100
        case .walkthrough: return 180
        case .inspector: return 150
        case .preview: return 200
        case .diff: return 150
        case .quickActions: return 100
        case .snippets: return 120
        case .symbols: return 100
        }
    }
    
    /// Whether this panel can be shown in split mode
    public var supportsSplit: Bool {
        switch self {
        case .preview, .diff:
            return true  // These work well taking full height
        default:
            return true
        }
    }
    
    /// Natural pairings for split view
    public var naturalPairings: [RightPanelType] {
        switch self {
        case .chat:
            return [.notifications, .documentation, .quickHelp, .walkthrough]
        case .notifications:
            return [.chat]
        case .documentation:
            return [.chat, .preview, .symbols]
        case .quickHelp:
            return [.chat, .inspector]
        case .walkthrough:
            return [.chat]
        case .inspector:
            return [.preview, .quickHelp]
        case .preview:
            return [.inspector, .documentation, .symbols]
        case .diff:
            return [.chat]
        case .quickActions:
            return [.chat, .inspector]
        case .snippets:
            return [.chat, .documentation]
        case .symbols:
            return [.preview, .documentation]
        }
    }
}

// MARK: - Bottom Panel Types

/// All possible content types for the bottom panel
public enum BottomPanelType: String, CaseIterable, Codable, Sendable, Identifiable {
    // Execution
    case terminal           // Interactive terminal
    case output             // Build/run output
    case console            // App console logs
    
    // Diagnostics
    case problems           // Errors, warnings, hints
    case debug              // Debugger
    
    // Search & Navigation
    case searchResults      // Global search results
    case references         // Find references results
    
    // Version Control
    case git                // Git status, staging
    case commits            // Commit history
    
    // Testing
    case tests              // Test runner
    case coverage           // Code coverage
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .terminal: return "Terminal"
        case .output: return "Output"
        case .console: return "Console"
        case .problems: return "Problems"
        case .debug: return "Debug"
        case .searchResults: return "Search"
        case .references: return "References"
        case .git: return "Git"
        case .commits: return "Commits"
        case .tests: return "Tests"
        case .coverage: return "Coverage"
        }
    }
    
    public var icon: String {
        switch self {
        case .terminal: return "terminal.fill"
        case .output: return "doc.text.fill"
        case .console: return "text.alignleft"
        case .problems: return "exclamationmark.triangle.fill"
        case .debug: return "ant.fill"
        case .searchResults: return "magnifyingglass"
        case .references: return "link"
        case .git: return "arrow.triangle.branch"
        case .commits: return "clock.arrow.circlepath"
        case .tests: return "checkmark.seal.fill"
        case .coverage: return "chart.bar.fill"
        }
    }
    
    public var colorCategory: String {
        switch self {
        case .terminal: return "commands"
        case .output: return "info"
        case .console: return "neutral"
        case .problems: return "warning"
        case .debug: return "error"
        case .searchResults: return "search"
        case .references: return "info"
        case .git: return "agents"
        case .commits: return "agents"
        case .tests: return "success"
        case .coverage: return "info"
        }
    }
    
    /// Badge count source (what triggers badge updates)
    public var badgeSource: BadgeSource {
        switch self {
        case .problems: return .errorCount
        case .tests: return .failedTests
        case .git: return .uncommittedChanges
        case .searchResults: return .resultCount
        case .references: return .resultCount
        default: return .none
        }
    }
}

public enum BadgeSource: String, Codable, Sendable {
    case none
    case errorCount
    case warningCount
    case failedTests
    case uncommittedChanges
    case resultCount
    case unreadCount
}

// MARK: - Panel Layout State

/// Current state of the unified panel system
public struct UnifiedPanelState: Codable, Sendable {
    // Right sidebar
    public var rightPanelMode: RightPanelMode
    public var rightPanelWidth: Double
    public var rightSplitRatio: Double
    
    // Bottom panel
    public var bottomPanelVisible: Bool
    public var bottomPanelHeight: Double
    public var bottomPanelTab: BottomPanelType
    public var bottomPanelPinned: Bool
    
    // Coordination
    public var linkedPanels: Bool  // When true, certain actions sync between panels
    
    public init(
        rightPanelMode: RightPanelMode = .hidden,
        rightPanelWidth: Double = 380,
        rightSplitRatio: Double = 0.5,
        bottomPanelVisible: Bool = false,
        bottomPanelHeight: Double = 200,
        bottomPanelTab: BottomPanelType = .terminal,
        bottomPanelPinned: Bool = false,
        linkedPanels: Bool = true
    ) {
        self.rightPanelMode = rightPanelMode
        self.rightPanelWidth = rightPanelWidth
        self.rightSplitRatio = rightSplitRatio
        self.bottomPanelVisible = bottomPanelVisible
        self.bottomPanelHeight = bottomPanelHeight
        self.bottomPanelTab = bottomPanelTab
        self.bottomPanelPinned = bottomPanelPinned
        self.linkedPanels = linkedPanels
    }
}

/// Right panel display mode
public enum RightPanelMode: Codable, Sendable, Equatable {
    case hidden
    case single(RightPanelType)
    case split(top: RightPanelType, bottom: RightPanelType)
    case fullChat  // Special mode: chat + integrated input
    
    public var isVisible: Bool {
        if case .hidden = self { return false }
        return true
    }
    
    public var visiblePanels: [RightPanelType] {
        switch self {
        case .hidden: return []
        case .single(let type): return [type]
        case .split(let top, let bottom): return [top, bottom]
        case .fullChat: return [.chat]
        }
    }
}

// MARK: - Context-Aware Panel Suggestions

/// Suggests panel configurations based on context
public struct PanelContextSuggestion: Codable, Sendable, Identifiable {
    public let id: String
    public let trigger: SuggestionTrigger
    public let rightPanel: RightPanelMode?
    public let bottomPanel: BottomPanelType?
    public let reason: String
    
    public init(
        id: String = UUID().uuidString,
        trigger: SuggestionTrigger,
        rightPanel: RightPanelMode? = nil,
        bottomPanel: BottomPanelType? = nil,
        reason: String
    ) {
        self.id = id
        self.trigger = trigger
        self.rightPanel = rightPanel
        self.bottomPanel = bottomPanel
        self.reason = reason
    }
}

public enum SuggestionTrigger: String, Codable, Sendable {
    case fileOpened         // User opened a file
    case buildStarted       // Build process started
    case buildFailed        // Build failed with errors
    case testStarted        // Tests running
    case testFailed         // Tests failed
    case gitChanged         // Git status changed
    case searchPerformed    // User searched
    case errorClicked       // User clicked an error
    case helpRequested      // User asked for help
    case workflowStarted    // Workflow execution started
}

// MARK: - Panel Presets

/// Predefined panel configurations for common workflows
public enum PanelPreset: String, CaseIterable, Codable, Sendable {
    case coding             // Terminal + Problems, Chat available
    case debugging          // Debug + Console, Inspector
    case reviewing          // Diff + Git, Chat
    case learning           // Docs + Walkthrough, Chat
    case testing            // Tests + Coverage, Problems
    case focused            // Minimal - just editor
    
    public var title: String {
        switch self {
        case .coding: return "Coding"
        case .debugging: return "Debugging"
        case .reviewing: return "Code Review"
        case .learning: return "Learning"
        case .testing: return "Testing"
        case .focused: return "Focused"
        }
    }
    
    public var icon: String {
        switch self {
        case .coding: return "chevron.left.forwardslash.chevron.right"
        case .debugging: return "ant.fill"
        case .reviewing: return "arrow.left.arrow.right"
        case .learning: return "book.fill"
        case .testing: return "checkmark.seal.fill"
        case .focused: return "rectangle.center.inset.filled"
        }
    }
    
    public var state: UnifiedPanelState {
        switch self {
        case .coding:
            return UnifiedPanelState(
                rightPanelMode: .hidden,
                bottomPanelVisible: true,
                bottomPanelTab: .terminal
            )
        case .debugging:
            return UnifiedPanelState(
                rightPanelMode: .single(.inspector),
                bottomPanelVisible: true,
                bottomPanelHeight: 250,
                bottomPanelTab: .debug
            )
        case .reviewing:
            return UnifiedPanelState(
                rightPanelMode: .split(top: .diff, bottom: .chat),
                bottomPanelVisible: true,
                bottomPanelTab: .git
            )
        case .learning:
            return UnifiedPanelState(
                rightPanelMode: .split(top: .documentation, bottom: .chat),
                bottomPanelVisible: false
            )
        case .testing:
            return UnifiedPanelState(
                rightPanelMode: .hidden,
                bottomPanelVisible: true,
                bottomPanelHeight: 300,
                bottomPanelTab: .tests
            )
        case .focused:
            return UnifiedPanelState(
                rightPanelMode: .hidden,
                bottomPanelVisible: false
            )
        }
    }
}

// MARK: - Panel Coordination Rules

/// Rules for how panels coordinate with each other
public struct PanelCoordinationRule: Codable, Sendable, Identifiable {
    public let id: String
    public let trigger: CoordinationTrigger
    public let action: CoordinationAction
    public let enabled: Bool
    
    public init(
        id: String = UUID().uuidString,
        trigger: CoordinationTrigger,
        action: CoordinationAction,
        enabled: Bool = true
    ) {
        self.id = id
        self.trigger = trigger
        self.action = action
        self.enabled = enabled
    }
}

public enum CoordinationTrigger: String, Codable, Sendable {
    case problemsDetected       // Build found errors
    case searchCompleted        // Search finished
    case previewFileOpened      // Previewable file opened
    case chatMentionedCode      // Chat referenced code
    case debugBreakpointHit     // Debugger stopped
    case testCompleted          // Test run finished
}

public enum CoordinationAction: String, Codable, Sendable {
    case showProblemsPanel
    case showSearchResults
    case showPreview
    case highlightCode
    case showDebugPanel
    case showTestResults
    case showInspector
}

// MARK: - Default Coordination Rules

public extension PanelCoordinationRule {
    static var defaults: [PanelCoordinationRule] {
        [
            PanelCoordinationRule(
                trigger: .problemsDetected,
                action: .showProblemsPanel
            ),
            PanelCoordinationRule(
                trigger: .searchCompleted,
                action: .showSearchResults
            ),
            PanelCoordinationRule(
                trigger: .previewFileOpened,
                action: .showPreview
            ),
            PanelCoordinationRule(
                trigger: .debugBreakpointHit,
                action: .showDebugPanel
            ),
            PanelCoordinationRule(
                trigger: .testCompleted,
                action: .showTestResults
            )
        ]
    }
}
