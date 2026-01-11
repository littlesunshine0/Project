//
//  FlowColorSystem.swift
//  FlowKit
//
//  Advanced color system with dynamic theming, gradients, and effects
//

import SwiftUI

// MARK: - Color Palette

public struct FlowPalette {
    
    // MARK: - Base Colors (HSL-based for consistency)
    
    public struct Base {
        // Neutrals
        public static let gray50 = Color(hue: 0, saturation: 0, brightness: 0.98)
        public static let gray100 = Color(hue: 0, saturation: 0, brightness: 0.96)
        public static let gray200 = Color(hue: 0, saturation: 0, brightness: 0.90)
        public static let gray300 = Color(hue: 0, saturation: 0, brightness: 0.80)
        public static let gray400 = Color(hue: 0, saturation: 0, brightness: 0.65)
        public static let gray500 = Color(hue: 0, saturation: 0, brightness: 0.50)
        public static let gray600 = Color(hue: 0, saturation: 0, brightness: 0.35)
        public static let gray700 = Color(hue: 0, saturation: 0, brightness: 0.25)
        public static let gray800 = Color(hue: 0, saturation: 0, brightness: 0.15)
        public static let gray900 = Color(hue: 0, saturation: 0, brightness: 0.10)
        public static let gray950 = Color(hue: 0, saturation: 0, brightness: 0.05)
        
        // Brand colors
        public static let primary = Color(hue: 0.6, saturation: 0.8, brightness: 0.65)      // Blue
        public static let secondary = Color(hue: 0.75, saturation: 0.7, brightness: 0.6)    // Purple
        public static let accent = Color(hue: 0.55, saturation: 0.9, brightness: 0.7)       // Cyan
    }
    
    // MARK: - Semantic Colors
    
    public struct Semantic {
        public static func background(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Base.gray950 : Base.gray50
        }
        
        public static func surface(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Base.gray900 : Color.white
        }
        
        public static func elevated(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Base.gray800 : Base.gray100
        }
        
        public static func floating(_ scheme: ColorScheme) -> Color {
            scheme == .dark 
                ? Color(hue: 0, saturation: 0, brightness: 0.12)
                : Color.white
        }
        
        public static func overlay(_ scheme: ColorScheme) -> Color {
            scheme == .dark
                ? Color.black.opacity(0.6)
                : Color.black.opacity(0.3)
        }
    }
    
    // MARK: - Text Colors
    
    public struct Text {
        public static func primary(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Base.gray100 : Base.gray900
        }
        
        public static func secondary(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Base.gray400 : Base.gray600
        }
        
        public static func tertiary(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Base.gray500 : Base.gray500
        }
        
        public static func disabled(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Base.gray600 : Base.gray400
        }
        
        public static func inverse(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Base.gray900 : Base.gray100
        }
    }
    
    // MARK: - Border Colors
    
    public struct Border {
        public static func subtle(_ scheme: ColorScheme) -> Color {
            scheme == .dark
                ? Color.white.opacity(0.06)
                : Color.black.opacity(0.06)
        }
        
        public static func medium(_ scheme: ColorScheme) -> Color {
            scheme == .dark
                ? Color.white.opacity(0.12)
                : Color.black.opacity(0.12)
        }
        
        public static func strong(_ scheme: ColorScheme) -> Color {
            scheme == .dark
                ? Color.white.opacity(0.2)
                : Color.black.opacity(0.2)
        }
        
        public static func focus(_ scheme: ColorScheme) -> Color {
            Base.primary.opacity(0.5)
        }
    }
    
    // MARK: - Status Colors
    
    public struct Status {
        public static let success = Color(hue: 0.38, saturation: 0.7, brightness: 0.55)
        public static let warning = Color(hue: 0.1, saturation: 0.85, brightness: 0.65)
        public static let error = Color(hue: 0.0, saturation: 0.75, brightness: 0.6)
        public static let info = Color(hue: 0.58, saturation: 0.7, brightness: 0.6)
        
        public static func successBackground(_ scheme: ColorScheme) -> Color {
            success.opacity(scheme == .dark ? 0.15 : 0.1)
        }
        
        public static func warningBackground(_ scheme: ColorScheme) -> Color {
            warning.opacity(scheme == .dark ? 0.15 : 0.1)
        }
        
        public static func errorBackground(_ scheme: ColorScheme) -> Color {
            error.opacity(scheme == .dark ? 0.15 : 0.1)
        }
        
        public static func infoBackground(_ scheme: ColorScheme) -> Color {
            info.opacity(scheme == .dark ? 0.15 : 0.1)
        }
    }
    
    // MARK: - Category Colors
    
    public struct Category {
        public static let chat = Color(hue: 0.75, saturation: 0.7, brightness: 0.65)        // Purple
        public static let terminal = Color(hue: 0.45, saturation: 0.6, brightness: 0.5)     // Teal
        public static let editor = Color(hue: 0.6, saturation: 0.6, brightness: 0.6)        // Blue
        public static let explorer = Color(hue: 0.1, saturation: 0.7, brightness: 0.6)      // Orange
        public static let search = Color(hue: 0.55, saturation: 0.8, brightness: 0.6)       // Cyan
        public static let debug = Color(hue: 0.0, saturation: 0.7, brightness: 0.6)         // Red
        public static let preview = Color(hue: 0.38, saturation: 0.6, brightness: 0.55)     // Green
    }
}


// MARK: - Gradient Presets

public struct FlowGradients {
    
    /// Subtle surface gradient for depth
    public static func surface(_ scheme: ColorScheme) -> LinearGradient {
        LinearGradient(
            colors: [
                FlowPalette.Semantic.surface(scheme),
                FlowPalette.Semantic.surface(scheme).opacity(0.95)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Panel header gradient
    public static func panelHeader(_ scheme: ColorScheme, accent: Color) -> LinearGradient {
        LinearGradient(
            colors: [
                accent.opacity(scheme == .dark ? 0.08 : 0.05),
                Color.clear
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// Glow effect gradient
    public static func glow(_ color: Color) -> RadialGradient {
        RadialGradient(
            colors: [color.opacity(0.4), color.opacity(0)],
            center: .center,
            startRadius: 0,
            endRadius: 50
        )
    }
    
    /// Chat bubble gradient
    public static func chatBubble(isUser: Bool, scheme: ColorScheme) -> LinearGradient {
        if isUser {
            return LinearGradient(
                colors: [FlowPalette.Category.chat, FlowPalette.Category.chat.opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [
                    FlowPalette.Semantic.elevated(scheme),
                    FlowPalette.Semantic.elevated(scheme).opacity(0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    /// Toolbar background gradient
    public static func toolbar(_ scheme: ColorScheme) -> LinearGradient {
        LinearGradient(
            colors: [
                FlowPalette.Semantic.elevated(scheme),
                FlowPalette.Semantic.elevated(scheme).opacity(0.98)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Accent highlight gradient
    public static func accentHighlight(_ color: Color) -> LinearGradient {
        LinearGradient(
            colors: [color, color.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Glass morphism effect
    public static func glass(_ scheme: ColorScheme) -> some View {
        ZStack {
            FlowPalette.Semantic.floating(scheme)
            
            LinearGradient(
                colors: [
                    Color.white.opacity(scheme == .dark ? 0.05 : 0.3),
                    Color.white.opacity(0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

// MARK: - Shadow Presets

public struct FlowShadows {
    
    public static func small(_ scheme: ColorScheme) -> some View {
        Color.black.opacity(scheme == .dark ? 0.3 : 0.1)
            .blur(radius: 4)
            .offset(y: 2)
    }
    
    public static func medium(_ scheme: ColorScheme) -> some View {
        Color.black.opacity(scheme == .dark ? 0.4 : 0.15)
            .blur(radius: 10)
            .offset(y: 4)
    }
    
    public static func large(_ scheme: ColorScheme) -> some View {
        Color.black.opacity(scheme == .dark ? 0.5 : 0.2)
            .blur(radius: 20)
            .offset(y: 8)
    }
    
    public static func floating(_ scheme: ColorScheme) -> some View {
        Color.black.opacity(scheme == .dark ? 0.5 : 0.15)
            .blur(radius: 25)
            .offset(x: -4, y: 4)
    }
    
    public static func glow(_ color: Color, intensity: Double = 0.5) -> some View {
        color.opacity(intensity)
            .blur(radius: 15)
    }
}

// MARK: - View Modifiers

public struct GlassMorphismModifier: ViewModifier {
    let colorScheme: ColorScheme
    let cornerRadius: CGFloat
    
    public func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    FlowPalette.Semantic.floating(colorScheme)
                    
                    LinearGradient(
                        colors: [
                            Color.white.opacity(colorScheme == .dark ? 0.08 : 0.5),
                            Color.white.opacity(0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(colorScheme == .dark ? 0.15 : 0.5),
                                Color.white.opacity(colorScheme == .dark ? 0.05 : 0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

public struct AccentBorderModifier: ViewModifier {
    let color: Color
    let colorScheme: ColorScheme
    let cornerRadius: CGFloat
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                color.opacity(0.4),
                                FlowPalette.Border.medium(colorScheme)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
    }
}

// MARK: - View Extensions

public extension View {
    func glassMorphism(colorScheme: ColorScheme, cornerRadius: CGFloat = 16) -> some View {
        modifier(GlassMorphismModifier(colorScheme: colorScheme, cornerRadius: cornerRadius))
    }
    
    func accentBorder(color: Color, colorScheme: ColorScheme, cornerRadius: CGFloat = 12) -> some View {
        modifier(AccentBorderModifier(color: color, colorScheme: colorScheme, cornerRadius: cornerRadius))
    }
    
    func floatingShadow(_ scheme: ColorScheme) -> some View {
        self.shadow(
            color: Color.black.opacity(scheme == .dark ? 0.5 : 0.15),
            radius: 20,
            x: -4,
            y: 4
        )
    }
    
    func subtleShadow(_ scheme: ColorScheme) -> some View {
        self.shadow(
            color: Color.black.opacity(scheme == .dark ? 0.3 : 0.1),
            radius: 8,
            x: 0,
            y: 2
        )
    }
}
