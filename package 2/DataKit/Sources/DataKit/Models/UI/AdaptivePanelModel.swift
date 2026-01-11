//
//  AdaptivePanelModel.swift
//  DataKit
//
//  Adaptive panel system that learns from user behavior
//  ML-visible, can be reasoned about, validated, and automated
//

import Foundation

// MARK: - Panel Usage Event

/// Records a single panel interaction event
public struct PanelUsageEvent: Codable, Sendable, Identifiable {
    public let id: String
    public let panelType: SidebarContentTypeModel
    public let action: PanelAction
    public let timestamp: Date
    public let duration: TimeInterval?  // How long panel was open
    public let context: PanelContext
    public let triggeredBy: PanelTrigger
    
    public init(
        id: String = UUID().uuidString,
        panelType: SidebarContentTypeModel,
        action: PanelAction,
        timestamp: Date = Date(),
        duration: TimeInterval? = nil,
        context: PanelContext = PanelContext(),
        triggeredBy: PanelTrigger = .manual
    ) {
        self.id = id
        self.panelType = panelType
        self.action = action
        self.timestamp = timestamp
        self.duration = duration
        self.context = context
        self.triggeredBy = triggeredBy
    }
}

/// Actions that can be performed on panels
public enum PanelAction: String, Codable, Sendable {
    case opened
    case closed
    case expanded
    case collapsed
    case splitAdded
    case splitRemoved
    case resized
    case focused
    case interacted  // User interacted with content
}

/// What triggered the panel action
public enum PanelTrigger: String, Codable, Sendable {
    case manual          // User clicked
    case keyboard        // Keyboard shortcut
    case contextual      // System suggested based on context
    case workflow        // Part of a workflow
    case notification    // Notification triggered it
    case automatic       // System auto-opened
}

/// Context when panel was used
public struct PanelContext: Codable, Sendable {
    public var activeFile: String?
    public var activeFileType: String?
    public var primaryNavItem: String?
    public var timeOfDay: TimeOfDay
    public var sessionDuration: TimeInterval
    public var otherOpenPanels: [String]
    
    public init(
        activeFile: String? = nil,
        activeFileType: String? = nil,
        primaryNavItem: String? = nil,
        timeOfDay: TimeOfDay = .afternoon,
        sessionDuration: TimeInterval = 0,
        otherOpenPanels: [String] = []
    ) {
        self.activeFile = activeFile
        self.activeFileType = activeFileType
        self.primaryNavItem = primaryNavItem
        self.timeOfDay = timeOfDay
        self.sessionDuration = sessionDuration
        self.otherOpenPanels = otherOpenPanels
    }
}

public enum TimeOfDay: String, Codable, Sendable {
    case morning    // 6am - 12pm
    case afternoon  // 12pm - 6pm
    case evening    // 6pm - 10pm
    case night      // 10pm - 6am
    
    public static func current() -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return .morning
        case 12..<18: return .afternoon
        case 18..<22: return .evening
        default: return .night
        }
    }
}

// MARK: - Panel Usage Statistics

/// Aggregated statistics for a panel type
public struct PanelUsageStats: Codable, Sendable, Identifiable {
    public let id: String
    public let panelType: SidebarContentTypeModel
    public var totalOpens: Int
    public var totalDuration: TimeInterval
    public var averageDuration: TimeInterval
    public var lastUsed: Date?
    public var usageByTimeOfDay: [TimeOfDay: Int]
    public var usageByFileType: [String: Int]
    public var usageByNavItem: [String: Int]
    public var commonPairings: [SidebarContentTypeModel: Int]
    public var preferredPosition: SidebarPanelPosition?
    
    public init(panelType: SidebarContentTypeModel) {
        self.id = panelType.rawValue
        self.panelType = panelType
        self.totalOpens = 0
        self.totalDuration = 0
        self.averageDuration = 0
        self.lastUsed = nil
        self.usageByTimeOfDay = [:]
        self.usageByFileType = [:]
        self.usageByNavItem = [:]
        self.commonPairings = [:]
        self.preferredPosition = nil
    }
    
    /// Usage score (0-100) based on recency and frequency
    public var usageScore: Double {
        let frequencyScore = min(Double(totalOpens) / 100.0, 1.0) * 50
        let recencyScore: Double
        if let lastUsed = lastUsed {
            let hoursSinceUse = Date().timeIntervalSince(lastUsed) / 3600
            recencyScore = max(0, 50 - hoursSinceUse)
        } else {
            recencyScore = 0
        }
        return frequencyScore + recencyScore
    }
}

// MARK: - Panel Pairing

/// A pairing of two sidebar content types for split view
public struct PanelPairing: Codable, Sendable, Equatable {
    public let first: SidebarContentTypeModel
    public let second: SidebarContentTypeModel
    
    public init(first: SidebarContentTypeModel, second: SidebarContentTypeModel) {
        self.first = first
        self.second = second
    }
}

// MARK: - Adaptive Panel Configuration

/// Configuration that adapts based on user behavior
public struct AdaptivePanelConfig: Codable, Sendable, Identifiable {
    public let id: String
    public var rightSidebarPanels: [SidebarContentTypeModel]
    public var bottomPanelTabs: [BottomPanelTabTypeModel]
    public var defaultRightSidebarMode: RightSidebarModeModel
    public var defaultBottomPanelTab: BottomPanelTabTypeModel
    public var autoShowChat: Bool
    public var autoShowTerminal: Bool
    public var autoShowProblems: Bool
    public var suggestedPairings: [PanelPairing]
    public var panelPriorities: [String: Int]  // Using String keys for Codable
    
    public init(
        id: String = UUID().uuidString,
        rightSidebarPanels: [SidebarContentTypeModel] = [.chat, .notifications, .documentation],
        bottomPanelTabs: [BottomPanelTabTypeModel] = [.terminal, .output, .problems, .debug],
        defaultRightSidebarMode: RightSidebarModeModel = .minimized,
        defaultBottomPanelTab: BottomPanelTabTypeModel = .terminal,
        autoShowChat: Bool = false,
        autoShowTerminal: Bool = false,
        autoShowProblems: Bool = true,
        suggestedPairings: [PanelPairing] = [],
        panelPriorities: [String: Int] = [:]
    ) {
        self.id = id
        self.rightSidebarPanels = rightSidebarPanels
        self.bottomPanelTabs = bottomPanelTabs
        self.defaultRightSidebarMode = defaultRightSidebarMode
        self.defaultBottomPanelTab = defaultBottomPanelTab
        self.autoShowChat = autoShowChat
        self.autoShowTerminal = autoShowTerminal
        self.autoShowProblems = autoShowProblems
        self.suggestedPairings = suggestedPairings
        self.panelPriorities = panelPriorities
    }
    
    /// Get priority for a panel type
    public func priority(for panel: SidebarContentTypeModel) -> Int {
        panelPriorities[panel.rawValue] ?? 0
    }
}

/// Bottom panel tab types
public enum BottomPanelTabTypeModel: String, CaseIterable, Codable, Sendable, Identifiable {
    case terminal
    case output
    case problems
    case debug
    case search
    case console
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .terminal: return "Terminal"
        case .output: return "Output"
        case .problems: return "Problems"
        case .debug: return "Debug"
        case .search: return "Search"
        case .console: return "Console"
        }
    }
    
    public var icon: String {
        switch self {
        case .terminal: return "terminal.fill"
        case .output: return "doc.text.fill"
        case .problems: return "exclamationmark.triangle.fill"
        case .debug: return "ant.fill"
        case .search: return "magnifyingglass"
        case .console: return "text.alignleft"
        }
    }
    
    public var colorCategory: String {
        switch self {
        case .terminal: return "commands"
        case .output: return "info"
        case .problems: return "warning"
        case .debug: return "error"
        case .search: return "search"
        case .console: return "neutral"
        }
    }
}

// MARK: - Panel Recommendation

/// A recommendation for panel configuration
public struct PanelRecommendation: Codable, Sendable, Identifiable {
    public let id: String
    public let type: PanelRecommendationType
    public let panels: [SidebarContentTypeModel]
    public let reason: String
    public let confidence: Double  // 0-1
    public let context: PanelContext
    
    public init(
        id: String = UUID().uuidString,
        type: PanelRecommendationType,
        panels: [SidebarContentTypeModel],
        reason: String,
        confidence: Double,
        context: PanelContext = PanelContext()
    ) {
        self.id = id
        self.type = type
        self.panels = panels
        self.reason = reason
        self.confidence = confidence
        self.context = context
    }
}

public enum PanelRecommendationType: String, Codable, Sendable {
    case openPanel
    case closePanel
    case splitPanels
    case switchPanel
    case expandPanel
}

// MARK: - User Panel Preferences

/// User's explicit panel preferences
public struct UserPanelPreferences: Codable, Sendable {
    public var preferredRightSidebarWidth: Double
    public var preferredBottomPanelHeight: Double
    public var preferredSplitRatio: Double
    public var pinnedPanels: [SidebarContentTypeModel]
    public var hiddenPanels: [SidebarContentTypeModel]
    public var keyboardShortcuts: [String: String]  // Panel rawValue -> shortcut
    public var autoHideDelay: TimeInterval  // Auto-hide after inactivity
    public var rememberLastState: Bool
    
    public init(
        preferredRightSidebarWidth: Double = 380,
        preferredBottomPanelHeight: Double = 200,
        preferredSplitRatio: Double = 0.5,
        pinnedPanels: [SidebarContentTypeModel] = [],
        hiddenPanels: [SidebarContentTypeModel] = [],
        keyboardShortcuts: [String: String] = [:],
        autoHideDelay: TimeInterval = 0,  // 0 = never
        rememberLastState: Bool = true
    ) {
        self.preferredRightSidebarWidth = preferredRightSidebarWidth
        self.preferredBottomPanelHeight = preferredBottomPanelHeight
        self.preferredSplitRatio = preferredSplitRatio
        self.pinnedPanels = pinnedPanels
        self.hiddenPanels = hiddenPanels
        self.keyboardShortcuts = keyboardShortcuts
        self.autoHideDelay = autoHideDelay
        self.rememberLastState = rememberLastState
    }
    
    /// Get keyboard shortcut for a panel
    public func shortcut(for panel: SidebarContentTypeModel) -> String? {
        keyboardShortcuts[panel.rawValue]
    }
}
