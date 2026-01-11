//
//  MilestoneModel.swift
//  DataKit
//

import Foundation

/// Milestone model
public struct MilestoneModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let description: String
    public let targetDate: Date?
    public var isCompleted: Bool
    public var completedAt: Date?
    
    public init(id: String = UUID().uuidString, title: String, description: String = "", targetDate: Date? = nil, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.targetDate = targetDate
        self.isCompleted = isCompleted
        self.completedAt = nil
    }
}
