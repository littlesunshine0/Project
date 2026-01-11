//
//  RightSidebarState.swift
//  FlowKit
//
//  SwiftUI state management for the right sidebar
//  Core models live in DataKit - this file provides ObservableObject manager
//  Panels share space without overlapping - they never touch each other
//

import SwiftUI
import Combine
import DesignKit
import DataKit

// MARK: - Type Aliases for DataKit Models

/// Type alias for DataKit's RightPanel enum
public typealias RightPanelType = RightPanel

/// Type alias for DataKit's BottomPanel enum
public typealias BottomPanelType = BottomPanel

/// Type alias for DataKit's WorkspacePanelState
public typealias PanelState = WorkspacePanelState

/// Type alias for DataKit's WorkspacePreset
public typealias PanelPreset = WorkspacePreset

// MARK: - Sidebar Content Type (SwiftUI)

/// Content types that can appear in the right sidebar with SwiftUI Color
/// Maps to DataKit's SidebarContentTypeModel and RightPanel
public enum SidebarContentType: String, CaseIterable, Identifiable, Sendable {
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
    
    // Notifications
    case notifications
    case tasks
    
    // Learning
    case documentation
    case walkthrough
    case snippets
    
    // Legacy (for compatibility)
    case search
    case outline
    
    public var id: String { rawValue }
    
    /// Get the DataKit RightPanel for this type
    public var rightPanel: RightPanel? {
        switch self {
        case .chat: return .chat
        case .quickHelp: return .quickHelp
        case .suggestions: return .suggestions
        case .inspector: return .inspector
        case .preview: return .preview
        case .diff: return .diff
        case .history: return .history
        case .symbols: return .symbols
        case .references: return .references
        case .bookmarks: return .bookmarks
        case .notifications: return .activity
        case .tasks: return .tasks
        case .documentation: return .documentation
        case .walkthrough: return .walkthrough
        case .snippets: return .snippets
        case .search: return nil  // Search is in bottom panel
        case .outline: return .symbols  // Outline maps to symbols
        }
    }
    
    /// Get the DataKit model for this type (legacy support)
    public var model: SidebarContentTypeModel? {
        SidebarContentTypeModel(rawValue: rawValue)
    }
    
    public var title: String {
        rightPanel?.title ?? model?.title ?? rawValue.capitalized
    }
    
    public var icon: String {
        rightPanel?.icon ?? model?.icon ?? "questionmark"
    }
    
    public var accentColor: Color {
        if let panel = rightPanel {
            return Color.forPanelCategory(panel.colorCategory)
        }
        guard let model = model else { return .gray }
        return Color.forColorCategory(model.colorCategory)
    }
    
    /// Whether this content type supports split view
    public var supportsSplit: Bool {
        model?.supportsSplit ?? true
    }
    
    /// Whether this content type can expand to full
    public var supportsFullExpand: Bool {
        model?.supportsFullExpand ?? false
    }
    
    /// Suggested pairings for split view
    public var suggestedPairings: [SidebarContentType] {
        if let panel = rightPanel {
            return panel.naturalPairings.compactMap { SidebarContentType(from: $0) }
        }
        return model?.suggestedPairings.compactMap { SidebarContentType(rawValue: $0.rawValue) } ?? []
    }
    
    /// Default minimum height
    public var defaultMinHeight: CGFloat {
        if let panel = rightPanel {
            return CGFloat(panel.minHeight)
        }
        return CGFloat(model?.defaultMinHeight ?? 100)
    }
    
    /// Initialize from RightPanel
    public init?(from panel: RightPanel) {
        switch panel {
        case .chat: self = .chat
        case .quickHelp: self = .quickHelp
        case .suggestions: self = .suggestions
        case .inspector: self = .inspector
        case .preview: self = .preview
        case .diff: self = .diff
        case .history: self = .history
        case .symbols: self = .symbols
        case .references: self = .references
        case .bookmarks: self = .bookmarks
        case .activity: self = .notifications
        case .tasks: self = .tasks
        case .documentation: self = .documentation
        case .walkthrough: self = .walkthrough
        case .snippets: self = .snippets
        }
    }
}

// MARK: - Color Extensions for Panel Categories

public extension Color {
    /// Get color for panel color category
    static func forPanelCategory(_ category: String) -> Color {
        switch category {
        case "chat": return FlowColors.Category.chat
        case "documentation": return FlowColors.Category.documentation
        case "neutral": return FlowColors.Status.neutral
        case "projects": return FlowColors.Category.projects
        case "agents": return FlowColors.Category.agents
        case "info": return FlowColors.Status.info
        case "warning": return FlowColors.Status.warning
        case "workflows": return FlowColors.Category.workflows
        case "commands": return FlowColors.Category.commands
        case "search": return FlowColors.Category.search
        case "success": return FlowColors.Status.success
        case "error": return FlowColors.Status.error
        default: return FlowColors.Status.neutral
        }
    }
    
    /// Get color for legacy color category
    static func forColorCategory(_ category: String) -> Color {
        forPanelCategory(category)
    }
}

// MARK: - Right Sidebar Mode (SwiftUI)

/// Mode for the right sidebar - SwiftUI layout state
/// Panels share space with gaps between them - they never touch
public enum RightSidebarMode: Equatable, Sendable {
    case minimized
    case single(SidebarContentType)
    case split(top: SidebarContentType, bottom: SidebarContentType)
    case triple(top: SidebarContentType, middle: SidebarContentType, bottom: SidebarContentType)
    case fullFloating(SidebarContentType)
    case fullChat
    
    /// All visible content types
    public var visibleContentTypes: [SidebarContentType] {
        switch self {
        case .minimized: return []
        case .single(let type): return [type]
        case .split(let top, let bottom): return [top, bottom]
        case .triple(let top, let middle, let bottom): return [top, middle, bottom]
        case .fullFloating(let type): return [type]
        case .fullChat: return [.chat]
        }
    }
    
    /// Check if showing a specific type
    public func isShowing(_ type: SidebarContentType) -> Bool {
        visibleContentTypes.contains(type)
    }
    
    /// Convert to DataKit's RightPanelDisplayMode
    public var displayMode: RightPanelDisplayMode {
        switch self {
        case .minimized:
            return .hidden
        case .single(let type):
            if let panel = type.rightPanel {
                return .single(panel)
            }
            return .hidden
        case .split(let top, let bottom):
            if let topPanel = top.rightPanel, let bottomPanel = bottom.rightPanel {
                return .split(top: topPanel, bottom: bottomPanel)
            }
            return .hidden
        case .triple:
            // DataKit doesn't have triple, use split with top two
            if case .triple(let top, _, let bottom) = self,
               let topPanel = top.rightPanel, let bottomPanel = bottom.rightPanel {
                return .split(top: topPanel, bottom: bottomPanel)
            }
            return .hidden
        case .fullFloating(let type):
            if let panel = type.rightPanel {
                return .single(panel)
            }
            return .hidden
        case .fullChat:
            return .fullChat
        }
    }
    
    /// Initialize from DataKit's RightPanelDisplayMode
    public init(from displayMode: RightPanelDisplayMode) {
        switch displayMode {
        case .hidden:
            self = .minimized
        case .single(let panel):
            if let type = SidebarContentType(from: panel) {
                self = .single(type)
            } else {
                self = .minimized
            }
        case .split(let top, let bottom):
            if let topType = SidebarContentType(from: top),
               let bottomType = SidebarContentType(from: bottom) {
                self = .split(top: topType, bottom: bottomType)
            } else {
                self = .minimized
            }
        case .fullChat:
            self = .fullChat
        }
    }
}

// MARK: - Right Sidebar Manager (SwiftUI ObservableObject)

/// Manages the right sidebar state - SwiftUI rendering
@MainActor
public class RightSidebarManager: ObservableObject {
    public static let shared = RightSidebarManager()
    
    @Published public var mode: RightSidebarMode = .minimized
    @Published public var sidebarWidth: CGFloat = 380
    @Published public var splitRatio: CGFloat = 0.5
    @Published public var middleSplitRatio: CGFloat = 0.33  // For triple mode
    
    // Panel state tracking (syncs with DataKit models)
    @Published public var panelState: WorkspacePanelState = WorkspacePanelState()
    @Published public var triggerRules: [PanelTriggerRule] = PanelTriggerRule.defaults
    @Published public var currentPreset: WorkspacePreset?
    
    // Badge counts
    @Published public var badges: [String: Int] = [:]
    
    private init() {
        // Initialize with default trigger rules
        setupTriggerRules()
    }
    
    private func setupTriggerRules() {
        triggerRules = PanelTriggerRule.defaults
    }
    
    // MARK: - Actions
    
    public func showChat() {
        if case .split(_, let bottom) = mode, bottom != .chat {
            mode = .split(top: .chat, bottom: bottom)
        } else {
            mode = .single(.chat)
        }
    }
    
    public func showContent(_ type: SidebarContentType) {
        mode = .single(type)
    }
    
    public func splitWith(top: SidebarContentType, bottom: SidebarContentType) {
        mode = .split(top: top, bottom: bottom)
    }
    
    public func addToSplit(_ type: SidebarContentType, position: SplitPosition) {
        switch mode {
        case .minimized:
            mode = .single(type)
        case .single(let current):
            if position == .top {
                mode = .split(top: type, bottom: current)
            } else {
                mode = .split(top: current, bottom: type)
            }
        case .split(let top, let bottom):
            if position == .top {
                mode = .split(top: type, bottom: bottom)
            } else {
                mode = .split(top: top, bottom: type)
            }
        case .triple(let top, _, let bottom):
            if position == .top {
                mode = .triple(top: type, middle: top, bottom: bottom)
            } else {
                mode = .triple(top: top, middle: bottom, bottom: type)
            }
        case .fullFloating:
            mode = .single(type)
        case .fullChat:
            if position == .top {
                mode = .split(top: type, bottom: .chat)
            } else {
                mode = .split(top: .chat, bottom: type)
            }
        }
    }
    
    public func expandToFull() {
        switch mode {
        case .single(let type):
            if type == .chat {
                mode = .fullChat
            } else {
                mode = .fullFloating(type)
            }
        case .split(let top, let bottom):
            if top == .chat {
                mode = .fullChat
            } else if bottom == .chat {
                mode = .fullFloating(top)
            } else {
                mode = .fullFloating(top)
            }
        default:
            mode = .fullChat
        }
    }
    
    public func expandChatToFull() {
        mode = .fullChat
        NotificationCenter.default.post(name: .fullChatModeActivated, object: nil)
    }
    
    public func expandContentToFull(_ type: SidebarContentType) {
        if type == .chat {
            mode = .fullChat
        } else {
            mode = .fullFloating(type)
        }
    }
    
    public func collapse() {
        switch mode {
        case .fullFloating(let type):
            mode = .single(type)
        case .fullChat:
            mode = .single(.chat)
        default:
            break
        }
    }
    
    public func minimize() {
        mode = .minimized
    }
    
    public func toggle() {
        if case .minimized = mode {
            mode = .single(.chat)
        } else {
            mode = .minimized
        }
    }
    
    public var isVisible: Bool {
        if case .minimized = mode { return false }
        return true
    }
    
    public var isFloating: Bool {
        switch mode {
        case .fullFloating, .fullChat:
            return true
        default:
            return false
        }
    }
    
    public var isFullChatMode: Bool {
        if case .fullChat = mode { return true }
        return false
    }
    
    public var isShowingNotifications: Bool {
        switch mode {
        case .single(.notifications), .fullFloating(.notifications):
            return true
        case .split(let top, let bottom):
            return top == .notifications || bottom == .notifications
        case .triple(let top, let middle, let bottom):
            return top == .notifications || middle == .notifications || bottom == .notifications
        default:
            return false
        }
    }
    
    /// Toggle notifications panel - independent of chat
    /// Notifications is its own panel, not tied to chat
    public func toggleNotifications() {
        if isShowingNotifications {
            // Remove notifications from current mode
            switch mode {
            case .single(.notifications):
                mode = .minimized
            case .fullFloating(.notifications):
                mode = .minimized
            case .split(let top, let bottom):
                if top == .notifications {
                    mode = .single(bottom)
                } else if bottom == .notifications {
                    mode = .single(top)
                }
            case .triple(let top, let middle, let bottom):
                if top == .notifications {
                    mode = .split(top: middle, bottom: bottom)
                } else if middle == .notifications {
                    mode = .split(top: top, bottom: bottom)
                } else if bottom == .notifications {
                    mode = .split(top: top, bottom: middle)
                }
            default:
                break
            }
        } else {
            // Add notifications to current mode
            switch mode {
            case .minimized:
                // Just show notifications alone
                mode = .single(.notifications)
            case .single(let current):
                // Add notifications above current content
                mode = .split(top: .notifications, bottom: current)
            case .split(let top, let bottom):
                // Add notifications as top, push others down
                mode = .triple(top: .notifications, middle: top, bottom: bottom)
            case .triple:
                // Already at max, replace top with notifications
                if case .triple(_, let middle, let bottom) = mode {
                    mode = .triple(top: .notifications, middle: middle, bottom: bottom)
                }
            case .fullFloating(let type):
                // Exit full mode and add notifications
                mode = .split(top: .notifications, bottom: type)
            case .fullChat:
                // Exit full chat and add notifications
                mode = .split(top: .notifications, bottom: .chat)
            }
        }
    }
    
    /// Show notifications panel (standalone, not tied to chat)
    public func showNotifications() {
        mode = .single(.notifications)
    }
    
    // MARK: - Enhanced Panel Management
    
    /// Show documentation panel, optionally with chat
    public func showDocumentation(withChat: Bool = false) {
        if withChat {
            mode = .split(top: .documentation, bottom: .chat)
        } else {
            mode = .single(.documentation)
        }
    }
    
    /// Show walkthrough panel, optionally with chat
    public func showWalkthrough(withChat: Bool = true) {
        if withChat {
            mode = .split(top: .walkthrough, bottom: .chat)
        } else {
            mode = .single(.walkthrough)
        }
    }
    
    /// Show inspector panel
    public func showInspector() {
        mode = .single(.inspector)
    }
    
    /// Show preview panel
    public func showPreview() {
        mode = .single(.preview)
    }
    
    /// Show search panel
    public func showSearch() {
        mode = .single(.search)
    }
    
    /// Toggle a specific content type
    public func toggle(_ type: SidebarContentType) {
        if mode.isShowing(type) {
            // Remove this type
            switch mode {
            case .single:
                mode = .minimized
            case .split(let top, let bottom):
                if top == type {
                    mode = .single(bottom)
                } else {
                    mode = .single(top)
                }
            case .triple(let top, let middle, let bottom):
                if top == type {
                    mode = .split(top: middle, bottom: bottom)
                } else if middle == type {
                    mode = .split(top: top, bottom: bottom)
                } else {
                    mode = .split(top: top, bottom: middle)
                }
            default:
                mode = .minimized
            }
        } else {
            // Add this type
            addContent(type)
        }
    }
    
    /// Add content to the sidebar (smart placement)
    public func addContent(_ type: SidebarContentType) {
        switch mode {
        case .minimized:
            mode = .single(type)
        case .single(let current):
            // Use suggested pairings if available
            if type.suggestedPairings.contains(current) || current.suggestedPairings.contains(type) {
                // Put the higher priority one on top
                let typePriority = type.model?.defaultPriority ?? 0
                let currentPriority = current.model?.defaultPriority ?? 0
                if typePriority > currentPriority {
                    mode = .split(top: type, bottom: current)
                } else {
                    mode = .split(top: current, bottom: type)
                }
            } else {
                mode = .split(top: current, bottom: type)
            }
        case .split(let top, let bottom):
            // Upgrade to triple if supported
            mode = .triple(top: top, middle: type, bottom: bottom)
        case .triple:
            // Already at max, replace middle
            if case .triple(let top, _, let bottom) = mode {
                mode = .triple(top: top, middle: type, bottom: bottom)
            }
        case .fullFloating, .fullChat:
            // Collapse and add
            collapse()
            addContent(type)
        }
    }
    
    /// Apply a preset configuration
    public func applyPreset(_ preset: SidebarPresetModel) {
        let config = preset.config
        guard !config.slots.isEmpty else {
            mode = .minimized
            return
        }
        
        let types = config.slots.compactMap { SidebarContentType(rawValue: $0.contentType.rawValue) }
        
        switch types.count {
        case 0:
            mode = .minimized
        case 1:
            mode = .single(types[0])
        case 2:
            mode = .split(top: types[0], bottom: types[1])
        default:
            mode = .triple(top: types[0], middle: types[1], bottom: types[2])
        }
    }
    
    /// Check if showing a specific content type
    public func isShowing(_ type: SidebarContentType) -> Bool {
        mode.isShowing(type)
    }
    
    public enum SplitPosition {
        case top, middle, bottom
    }
    
    // MARK: - Workspace Presets
    
    /// Apply a workspace preset (coding, debugging, testing, etc.)
    public func applyWorkspacePreset(_ preset: WorkspacePreset) {
        currentPreset = preset
        let state = preset.state
        
        // Apply right panel mode
        mode = RightSidebarMode(from: state.rightPanelMode)
        sidebarWidth = CGFloat(state.rightPanelWidth)
        splitRatio = CGFloat(state.rightSplitRatio)
        
        // Update panel state
        panelState = state
        
        // Post notification
        NotificationCenter.default.post(
            name: .workspacePresetApplied,
            object: nil,
            userInfo: ["preset": preset]
        )
    }
    
    /// Get recommended preset based on current context
    public func recommendedPreset(forFileType fileType: String?) -> WorkspacePreset {
        guard let fileType = fileType else { return .coding }
        
        switch fileType.lowercased() {
        case "swift", "py", "js", "ts", "java", "cpp", "c", "rs":
            return .coding
        case "md", "txt", "rtf":
            return .learning
        case "xctest", "spec.ts", "test.js", "test.py":
            return .testing
        default:
            return .coding
        }
    }
    
    // MARK: - Panel Triggers
    
    /// Handle a panel trigger event
    public func handleTrigger(_ event: PanelTriggerEvent) {
        for rule in triggerRules where rule.enabled && rule.event == event {
            // Check condition if present
            if let condition = rule.condition {
                guard shouldApplyRule(condition: condition) else { continue }
            }
            
            // Apply right panel action
            if let action = rule.rightPanelAction {
                applyRightPanelAction(action)
            }
            
            // Post notification for bottom panel action (handled by BottomPanelManager)
            if let action = rule.bottomPanelAction {
                NotificationCenter.default.post(
                    name: .bottomPanelActionRequested,
                    object: nil,
                    userInfo: ["action": action]
                )
            }
        }
    }
    
    private func shouldApplyRule(condition: TriggerCondition) -> Bool {
        switch condition {
        case .fileType(let type):
            // Check if current file matches type
            return true // Simplified - would check actual file type
        case .hasErrors:
            return (badges["errors"] ?? 0) > 0
        case .hasWarnings:
            return (badges["warnings"] ?? 0) > 0
        case .panelNotVisible(let panelId):
            return !mode.visibleContentTypes.contains { $0.rawValue == panelId }
        case .userPreference:
            return true // Would check user preferences
        }
    }
    
    private func applyRightPanelAction(_ action: RightPanelAction) {
        switch action {
        case .show(let panel):
            if let type = SidebarContentType(from: panel) {
                showContent(type)
            }
        case .showSplit(let top, let bottom):
            if let topType = SidebarContentType(from: top),
               let bottomType = SidebarContentType(from: bottom) {
                splitWith(top: topType, bottom: bottomType)
            }
        case .hide:
            minimize()
        case .toggle(let panel):
            if let type = SidebarContentType(from: panel) {
                toggle(type)
            }
        }
    }
    
    // MARK: - Badge Management
    
    /// Update badge count for a panel
    public func updateBadge(_ count: Int, for key: String) {
        badges[key] = count
        panelState.badges[key] = count
    }
    
    /// Get badge count for a panel type
    public func badgeCount(for type: SidebarContentType) -> Int? {
        guard let panel = type.rightPanel else { return nil }
        
        switch panel {
        case .activity:
            return badges["notifications"]
        case .tasks:
            return badges["runningTasks"]
        default:
            return nil
        }
    }
    
    // MARK: - New Panel Types
    
    /// Show quick help panel
    public func showQuickHelp() {
        mode = .single(.quickHelp)
    }
    
    /// Show suggestions panel
    public func showSuggestions() {
        mode = .single(.suggestions)
    }
    
    /// Show diff panel
    public func showDiff() {
        mode = .single(.diff)
    }
    
    /// Show history panel
    public func showHistory() {
        mode = .single(.history)
    }
    
    /// Show symbols panel (outline)
    public func showSymbols() {
        mode = .single(.symbols)
    }
    
    /// Show references panel
    public func showReferences() {
        mode = .single(.references)
    }
    
    /// Show bookmarks panel
    public func showBookmarks() {
        mode = .single(.bookmarks)
    }
    
    /// Show tasks panel
    public func showTasks() {
        mode = .single(.tasks)
    }
    
    /// Show snippets panel
    public func showSnippets() {
        mode = .single(.snippets)
    }
    
    /// Show debugging layout (inspector + chat, debug panel)
    public func showDebuggingLayout() {
        applyWorkspacePreset(.debugging)
    }
    
    /// Show testing layout
    public func showTestingLayout() {
        applyWorkspacePreset(.testing)
    }
    
    /// Show code review layout
    public func showReviewLayout() {
        applyWorkspacePreset(.reviewing)
    }
}

// MARK: - Notification Names

public extension Notification.Name {
    static let fullChatModeActivated = Notification.Name("fullChatModeActivated")
    static let sidebarContentChanged = Notification.Name("sidebarContentChanged")
    static let sidebarModeChanged = Notification.Name("sidebarModeChanged")
    static let workspacePresetApplied = Notification.Name("workspacePresetApplied")
    static let bottomPanelActionRequested = Notification.Name("bottomPanelActionRequested")
    static let panelTriggerFired = Notification.Name("panelTriggerFired")
}
