//
//  UnifiedPanelLayoutModel.swift
//  DataKit
//
//  Defines the unified layout system for bottom panel and right sidebar
//  They work as a coordinated unit - never touching, rounded corners, 12px gaps
//  Same visual style as dashboard cards
//

import Foundation

// MARK: - Layout Constants

/// Standard spacing and sizing for the unified panel system
public struct PanelLayoutConstants: Sendable {
    /// Gap between panels and window edges (12px)
    public static let panelGap: Double = 12
    
    /// Corner radius for panels (matches dashboard cards)
    public static let cornerRadius: Double = 16
    
    /// Minimum panel sizes
    public static let minRightSidebarWidth: Double = 320
    public static let maxRightSidebarWidth: Double = 600
    public static let defaultRightSidebarWidth: Double = 380
    
    public static let minBottomPanelHeight: Double = 150
    public static let maxBottomPanelHeight: Double = 500
    public static let defaultBottomPanelHeight: Double = 220
    
    /// Split ratios for sidebar
    public static let minSplitRatio: Double = 0.2
    public static let maxSplitRatio: Double = 0.8
    public static let defaultSplitRatio: Double = 0.5
    
    /// Triple split ratios
    public static let tripleTopRatio: Double = 0.33
    public static let tripleMiddleRatio: Double = 0.34
    public static let tripleBottomRatio: Double = 0.33
    
    /// Maximum components in sidebar
    public static let maxSidebarComponents: Int = 3
    
    /// Divider height between split panels
    public static let dividerHeight: Double = 6
    
    private init() {}
}

// MARK: - Panel Region

/// Defines a region in the workspace where panels can appear
public enum PanelRegion: String, Codable, Sendable, CaseIterable {
    case rightSidebar   // Right side of workspace
    case bottomPanel    // Bottom of workspace (above input)
    
    public var maxComponents: Int {
        switch self {
        case .rightSidebar: return 3  // Single, split, or triple
        case .bottomPanel: return 1   // Single tab at a time (tabs switch content)
        }
    }
}

// MARK: - Unified Panel Layout State

/// Complete state of the unified panel layout system
public struct UnifiedPanelLayoutState: Codable, Sendable, Equatable {
    // Right Sidebar
    public var rightSidebarVisible: Bool
    public var rightSidebarWidth: Double
    public var rightSidebarComponents: [RightSidebarComponent]
    public var rightSidebarSplitRatios: [Double]  // Ratios for each component
    
    // Bottom Panel
    public var bottomPanelVisible: Bool
    public var bottomPanelHeight: Double
    public var bottomPanelActiveTab: BottomPanelTabType
    public var bottomPanelPinnedTabs: [BottomPanelTabType]
    
    // Coordination
    public var coordinationMode: PanelCoordinationMode
    
    public init(
        rightSidebarVisible: Bool = false,
        rightSidebarWidth: Double = PanelLayoutConstants.defaultRightSidebarWidth,
        rightSidebarComponents: [RightSidebarComponent] = [],
        rightSidebarSplitRatios: [Double] = [1.0],
        bottomPanelVisible: Bool = false,
        bottomPanelHeight: Double = PanelLayoutConstants.defaultBottomPanelHeight,
        bottomPanelActiveTab: BottomPanelTabType = .terminal,
        bottomPanelPinnedTabs: [BottomPanelTabType] = [.terminal, .problems],
        coordinationMode: PanelCoordinationMode = .independent
    ) {
        self.rightSidebarVisible = rightSidebarVisible
        self.rightSidebarWidth = rightSidebarWidth
        self.rightSidebarComponents = rightSidebarComponents
        self.rightSidebarSplitRatios = rightSidebarSplitRatios
        self.bottomPanelVisible = bottomPanelVisible
        self.bottomPanelHeight = bottomPanelHeight
        self.bottomPanelActiveTab = bottomPanelActiveTab
        self.bottomPanelPinnedTabs = bottomPanelPinnedTabs
        self.coordinationMode = coordinationMode
    }
}

// MARK: - Right Sidebar Component

/// A component that can appear in the right sidebar
public struct RightSidebarComponent: Codable, Sendable, Equatable, Identifiable {
    public let id: String
    public let type: RightSidebarComponentType
    public var minHeight: Double
    public var preferredHeight: Double?
    
    public init(
        id: String = UUID().uuidString,
        type: RightSidebarComponentType,
        minHeight: Double? = nil,
        preferredHeight: Double? = nil
    ) {
        self.id = id
        self.type = type
        self.minHeight = minHeight ?? type.defaultMinHeight
        self.preferredHeight = preferredHeight
    }
}

/// Types of components that can appear in the right sidebar
public enum RightSidebarComponentType: String, Codable, Sendable, CaseIterable, Identifiable {
    // Assistant
    case chat
    case quickHelp
    case suggestions
    
    // Inspection
    case inspector
    case preview
    case diff
    case history
    
    // Navigation
    case symbols
    case references
    case bookmarks
    
    // Activity
    case notifications
    case tasks
    
    // Learning
    case documentation
    case walkthrough
    case snippets
    
    public var id: String { rawValue }
    
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
        case .notifications: return "Activity"
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
        case .notifications: return "bell.fill"
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
        case .notifications: return "warning"
        case .tasks: return "workflows"
        case .snippets: return "commands"
        }
    }
    
    public var defaultMinHeight: Double {
        switch self {
        case .chat: return 200
        case .preview: return 200
        case .inspector: return 150
        case .diff, .history: return 180
        case .documentation, .walkthrough: return 180
        default: return 120
        }
    }
    
    /// Natural pairings for split view
    public var naturalPairings: [RightSidebarComponentType] {
        switch self {
        case .chat: return [.notifications, .documentation, .quickHelp, .suggestions]
        case .quickHelp: return [.chat, .inspector]
        case .suggestions: return [.chat]
        case .inspector: return [.preview, .history, .quickHelp]
        case .preview: return [.inspector, .symbols, .documentation]
        case .diff: return [.chat, .history]
        case .history: return [.diff, .inspector]
        case .symbols: return [.preview, .documentation]
        case .references: return [.chat, .inspector]
        case .bookmarks: return [.documentation]
        case .notifications: return [.chat, .tasks]
        case .tasks: return [.notifications, .chat]
        case .documentation: return [.chat, .preview, .symbols]
        case .walkthrough: return [.chat]
        case .snippets: return [.chat, .documentation]
        }
    }
}


// MARK: - Bottom Panel Tab Type

/// Types of tabs in the bottom panel
public enum BottomPanelTabType: String, Codable, Sendable, CaseIterable, Identifiable {
    // Execution
    case terminal
    case output
    case console
    
    // Diagnostics
    case problems
    case debug
    case performance
    
    // Search
    case search
    case findReplace
    
    // Version Control
    case git
    case commits
    case stash
    
    // Testing
    case tests
    case coverage
    
    // Data
    case database
    case network
    
    public var id: String { rawValue }
    
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
    
    /// Whether this tab has a badge
    public var hasBadge: Bool {
        switch self {
        case .problems, .tests, .git, .search, .network:
            return true
        default:
            return false
        }
    }
    
    /// Whether this tab supports input
    public var hasInput: Bool {
        switch self {
        case .terminal, .console, .debug, .search, .findReplace, .database:
            return true
        default:
            return false
        }
    }
}

// MARK: - Panel Coordination Mode

/// How the bottom panel and right sidebar coordinate
public enum PanelCoordinationMode: String, Codable, Sendable {
    case independent      // Panels operate independently
    case linked           // Panels respond to each other's state
    case synchronized     // Panels show related content
    case exclusive        // Only one panel visible at a time
}

// MARK: - Panel Layout Configuration

/// Configuration for how panels are laid out
public struct PanelLayoutConfiguration: Codable, Sendable, Equatable {
    /// Gap between panels (default 12px)
    public var panelGap: Double
    
    /// Corner radius for panels
    public var cornerRadius: Double
    
    /// Whether panels have shadows
    public var showShadows: Bool
    
    /// Whether panels have borders
    public var showBorders: Bool
    
    /// Animation duration for panel transitions
    public var animationDuration: Double
    
    public init(
        panelGap: Double = PanelLayoutConstants.panelGap,
        cornerRadius: Double = PanelLayoutConstants.cornerRadius,
        showShadows: Bool = true,
        showBorders: Bool = true,
        animationDuration: Double = 0.25
    ) {
        self.panelGap = panelGap
        self.cornerRadius = cornerRadius
        self.showShadows = showShadows
        self.showBorders = showBorders
        self.animationDuration = animationDuration
    }
    
    public static let `default` = PanelLayoutConfiguration()
    
    public static let compact = PanelLayoutConfiguration(
        panelGap: 8,
        cornerRadius: 12,
        showShadows: false
    )
    
    public static let spacious = PanelLayoutConfiguration(
        panelGap: 16,
        cornerRadius: 20,
        showShadows: true
    )
}

// MARK: - Panel Frame

/// Calculated frame for a panel
public struct PanelFrame: Codable, Sendable, Equatable {
    public var x: Double
    public var y: Double
    public var width: Double
    public var height: Double
    
    public init(x: Double = 0, y: Double = 0, width: Double = 0, height: Double = 0) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    public var isEmpty: Bool {
        width <= 0 || height <= 0
    }
}

// MARK: - Layout Calculator

/// Calculates panel frames based on workspace size and state
public struct PanelLayoutCalculator: Sendable {
    public let workspaceWidth: Double
    public let workspaceHeight: Double
    public let config: PanelLayoutConfiguration
    public let state: UnifiedPanelLayoutState
    
    public init(
        workspaceWidth: Double,
        workspaceHeight: Double,
        config: PanelLayoutConfiguration = .default,
        state: UnifiedPanelLayoutState
    ) {
        self.workspaceWidth = workspaceWidth
        self.workspaceHeight = workspaceHeight
        self.config = config
        self.state = state
    }
    
    /// Calculate the frame for the right sidebar
    public var rightSidebarFrame: PanelFrame {
        guard state.rightSidebarVisible else { return PanelFrame() }
        
        let width = min(state.rightSidebarWidth, PanelLayoutConstants.maxRightSidebarWidth)
        let x = workspaceWidth - width - config.panelGap
        let y = config.panelGap
        
        // Height depends on whether bottom panel is visible
        let bottomOffset = state.bottomPanelVisible 
            ? state.bottomPanelHeight + config.panelGap * 2
            : config.panelGap
        let height = workspaceHeight - y - bottomOffset
        
        return PanelFrame(x: x, y: y, width: width, height: height)
    }
    
    /// Calculate the frame for the bottom panel
    public var bottomPanelFrame: PanelFrame {
        guard state.bottomPanelVisible else { return PanelFrame() }
        
        let height = min(state.bottomPanelHeight, PanelLayoutConstants.maxBottomPanelHeight)
        let y = workspaceHeight - height - config.panelGap
        let x = config.panelGap
        
        // Width depends on whether right sidebar is visible
        let rightOffset = state.rightSidebarVisible
            ? state.rightSidebarWidth + config.panelGap
            : config.panelGap
        let width = workspaceWidth - x - rightOffset
        
        return PanelFrame(x: x, y: y, width: width, height: height)
    }
    
    /// Calculate frames for split components in the right sidebar
    public func rightSidebarComponentFrames() -> [PanelFrame] {
        let sidebarFrame = rightSidebarFrame
        guard !sidebarFrame.isEmpty else { return [] }
        
        let componentCount = state.rightSidebarComponents.count
        guard componentCount > 0 else { return [] }
        
        let dividerSpace = Double(componentCount - 1) * PanelLayoutConstants.dividerHeight
        let availableHeight = sidebarFrame.height - dividerSpace
        
        var frames: [PanelFrame] = []
        var currentY = sidebarFrame.y
        
        for (index, ratio) in state.rightSidebarSplitRatios.prefix(componentCount).enumerated() {
            let componentHeight = availableHeight * ratio
            frames.append(PanelFrame(
                x: sidebarFrame.x,
                y: currentY,
                width: sidebarFrame.width,
                height: componentHeight
            ))
            currentY += componentHeight + PanelLayoutConstants.dividerHeight
        }
        
        return frames
    }
}


// MARK: - Layout Presets

/// Predefined layout configurations for common workflows
public enum PanelLayoutPreset: String, Codable, Sendable, CaseIterable {
    case coding         // Terminal visible, sidebar hidden
    case debugging      // Debug + inspector + chat
    case testing        // Tests + inspector
    case reviewing      // Git + diff + chat
    case learning       // Docs + chat, no bottom panel
    case focused        // All panels hidden
    case presenting     // Preview only, large
    
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
    
    public var layoutState: UnifiedPanelLayoutState {
        switch self {
        case .coding:
            return UnifiedPanelLayoutState(
                rightSidebarVisible: false,
                bottomPanelVisible: true,
                bottomPanelHeight: 200,
                bottomPanelActiveTab: .terminal
            )
            
        case .debugging:
            return UnifiedPanelLayoutState(
                rightSidebarVisible: true,
                rightSidebarWidth: 400,
                rightSidebarComponents: [
                    RightSidebarComponent(type: .inspector),
                    RightSidebarComponent(type: .chat)
                ],
                rightSidebarSplitRatios: [0.5, 0.5],
                bottomPanelVisible: true,
                bottomPanelHeight: 250,
                bottomPanelActiveTab: .debug,
                coordinationMode: .linked
            )
            
        case .testing:
            return UnifiedPanelLayoutState(
                rightSidebarVisible: true,
                rightSidebarWidth: 350,
                rightSidebarComponents: [
                    RightSidebarComponent(type: .inspector)
                ],
                rightSidebarSplitRatios: [1.0],
                bottomPanelVisible: true,
                bottomPanelHeight: 300,
                bottomPanelActiveTab: .tests,
                coordinationMode: .linked
            )
            
        case .reviewing:
            return UnifiedPanelLayoutState(
                rightSidebarVisible: true,
                rightSidebarWidth: 420,
                rightSidebarComponents: [
                    RightSidebarComponent(type: .diff),
                    RightSidebarComponent(type: .chat)
                ],
                rightSidebarSplitRatios: [0.6, 0.4],
                bottomPanelVisible: true,
                bottomPanelHeight: 200,
                bottomPanelActiveTab: .git,
                coordinationMode: .synchronized
            )
            
        case .learning:
            return UnifiedPanelLayoutState(
                rightSidebarVisible: true,
                rightSidebarWidth: 450,
                rightSidebarComponents: [
                    RightSidebarComponent(type: .documentation),
                    RightSidebarComponent(type: .chat)
                ],
                rightSidebarSplitRatios: [0.55, 0.45],
                bottomPanelVisible: false,
                coordinationMode: .synchronized
            )
            
        case .focused:
            return UnifiedPanelLayoutState(
                rightSidebarVisible: false,
                bottomPanelVisible: false
            )
            
        case .presenting:
            return UnifiedPanelLayoutState(
                rightSidebarVisible: true,
                rightSidebarWidth: 500,
                rightSidebarComponents: [
                    RightSidebarComponent(type: .preview)
                ],
                rightSidebarSplitRatios: [1.0],
                bottomPanelVisible: false
            )
        }
    }
}

// MARK: - Panel Actions

/// Actions that can be performed on the unified panel system
public enum UnifiedPanelAction: Codable, Sendable {
    // Right Sidebar
    case showRightSidebar
    case hideRightSidebar
    case toggleRightSidebar
    case setRightSidebarWidth(Double)
    case addSidebarComponent(RightSidebarComponentType)
    case removeSidebarComponent(String)  // by ID
    case setSidebarComponents([RightSidebarComponentType])
    case setSplitRatios([Double])
    
    // Bottom Panel
    case showBottomPanel
    case hideBottomPanel
    case toggleBottomPanel
    case setBottomPanelHeight(Double)
    case setBottomPanelTab(BottomPanelTabType)
    case pinBottomPanelTab(BottomPanelTabType)
    case unpinBottomPanelTab(BottomPanelTabType)
    
    // Presets
    case applyPreset(PanelLayoutPreset)
    
    // Coordination
    case setCoordinationMode(PanelCoordinationMode)
}

// MARK: - Panel Events

/// Events emitted by the panel system
public enum UnifiedPanelEvent: Codable, Sendable {
    case rightSidebarVisibilityChanged(Bool)
    case rightSidebarWidthChanged(Double)
    case rightSidebarComponentsChanged([RightSidebarComponentType])
    case bottomPanelVisibilityChanged(Bool)
    case bottomPanelHeightChanged(Double)
    case bottomPanelTabChanged(BottomPanelTabType)
    case presetApplied(PanelLayoutPreset)
    case coordinationModeChanged(PanelCoordinationMode)
}

// MARK: - Badge Counts

/// Badge counts for panels
public struct PanelBadgeCounts: Codable, Sendable, Equatable {
    public var problems: Int
    public var warnings: Int
    public var errors: Int
    public var failedTests: Int
    public var passedTests: Int
    public var uncommittedChanges: Int
    public var searchResults: Int
    public var notifications: Int
    public var runningTasks: Int
    
    public init(
        problems: Int = 0,
        warnings: Int = 0,
        errors: Int = 0,
        failedTests: Int = 0,
        passedTests: Int = 0,
        uncommittedChanges: Int = 0,
        searchResults: Int = 0,
        notifications: Int = 0,
        runningTasks: Int = 0
    ) {
        self.problems = problems
        self.warnings = warnings
        self.errors = errors
        self.failedTests = failedTests
        self.passedTests = passedTests
        self.uncommittedChanges = uncommittedChanges
        self.searchResults = searchResults
        self.notifications = notifications
        self.runningTasks = runningTasks
    }
    
    /// Get badge count for a bottom panel tab
    public func badge(for tab: BottomPanelTabType) -> Int? {
        switch tab {
        case .problems: return problems > 0 ? problems : nil
        case .tests: return failedTests > 0 ? failedTests : nil
        case .git: return uncommittedChanges > 0 ? uncommittedChanges : nil
        case .search: return searchResults > 0 ? searchResults : nil
        default: return nil
        }
    }
    
    /// Get badge count for a sidebar component
    public func badge(for component: RightSidebarComponentType) -> Int? {
        switch component {
        case .notifications: return notifications > 0 ? notifications : nil
        case .tasks: return runningTasks > 0 ? runningTasks : nil
        default: return nil
        }
    }
}
