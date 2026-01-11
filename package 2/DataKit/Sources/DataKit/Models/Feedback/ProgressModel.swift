//
//  ProgressModel.swift
//  DataKit
//

import Foundation

/// Progress model for tracking operations
public struct ProgressModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public var current: Double
    public let total: Double
    public let unit: String?
    public var status: ProgressStatus
    public let startedAt: Date
    public var completedAt: Date?
    
    public init(id: String = UUID().uuidString, title: String, current: Double = 0, total: Double = 100, unit: String? = nil, status: ProgressStatus = .pending) {
        self.id = id
        self.title = title
        self.current = current
        self.total = total
        self.unit = unit
        self.status = status
        self.startedAt = Date()
    }
    
    public var percentage: Double {
        guard total > 0 else { return 0 }
        return min(current / total, 1.0)
    }
    
    public var isComplete: Bool {
        current >= total || status == .completed
    }
}
