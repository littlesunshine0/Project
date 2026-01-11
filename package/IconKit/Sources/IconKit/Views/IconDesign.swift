//
//  IconDesign.swift
//  IconKit
//
//  SwiftUI views for rendering icons
//

import SwiftUI

/// Main icon design view - renders icons based on style
public struct IconDesign: View {
    let style: IconStyle
    let size: CGFloat
    let colors: [Color]?
    let label: String?
    
    public init(
        style: IconStyle,
        size: CGFloat = 1024,
        colors: [Color]? = nil,
        label: String? = nil
    ) {
        self.style = style
        self.size = size
        self.colors = colors
        self.label = label
    }
    
    private var effectiveColors: [Color] {
        colors ?? style.defaultColors
    }
    
    public var body: some View {
        ZStack {
            // Background
            backgroundView
            
            // Main icon shape
            iconShape
            
            // Label if provided
            if let label = label, size >= 128 {
                labelView(label)
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.225, style: .continuous))
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        LinearGradient(
            colors: effectiveColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    @ViewBuilder
    private var iconShape: some View {
        switch style {
        case .glowOrb:
            GlowOrbShape(size: size)
        case .gradient:
            GradientShape(size: size, colors: effectiveColors)
        case .minimal:
            MinimalShape(size: size)
        case .cube, .box:
            CubeShape(size: size)
        case .hexagon:
            HexagonShape(size: size)
        case .star:
            StarShape(size: size)
        case .diamond:
            DiamondShape(size: size)
        case .badge:
            BadgeShape(size: size)
        case .gear, .cog:
            GearShape(size: size)
        case .circuit:
            CircuitShape(size: size)
        case .layers, .stack:
            LayersShape(size: size)
        case .grid:
            GridShape(size: size)
        case .lightbulb:
            LightbulbIconView(size: size)
        case .brain:
            BrainIconView(size: size)
        case .spark:
            SparkIconView(size: size)
        }
    }
    
    private func labelView(_ text: String) -> some View {
        Text(text.prefix(2).uppercased())
            .font(.system(size: size * 0.2, weight: .bold, design: .rounded))
            .foregroundStyle(.white.opacity(0.3))
            .offset(y: size * 0.3)
    }
}

// MARK: - Icon Shapes

struct GlowOrbShape: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: size * 0.04
                )
                .frame(width: size * 0.65, height: size * 0.65)
                .blur(radius: size * 0.02)
            
            // Inner glowing orb
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white,
                            Color(red: 1.0, green: 0.9, blue: 0.6).opacity(0.8),
                            Color(red: 1.0, green: 0.6, blue: 0.4).opacity(0.4)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.25
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
                .shadow(color: Color.white.opacity(0.8), radius: size * 0.08)
            
            // Sparkles
            ForEach(0..<6, id: \.self) { index in
                Image(systemName: "sparkle")
                    .font(.system(size: size * 0.12, weight: .bold))
                    .foregroundStyle(.white)
                    .offset(
                        x: cos(Double(index) * .pi / 3) * size * 0.35,
                        y: sin(Double(index) * .pi / 3) * size * 0.35
                    )
                    .opacity(0.9)
            }
        }
    }
}

struct GradientShape: View {
    let size: CGFloat
    let colors: [Color]
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [.white.opacity(0.9)] + colors.map { $0.opacity(0.5) },
                    center: .center,
                    startRadius: 0,
                    endRadius: size * 0.4
                )
            )
            .frame(width: size * 0.6, height: size * 0.6)
            .shadow(color: .white.opacity(0.5), radius: size * 0.05)
    }
}

struct MinimalShape: View {
    let size: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.1)
            .stroke(.white.opacity(0.8), lineWidth: size * 0.03)
            .frame(width: size * 0.5, height: size * 0.5)
    }
}

struct CubeShape: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // 3D cube effect
            RoundedRectangle(cornerRadius: size * 0.05)
                .fill(.white.opacity(0.3))
                .frame(width: size * 0.4, height: size * 0.4)
                .offset(x: size * 0.03, y: size * 0.03)
            
            RoundedRectangle(cornerRadius: size * 0.05)
                .fill(.white.opacity(0.6))
                .frame(width: size * 0.4, height: size * 0.4)
            
            Image(systemName: "shippingbox.fill")
                .font(.system(size: size * 0.25))
                .foregroundStyle(.white)
        }
    }
}

struct HexagonShape: View {
    let size: CGFloat
    
    var body: some View {
        Image(systemName: "hexagon.fill")
            .font(.system(size: size * 0.5))
            .foregroundStyle(.white.opacity(0.8))
    }
}

struct StarShape: View {
    let size: CGFloat
    
    var body: some View {
        Image(systemName: "star.fill")
            .font(.system(size: size * 0.45))
            .foregroundStyle(.white)
            .shadow(color: .white.opacity(0.8), radius: size * 0.05)
    }
}

struct DiamondShape: View {
    let size: CGFloat
    
    var body: some View {
        Image(systemName: "diamond.fill")
            .font(.system(size: size * 0.4))
            .foregroundStyle(.white)
            .rotationEffect(.degrees(0))
    }
}

struct BadgeShape: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.2))
                .frame(width: size * 0.6, height: size * 0.6)
            
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: size * 0.35))
                .foregroundStyle(.white)
        }
    }
}

struct GearShape: View {
    let size: CGFloat
    
    var body: some View {
        Image(systemName: "gearshape.fill")
            .font(.system(size: size * 0.45))
            .foregroundStyle(.white.opacity(0.9))
    }
}

struct CircuitShape: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Image(systemName: "cpu.fill")
                .font(.system(size: size * 0.4))
                .foregroundStyle(.white)
            
            ForEach(0..<4, id: \.self) { index in
                Rectangle()
                    .fill(.white.opacity(0.5))
                    .frame(width: size * 0.02, height: size * 0.15)
                    .offset(y: -size * 0.32)
                    .rotationEffect(.degrees(Double(index) * 90))
            }
        }
    }
}

struct LayersShape: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                RoundedRectangle(cornerRadius: size * 0.05)
                    .fill(.white.opacity(0.3 + Double(index) * 0.2))
                    .frame(width: size * 0.45, height: size * 0.12)
                    .offset(y: CGFloat(index - 1) * size * 0.12)
            }
        }
    }
}

struct GridShape: View {
    let size: CGFloat
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(size * 0.12), spacing: size * 0.03), count: 3), spacing: size * 0.03) {
            ForEach(0..<9, id: \.self) { _ in
                RoundedRectangle(cornerRadius: size * 0.02)
                    .fill(.white.opacity(0.7))
                    .frame(width: size * 0.12, height: size * 0.12)
            }
        }
    }
}

struct LightbulbIconView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Glow effect
            Circle()
                .fill(.white.opacity(0.3))
                .frame(width: size * 0.6, height: size * 0.6)
                .blur(radius: size * 0.05)
            
            Image(systemName: "lightbulb.fill")
                .font(.system(size: size * 0.4))
                .foregroundStyle(.white)
        }
    }
}

struct BrainIconView: View {
    let size: CGFloat
    
    var body: some View {
        Image(systemName: "brain.head.profile")
            .font(.system(size: size * 0.4))
            .foregroundStyle(.white)
    }
}

struct SparkIconView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                Image(systemName: "sparkle")
                    .font(.system(size: size * 0.1))
                    .foregroundStyle(.white)
                    .offset(
                        x: cos(Double(index) * .pi / 4) * size * 0.25,
                        y: sin(Double(index) * .pi / 4) * size * 0.25
                    )
            }
            
            Image(systemName: "sparkles")
                .font(.system(size: size * 0.3))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Preview

#Preview("Icon Styles") {
    ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
            ForEach(IconStyle.allCases, id: \.self) { style in
                VStack {
                    IconDesign(style: style, size: 128)
                    Text(style.rawValue)
                        .font(.caption)
                }
            }
        }
        .padding()
    }
}
