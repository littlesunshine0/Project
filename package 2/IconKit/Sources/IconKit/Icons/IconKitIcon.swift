//
//  IconKitIcon.swift
//  IconKit
//
//  HIG-Compliant Custom Icon for IconKit - Universal Icon System
//
//  Design Concept:
//  - Paintbrush representing design, creation, and visual tools
//  - Layered construction: Background + Handle + Ferrule + Bristles + Paint
//  - Cyan accent for creative spark
//  - Filled, overlapping shapes (HIG guideline)
//

import SwiftUI

// MARK: - Custom Paintbrush Shapes

/// Paintbrush handle shape - elegant tapered form
struct IconKitBrushHandle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Handle runs diagonally from top-right to bottom-left
        // Elegant tapered shape
        
        // Top of handle (narrow end)
        path.move(to: CGPoint(x: w * 0.82, y: h * 0.08))
        
        // Right edge of handle
        path.addCurve(
            to: CGPoint(x: w * 0.48, y: h * 0.52),
            control1: CGPoint(x: w * 0.88, y: h * 0.18),
            control2: CGPoint(x: w * 0.62, y: h * 0.38)
        )
        
        // Transition to ferrule
        path.addLine(to: CGPoint(x: w * 0.42, y: h * 0.58))
        
        // Left edge back up
        path.addCurve(
            to: CGPoint(x: w * 0.75, y: h * 0.12),
            control1: CGPoint(x: w * 0.52, y: h * 0.42),
            control2: CGPoint(x: w * 0.78, y: h * 0.22)
        )
        
        // Top cap
        path.addQuadCurve(
            to: CGPoint(x: w * 0.82, y: h * 0.08),
            control: CGPoint(x: w * 0.80, y: h * 0.06)
        )
        
        path.closeSubpath()
        return path
    }
}

/// Ferrule (metal band) shape
struct IconKitFerrule: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Metal band connecting handle to bristles
        path.move(to: CGPoint(x: w * 0.48, y: h * 0.52))
        path.addLine(to: CGPoint(x: w * 0.42, y: h * 0.58))
        path.addLine(to: CGPoint(x: w * 0.32, y: h * 0.68))
        path.addLine(to: CGPoint(x: w * 0.38, y: h * 0.62))
        path.closeSubpath()
        
        return path
    }
}

/// Brush bristles shape - tapered tip
struct IconKitBristles: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Bristles taper to a point
        path.move(to: CGPoint(x: w * 0.38, y: h * 0.62))
        path.addLine(to: CGPoint(x: w * 0.32, y: h * 0.68))
        
        // Bristle tip curves
        path.addCurve(
            to: CGPoint(x: w * 0.10, y: h * 0.92),
            control1: CGPoint(x: w * 0.22, y: h * 0.78),
            control2: CGPoint(x: w * 0.12, y: h * 0.88)
        )
        
        // Point
        path.addQuadCurve(
            to: CGPoint(x: w * 0.18, y: h * 0.88),
            control: CGPoint(x: w * 0.08, y: h * 0.95)
        )
        
        // Back up
        path.addCurve(
            to: CGPoint(x: w * 0.38, y: h * 0.62),
            control1: CGPoint(x: w * 0.25, y: h * 0.80),
            control2: CGPoint(x: w * 0.32, y: h * 0.70)
        )
        
        path.closeSubpath()
        return path
    }
}

/// Paint stroke/splash shape
struct IconKitPaintStroke: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Organic paint stroke near brush tip
        path.move(to: CGPoint(x: w * 0.08, y: h * 0.88))
        
        path.addCurve(
            to: CGPoint(x: w * 0.22, y: h * 0.78),
            control1: CGPoint(x: w * 0.10, y: h * 0.82),
            control2: CGPoint(x: w * 0.16, y: h * 0.78)
        )
        
        path.addCurve(
            to: CGPoint(x: w * 0.15, y: h * 0.92),
            control1: CGPoint(x: w * 0.20, y: h * 0.84),
            control2: CGPoint(x: w * 0.18, y: h * 0.90)
        )
        
        path.addQuadCurve(
            to: CGPoint(x: w * 0.08, y: h * 0.88),
            control: CGPoint(x: w * 0.06, y: h * 0.92)
        )
        
        path.closeSubpath()
        return path
    }
}

/// Color swatch dots
struct IconKitColorDots: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Cyan dot
            Circle()
                .fill(KitDesignSystem.accentCyan)
                .frame(width: size * 0.08, height: size * 0.08)
                .offset(x: size * 0.12, y: -size * 0.08)
            
            // Smaller accent dot
            Circle()
                .fill(KitDesignSystem.accentCyanBright)
                .frame(width: size * 0.05, height: size * 0.05)
                .offset(x: size * 0.08, y: size * 0.05)
        }
    }
}

// MARK: - IconKit Icon View

/// HIG-Compliant IconKit Icon
/// Layered paintbrush design with cyan creative accent
public struct IconKitIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 128, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
    }
    
    public var body: some View {
        KitIconBase(size: size, variant: variant) {
            iconKitSymbol
        }
    }
    
    // MARK: - Symbol Layers
    
    @ViewBuilder
    private var iconKitSymbol: some View {
        ZStack {
            // Layer 1: Paint stroke (cyan accent)
            IconKitPaintStroke()
                .fill(
                    LinearGradient(
                        colors: [
                            KitDesignSystem.accentCyanBright,
                            KitDesignSystem.accentCyan
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 2: Brush handle (wood grain gradient)
            IconKitBrushHandle()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(red: 0.85, green: 0.70, blue: 0.50), location: 0.0),
                            .init(color: Color(red: 0.72, green: 0.55, blue: 0.38), location: 0.4),
                            .init(color: Color(red: 0.60, green: 0.45, blue: 0.30), location: 0.7),
                            .init(color: Color(red: 0.50, green: 0.38, blue: 0.25), location: 1.0)
                        ],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 3: Handle highlight
            IconKitBrushHandle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.4),
                            Color.white.opacity(0.1),
                            Color.clear
                        ],
                        startPoint: .topTrailing,
                        endPoint: .center
                    )
                )
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 4: Ferrule (metallic)
            IconKitFerrule()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.80, green: 0.80, blue: 0.82),
                            Color(red: 0.55, green: 0.55, blue: 0.58),
                            Color(red: 0.70, green: 0.70, blue: 0.72)
                        ],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 5: Bristles
            IconKitBristles()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.35, green: 0.30, blue: 0.25),
                            Color(red: 0.25, green: 0.20, blue: 0.15),
                            Color(red: 0.18, green: 0.15, blue: 0.12)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 6: Bristle highlight
            IconKitBristles()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.15),
                            Color.clear
                        ],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 7: Color dots (creative accent)
            IconKitColorDots(size: size * 0.55)
        }
    }
}

// MARK: - Animated Version

public struct IconKitIconAnimated: View {
    public let size: CGFloat
    
    @State private var brushRotation: Double = 0
    @State private var paintPulse: Double = 0.8
    @State private var dotScale: CGFloat = 1.0
    
    public init(size: CGFloat = 128) {
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            // Subtle rotating glow
            HIGSquircle()
                .fill(
                    AngularGradient(
                        colors: [
                            KitDesignSystem.accentCyan.opacity(0.2),
                            KitDesignSystem.fgPrimary.opacity(0.1),
                            KitDesignSystem.accentCyan.opacity(0.2)
                        ],
                        center: .center,
                        startAngle: .degrees(brushRotation),
                        endAngle: .degrees(brushRotation + 360)
                    )
                )
                .frame(width: size, height: size)
                .blur(radius: size * 0.05)
            
            // Base icon
            KitIconBase(size: size * 0.92, variant: .inApp) {
                animatedSymbol
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                brushRotation = 360
            }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                paintPulse = 1.0
            }
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                dotScale = 1.15
            }
        }
    }
    
    @ViewBuilder
    private var animatedSymbol: some View {
        ZStack {
            // Animated paint stroke
            IconKitPaintStroke()
                .fill(
                    LinearGradient(
                        colors: [
                            KitDesignSystem.accentCyanBright.opacity(paintPulse),
                            KitDesignSystem.accentCyan.opacity(paintPulse * 0.9)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Handle
            IconKitBrushHandle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.82, green: 0.68, blue: 0.48),
                            Color(red: 0.58, green: 0.43, blue: 0.28)
                        ],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Handle highlight
            IconKitBrushHandle()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.35), Color.clear],
                        startPoint: .topTrailing,
                        endPoint: .center
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Ferrule
            IconKitFerrule()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.78, green: 0.78, blue: 0.80),
                            Color(red: 0.58, green: 0.58, blue: 0.60)
                        ],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Bristles
            IconKitBristles()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.32, green: 0.28, blue: 0.22),
                            Color(red: 0.18, green: 0.15, blue: 0.12)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Animated color dots
            ZStack {
                Circle()
                    .fill(KitDesignSystem.accentCyan)
                    .frame(width: size * 0.07, height: size * 0.07)
                    .offset(x: size * 0.11, y: -size * 0.07)
                    .scaleEffect(dotScale)
                
                Circle()
                    .fill(KitDesignSystem.accentCyanBright)
                    .frame(width: size * 0.045, height: size * 0.045)
                    .offset(x: size * 0.07, y: size * 0.045)
                    .scaleEffect(2 - dotScale)
            }
        }
    }
}

// MARK: - Preview

#Preview("IconKit Icon - Professional") {
    VStack(spacing: 30) {
        Text("IconKit Icon")
            .font(.title.bold())
        
        HStack(spacing: 30) {
            VStack {
                IconKitIcon(size: 128, variant: .inApp)
                Text("Standard")
                    .font(.caption)
            }
            
            VStack {
                IconKitIconAnimated(size: 128)
                Text("Animated")
                    .font(.caption)
            }
        }
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
            ForEach([IconVariantType.darkMode, .lightMode, .outline, .accessible], id: \.self) { variant in
                VStack {
                    IconKitIcon(size: 80, variant: variant)
                    Text(variant.displayName)
                        .font(.caption2)
                }
            }
        }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
