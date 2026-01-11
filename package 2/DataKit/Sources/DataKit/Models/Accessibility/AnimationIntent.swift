//
//  AnimationIntent.swift
//  DataKit
//

import Foundation

/// Animation intent for semantic animations
public struct AnimationIntent: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: AnimationType
    public let duration: TimeInterval
    public let curve: AnimationCurve
    public let delay: TimeInterval
    public let repeatCount: Int
    
    public init(id: String = UUID().uuidString, type: AnimationType, duration: TimeInterval = 0.3, curve: AnimationCurve = .easeInOut, delay: TimeInterval = 0, repeatCount: Int = 1) {
        self.id = id
        self.type = type
        self.duration = duration
        self.curve = curve
        self.delay = delay
        self.repeatCount = repeatCount
    }
}
