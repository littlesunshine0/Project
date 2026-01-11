//
//  InputPanelState.swift
//  FlowKit
//
//  SwiftUI state management for the bottom input panel
//  Core models live in DataKit - this file provides ObservableObject manager
//
//  Supports multi-panel layout with overflow:
//  - Top slot: primary panel
//  - Bottom-middle slot: overflow panel (when 2+ panels open)
//  - Tab bar: when 3+ panels of same type or 4+ total panels
//

import SwiftUI
import Combine
import DesignKit
import DataKit

// MARK: - Type Aliases

public typealias InputPanelWidthMode = InputPanelWidthModeModel

// MARK: - Input Panel Tab (SwiftUI)

/// Types of input/interaction in the bottom panel with SwiftUI Color
public enum InputPanelTab: String, CaseIterable, Identifiable, Sendable {
    case chatInput
    case terminal
    case output
    case problems
    case debug
    
    public var id: String { rawValue }
    
    public var title: String {
        InputPanelTabModel(rawValue: rawValue)?.title ?? rawValue.capitalized
    }
    
    public var icon: String {
        InputPanelTabModel(rawValue: rawValue)?.icon ?? "questionmark"
    }
    
    public var accentColor: Color {
        guard let model = InputPanelTabModel(rawValue: rawValue) else { return .gray }
        switch model.colorCategory {
        case "chat": return FlowColors.Category.chat
        case "commands": return FlowColors.Category.commands
        case "info": return FlowColors.Status.info
        case "warning": return FlowColors.Status.warning
        case "error": return FlowColors.Status.error
        default: return FlowColors.Status.neutral
        }
    }
    
    public var placeholder: String {
        InputPanelTabModel(rawValue: rawValue)?.placeholder ?? ""
    }
    
    public var hasInput: Bool {
        InputPanelTabModel(rawValue: rawValue)?.hasInput ?? false
    }
}

// MARK: - Open Panel Instance

/// Represents a single open panel instance (allows multiple of same type)
public struct OpenPanelInstance: Identifiable, Equatable {
    public let id: UUID
    public let tab: InputPanelTab
    public let title: String
    public let createdAt: Date
    
    public init(tab: InputPanelTab, title: String? = nil) {
        self.id = UUID()
        self.tab = tab
        self.title = title ?? tab.title
        self.createdAt = Date()
    }
}

// MARK: - Panel Layout Mode

/// How panels are arranged based on count
public enum PanelLayoutMode: Equatable {
    case single                           // 1 panel: full view
    case stacked                          // 2 panels: top + bottom-middle
    case stackedWithTabs(overflowCount: Int)  // 3+ panels: top + bottom-middle with tabs
    case layeredGroup(type: InputPanelTab, count: Int)  // Multiple of same type: layered look
}

// MARK: - Input Panel Manager (SwiftUI ObservableObject)

/// Manages the bottom input panel state - SwiftUI rendering
/// Supports multiple open panels with overflow behavior
@MainActor
public class InputPanelManager: ObservableObject {
    public static let shared = InputPanelManager()
    
    // MARK: - Published State
    
    @Published public var isVisible: Bool = false
    @Published public var selectedTab: InputPanelTab = .chatInput
    @Published public var panelHeight: CGFloat = 200
    @Published public var isExpanded: Bool = false
    @Published public var widthMode: InputPanelWidthModeModel = .matchChat
    
    /// All currently open panel instances (ordered by creation time)
    @Published public var openPanels: [OpenPanelInstance] = []
    
    /// Currently focused panel in top slot
    @Published public var topPanelId: UUID? = nil
    
    /// Currently focused panel in bottom-middle slot (overflow)
    @Published public var bottomPanelId: UUID? = nil
    
    /// Selected tab within overflow tab bar (when 3+ panels)
    @Published public var overflowSelectedIndex: Int = 0
    
    // Input text for each tab
    @Published public var chatInputText: String = ""
    @Published public var terminalInputText: String = ""
    @Published public var debugInputText: String = ""
    
    // Counts for badges
    @Published public var problemsCount: Int = 0
    @Published public var outputLinesCount: Int = 0
    
    /// Maximum panels before forcing tab consolidation
    private let maxVisiblePanels = 3
    
    private init() {}
    
    // MARK: - Computed Properties
    
    /// Current layout mode based on open panel count
    public var layoutMode: PanelLayoutMode {
        let count = openPanels.count
        
        // Check for grouped same-type panels
        let groupedByType = Dictionary(grouping: openPanels, by: { $0.tab })
        if let (type, panels) = groupedByType.first(where: { $0.value.count >= 2 }) {
            return .layeredGroup(type: type, count: panels.count)
        }
        
        switch count {
        case 0, 1:
            return .single
        case 2:
            return .stacked
        default:
            return .stackedWithTabs(overflowCount: count - 1)
        }
    }
    
    /// Panel for top slot
    public var topPanel: OpenPanelInstance? {
        if let id = topPanelId {
            return openPanels.first { $0.id == id }
        }
        return openPanels.first
    }
    
    /// Panels for bottom-middle slot (overflow)
    public var overflowPanels: [OpenPanelInstance] {
        guard openPanels.count > 1 else { return [] }
        let topId = topPanel?.id
        return openPanels.filter { $0.id != topId }
    }
    
    /// Currently selected overflow panel
    public var selectedOverflowPanel: OpenPanelInstance? {
        guard !overflowPanels.isEmpty else { return nil }
        let index = min(overflowSelectedIndex, overflowPanels.count - 1)
        return overflowPanels[safe: index]
    }
    
    /// Panels grouped by type (for layered display)
    public var panelsByType: [InputPanelTab: [OpenPanelInstance]] {
        Dictionary(grouping: openPanels, by: { $0.tab })
    }
    
    /// Whether we need to show overflow tab bar
    public var showsOverflowTabs: Bool {
        overflowPanels.count >= 2
    }
    
    /// Whether we have layered panels of same type
    public var hasLayeredPanels: Bool {
        panelsByType.values.contains { $0.count >= 2 }
    }
    
    // MARK: - Actions
    
    public func show(tab: InputPanelTab? = nil) {
        isVisible = true
        if let tab = tab {
            selectedTab = tab
            // Add panel if not already open
            if !openPanels.contains(where: { $0.tab == tab }) {
                addPanel(tab: tab)
            } else {
                // Focus existing panel of this type
                if let existing = openPanels.first(where: { $0.tab == tab }) {
                    focusPanel(existing.id)
                }
            }
        } else if openPanels.isEmpty {
            addPanel(tab: .chatInput)
        }
    }
    
    public func hide() {
        isVisible = false
    }
    
    public func toggle() {
        isVisible.toggle()
    }
    
    public func selectTab(_ tab: InputPanelTab) {
        selectedTab = tab
        if !isVisible {
            isVisible = true
        }
        // Focus or add panel of this type
        if let existing = openPanels.first(where: { $0.tab == tab }) {
            focusPanel(existing.id)
        } else {
            addPanel(tab: tab)
        }
    }
    
    /// Add a new panel instance
    public func addPanel(tab: InputPanelTab, title: String? = nil) {
        let panel = OpenPanelInstance(tab: tab, title: title)
        openPanels.append(panel)
        
        // If this is the first panel, make it the top panel
        if openPanels.count == 1 {
            topPanelId = panel.id
        } else if openPanels.count == 2 {
            // Second panel goes to bottom-middle
            bottomPanelId = panel.id
        }
        
        selectedTab = tab
        isVisible = true
    }
    
    /// Close a specific panel instance
    public func closePanel(_ id: UUID) {
        openPanels.removeAll { $0.id == id }
        
        // Update focus if needed
        if topPanelId == id {
            topPanelId = openPanels.first?.id
        }
        if bottomPanelId == id {
            bottomPanelId = overflowPanels.first?.id
        }
        
        // Hide if no panels left
        if openPanels.isEmpty {
            isVisible = false
        }
        
        // Update selected tab
        if let top = topPanel {
            selectedTab = top.tab
        }
    }
    
    /// Focus a specific panel (bring to top slot)
    public func focusPanel(_ id: UUID) {
        guard let panel = openPanels.first(where: { $0.id == id }) else { return }
        
        // Swap with current top if different
        if topPanelId != id {
            bottomPanelId = topPanelId
            topPanelId = id
        }
        
        selectedTab = panel.tab
    }
    
    /// Swap top and bottom panels
    public func swapPanels() {
        let oldTop = topPanelId
        topPanelId = bottomPanelId
        bottomPanelId = oldTop
        
        if let top = topPanel {
            selectedTab = top.tab
        }
    }
    
    /// Select overflow panel by index
    public func selectOverflowPanel(at index: Int) {
        guard index >= 0 && index < overflowPanels.count else { return }
        overflowSelectedIndex = index
    }
    
    public func toggleExpand() {
        isExpanded.toggle()
        panelHeight = isExpanded ? 350 : 200
    }
    
    public func toggleWidthMode() {
        let newMode: InputPanelWidthModeModel = widthMode == .matchChat ? .extended : .matchChat
        widthMode = newMode
        
        NotificationCenter.default.post(
            name: .inputPanelWidthModeChanged,
            object: nil,
            userInfo: ["isExtended": newMode == .extended]
        )
    }
    
    public var isWidthExtended: Bool {
        widthMode == .extended
    }
    
    public var currentInputText: Binding<String> {
        switch selectedTab {
        case .chatInput:
            return Binding(get: { self.chatInputText }, set: { self.chatInputText = $0 })
        case .terminal:
            return Binding(get: { self.terminalInputText }, set: { self.terminalInputText = $0 })
        case .debug:
            return Binding(get: { self.debugInputText }, set: { self.debugInputText = $0 })
        default:
            return .constant("")
        }
    }
    
    public func sendChatMessage() {
        guard !chatInputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        NotificationCenter.default.post(
            name: .chatMessageSent,
            object: nil,
            userInfo: ["message": chatInputText]
        )
        chatInputText = ""
    }
    
    public func executeTerminalCommand() {
        guard !terminalInputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        NotificationCenter.default.post(
            name: .terminalCommandExecuted,
            object: nil,
            userInfo: ["command": terminalInputText]
        )
        terminalInputText = ""
    }
}

// MARK: - Array Safe Subscript

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Notification Names

public extension Notification.Name {
    static let chatMessageSent = Notification.Name("chatMessageSent")
    static let terminalCommandExecuted = Notification.Name("terminalCommandExecuted")
    static let inputPanelWidthModeChanged = Notification.Name("inputPanelWidthModeChanged")
}
