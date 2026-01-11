//
//  LearnKitIcon.swift
//  IconKit
//
//  HIG-Compliant Custom Icon for LearnKit - Machine Learning & Prediction
//
//  Design Concept:
//  - Neural network nodes representing machine learning
//  - Layered construction: Background + Nodes + Connections + Glow
//  - Filled, overlapping shapes (HIG guideline)
//

import SwiftUI

// MARK: - LearnKit Icon View

public struct LearnKitIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 128, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
    }
    
    public var body: some View {
        KitIconBase(size: size, variant: variant) {
            learnKitSymbol
        }
    }
    
    @ViewBuilder
    private var learnKitSymbol: some View {
        ZStack {
            // Layer 1: Neural network connections
            neuralConnections
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 2: Input layer nodes
            inputNodes
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 3: Hidden layer nodes
            hiddenNodes
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 4: Output node
            outputNode
                .frame(width: size * 0.5, height: size * 0.5)
        }
    }
    
    private var neuralConnections: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            
            // Input layer positions
            let inputNodes: [(CGFloat, CGFloat)] = [
                (0.2, 0.25), (0.2, 0.5), (0.2, 0.75)
            ]
            
            // Hidden layer positions
            let hiddenNodes: [(CGFloat, CGFloat)] = [
                (0.5, 0.3), (0.5, 0.7)
            ]
            
            // Output position
            let outputNode: (CGFloat, CGFloat) = (0.8, 0.5)
            
            // Draw connections from input to hidden
            for input in inputNodes {
                for hidden in hiddenNodes {
                    var path = Path()
                    path.move(to: CGPoint(x: w * input.0, y: h * input.1))
                    path.addLine(to: CGPoint(x: w * hidden.0, y: h * hidden.1))
                    context.stroke(
                        path,
                        with: .linearGradient(
                            Gradient(colors: [
                                KitDesignSystem.fgPrimary.opacity(0.6),
                                KitDesignSystem.fgSecondary.opacity(0.4)
                            ]),
                            startPoint: CGPoint(x: w * input.0, y: h * input.1),
                            endPoint: CGPoint(x: w * hidden.0, y: h * hidden.1)
                        ),
                        lineWidth: 1.5
                    )
                }
            }
            
            // Draw connections from hidden to output
            for hidden in hiddenNodes {
                var path = Path()
                path.move(to: CGPoint(x: w * hidden.0, y: h * hidden.1))
                path.addLine(to: CGPoint(x: w * outputNode.0, y: h * outputNode.1))
                context.stroke(
                    path,
                    with: .linearGradient(
                        Gradient(colors: [
                            KitDesignSystem.fgSecondary.opacity(0.5),
                            KitDesignSystem.accentCyan.opacity(0.7)
                        ]),
                        startPoint: CGPoint(x: w * hidden.0, y: h * hidden.1),
                        endPoint: CGPoint(x: w * outputNode.0, y: h * outputNode.1)
                    ),
                    lineWidth: 2
                )
            }
        }
    }
    
    private var inputNodes: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let nodeRadius = w * 0.06
            
            let positions: [(CGFloat, CGFloat)] = [
                (0.2, 0.25), (0.2, 0.5), (0.2, 0.75)
            ]
            
            for pos in positions {
                let rect = CGRect(
                    x: w * pos.0 - nodeRadius,
                    y: h * pos.1 - nodeRadius,
                    width: nodeRadius * 2,
                    height: nodeRadius * 2
                )
                
                // Node fill
                context.fill(
                    Circle().path(in: rect),
                    with: .linearGradient(
                        Gradient(colors: [
                            KitDesignSystem.fgPrimary,
                            KitDesignSystem.fgSecondary
                        ]),
                        startPoint: CGPoint(x: rect.minX, y: rect.minY),
                        endPoint: CGPoint(x: rect.maxX, y: rect.maxY)
                    )
                )
                
                // Node highlight
                let highlightRect = CGRect(
                    x: w * pos.0 - nodeRadius * 0.5,
                    y: h * pos.1 - nodeRadius * 0.8,
                    width: nodeRadius,
                    height: nodeRadius * 0.6
                )
                context.fill(
                    Ellipse().path(in: highlightRect),
                    with: .color(Color.white.opacity(0.4))
                )
            }
        }
    }
    
    private var hiddenNodes: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let nodeRadius = w * 0.08
            
            let positions: [(CGFloat, CGFloat)] = [
                (0.5, 0.3), (0.5, 0.7)
            ]
            
            for pos in positions {
                let rect = CGRect(
                    x: w * pos.0 - nodeRadius,
                    y: h * pos.1 - nodeRadius,
                    width: nodeRadius * 2,
                    height: nodeRadius * 2
                )
                
                // Node fill
                context.fill(
                    Circle().path(in: rect),
                    with: .linearGradient(
                        Gradient(colors: [
                            KitDesignSystem.fgPrimary.opacity(0.9),
                            KitDesignSystem.fgTertiary
                        ]),
                        startPoint: CGPoint(x: rect.minX, y: rect.minY),
                        endPoint: CGPoint(x: rect.maxX, y: rect.maxY)
                    )
                )
                
                // Node highlight
                let highlightRect = CGRect(
                    x: w * pos.0 - nodeRadius * 0.5,
                    y: h * pos.1 - nodeRadius * 0.8,
                    width: nodeRadius,
                    height: nodeRadius * 0.6
                )
                context.fill(
                    Ellipse().path(in: highlightRect),
                    with: .color(Color.white.opacity(0.35))
                )
            }
        }
    }
    
    private var outputNode: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let nodeRadius = w * 0.1
            let pos: (CGFloat, CGFloat) = (0.8, 0.5)
            
            // Glow
            let glowRect = CGRect(
                x: w * pos.0 - nodeRadius * 1.5,
                y: h * pos.1 - nodeRadius * 1.5,
                width: nodeRadius * 3,
                height: nodeRadius * 3
            )
            context.fill(
                Circle().path(in: glowRect),
                with: .radialGradient(
                    Gradient(colors: [
                        KitDesignSystem.accentCyan.opacity(0.4),
                        Color.clear
                    ]),
                    center: CGPoint(x: w * pos.0, y: h * pos.1),
                    startRadius: 0,
                    endRadius: nodeRadius * 1.5
                )
            )
            
            let rect = CGRect(
                x: w * pos.0 - nodeRadius,
                y: h * pos.1 - nodeRadius,
                width: nodeRadius * 2,
                height: nodeRadius * 2
            )
            
            // Node fill
            context.fill(
                Circle().path(in: rect),
                with: .linearGradient(
                    Gradient(colors: [
                        KitDesignSystem.accentCyan,
                        KitDesignSystem.accentCyanBright.opacity(0.8)
                    ]),
                    startPoint: CGPoint(x: rect.minX, y: rect.minY),
                    endPoint: CGPoint(x: rect.maxX, y: rect.maxY)
                )
            )
            
            // Node highlight
            let highlightRect = CGRect(
                x: w * pos.0 - nodeRadius * 0.5,
                y: h * pos.1 - nodeRadius * 0.8,
                width: nodeRadius,
                height: nodeRadius * 0.6
            )
            context.fill(
                Ellipse().path(in: highlightRect),
                with: .color(Color.white.opacity(0.5))
            )
        }
    }
}

#Preview("LearnKit Icon") {
    VStack(spacing: 20) {
        LearnKitIcon(size: 128, variant: .inApp)
        Text("LearnKit")
            .font(.caption)
    }
    .padding()
}
