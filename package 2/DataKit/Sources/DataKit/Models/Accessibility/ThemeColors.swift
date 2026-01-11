//
//  ThemeColors.swift
//  DataKit
//

import Foundation

public struct ThemeColors: Codable, Sendable, Hashable {
    public let primary: ColorModel
    public let secondary: ColorModel
    public let accent: ColorModel
    public let background: ColorModel
    public let surface: ColorModel
    public let error: ColorModel
    public let warning: ColorModel
    public let success: ColorModel
    public let info: ColorModel
    
    public init(
        primary: ColorModel = ColorModel(hex: "#007AFF"),
        secondary: ColorModel = ColorModel(hex: "#5856D6"),
        accent: ColorModel = ColorModel(hex: "#FF9500"),
        background: ColorModel = ColorModel(hex: "#FFFFFF"),
        surface: ColorModel = ColorModel(hex: "#F2F2F7"),
        error: ColorModel = ColorModel(hex: "#FF3B30"),
        warning: ColorModel = ColorModel(hex: "#FF9500"),
        success: ColorModel = ColorModel(hex: "#34C759"),
        info: ColorModel = ColorModel(hex: "#5AC8FA")
    ) {
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
        self.background = background
        self.surface = surface
        self.error = error
        self.warning = warning
        self.success = success
        self.info = info
    }
}
