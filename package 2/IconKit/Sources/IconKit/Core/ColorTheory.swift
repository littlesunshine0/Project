//
//  ColorTheory.swift
//  IconKit
//
//  Professional color theory system for icon design
//  Includes color harmonies, perceptual uniformity, and accessibility
//

import SwiftUI

// MARK: - Color Theory Foundation

/// Professional color system based on color theory principles
public struct ColorTheory {
    
    // MARK: - HSL Color Model (More intuitive than RGB)
    
    public struct HSLColor: Sendable {
        public let hue: Double        // 0-360
        public let saturation: Double // 0-1
        public let lightness: Double  // 0-1
        public let alpha: Double      // 0-1
        
        public init(hue: Double, saturation: Double, lightness: Double, alpha: Double = 1.0) {
            self.hue = hue.truncatingRemainder(dividingBy: 360)
            self.saturation = min(max(saturation, 0), 1)
            self.lightness = min(max(lightness, 0), 1)
            self.alpha = min(max(alpha, 0), 1)
        }
        
        public var color: Color {
            Color(hue: hue / 360, saturation: saturation, brightness: lightness)
                .opacity(alpha)
        }
        
        // Shift hue by degrees
        public func shiftHue(by degrees: Double) -> HSLColor {
            HSLColor(hue: hue + degrees, saturation: saturation, lightness: lightness, alpha: alpha)
        }
        
        // Adjust saturation
        public func saturate(by amount: Double) -> HSLColor {
            HSLColor(hue: hue, saturation: saturation + amount, lightness: lightness, alpha: alpha)
        }
        
        // Adjust lightness
        public func lighten(by amount: Double) -> HSLColor {
            HSLColor(hue: hue, saturation: saturation, lightness: lightness + amount, alpha: alpha)
        }
    }
    
    // MARK: - Color Harmonies
    
    /// Generate complementary color (opposite on color wheel)
    public static func complementary(_ base: HSLColor) -> HSLColor {
        base.shiftHue(by: 180)
    }
    
    /// Generate split-complementary colors
    public static func splitComplementary(_ base: HSLColor) -> (HSLColor, HSLColor) {
        (base.shiftHue(by: 150), base.shiftHue(by: 210))
    }
    
    /// Generate triadic colors (120° apart)
    public static func triadic(_ base: HSLColor) -> (HSLColor, HSLColor) {
        (base.shiftHue(by: 120), base.shiftHue(by: 240))
    }
    
    /// Generate tetradic/square colors (90° apart)
    public static func tetradic(_ base: HSLColor) -> (HSLColor, HSLColor, HSLColor) {
        (base.shiftHue(by: 90), base.shiftHue(by: 180), base.shiftHue(by: 270))
    }
    
    /// Generate analogous colors (adjacent on wheel)
    public static func analogous(_ base: HSLColor, spread: Double = 30) -> (HSLColor, HSLColor) {
        (base.shiftHue(by: -spread), base.shiftHue(by: spread))
    }
    
    // MARK: - Professional Palettes
    
    /// Kit blue palette - professional, trustworthy, technical
    public static let kitBluePalette = ColorPalette(
        primary: HSLColor(hue: 215, saturation: 0.65, lightness: 0.55),
        secondary: HSLColor(hue: 215, saturation: 0.55, lightness: 0.40),
        tertiary: HSLColor(hue: 215, saturation: 0.75, lightness: 0.30),
        accent: HSLColor(hue: 200, saturation: 0.80, lightness: 0.65),
        highlight: HSLColor(hue: 210, saturation: 0.30, lightness: 0.90)
    )
    
    /// Warm creative palette - for FlowKit
    public static let warmCreativePalette = ColorPalette(
        primary: HSLColor(hue: 30, saturation: 0.90, lightness: 0.55),
        secondary: HSLColor(hue: 340, saturation: 0.75, lightness: 0.50),
        tertiary: HSLColor(hue: 280, saturation: 0.60, lightness: 0.45),
        accent: HSLColor(hue: 45, saturation: 0.95, lightness: 0.65),
        highlight: HSLColor(hue: 40, saturation: 0.20, lightness: 0.95)
    )
    
    /// Idea/innovation palette - for IdeaKit
    public static let ideaPalette = ColorPalette(
        primary: HSLColor(hue: 215, saturation: 0.70, lightness: 0.50),
        secondary: HSLColor(hue: 215, saturation: 0.60, lightness: 0.35),
        tertiary: HSLColor(hue: 220, saturation: 0.80, lightness: 0.25),
        accent: HSLColor(hue: 45, saturation: 0.90, lightness: 0.60),  // Golden accent for "lightbulb moment"
        highlight: HSLColor(hue: 50, saturation: 0.95, lightness: 0.85)
    )
    
    /// Design/creation palette - for IconKit
    public static let designPalette = ColorPalette(
        primary: HSLColor(hue: 215, saturation: 0.65, lightness: 0.52),
        secondary: HSLColor(hue: 215, saturation: 0.55, lightness: 0.38),
        tertiary: HSLColor(hue: 220, saturation: 0.75, lightness: 0.28),
        accent: HSLColor(hue: 180, saturation: 0.70, lightness: 0.55),  // Cyan accent for creativity
        highlight: HSLColor(hue: 190, saturation: 0.60, lightness: 0.80)
    )
}

// MARK: - Color Palette

public struct ColorPalette: Sendable {
    public let primary: ColorTheory.HSLColor
    public let secondary: ColorTheory.HSLColor
    public let tertiary: ColorTheory.HSLColor
    public let accent: ColorTheory.HSLColor
    public let highlight: ColorTheory.HSLColor
    
    public var primaryColor: Color { primary.color }
    public var secondaryColor: Color { secondary.color }
    public var tertiaryColor: Color { tertiary.color }
    public var accentColor: Color { accent.color }
    public var highlightColor: Color { highlight.color }
    
    /// Generate gradient from palette
    public var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [primary.lighten(by: 0.15).color, primary.color, secondary.color],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Deep gradient for backgrounds
    public var deepGradient: LinearGradient {
        LinearGradient(
            colors: [secondary.color, tertiary.color, tertiary.lighten(by: -0.1).color],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Radial glow gradient
    public func glowGradient(intensity: Double = 0.6) -> RadialGradient {
        RadialGradient(
            colors: [
                accent.color.opacity(intensity),
                accent.color.opacity(intensity * 0.5),
                Color.clear
            ],
            center: .center,
            startRadius: 0,
            endRadius: 100
        )
    }
}

// MARK: - Perceptual Color Adjustments

public extension ColorTheory {
    
    /// Adjust color for better perceptual contrast
    static func perceptuallyAdjusted(_ color: HSLColor, forBackground isDark: Bool) -> HSLColor {
        if isDark {
            // On dark backgrounds, increase lightness and slightly reduce saturation
            return color.lighten(by: 0.1).saturate(by: -0.05)
        } else {
            // On light backgrounds, decrease lightness and increase saturation
            return color.lighten(by: -0.1).saturate(by: 0.05)
        }
    }
    
    /// Generate accessible color pair (WCAG AA compliant)
    static func accessiblePair(from base: HSLColor) -> (foreground: HSLColor, background: HSLColor) {
        let darkBg = HSLColor(hue: base.hue, saturation: 0.15, lightness: 0.12)
        let lightFg = HSLColor(hue: base.hue, saturation: 0.10, lightness: 0.95)
        return (lightFg, darkBg)
    }
}

// MARK: - Gradient Generators

public struct GradientFactory {
    
    /// Create smooth multi-stop gradient
    public static func smooth(colors: [Color], angle: Double = 45) -> LinearGradient {
        let startPoint = UnitPoint(
            x: 0.5 - 0.5 * cos(angle * .pi / 180),
            y: 0.5 - 0.5 * sin(angle * .pi / 180)
        )
        let endPoint = UnitPoint(
            x: 0.5 + 0.5 * cos(angle * .pi / 180),
            y: 0.5 + 0.5 * sin(angle * .pi / 180)
        )
        return LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
    }
    
    /// Create depth gradient (for layered effects)
    public static func depth(base: ColorTheory.HSLColor, layers: Int = 3) -> [Color] {
        (0..<layers).map { i in
            let factor = Double(i) / Double(layers - 1)
            return base.lighten(by: -0.15 * factor).saturate(by: -0.1 * factor).color
        }
    }
    
    /// Create glow gradient
    public static func glow(color: Color, intensity: Double = 0.8) -> RadialGradient {
        RadialGradient(
            colors: [
                color.opacity(intensity),
                color.opacity(intensity * 0.6),
                color.opacity(intensity * 0.3),
                color.opacity(intensity * 0.1),
                Color.clear
            ],
            center: .center,
            startRadius: 0,
            endRadius: 100
        )
    }
    
    /// Create metallic gradient
    public static func metallic(base: ColorTheory.HSLColor) -> LinearGradient {
        LinearGradient(
            colors: [
                base.lighten(by: 0.3).saturate(by: -0.3).color,
                base.lighten(by: 0.1).color,
                base.color,
                base.lighten(by: -0.1).color,
                base.lighten(by: 0.15).saturate(by: -0.2).color
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Create glass/frosted gradient
    public static func glass(tint: Color = .white) -> LinearGradient {
        LinearGradient(
            colors: [
                tint.opacity(0.4),
                tint.opacity(0.2),
                tint.opacity(0.05),
                tint.opacity(0.1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
