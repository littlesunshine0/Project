//
//  ActivityModel.swift
//  DataKit
//

import Foundation

/// Activity model for tracking user actions
public struct ActivityModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: ActivityType
    public let action: String
    public let target: String?
    public let metadata: [String: String]
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, type: ActivityType, action: String, target: String? = nil, metadata: [String: String] = [:]) {
        self.id = id
        self.type = type
        self.action = action
        self.target = target
        self.metadata = metadata
        self.timestamp = Date()
    }
}
