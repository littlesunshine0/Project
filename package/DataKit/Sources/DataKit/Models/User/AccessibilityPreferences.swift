//
//  AccessibilityPreferences.swift
//  DataKit
//

import Foundation

public struct AccessibilityPreferences: Codable, Sendable, Hashable {
    public let reduceMotion: Bool
    public let increaseContrast: Bool
    public let largerText: Bool
    public let voiceOverEnabled: Bool
    
    public init(reduceMotion: Bool = false, increaseContrast: Bool = false, largerText: Bool = false, voiceOverEnabled: Bool = false) {
        self.reduceMotion = reduceMotion
        self.increaseContrast = increaseContrast
        self.largerText = largerText
        self.voiceOverEnabled = voiceOverEnabled
    }
}
