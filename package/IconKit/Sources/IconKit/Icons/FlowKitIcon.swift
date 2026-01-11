//
//  FlowKitIcon.swift
//  IconKit
//
//  HIG-Compliant Custom Icon for FlowKit - Main Application
//
//  Design Concept:
//  - Warm glowing orb representing flow, creativity, and energy
//  - Layered construction: Background + Core orb + Inner glow + Outer corona
//  - Warm orange-to-magenta gradient (different from Kit blue)
//  - Organic, flowing aesthetic
//

import SwiftUI

// MARK: - FlowKit Design System

/// Warm color palette for FlowKit (distinct from Kit blue)
struct FlowKitColors {
    // Warm gradient - orange to magenta
    static let warmOrange = Color(red: 1.0, green: 0.60, blue: 0.20)       // #FF9933
    static let warmCoral = Color(red: 0.95, green: 0.45, blue: 0.40)       // #F27366
    static let warmMagenta = Color(red: 0.90, green: 0.30, blue: 0.50)     // #E64D80
    static let warmPurple = Color(red: 0.60, green: 0.20, blue: 0.90)      // #9933E6
    
    // Core glow colors
    static let coreWhite = Color(red: 1.0, green: 0.98, blue: 0.95)
    static let coreGold = Color(red: 1.0, green: 0.85, blue: 0.55)
    
    // Background
    static let bgDark = Color(red: 0.10, green: 0.08, blue: 0.15)
    static let bgMid = Color(red: 0.15, green: 0.10, blue: 0.22)
}

// MARK: - Custom Orb Shapes

/// Organic flowing orb shape with subtle variation
struct FlowKitOrbShape: Shape {
    func path(in rect: CGRect) -> Path {
        // Slightly organic circle with subtle wobble
        let cx = rect.midX
        let cy = rect.midY
        let r = min(rect.width, rect.height) / 2
        
        var path = Path()
        let points = 64
        
        for i in 0...points {
            let angle = CGFloat(i) * 2 * .pi / CGFloat(points)
            // Subtle organic variation
            let wobble = 1.0 + 0.02 * sin(angle * 3) + 0.01 * cos(angle * 5)
            let x = cx + r * wobble * cos(angle)
            let y = cy + r * wobble * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

/// Corona rays shape
struct CoronaRaysShape: Shape {
    let rayCount: Int
    
    init(rayCount: Int = 12) {
        self.rayCount = rayCount
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cx = rect.midX
        let cy = rect.midY
        let innerR = min(rect.width, rect.height) * 0.35
        let outerR = min(rect.width, rect.height) * 0.48
        
        for i in 0..<rayCount {
            let angle = CGFloat(i) * 2 * .pi / CGFloat(rayCount)
            let rayWidth: CGFloat = 0.08
            
            // Tapered ray
            let innerLeft = CGPoint(
                x: cx + innerR * cos(angle - rayWidth),
                y: cy + innerR * sin(angle - rayWidth)
            )
            let innerRight = CGPoint(
                x: cx + innerR * cos(angle + rayWidth),
                y: cy + innerR * sin(angle + rayWidth)
            )
            let outerPoint = CGPoint(
                x: cx + outerR * cos(angle),
                y: cy + outerR * sin(angle)
            )
            
            path.move(to: innerLeft)
            path.addLine(to: outerPoint)
            path.addLine(to: innerRight)
            path.closeSubpath()
        }
        
        return path
    }
}

/// Inner energy swirl shape
struct EnergySwirlShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cx = rect.midX
        let cy = rect.midY
        let r = min(rect.width, rect.height) * 0.25
        
        // Spiral energy pattern
        let turns: CGFloat = 1.5
        let points = 50
        
        for i in 0..<points {
            let t = CGFloat(i) / CGFloat(points)
            let angle = t * turns * 2 * .pi
            let radius = r * (0.3 + t * 0.7)
            let x = cx + radius * cos(angle)
            let y = cy + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

// MARK: - FlowKit Icon View

/// HIG-Compliant FlowKit Icon
/// Warm glowing orb design (distinct from Kit icons)
public struct FlowKitIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 128, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
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
    
    // MARK: - Standard Version
    
    private var standardVersion: some View {
        ZStack {
            // Layer 1: Background squircle
            HIGSquircle()
                .fill(
                    LinearGradient(
                        colors: [FlowKitColors.bgMid, FlowKitColors.bgDark],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Layer 2: Outer corona glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            FlowKitColors.warmOrange.opacity(0.5),
                            FlowKitColors.warmMagenta.opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: size * 0.15,
                        endRadius: size * 0.45
                    )
                )
                .frame(width: size * 0.9, height: size * 0.9)
            
            // Layer 3: Corona rays
            CoronaRaysShape(rayCount: 12)
                .fill(
                    RadialGradient(
                        colors: [
                            FlowKitColors.warmOrange.opacity(0.6),
                            FlowKitColors.warmCoral.opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: size * 0.12,
                        endRadius: size * 0.35
                    )
                )
                .frame(width: size * 0.8, height: size * 0.8)
            
            // Layer 4: Main orb
            FlowKitOrbShape()
                .fill(
                    RadialGradient(
                        stops: [
                            .init(color: FlowKitColors.coreWhite, location: 0.0),
                            .init(color: FlowKitColors.coreGold, location: 0.2),
                            .init(color: FlowKitColors.warmOrange, location: 0.5),
                            .init(color: FlowKitColors.warmCoral, location: 0.7),
                            .init(color: FlowKitColors.warmMagenta, location: 1.0)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.25
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 5: Inner highlight
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.9),
                            Color.white.opacity(0.3),
                            Color.clear
                        ],
                        center: UnitPoint(x: 0.35, y: 0.35),
                        startRadius: 0,
                        endRadius: size * 0.12
                    )
                )
                .frame(width: size * 0.4, height: size * 0.4)
                .offset(x: -size * 0.03, y: -size * 0.03)
            
            // Layer 6: Liquid Glass overlay on squircle
            HIGSquircle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.15),
                            Color.clear,
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Layer 7: Edge highlight
            HIGSquircle()
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.05),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: size * 0.008
                )
        }
        .frame(width: size, height: size)
    }
    
    // MARK: - Solid Black
    
    private var solidBlackVersion: some View {
        ZStack {
            HIGSquircle()
                .fill(Color.black)
            
            Circle()
                .fill(Color.black.opacity(0.7))
                .frame(width: size * 0.5, height: size * 0.5)
            
            Circle()
                .fill(Color.black)
                .frame(width: size * 0.3, height: size * 0.3)
        }
        .frame(width: size, height: size)
    }
    
    // MARK: - Solid White
    
    private var solidWhiteVersion: some View {
        ZStack {
            HIGSquircle()
                .fill(Color.white)
            
            Circle()
                .strokeBorder(Color.white, lineWidth: size * 0.02)
                .frame(width: size * 0.5, height: size * 0.5)
            
            Circle()
                .fill(Color.white)
                .frame(width: size * 0.25, height: size * 0.25)
        }
        .frame(width: size, height: size)
    }
    
    // MARK: - Outline
    
    private var outlineVersion: some View {
        ZStack {
            HIGSquircle()
                .strokeBorder(
                    LinearGradient(
                        colors: [FlowKitColors.warmOrange, FlowKitColors.warmMagenta],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: size * 0.02
                )
            
            Circle()
                .strokeBorder(
                    LinearGradient(
                        colors: [FlowKitColors.warmOrange, FlowKitColors.warmCoral],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: size * 0.025
                )
                .frame(width: size * 0.5, height: size * 0.5)
        }
        .frame(width: size, height: size)
    }
    
    // MARK: - Accessible
    
    private var accessibleVersion: some View {
        ZStack {
            HIGSquircle()
                .fill(Color.black)
            
            Circle()
                .fill(Color.orange)
                .frame(width: size * 0.55, height: size * 0.55)
            
            Circle()
                .fill(Color.white)
                .frame(width: size * 0.25, height: size * 0.25)
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
                            Color(red: 0.12, green: 0.08, blue: 0.18),
                            Color(red: 0.08, green: 0.05, blue: 0.12)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            FlowKitColors.warmOrange.opacity(0.4),
                            FlowKitColors.warmMagenta.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: size * 0.1,
                        endRadius: size * 0.4
                    )
                )
                .frame(width: size * 0.85, height: size * 0.85)
            
            FlowKitOrbShape()
                .fill(
                    RadialGradient(
                        colors: [
                            FlowKitColors.coreGold.opacity(0.9),
                            FlowKitColors.warmOrange.opacity(0.8),
                            FlowKitColors.warmCoral.opacity(0.7)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.22
                    )
                )
                .frame(width: size * 0.45, height: size * 0.45)
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
                            Color(red: 0.98, green: 0.95, blue: 0.92),
                            Color(red: 0.95, green: 0.90, blue: 0.88)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            FlowKitColors.warmOrange.opacity(0.5),
                            FlowKitColors.warmCoral.opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: size * 0.1,
                        endRadius: size * 0.4
                    )
                )
                .frame(width: size * 0.85, height: size * 0.85)
            
            FlowKitOrbShape()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white,
                            FlowKitColors.warmOrange,
                            FlowKitColors.warmCoral
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.22
                    )
                )
                .frame(width: size * 0.45, height: size * 0.45)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Animated Version

public struct FlowKitIconAnimated: View {
    public let size: CGFloat
    
    @State private var coronaRotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var glowIntensity: Double = 0.5
    
    public init(size: CGFloat = 128) {
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            // Background
            HIGSquircle()
                .fill(
                    LinearGradient(
                        colors: [FlowKitColors.bgMid, FlowKitColors.bgDark],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Animated outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            FlowKitColors.warmOrange.opacity(glowIntensity),
                            FlowKitColors.warmMagenta.opacity(glowIntensity * 0.5),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: size * 0.12,
                        endRadius: size * 0.48
                    )
                )
                .frame(width: size * 0.95, height: size * 0.95)
            
            // Rotating corona
            CoronaRaysShape(rayCount: 12)
                .fill(
                    RadialGradient(
                        colors: [
                            FlowKitColors.warmOrange.opacity(0.5),
                            FlowKitColors.warmCoral.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: size * 0.1,
                        endRadius: size * 0.32
                    )
                )
                .frame(width: size * 0.75, height: size * 0.75)
                .rotationEffect(.degrees(coronaRotation))
            
            // Pulsing orb
            FlowKitOrbShape()
                .fill(
                    RadialGradient(
                        colors: [
                            FlowKitColors.coreWhite,
                            FlowKitColors.coreGold,
                            FlowKitColors.warmOrange,
                            FlowKitColors.warmMagenta
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.22
                    )
                )
                .frame(width: size * 0.45, height: size * 0.45)
                .scaleEffect(pulseScale)
            
            // Inner highlight
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.85),
                            Color.white.opacity(0.2),
                            Color.clear
                        ],
                        center: UnitPoint(x: 0.35, y: 0.35),
                        startRadius: 0,
                        endRadius: size * 0.1
                    )
                )
                .frame(width: size * 0.35, height: size * 0.35)
                .offset(x: -size * 0.025, y: -size * 0.025)
                .scaleEffect(pulseScale)
            
            // Glass overlay
            HIGSquircle()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.12), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                coronaRotation = 360
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulseScale = 1.05
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glowIntensity = 0.7
            }
        }
    }
}

// MARK: - Preview

#Preview("FlowKit Icon - Professional") {
    VStack(spacing: 30) {
        Text("FlowKit Icon")
            .font(.title.bold())
        
        HStack(spacing: 30) {
            VStack {
                FlowKitIcon(size: 128, variant: .inApp)
                Text("Standard")
                    .font(.caption)
            }
            
            VStack {
                FlowKitIconAnimated(size: 128)
                Text("Animated")
                    .font(.caption)
            }
        }
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
            ForEach([IconVariantType.darkMode, .lightMode, .outline, .accessible], id: \.self) { variant in
                VStack {
                    FlowKitIcon(size: 80, variant: variant)
                    Text(variant.displayName)
                        .font(.caption2)
                }
            }
        }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
