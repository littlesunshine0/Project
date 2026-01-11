//
//  AgentKitIcon.swift
//  IconKit
//
//  HIG-Compliant Custom Icon for AgentKit - Autonomous Agent System
//
//  Design Concept:
//  - Robot/AI head representing autonomous intelligence
//  - Antenna for communication/triggers
//  - Glowing eyes for active monitoring
//  - Layered construction with depth
//

import SwiftUI

// MARK: - Custom Agent Shapes

/// Agent head shape - rounded rectangle with notch
struct AgentHeadShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w / 2
        
        let headTop = h * 0.28
        let headBottom = h * 0.72
        let headWidth = w * 0.38
        let cornerRadius = w * 0.08
        
        // Main head rectangle with rounded corners
        let headRect = CGRect(
            x: cx - headWidth,
            y: headTop,
            width: headWidth * 2,
            height: headBottom - headTop
        )
        
        path.addRoundedRect(in: headRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        return path
    }
}

/// Agent antenna shape
struct AgentAntennaShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w / 2
        
        // Antenna stem
        let stemBottom = h * 0.28
        let stemTop = h * 0.12
        let stemWidth = w * 0.025
        
        path.move(to: CGPoint(x: cx - stemWidth, y: stemBottom))
        path.addLine(to: CGPoint(x: cx - stemWidth * 0.5, y: stemTop + w * 0.04))
        path.addLine(to: CGPoint(x: cx + stemWidth * 0.5, y: stemTop + w * 0.04))
        path.addLine(to: CGPoint(x: cx + stemWidth, y: stemBottom))
        path.closeSubpath()
        
        // Antenna ball
        let ballRadius = w * 0.045
        path.addEllipse(in: CGRect(
            x: cx - ballRadius,
            y: stemTop - ballRadius * 0.5,
            width: ballRadius * 2,
            height: ballRadius * 2
        ))
        
        return path
    }
}

/// Agent eye shape
struct AgentEyeShape: Shape {
    let isLeft: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w / 2
        
        let eyeY = h * 0.42
        let eyeRadius = w * 0.08
        let eyeOffset = w * 0.14
        
        let eyeX = isLeft ? cx - eyeOffset : cx + eyeOffset
        
        path.addEllipse(in: CGRect(
            x: eyeX - eyeRadius,
            y: eyeY - eyeRadius,
            width: eyeRadius * 2,
            height: eyeRadius * 2
        ))
        
        return path
    }
}

/// Agent mouth/speaker grille
struct AgentMouthShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w / 2
        
        let mouthY = h * 0.58
        let mouthWidth = w * 0.22
        let lineSpacing = h * 0.035
        
        // Three horizontal lines (speaker grille)
        for i in 0..<3 {
            let y = mouthY + CGFloat(i) * lineSpacing
            path.move(to: CGPoint(x: cx - mouthWidth, y: y))
            path.addLine(to: CGPoint(x: cx + mouthWidth, y: y))
        }
        
        return path
    }
}

/// Agent ear/side panel shape
struct AgentEarShape: Shape {
    let isLeft: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w / 2
        
        let earTop = h * 0.35
        let earBottom = h * 0.55
        let earWidth = w * 0.06
        let headEdge = w * 0.38
        
        let earX = isLeft ? cx - headEdge - earWidth : cx + headEdge
        
        let earRect = CGRect(
            x: earX,
            y: earTop,
            width: earWidth,
            height: earBottom - earTop
        )
        
        path.addRoundedRect(in: earRect, cornerSize: CGSize(width: w * 0.02, height: w * 0.02))
        
        return path
    }
}

// MARK: - AgentKit Icon View

/// HIG-Compliant AgentKit Icon
/// Robot head with antenna and glowing eyes
public struct AgentKitIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 128, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
    }
    
    public var body: some View {
        KitIconBase(size: size, variant: variant) {
            agentKitSymbol
        }
    }
    
    // MARK: - Symbol Layers
    
    @ViewBuilder
    private var agentKitSymbol: some View {
        ZStack {
            // Layer 1: Ears (side panels)
            AgentEarShape(isLeft: true)
                .fill(KitDesignSystem.fgTertiary)
                .frame(width: size * 0.55, height: size * 0.55)
            
            AgentEarShape(isLeft: false)
                .fill(KitDesignSystem.fgTertiary)
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 2: Antenna
            AgentAntennaShape()
                .fill(
                    LinearGradient(
                        colors: [KitDesignSystem.fgPrimary, KitDesignSystem.fgSecondary],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 3: Antenna glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            KitDesignSystem.accentCyanBright.opacity(0.8),
                            KitDesignSystem.accentCyan.opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.04
                    )
                )
                .frame(width: size * 0.08, height: size * 0.08)
                .offset(y: -size * 0.20)
            
            // Layer 4: Head
            AgentHeadShape()
                .fill(
                    LinearGradient(
                        colors: [KitDesignSystem.fgPrimary, KitDesignSystem.fgSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 5: Head highlight (Liquid Glass)
            AgentHeadShape()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.35), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 6: Eyes (glowing)
            AgentEyeShape(isLeft: true)
                .fill(
                    RadialGradient(
                        colors: [
                            KitDesignSystem.accentCyanBright,
                            KitDesignSystem.accentCyan
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.05
                    )
                )
                .frame(width: size * 0.55, height: size * 0.55)
            
            AgentEyeShape(isLeft: false)
                .fill(
                    RadialGradient(
                        colors: [
                            KitDesignSystem.accentCyanBright,
                            KitDesignSystem.accentCyan
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.05
                    )
                )
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 7: Eye highlights
            Circle()
                .fill(Color.white.opacity(0.7))
                .frame(width: size * 0.025, height: size * 0.025)
                .offset(x: -size * 0.085, y: -size * 0.05)
            
            Circle()
                .fill(Color.white.opacity(0.7))
                .frame(width: size * 0.025, height: size * 0.025)
                .offset(x: size * 0.065, y: -size * 0.05)
            
            // Layer 8: Mouth/speaker grille
            AgentMouthShape()
                .stroke(
                    KitDesignSystem.bgGradientBottom.opacity(0.6),
                    style: StrokeStyle(lineWidth: size * 0.012, lineCap: .round)
                )
                .frame(width: size * 0.55, height: size * 0.55)
        }
    }
}

// MARK: - Animated Version

public struct AgentKitIconAnimated: View {
    public let size: CGFloat
    
    @State private var eyeGlow: CGFloat = 0.8
    @State private var antennaGlow: CGFloat = 0.5
    
    public init(size: CGFloat = 128) {
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            // Pulsing glow
            HIGSquircle()
                .fill(
                    RadialGradient(
                        colors: [
                            KitDesignSystem.accentCyan.opacity(0.15 * antennaGlow),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: size * 0.25,
                        endRadius: size * 0.55
                    )
                )
                .frame(width: size, height: size)
            
            KitIconBase(size: size * 0.92, variant: .inApp) {
                animatedSymbol
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                eyeGlow = 1.0
            }
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                antennaGlow = 1.0
            }
        }
    }
    
    @ViewBuilder
    private var animatedSymbol: some View {
        ZStack {
            // Ears
            AgentEarShape(isLeft: true)
                .fill(KitDesignSystem.fgTertiary)
                .frame(width: size * 0.5, height: size * 0.5)
            
            AgentEarShape(isLeft: false)
                .fill(KitDesignSystem.fgTertiary)
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Antenna
            AgentAntennaShape()
                .fill(KitDesignSystem.fgPrimary)
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Animated antenna glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            KitDesignSystem.accentCyanBright.opacity(antennaGlow),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.05
                    )
                )
                .frame(width: size * 0.1, height: size * 0.1)
                .offset(y: -size * 0.18)
            
            // Head
            AgentHeadShape()
                .fill(
                    LinearGradient(
                        colors: [KitDesignSystem.fgPrimary, KitDesignSystem.fgSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Animated eyes
            AgentEyeShape(isLeft: true)
                .fill(KitDesignSystem.accentCyanBright.opacity(eyeGlow))
                .frame(width: size * 0.5, height: size * 0.5)
            
            AgentEyeShape(isLeft: false)
                .fill(KitDesignSystem.accentCyanBright.opacity(eyeGlow))
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Mouth
            AgentMouthShape()
                .stroke(
                    KitDesignSystem.bgGradientBottom.opacity(0.5),
                    style: StrokeStyle(lineWidth: size * 0.01, lineCap: .round)
                )
                .frame(width: size * 0.5, height: size * 0.5)
        }
    }
}

// MARK: - Preview

#Preview("AgentKit Icon - Professional") {
    VStack(spacing: 30) {
        Text("AgentKit Icon")
            .font(.title.bold())
        
        HStack(spacing: 30) {
            VStack {
                AgentKitIcon(size: 128, variant: .inApp)
                Text("Standard")
                    .font(.caption)
            }
            
            VStack {
                AgentKitIconAnimated(size: 128)
                Text("Animated")
                    .font(.caption)
            }
        }
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
            ForEach([IconVariantType.darkMode, .lightMode, .outline, .accessible], id: \.self) { variant in
                VStack {
                    AgentKitIcon(size: 80, variant: variant)
                    Text(variant.displayName)
                        .font(.caption2)
                }
            }
        }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
