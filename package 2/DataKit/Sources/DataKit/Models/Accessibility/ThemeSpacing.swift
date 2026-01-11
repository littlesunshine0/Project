//
//  ThemeSpacing.swift
//  DataKit
//

import Foundation

public struct ThemeSpacing: Codable, Sendable, Hashable {
    public let xs: Double
    public let sm: Double
    public let md: Double
    public let lg: Double
    public let xl: Double
    
    public init(xs: Double = 4, sm: Double = 8, md: Double = 16, lg: Double = 24, xl: Double = 32) {
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
    }
}
