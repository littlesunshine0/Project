//
//  AppState.swift
//  DataKit
//

import Foundation

/// Global application state
public struct AppState: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public var lifecycle: LifecycleState
    public var isReady: Bool
    public var isOnline: Bool
    public var activePackages: [String]
    public var focusedView: String?
    public let startedAt: Date
    
    public init(id: String = UUID().uuidString, lifecycle: LifecycleState = .uninitialized, isReady: Bool = false, isOnline: Bool = true, activePackages: [String] = [], focusedView: String? = nil) {
        self.id = id
        self.lifecycle = lifecycle
        self.isReady = isReady
        self.isOnline = isOnline
        self.activePackages = activePackages
        self.focusedView = focusedView
        self.startedAt = Date()
    }
}
