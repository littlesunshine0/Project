//
//  PreferenceModel.swift
//  DataKit
//

import Foundation

/// Preference model
public struct PreferenceModel: Codable, Sendable, Hashable {
    public let theme: String
    public let language: String
    public let timezone: String
    public let notifications: NotificationPreferences
    public let accessibility: AccessibilityPreferences
    public let privacy: PrivacyPreferences
    
    public init(
        theme: String = "system",
        language: String = "en",
        timezone: String = "UTC",
        notifications: NotificationPreferences = NotificationPreferences(),
        accessibility: AccessibilityPreferences = AccessibilityPreferences(),
        privacy: PrivacyPreferences = PrivacyPreferences()
    ) {
        self.theme = theme
        self.language = language
        self.timezone = timezone
        self.notifications = notifications
        self.accessibility = accessibility
        self.privacy = privacy
    }
}
