//
//  ThemeModel.swift
//  DataKit
//

import Foundation

/// Theme configuration
public struct ThemeModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let appearance: Appearance
    public let colors: ThemeColors
    public let typography: ThemeTypography
    public let spacing: ThemeSpacing
    public let cornerRadius: ThemeCornerRadius
    
    public init(id: String, name: String, appearance: Appearance = .system, colors: ThemeColors = ThemeColors(), typography: ThemeTypography = ThemeTypography(), spacing: ThemeSpacing = ThemeSpacing(), cornerRadius: ThemeCornerRadius = ThemeCornerRadius()) {
        self.id = id
        self.name = name
        self.appearance = appearance
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.cornerRadius = cornerRadius
    }
}
