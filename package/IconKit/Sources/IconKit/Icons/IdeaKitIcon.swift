//
//  IdeaKitIcon.swift
//  IconKit
//
//  HIG-Compliant Custom Icon for IdeaKit - Project Operating System
//
//  Design Concept:
//  - Lightbulb representing ideas, innovation, and illumination
//  - Layered construction: Background + Glass bulb + Filament + Glow
//  - Golden accent for "lightbulb moment" warmth
//  - Filled, overlapping shapes (HIG guideline)
//

import SwiftUI

// MARK: - Custom Lightbulb Shapes

/// Professional lightbulb glass bulb shape
/// Hand-crafted bezier curves for smooth, iconic silhouette
struct IdeaKitBulbGlass: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w / 2
        
        // Start at bottom-left of bulb neck
        path.move(to: CGPoint(x: cx - w * 0.15, y: h * 0.68))
        
        // Left side curve - smooth bezier up to top
        path.addCurve(
            to: CGPoint(x: cx - w * 0.38, y: h * 0.32),
            control1: CGPoint(x: cx - w * 0.28, y: h * 0.62),
            control2: CGPoint(x: cx - w * 0.40, y: h * 0.48)
        )
        
        // Top-left curve
        path.addCurve(
            to: CGPoint(x: cx, y: h * 0.08),
            control1: CGPoint(x: cx - w * 0.36, y: h * 0.16),
            control2: CGPoint(x: cx - w * 0.20, y: h * 0.08)
        )
        
        // Top-right curve
        path.addCurve(
            to: CGPoint(x: cx + w * 0.38, y: h * 0.32),
            control1: CGPoint(x: cx + w * 0.20, y: h * 0.08),
            control2: CGPoint(x: cx + w * 0.36, y: h * 0.16)
        )
        
        // Right side curve down to neck
        path.addCurve(
            to: CGPoint(x: cx + w * 0.15, y: h * 0.68),
            control1: CGPoint(x: cx + w * 0.40, y: h * 0.48),
            control2: CGPoint(x: cx + w * 0.28, y: h * 0.62)
        )
        
        // Bottom of bulb (neck)
        path.addLine(to: CGPoint(x: cx - w * 0.15, y: h * 0.68))
        path.closeSubpath()
        
        return path
    }
}

/// Lightbulb screw base shape
struct IdeaKitBulbBase: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w / 2
        
        let baseTop = h * 0.68
        let baseBottom = h * 0.88
        let baseWidth = w * 0.14
        
        // Main base rectangle with rounded bottom
        path.move(to: CGPoint(x: cx - baseWidth, y: baseTop))
        path.addLine(to: CGPoint(x: cx + baseWidth, y: baseTop))
        path.addLine(to: CGPoint(x: cx + baseWidth, y: baseBottom - w * 0.04))
        
        // Rounded bottom
        path.addQuadCurve(
            to: CGPoint(x: cx - baseWidth, y: baseBottom - w * 0.04),
            control: CGPoint(x: cx, y: baseBottom + w * 0.02)
        )
        
        path.closeSubpath()
        return path
    }
}

/// Lightbulb filament shape (stylized)
struct IdeaKitFilament: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w / 2
        
        // Stylized filament - simple elegant curves
        let filamentTop = h * 0.25
        let filamentBottom = h * 0.55
        let filamentWidth = w * 0.12
        
        // Left filament arm
        path.move(to: CGPoint(x: cx - filamentWidth, y: filamentBottom))
        path.addQuadCurve(
            to: CGPoint(x: cx - filamentWidth * 0.3, y: filamentTop),
            control: CGPoint(x: cx - filamentWidth * 1.2, y: h * 0.38)
        )
        
        // Top connection
        path.addQuadCurve(
            to: CGPoint(x: cx + filamentWidth * 0.3, y: filamentTop),
            control: CGPoint(x: cx, y: filamentTop - h * 0.05)
        )
        
        // Right filament arm
        path.addQuadCurve(
            to: CGPoint(x: cx + filamentWidth, y: filamentBottom),
            control: CGPoint(x: cx + filamentWidth * 1.2, y: h * 0.38)
        )
        
        return path
    }
}

/// Inner glow shape (elliptical)
struct IdeaKitGlowShape: Shape {
    func path(in rect: CGRect) -> Path {
        let cx = rect.midX
        let cy = rect.height * 0.35
        let rx = rect.width * 0.25
        let ry = rect.height * 0.22
        
        var path = Path()
        path.addEllipse(in: CGRect(
            x: cx - rx,
            y: cy - ry,
            width: rx * 2,
            height: ry * 2
        ))
        return path
    }
}

// MARK: - IdeaKit Icon View

/// HIG-Compliant IdeaKit Icon
/// Layered lightbulb design with golden glow accent
public struct IdeaKitIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 128, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
    }
    
    public var body: some View {
        KitIconBase(size: size, variant: variant) {
            ideaKitSymbol
        }
    }
    
    // MARK: - Symbol Layers
    
    @ViewBuilder
    private var ideaKitSymbol: some View {
        ZStack {
            // Layer 1: Outer glow (golden warmth)
            IdeaKitGlowShape()
                .fill(
                    RadialGradient(
                        colors: [
                            KitDesignSystem.accentGoldBright.opacity(0.6),
                            KitDesignSystem.accentGold.opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.2
                    )
                )
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 2: Bulb glass (filled shape with gradient)
            IdeaKitBulbGlass()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color.white.opacity(0.95), location: 0.0),
                            .init(color: KitDesignSystem.accentGoldBright.opacity(0.4), location: 0.3),
                            .init(color: KitDesignSystem.accentGold.opacity(0.5), location: 0.7),
                            .init(color: KitDesignSystem.accentGold.opacity(0.6), location: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 3: Glass highlight (Liquid Glass effect)
            IdeaKitBulbGlass()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color.white.opacity(0.7), location: 0.0),
                            .init(color: Color.white.opacity(0.2), location: 0.25),
                            .init(color: Color.clear, location: 0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 4: Filament (golden)
            IdeaKitFilament()
                .stroke(
                    LinearGradient(
                        colors: [
                            KitDesignSystem.accentGoldBright,
                            KitDesignSystem.accentGold
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: StrokeStyle(lineWidth: size * 0.018, lineCap: .round)
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 5: Screw base (metallic)
            IdeaKitBulbBase()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.75, green: 0.75, blue: 0.78),
                            Color(red: 0.55, green: 0.55, blue: 0.58),
                            Color(red: 0.65, green: 0.65, blue: 0.68)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 6: Base ridges (detail)
            baseRidges
                .frame(width: size * 0.5, height: size * 0.5)
        }
    }
    
    private var baseRidges: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let cx = w / 2
            let baseTop = h * 0.70
            let ridgeSpacing = h * 0.045
            let ridgeWidth = w * 0.24
            
            for i in 0..<3 {
                let y = baseTop + CGFloat(i) * ridgeSpacing
                var path = Path()
                path.move(to: CGPoint(x: cx - ridgeWidth / 2, y: y))
                path.addLine(to: CGPoint(x: cx + ridgeWidth / 2, y: y))
                
                context.stroke(
                    path,
                    with: .color(Color(red: 0.45, green: 0.45, blue: 0.48)),
                    lineWidth: 1.5
                )
            }
        }
    }
}

// MARK: - Animated Version

public struct IdeaKitIconAnimated: View {
    public let size: CGFloat
    
    @State private var glowIntensity: Double = 0.4
    @State private var filamentBrightness: Double = 0.8
    
    public init(size: CGFloat = 128) {
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            // Pulsing outer glow
            HIGSquircle()
                .fill(
                    RadialGradient(
                        colors: [
                            KitDesignSystem.accentGold.opacity(glowIntensity * 0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: size * 0.25,
                        endRadius: size * 0.55
                    )
                )
                .frame(width: size, height: size)
            
            // Base icon with animated glow
            KitIconBase(size: size * 0.92, variant: .inApp) {
                animatedSymbol
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                glowIntensity = 0.8
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                filamentBrightness = 1.0
            }
        }
    }
    
    @ViewBuilder
    private var animatedSymbol: some View {
        ZStack {
            // Animated glow
            IdeaKitGlowShape()
                .fill(
                    RadialGradient(
                        colors: [
                            KitDesignSystem.accentGoldBright.opacity(glowIntensity),
                            KitDesignSystem.accentGold.opacity(glowIntensity * 0.5),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.18
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Bulb glass
            IdeaKitBulbGlass()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.95),
                            KitDesignSystem.accentGoldBright.opacity(0.5 * filamentBrightness),
                            KitDesignSystem.accentGold.opacity(0.6 * filamentBrightness)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.45, height: size * 0.45)
            
            // Glass highlight
            IdeaKitBulbGlass()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.6), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
                .frame(width: size * 0.45, height: size * 0.45)
            
            // Animated filament
            IdeaKitFilament()
                .stroke(
                    KitDesignSystem.accentGoldBright.opacity(filamentBrightness),
                    style: StrokeStyle(lineWidth: size * 0.016, lineCap: .round)
                )
                .frame(width: size * 0.45, height: size * 0.45)
            
            // Base
            IdeaKitBulbBase()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.72, green: 0.72, blue: 0.75),
                            Color(red: 0.52, green: 0.52, blue: 0.55)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.45, height: size * 0.45)
        }
    }
}

// MARK: - Preview

#Preview("IdeaKit Icon - Professional") {
    VStack(spacing: 30) {
        Text("IdeaKit Icon")
            .font(.title.bold())
        
        HStack(spacing: 30) {
            VStack {
                IdeaKitIcon(size: 128, variant: .inApp)
                Text("Standard")
                    .font(.caption)
            }
            
            VStack {
                IdeaKitIconAnimated(size: 128)
                Text("Animated")
                    .font(.caption)
            }
        }
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
            ForEach([IconVariantType.darkMode, .lightMode, .outline, .accessible], id: \.self) { variant in
                VStack {
                    IdeaKitIcon(size: 80, variant: variant)
                    Text(variant.displayName)
                        .font(.caption2)
                }
            }
        }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
