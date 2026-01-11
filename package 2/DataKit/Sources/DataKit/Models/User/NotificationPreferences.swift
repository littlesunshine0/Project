//
//  NotificationPreferences.swift
//  DataKit
//

import Foundation

public struct NotificationPreferences: Codable, Sendable, Hashable {
    public let enabled: Bool
    public let sound: Bool
    public let badge: Bool
    public let preview: Bool
    
    public init(enabled: Bool = true, sound: Bool = true, badge: Bool = true, preview: Bool = true) {
        self.enabled = enabled
        self.sound = sound
        self.badge = badge
        self.preview = preview
    }
}
