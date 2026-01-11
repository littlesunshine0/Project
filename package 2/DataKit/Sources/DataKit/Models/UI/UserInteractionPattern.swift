//
//  UserInteractionPattern.swift
//  DataKit
//
//  Tracks user behavior patterns for intelligent panel placement
//

import Foundation

/// Tracks user behavior patterns for intelligent panel placement
public struct UserInteractionPattern: Codable, Sendable {
    public var lastChatOpenTime: Date?
    public var chatOpenCount: Int
    public var preferredChatPosition: WorkspacePanelPosition
    public var lastTerminalOpenTime: Date?
    public var terminalOpenCount: Int
    public var preferredTerminalPosition: WorkspacePanelPosition
    public var frequentlyUsedFiles: [String]
    public var lastActiveEditor: String?
    public var prefersSplitEditor: Bool
    public var prefersFloatingPanels: Bool
    
    public init(
        lastChatOpenTime: Date? = nil,
        chatOpenCount: Int = 0,
        preferredChatPosition: WorkspacePanelPosition = .right,
        lastTerminalOpenTime: Date? = nil,
        terminalOpenCount: Int = 0,
        preferredTerminalPosition: WorkspacePanelPosition = .bottom,
        frequentlyUsedFiles: [String] = [],
        lastActiveEditor: String? = nil,
        prefersSplitEditor: Bool = false,
        prefersFloatingPanels: Bool = true
    ) {
        self.lastChatOpenTime = lastChatOpenTime
        self.chatOpenCount = chatOpenCount
        self.preferredChatPosition = preferredChatPosition
        self.lastTerminalOpenTime = lastTerminalOpenTime
        self.terminalOpenCount = terminalOpenCount
        self.preferredTerminalPosition = preferredTerminalPosition
        self.frequentlyUsedFiles = frequentlyUsedFiles
        self.lastActiveEditor = lastActiveEditor
        self.prefersSplitEditor = prefersSplitEditor
        self.prefersFloatingPanels = prefersFloatingPanels
    }
}
