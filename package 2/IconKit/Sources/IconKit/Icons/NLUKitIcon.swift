//
//  NLUKitIcon.swift
//  IconKit
//
//  HIG-Compliant Custom Icon for NLUKit - Natural Language Understanding
//
//  Design Concept:
//  - Brain/speech bubble representing language understanding
//  - Layered construction: Background + Brain outline + Neural connections
//  - Filled, overlapping shapes (HIG guideline)
//

import SwiftUI

// MARK: - Custom NLU Shapes

/// Stylized brain shape
struct NLUKitBrainShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w * 0.5
        
        // Simplified brain silhouette
        path.move(to: CGPoint(x: cx - w * 0.25, y: h * 0.55))
        
        // Left side curves
        path.addCurve(
            to: CGPoint(x: cx - w * 0.15, y: h * 0.2),
            control1: CGPoint(x: cx - w * 0.35, y: h * 0.45),
            control2: CGPoint(x: cx - w * 0.3, y: h * 0.22)
        )
        
        // Top left lobe
        path.addCurve(
            to: CGPoint(x: cx, y: h * 0.18),
            control1: CGPoint(x: cx - w * 0.08, y: h * 0.15),
            control2: CGPoint(x: cx - w * 0.02, y: h * 0.16)
        )
        
        // Top right lobe
        path.addCurve(
            to: CGPoint(x: cx + w * 0.15, y: h * 0.2),
            control1: CGPoint(x: cx + w * 0.02, y: h * 0.16),
            control2: CGPoint(x: cx + w * 0.08, y: h * 0.15)
        )
        
        // Right side curves
        path.addCurve(
            to: CGPoint(x: cx + w * 0.25, y: h * 0.55),
            control1: CGPoint(x: cx + w * 0.3, y: h * 0.22),
            control2: CGPoint(x: cx + w * 0.35, y: h * 0.45)
        )
        
        // Bottom curve
        path.addCurve(
            to: CGPoint(x: cx - w * 0.25, y: h * 0.55),
            control1: CGPoint(x: cx + w * 0.15, y: h * 0.68),
            control2: CGPoint(x: cx - w * 0.15, y: h * 0.68)
        )
        
        path.closeSubpath()
        return path
    }
}

/// Speech bubble shape
struct NLUKitSpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Small speech bubble at bottom right
        let bubbleX = w * 0.6
        let bubbleY = h * 0.65
        let bubbleW = w * 0.28
        let bubbleH = h * 0.2
        let cornerR = w * 0.04
        
        path.addRoundedRect(
            in: CGRect(x: bubbleX, y: bubbleY, width: bubbleW, height: bubbleH),
            cornerSize: CGSize(width: cornerR, height: cornerR)
        )
        
        // Tail pointing to brain
        path.move(to: CGPoint(x: bubbleX + w * 0.02, y: bubbleY + bubbleH * 0.3))
        path.addLine(to: CGPoint(x: bubbleX - w * 0.05, y: bubbleY + bubbleH * 0.5))
        path.addLine(to: CGPoint(x: bubbleX + w * 0.02, y: bubbleY + bubbleH * 0.7))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - NLUKit Icon View

public struct NLUKitIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 128, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
    }
    
    public var body: some View {
        KitIconBase(size: size, variant: variant) {
            nluKitSymbol
        }
    }
    
    @ViewBuilder
    private var nluKitSymbol: some View {
        ZStack {
            // Layer 1: Brain shape
            NLUKitBrainShape()
                .fill(
                    LinearGradient(
                        colors: [
                            KitDesignSystem.fgPrimary.opacity(0.9),
                            KitDesignSystem.fgSecondary.opacity(0.8)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 2: Brain highlight
            NLUKitBrainShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.4),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 3: Neural connections
            neuralConnections
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 4: Speech bubble
            NLUKitSpeechBubble()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.95),
                            Color.white.opacity(0.85)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 5: Speech bubble text lines
            speechLines
                .frame(width: size * 0.5, height: size * 0.5)
        }
    }
    
    private var neuralConnections: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            
            // Neural connection dots
            let nodes: [(CGFloat, CGFloat)] = [
                (0.35, 0.32), (0.5, 0.28), (0.65, 0.32),
                (0.38, 0.45), (0.5, 0.42), (0.62, 0.45)
            ]
            
            // Draw connections
            let connections: [(Int, Int)] = [(0, 1), (1, 2), (0, 3), (1, 4), (2, 5), (3, 4), (4, 5)]
            
            for (from, to) in connections {
                var path = Path()
                path.move(to: CGPoint(x: w * nodes[from].0, y: h * nodes[from].1))
                path.addLine(to: CGPoint(x: w * nodes[to].0, y: h * nodes[to].1))
                context.stroke(path, with: .color(Color.white.opacity(0.5)), lineWidth: 1)
            }
            
            // Draw nodes
            for node in nodes {
                let rect = CGRect(x: w * node.0 - 2, y: h * node.1 - 2, width: 4, height: 4)
                context.fill(Circle().path(in: rect), with: .color(Color.white.opacity(0.8)))
            }
        }
    }
    
    private var speechLines: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            
            // Small text lines in speech bubble
            let lineY1 = h * 0.72
            let lineY2 = h * 0.78
            
            for (y, width) in [(lineY1, w * 0.18), (lineY2, w * 0.12)] {
                var path = Path()
                path.move(to: CGPoint(x: w * 0.64, y: y))
                path.addLine(to: CGPoint(x: w * 0.64 + width, y: y))
                context.stroke(path, with: .color(Color.gray.opacity(0.4)), lineWidth: 2)
            }
        }
    }
}

#Preview("NLUKit Icon") {
    VStack(spacing: 20) {
        NLUKitIcon(size: 128, variant: .inApp)
        Text("NLUKit")
            .font(.caption)
    }
    .padding()
}
