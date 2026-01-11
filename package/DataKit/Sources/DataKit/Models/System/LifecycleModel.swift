//
//  LifecycleModel.swift
//  DataKit
//

import Foundation

/// Lifecycle model for package/component state
public struct LifecycleModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let state: LifecycleState
    public let transitions: [LifecycleTransition]
    public let startedAt: Date?
    public var stoppedAt: Date?
    
    public init(id: String = UUID().uuidString, state: LifecycleState = .uninitialized, transitions: [LifecycleTransition] = []) {
        self.id = id
        self.state = state
        self.transitions = transitions
        self.startedAt = state == .running ? Date() : nil
    }
}
