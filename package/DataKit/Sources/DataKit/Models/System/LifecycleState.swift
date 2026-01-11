//
//  LifecycleState.swift
//  DataKit
//

import Foundation

public enum LifecycleState: String, Codable, Sendable, CaseIterable {
    case uninitialized, initializing, ready, running, paused, stopping, stopped, error
}
