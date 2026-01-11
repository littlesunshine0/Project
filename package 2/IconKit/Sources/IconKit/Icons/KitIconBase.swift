//
//  KitIconBase.swift
//  IconKit
//
//  HIG-Compliant Base Component for Kit Package Icons
//  
//  Design Principles (Apple HIG):
//  - Layered design: Background + foreground layers for depth
//  - Liquid Glass: System applies specular highlights, frostiness
//  - Filled shapes: Solid overlapping shapes, not outlines
//  - Subtle gradients: Top-to-bottom, light-to-dark
//  - Clear edges: No soft/feathered edges
//  - Simplicity: Core concept with minimal shapes
//

import SwiftUI

// MARK: - Kit Design System

/// Professional color palette for Kit icons
/// Based on color theory: Analogous blue palette with golden accent
public struct KitDesignSystem {
    
    // MARK: - Primary Blue Palette (Analogous harmony)
    
    /// Background gradient - subtle top-to-bottom, light-to-dark
    public static let bgGradientTop = Color(red: 0.22, green: 0.35, blue: 0.55)      // #384D8C
    public static let bgGradientMid = Color(red: 0.15, green: 0.25, blue: 0.45)      // #26407A
    public static let bgGradientBottom = Color(red: 0.10, green: 0.18, blue: 0.35)  // #1A2E59
    
    /// Foreground element colors
    public static let fgPrimary = Color(red: 0.45, green: 0.62, blue: 0.85)         // #739ED9
    public static let fgSecondary = Color(red: 0.35, green: 0.52, blue: 0.78)       // #5985C7
    public static let fgTertiary = Color(red: 0.28, green: 0.42, blue: 0.68)        // #476BAD
    
    /// Highlight colors (for Liquid Glass effect simulation)
    public static let highlightTop = Color.white.opacity(0.35)
    public static let highlightMid = Color.white.opacity(0.15)
    public static let highlightEdge = Color.white.opacity(0.08)
    
    /// Shadow/depth colors
    public static let shadowInner = Color.black.opacity(0.15)
    public static let shadowOuter = Color.black.opacity(0.25)
    
    // MARK: - Accent Colors (Split-complementary)
    
    /// Golden accent for IdeaKit (lightbulb glow)
    public static let accentGold = Color(red: 0.95, green: 0.78, blue: 0.35)        // #F2C759
    public static let accentGoldBright = Color(red: 1.0, green: 0.88, blue: 0.55)   // #FFE08C
    
    /// Cyan accent for IconKit (creative spark)
    public static let accentCyan = Color(red: 0.45, green: 0.82, blue: 0.88)        // #73D1E0
    public static let accentCyanBright = Color(red: 0.65, green: 0.92, blue: 0.95)  // #A6EBF2
    
    // MARK: - Gradients
    
    /// Background gradient (HIG: subtle top-to-bottom, light-to-dark)
    public static var backgroundGradient: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: bgGradientTop, location: 0.0),
                .init(color: bgGradientMid, location: 0.5),
                .init(color: bgGradientBottom, location: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Foreground element gradient
    public static var foregroundGradient: LinearGradient {
        LinearGradient(
            colors: [fgPrimary, fgSecondary, fgTertiary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Liquid Glass highlight overlay
    public static var liquidGlassHighlight: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: highlightTop, location: 0.0),
                .init(color: highlightMid, location: 0.3),
                .init(color: Color.clear, location: 0.6),
                .init(color: highlightEdge, location: 1.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - HIG-Compliant Squircle Shape

/// Continuous corner squircle matching iOS icon shape
/// Uses superellipse formula for mathematically smooth corners
public struct HIGSquircle: InsettableShape {
    var insetAmount: CGFloat = 0
    
    public init() {}
    
    public func path(in rect: CGRect) -> Path {
        let insetRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let cornerRadius = min(insetRect.width, insetRect.height) * 0.2237
        return Path(roundedRect: insetRect, cornerRadius: cornerRadius, style: .continuous)
    }
    
    public func inset(by amount: CGFloat) -> HIGSquircle {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}

/// Inset squircle for layered depth effect
public struct HIGSquircleInset: Shape {
    let insetRatio: CGFloat
    
    public init(insetRatio: CGFloat = 0.08) {
        self.insetRatio = insetRatio
    }
    
    public func path(in rect: CGRect) -> Path {
        let inset = min(rect.width, rect.height) * insetRatio
        let insetRect = rect.insetBy(dx: inset, dy: inset)
        let cornerRadius = min(insetRect.width, insetRect.height) * 0.2237
        return Path(roundedRect: insetRect, cornerRadius: cornerRadius, style: .continuous)
    }
}

// MARK: - Kit Icon Base View

/// HIG-Compliant base for all Kit package icons
/// Provides layered background with Liquid Glass styling
public struct KitIconBase<Symbol: View>: View {
    public let size: CGFloat
    public let symbol: Symbol
    public let variant: IconVariantType
    
    public init(
        size: CGFloat,
        variant: IconVariantType = .inApp,
        @ViewBuilder symbol: () -> Symbol
    ) {
        self.size = size
        self.variant = variant
        self.symbol = symbol()
    }
    
    public var body: some View {
        switch variant {
        case .solidBlack:
            solidBlackVersion
        case .solidWhite:
            solidWhiteVersion
        case .outline:
            outlineVersion
        case .highContrast, .accessible:
            accessibleVersion
        case .darkMode:
            darkModeVersion
        case .lightMode:
            lightModeVersion
        default:
            standardVersion
        }
    }
    
    // MARK: - Standard Version (HIG Liquid Glass Style)
    
    private var standardVersion: some View {
        ZStack {
            // Layer 1: Background with gradient
            HIGSquircle()
                .fill(KitDesignSystem.backgroundGradient)
            
            // Layer 2: Inner depth layer
            HIGSquircleInset(insetRatio: 0.06)
                .fill(
                    LinearGradient(
                        colors: [
                            KitDesignSystem.bgGradientMid,
                            KitDesignSystem.bgGradientBottom.opacity(0.9)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Layer 3: Liquid Glass highlight (top-left specular)
            HIGSquircle()
                .fill(KitDesignSystem.liquidGlassHighlight)
            
            // Layer 4: Edge highlight (subtle rim light)
            HIGSquircle()
                .strokeBorder(
                    LinearGradient(
                        stops: [
                            .init(color: Color.white.opacity(0.25), location: 0.0),
                            .init(color: Color.white.opacity(0.08), location: 0.3),
                            .init(color: Color.clear, location: 0.5),
                            .init(color: Color.white.opacity(0.05), location: 1.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: size * 0.01
                )
            
            // Layer 5: Symbol (foreground)
            symbol
                .frame(width: size * 0.55, height: size * 0.55)
        }
        .frame(width: size, height: size)
    }
    
    // MARK: - Solid Black (Monochrome)
    
    private var solidBlackVersion: some View {
        ZStack {
            HIGSquircle()
                .fill(Color.black)
            
            symbol
                .frame(width: size * 0.55, height: size * 0.55)
                .foregroundStyle(Color.black.opacity(0.8))
        }
        .frame(width: size, height: size)
        .colorMultiply(.black)
    }
    
    // MARK: - Solid White (Monochrome)
    
    private var solidWhiteVersion: some View {
        ZStack {
            HIGSquircle()
                .fill(Color.white)
            
            symbol
                .frame(width: size * 0.55, height: size * 0.55)
                .foregroundStyle(Color.white.opacity(0.9))
        }
        .frame(width: size, height: size)
        .colorMultiply(.white)
    }
    
    // MARK: - Outline
    
    private var outlineVersion: some View {
        ZStack {
            HIGSquircle()
                .strokeBorder(
                    KitDesignSystem.foregroundGradient,
                    lineWidth: size * 0.025
                )
            
            symbol
                .frame(width: size * 0.5, height: size * 0.5)
        }
        .frame(width: size, height: size)
    }
    
    // MARK: - Accessible (High Contrast)
    
    private var accessibleVersion: some View {
        ZStack {
            HIGSquircle()
                .fill(Color(red: 0.0, green: 0.2, blue: 0.5))
            
            HIGSquircleInset(insetRatio: 0.08)
                .fill(Color(red: 0.2, green: 0.5, blue: 0.9))
            
            symbol
                .frame(width: size * 0.5, height: size * 0.5)
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
    }
    
    // MARK: - Dark Mode
    
    private var darkModeVersion: some View {
        ZStack {
            HIGSquircle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.18, blue: 0.28),
                            Color(red: 0.08, green: 0.12, blue: 0.20)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            HIGSquircleInset(insetRatio: 0.06)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.15, green: 0.22, blue: 0.35),
                            Color(red: 0.10, green: 0.15, blue: 0.25)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            HIGSquircle()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.12), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
            
            symbol
                .frame(width: size * 0.55, height: size * 0.55)
        }
        .frame(width: size, height: size)
    }
    
    // MARK: - Light Mode
    
    private var lightModeVersion: some View {
        ZStack {
            HIGSquircle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.88, green: 0.92, blue: 0.98),
                            Color(red: 0.82, green: 0.88, blue: 0.95)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            HIGSquircleInset(insetRatio: 0.06)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.55, green: 0.68, blue: 0.88),
                            Color(red: 0.45, green: 0.58, blue: 0.78)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            HIGSquircle()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.5), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
            
            symbol
                .frame(width: size * 0.55, height: size * 0.55)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Preview

#Preview("Kit Icon Base - All Variants") {
    let variants: [IconVariantType] = [.inApp, .darkMode, .lightMode, .outline, .accessible]
    
    ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 20) {
            ForEach(variants, id: \.self) { variant in
                VStack(spacing: 8) {
                    KitIconBase(size: 100, variant: variant) {
                        // Sample symbol
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.white, .white.opacity(0.7)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 30
                                )
                            )
                            .frame(width: 40, height: 40)
                    }
                    
                    Text(variant.displayName)
                        .font(.caption)
                }
            }
        }
        .padding()
    }
    .background(Color.gray.opacity(0.1))
}
