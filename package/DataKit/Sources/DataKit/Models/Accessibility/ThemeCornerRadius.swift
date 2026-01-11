//
//  ThemeCornerRadius.swift
//  DataKit
//

import Foundation

public struct ThemeCornerRadius: Codable, Sendable, Hashable {
    public let none: Double
    public let sm: Double
    public let md: Double
    public let lg: Double
    public let full: Double
    
    public init(none: Double = 0, sm: Double = 4, md: Double = 8, lg: Double = 16, full: Double = 9999) {
        self.none = none
        self.sm = sm
        self.md = md
        self.lg = lg
        self.full = full
    }
}
