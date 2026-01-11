//
//  AgentConfig.swift
//  DataKit
//

import Foundation

public struct AgentConfig: Codable, Sendable, Hashable {
    public let autoStart: Bool
    public let priority: AgentPriority
    public let maxConcurrent: Int
    
    public init(autoStart: Bool = false, priority: AgentPriority = .normal, maxConcurrent: Int = 1) {
        self.autoStart = autoStart
        self.priority = priority
        self.maxConcurrent = maxConcurrent
    }
}
