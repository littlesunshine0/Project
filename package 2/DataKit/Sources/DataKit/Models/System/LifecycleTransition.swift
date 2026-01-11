//
//  LifecycleTransition.swift
//  DataKit
//

import Foundation

public struct LifecycleTransition: Codable, Sendable, Hashable {
    public let from: LifecycleState
    public let to: LifecycleState
    public let timestamp: Date
    
    public init(from: LifecycleState, to: LifecycleState) {
        self.from = from
        self.to = to
        self.timestamp = Date()
    }
}
