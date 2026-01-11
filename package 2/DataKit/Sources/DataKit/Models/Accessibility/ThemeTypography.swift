//
//  ThemeTypography.swift
//  DataKit
//

import Foundation

public struct ThemeTypography: Codable, Sendable, Hashable {
    public let fontFamily: String
    public let baseFontSize: Double
    public let lineHeight: Double
    
    public init(fontFamily: String = "SF Pro", baseFontSize: Double = 16, lineHeight: Double = 1.5) {
        self.fontFamily = fontFamily
        self.baseFontSize = baseFontSize
        self.lineHeight = lineHeight
    }
}
