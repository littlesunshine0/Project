//
//  AchievementModel.swift
//  DataKit
//

import Foundation

/// Achievement model for gamification
public struct AchievementModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let icon: String
    public let points: Int
    public var isUnlocked: Bool
    public var unlockedAt: Date?
    public let progress: Double
    
    public init(id: String, name: String, description: String, icon: String = "star.fill", points: Int = 0, isUnlocked: Bool = false, progress: Double = 0) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.points = points
        self.isUnlocked = isUnlocked
        self.unlockedAt = isUnlocked ? Date() : nil
        self.progress = progress
    }
}
