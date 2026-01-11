//
//  WorkspaceState.swift
//  FlowKit
//
//  SwiftUI state management for the IDE workspace layout
//  Uses DataKit models for core data
//

import SwiftUI
import Combine
import DesignKit
import DataKit

// MARK: - Type Aliases (Use DataKit models)

// WorkspaceLayoutMode and WorkspacePanelPosition are already defined in DataKit - no aliases needed

// MARK: - SwiftUI Color Extensions for DataKit Models

extension BottomBarTabModel {
    /// SwiftUI Color for rendering
    public var accentColor: Color {
        switch colorCategory {
        case "commands": return FlowColors.Category.commands
        case "warning": return FlowColors.Status.warning
        case "info": return FlowColors.Status.info
        case "error": return FlowColors.Status.error
        case "search": return FlowColors.Category.search
        default: return FlowColors.Status.neutral
        }
    }
}

// MARK: - Editor Tab (SwiftUI with Color)

/// Represents an open file/editor tab with SwiftUI Color
public struct EditorTab: Identifiable, Equatable, Hashable, Sendable {
    public let id: UUID
    public let filePath: String
    public let fileName: String
    public let fileExtension: String
    public let icon: String
    public let color: Color
    public var isModified: Bool
    public var isPinned: Bool
    public let openedAt: Date
    
    public init(
        id: UUID = UUID(),
        filePath: String,
        fileName: String,
        fileExtension: String,
        icon: String = "doc.text",
        color: Color = .blue,
        isModified: Bool = false,
        isPinned: Bool = false,
        openedAt: Date = Date()
    ) {
        self.id = id
        self.filePath = filePath
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.icon = icon
        self.color = color
        self.isModified = isModified
        self.isPinned = isPinned
        self.openedAt = openedAt
    }
    
    /// Create from DataKit model
    public init(from model: EditorTabModel) {
        self.id = model.id
        self.filePath = model.filePath
        self.fileName = model.fileName
        self.fileExtension = model.fileExtension
        self.icon = model.icon
        self.color = Self.color(from: model.colorName)
        self.isModified = model.isModified
        self.isPinned = model.isPinned
        self.openedAt = model.openedAt
    }
    
    public static func forFile(_ path: String) -> EditorTab {
        let model = EditorTabModel.forFile(path)
        return EditorTab(from: model)
    }
    
    private static func color(from name: String) -> Color {
        switch name {
        case "orange": return .orange
        case "yellow": return .yellow
        case "blue": return .blue
        case "green": return .green
        case "gray": return .gray
        case "purple": return .purple
        case "pink": return .pink
        case "cyan": return .cyan
        default: return .secondary
        }
    }
}

// MARK: - Bottom Bar Tab (SwiftUI wrapper)

public typealias BottomBarTab = BottomBarTabModel

// MARK: - Workspace Manager (SwiftUI ObservableObject)

/// Central state manager for the entire workspace - SwiftUI rendering
@MainActor
public class WorkspaceManager: ObservableObject {
    public static let shared = WorkspaceManager()
    
    // MARK: - Layout State
    @Published public var layoutMode: WorkspaceLayoutMode = .standard
    @Published public var isToolbarVisible: Bool = true
    @Published public var isStatusBarVisible: Bool = true
    
    // MARK: - Chat & Input Panel State
    @Published public var isChatOpen: Bool = false
    @Published public var isChatExpanded: Bool = true
    @Published public var chatWidth: CGFloat = 380
    
    // MARK: - Input Panel State
    @Published public var isInputPanelVisible: Bool = false
    @Published public var inputPanelHeight: CGFloat = 200
    @Published public var selectedInputTab: BottomBarTabModel = .terminal
    
    // MARK: - Bottom Bar State
    @Published public var isBottomBarExpanded: Bool = false
    @Published public var selectedBottomTab: BottomBarTabModel = .terminal
    @Published public var bottomPanelHeight: CGFloat = 250
    
    // MARK: - Editor State
    @Published public var openTabs: [EditorTab] = []
    @Published public var activeTabId: UUID?
    @Published public var splitEditorEnabled: Bool = false
    @Published public var secondaryActiveTabId: UUID?
    
    // MARK: - Sidebar State
    @Published public var isLeftSidebarOpen: Bool = true
    @Published public var leftSidebarWidth: CGFloat = 280
    @Published public var isRightSidebarOpen: Bool = false
    @Published public var rightSidebarWidth: CGFloat = 300
    
    // MARK: - User Patterns (from DataKit)
    @Published public var userPatterns: UserInteractionPattern = UserInteractionPattern()
    
    // MARK: - Animation
    @Published public var animationSpeed: Double = 1.0
    @Published public var useSpringAnimations: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupPatternTracking()
    }
    
    // MARK: - Chat Actions
    
    public func toggleChat() {
        withAnimation(workspaceAnimation) {
            isChatOpen.toggle()
            if isChatOpen {
                isInputPanelVisible = true
                userPatterns.lastChatOpenTime = Date()
                userPatterns.chatOpenCount += 1
            }
        }
    }
    
    public func openChat() {
        withAnimation(workspaceAnimation) {
            isChatOpen = true
            isChatExpanded = true
            isInputPanelVisible = true
            userPatterns.lastChatOpenTime = Date()
            userPatterns.chatOpenCount += 1
        }
    }
    
    public func closeChat() {
        withAnimation(workspaceAnimation) {
            isChatOpen = false
        }
    }
    
    // MARK: - Input Panel Actions
    
    public func toggleInputPanel() {
        withAnimation(workspaceAnimation) {
            isInputPanelVisible.toggle()
        }
    }
    
    public func minimizeInputPanel() {
        withAnimation(workspaceAnimation) {
            isInputPanelVisible = true
        }
    }
    
    public func expandInputPanel() {
        withAnimation(workspaceAnimation) {
            isInputPanelVisible = true
            isBottomBarExpanded = true
        }
    }
    
    // MARK: - Bottom Bar Actions
    
    public func selectBottomTab(_ tab: BottomBarTabModel) {
        withAnimation(workspaceAnimation) {
            selectedBottomTab = tab
            if !isBottomBarExpanded {
                isBottomBarExpanded = true
            }
        }
    }
    
    public func toggleBottomBar() {
        withAnimation(workspaceAnimation) {
            isBottomBarExpanded.toggle()
        }
    }
    
    // MARK: - Editor Tab Actions
    
    public func openFile(_ path: String) {
        if let existing = openTabs.first(where: { $0.filePath == path }) {
            activeTabId = existing.id
            return
        }
        
        let tab = EditorTab.forFile(path)
        withAnimation(workspaceAnimation) {
            openTabs.append(tab)
            activeTabId = tab.id
        }
        
        if !userPatterns.frequentlyUsedFiles.contains(path) {
            userPatterns.frequentlyUsedFiles.append(path)
            if userPatterns.frequentlyUsedFiles.count > 20 {
                userPatterns.frequentlyUsedFiles.removeFirst()
            }
        }
        userPatterns.lastActiveEditor = path
    }
    
    public func closeTab(_ tabId: UUID) {
        withAnimation(workspaceAnimation) {
            openTabs.removeAll { $0.id == tabId }
            if activeTabId == tabId {
                activeTabId = openTabs.last?.id
            }
        }
    }
    
    public func closeAllTabs() {
        withAnimation(workspaceAnimation) {
            openTabs.removeAll { !$0.isPinned }
            activeTabId = openTabs.first?.id
        }
    }
    
    // MARK: - Animation Helpers
    
    public var workspaceAnimation: Animation {
        if useSpringAnimations {
            return .spring(response: 0.35 * animationSpeed, dampingFraction: 0.8)
        } else {
            return .easeInOut(duration: 0.25 * animationSpeed)
        }
    }
    
    public var quickAnimation: Animation {
        if useSpringAnimations {
            return .spring(response: 0.2 * animationSpeed, dampingFraction: 0.85)
        } else {
            return .easeOut(duration: 0.15 * animationSpeed)
        }
    }
    
    // MARK: - Pattern Tracking
    
    private func setupPatternTracking() {
        $isChatOpen
            .sink { [weak self] isOpen in
                if isOpen {
                    self?.userPatterns.lastChatOpenTime = Date()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Layout Calculations
    
    public func contentWidth(totalWidth: CGFloat, leftSidebarWidth: CGFloat) -> CGFloat {
        var width = totalWidth - leftSidebarWidth
        if isChatOpen {
            width -= chatWidth
        }
        return max(width, 400)
    }
    
    public var panelInset: CGFloat { 12 }
}

// MARK: - Notification Names

public extension Notification.Name {
    static let workspaceLayoutChanged = Notification.Name("workspaceLayoutChanged")
    static let editorTabChanged = Notification.Name("editorTabChanged")
    static let chatToggled = Notification.Name("chatToggled")
}
