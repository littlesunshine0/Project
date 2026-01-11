//
//  GuideModel.swift
//  DataKit
//

import Foundation

/// Guide model
public struct GuideModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let description: String
    public let steps: [GuideStep]
    public let difficulty: Difficulty
    public let estimatedTime: TimeInterval
    
    public init(id: String = UUID().uuidString, title: String, description: String = "", steps: [GuideStep] = [], difficulty: Difficulty = .beginner, estimatedTime: TimeInterval = 300) {
        self.id = id
        self.title = title
        self.description = description
        self.steps = steps
        self.difficulty = difficulty
        self.estimatedTime = estimatedTime
    }
}
