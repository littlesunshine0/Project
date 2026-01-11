//
//  PrivacyPreferences.swift
//  DataKit
//

import Foundation

public struct PrivacyPreferences: Codable, Sendable, Hashable {
    public let analyticsEnabled: Bool
    public let crashReportsEnabled: Bool
    public let personalizedContent: Bool
    
    public init(analyticsEnabled: Bool = true, crashReportsEnabled: Bool = true, personalizedContent: Bool = true) {
        self.analyticsEnabled = analyticsEnabled
        self.crashReportsEnabled = crashReportsEnabled
        self.personalizedContent = personalizedContent
    }
}
