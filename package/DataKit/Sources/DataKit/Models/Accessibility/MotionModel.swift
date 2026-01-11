//
//  MotionModel.swift
//  DataKit
//

import Foundation

/// Motion preferences
public struct MotionModel: Codable, Sendable, Hashable {
    public let reduceMotion: Bool
    public let autoplayAnimations: Bool
    public let parallaxEffects: Bool
    public let transitionDuration: TimeInterval
    
    public init(reduceMotion: Bool = false, autoplayAnimations: Bool = true, parallaxEffects: Bool = true, transitionDuration: TimeInterval = 0.3) {
        self.reduceMotion = reduceMotion
        self.autoplayAnimations = autoplayAnimations
        self.parallaxEffects = parallaxEffects
        self.transitionDuration = transitionDuration
    }
    
    public static let reduced = MotionModel(reduceMotion: true, autoplayAnimations: false, parallaxEffects: false, transitionDuration: 0.1)
    public static let standard = MotionModel()
}
