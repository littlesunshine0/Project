//
//  FallbackModel.swift
//  DataKit
//

import Foundation

/// Fallback model for graceful degradation
public struct FallbackModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let originalAction: String
    public let fallbackAction: String
    public let reason: String
    public let isAutomatic: Bool
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, originalAction: String, fallbackAction: String, reason: String, isAutomatic: Bool = true) {
        self.id = id
        self.originalAction = originalAction
        self.fallbackAction = fallbackAction
        self.reason = reason
        self.isAutomatic = isAutomatic
        self.timestamp = Date()
    }
}
