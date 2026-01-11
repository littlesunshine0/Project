//
//  WorkflowKitIcon.swift
//  IconKit
//
//  HIG-Compliant Custom Icon for WorkflowKit - Workflow Orchestration System
//
//  Design Concept:
//  - Interconnected nodes representing workflow steps
//  - Flow arrows showing execution path
//  - Layered construction with depth
//  - Blue Kit palette with cyan accents for flow
//

import SwiftUI

// MARK: - Custom Workflow Shapes

/// Workflow node shape - rounded rectangle
struct WorkflowNodeShape: Shape {
    let nodeIndex: Int
    let totalNodes: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Calculate node position based on index
        let positions: [(x: CGFloat, y: CGFloat)] = [
            (0.25, 0.22),  // Top node
            (0.75, 0.22),  // Top-right node
            (0.50, 0.50),  // Center node
            (0.25, 0.78),  // Bottom-left node
            (0.75, 0.78)   // Bottom-right node
        ]
        
        guard nodeIndex < positions.count else { return path }
        
        let pos = positions[nodeIndex]
        let nodeSize = w * 0.18
        let cornerRadius = nodeSize * 0.25
        
        let nodeRect = CGRect(
            x: w * pos.x - nodeSize / 2,
            y: h * pos.y - nodeSize / 2,
            width: nodeSize,
            height: nodeSize
        )
        
        path.addRoundedRect(in: nodeRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        return path
    }
}

/// Flow connection lines between nodes
struct WorkflowFlowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Node positions
        let topLeft = CGPoint(x: w * 0.25, y: h * 0.22)
        let topRight = CGPoint(x: w * 0.75, y: h * 0.22)
        let center = CGPoint(x: w * 0.50, y: h * 0.50)
        let bottomLeft = CGPoint(x: w * 0.25, y: h * 0.78)
        let bottomRight = CGPoint(x: w * 0.75, y: h * 0.78)
        
        let nodeRadius = w * 0.09
        
        // Connection: Top-left to Center
        path.move(to: CGPoint(x: topLeft.x + nodeRadius * 0.7, y: topLeft.y + nodeRadius * 0.7))
        path.addQuadCurve(
            to: CGPoint(x: center.x - nodeRadius * 0.7, y: center.y - nodeRadius * 0.7),
            control: CGPoint(x: topLeft.x + w * 0.08, y: center.y - h * 0.08)
        )
        
        // Connection: Top-right to Center
        path.move(to: CGPoint(x: topRight.x - nodeRadius * 0.7, y: topRight.y + nodeRadius * 0.7))
        path.addQuadCurve(
            to: CGPoint(x: center.x + nodeRadius * 0.7, y: center.y - nodeRadius * 0.7),
            control: CGPoint(x: topRight.x - w * 0.08, y: center.y - h * 0.08)
        )
        
        // Connection: Center to Bottom-left
        path.move(to: CGPoint(x: center.x - nodeRadius * 0.7, y: center.y + nodeRadius * 0.7))
        path.addQuadCurve(
            to: CGPoint(x: bottomLeft.x + nodeRadius * 0.7, y: bottomLeft.y - nodeRadius * 0.7),
            control: CGPoint(x: center.x - w * 0.08, y: center.y + h * 0.08)
        )
        
        // Connection: Center to Bottom-right
        path.move(to: CGPoint(x: center.x + nodeRadius * 0.7, y: center.y + nodeRadius * 0.7))
        path.addQuadCurve(
            to: CGPoint(x: bottomRight.x - nodeRadius * 0.7, y: bottomRight.y - nodeRadius * 0.7),
            control: CGPoint(x: center.x + w * 0.08, y: center.y + h * 0.08)
        )
        
        return path
    }
}

/// Arrow heads for flow direction
struct WorkflowArrowsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Arrow positions (midpoints of connections)
        let arrowPositions: [(x: CGFloat, y: CGFloat, angle: CGFloat)] = [
            (0.35, 0.34, .pi * 0.75),    // Top-left to center
            (0.65, 0.34, .pi * 0.25),    // Top-right to center
            (0.35, 0.66, .pi * 1.25),    // Center to bottom-left
            (0.65, 0.66, .pi * 1.75)     // Center to bottom-right
        ]
        
        let arrowSize = w * 0.04
        
        for arrow in arrowPositions {
            let center = CGPoint(x: w * arrow.x, y: h * arrow.y)
            let angle = arrow.angle
            
            // Arrow head triangle
            let tip = CGPoint(
                x: center.x + cos(angle) * arrowSize,
                y: center.y + sin(angle) * arrowSize
            )
            let left = CGPoint(
                x: center.x + cos(angle + .pi * 0.75) * arrowSize * 0.8,
                y: center.y + sin(angle + .pi * 0.75) * arrowSize * 0.8
            )
            let right = CGPoint(
                x: center.x + cos(angle - .pi * 0.75) * arrowSize * 0.8,
                y: center.y + sin(angle - .pi * 0.75) * arrowSize * 0.8
            )
            
            path.move(to: tip)
            path.addLine(to: left)
            path.addLine(to: right)
            path.closeSubpath()
        }
        
        return path
    }
}

/// Center play/execute symbol
struct WorkflowPlayShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w * 0.50
        let cy = h * 0.50
        let size = w * 0.05
        
        // Play triangle
        path.move(to: CGPoint(x: cx - size * 0.4, y: cy - size * 0.6))
        path.addLine(to: CGPoint(x: cx + size * 0.6, y: cy))
        path.addLine(to: CGPoint(x: cx - size * 0.4, y: cy + size * 0.6))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - WorkflowKit Icon View

/// HIG-Compliant WorkflowKit Icon
/// Interconnected nodes with flow arrows
public struct WorkflowKitIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 128, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
    }
    
    public var body: some View {
        KitIconBase(size: size, variant: variant) {
            workflowKitSymbol
        }
    }
    
    // MARK: - Symbol Layers
    
    @ViewBuilder
    private var workflowKitSymbol: some View {
        ZStack {
            // Layer 1: Flow connections (background)
            WorkflowFlowShape()
                .stroke(
                    LinearGradient(
                        colors: [
                            KitDesignSystem.accentCyan.opacity(0.6),
                            KitDesignSystem.fgSecondary.opacity(0.4)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: StrokeStyle(lineWidth: size * 0.012, lineCap: .round)
                )
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 2: Arrow heads
            WorkflowArrowsShape()
                .fill(KitDesignSystem.accentCyan.opacity(0.8))
                .frame(width: size * 0.55, height: size * 0.55)
            
            // Layer 3: Workflow nodes
            ForEach(0..<5, id: \.self) { index in
                WorkflowNodeShape(nodeIndex: index, totalNodes: 5)
                    .fill(
                        LinearGradient(
                            colors: [
                                index == 2 ? KitDesignSystem.accentCyanBright : KitDesignSystem.fgPrimary,
                                index == 2 ? KitDesignSystem.accentCyan : KitDesignSystem.fgSecondary
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size * 0.55, height: size * 0.55)
            }
            
            // Layer 4: Node highlights (Liquid Glass)
            ForEach(0..<5, id: \.self) { index in
                WorkflowNodeShape(nodeIndex: index, totalNodes: 5)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.4), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                    )
                    .frame(width: size * 0.55, height: size * 0.55)
            }
            
            // Layer 5: Center play symbol
            WorkflowPlayShape()
                .fill(Color.white.opacity(0.9))
                .frame(width: size * 0.55, height: size * 0.55)
        }
    }
}

// MARK: - Animated Version

public struct WorkflowKitIconAnimated: View {
    public let size: CGFloat
    
    @State private var flowProgress: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    
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
                            KitDesignSystem.accentCyan.opacity(0.2 * pulseScale),
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
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                flowProgress = 1.0
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseScale = 1.3
            }
        }
    }
    
    @ViewBuilder
    private var animatedSymbol: some View {
        ZStack {
            // Animated flow lines
            WorkflowFlowShape()
                .trim(from: 0, to: flowProgress)
                .stroke(
                    LinearGradient(
                        colors: [
                            KitDesignSystem.accentCyanBright,
                            KitDesignSystem.accentCyan
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: StrokeStyle(lineWidth: size * 0.014, lineCap: .round)
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Nodes
            ForEach(0..<5, id: \.self) { index in
                WorkflowNodeShape(nodeIndex: index, totalNodes: 5)
                    .fill(
                        LinearGradient(
                            colors: [
                                index == 2 ? KitDesignSystem.accentCyanBright : KitDesignSystem.fgPrimary,
                                index == 2 ? KitDesignSystem.accentCyan : KitDesignSystem.fgSecondary
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size * 0.5, height: size * 0.5)
                    .scaleEffect(index == 2 ? pulseScale * 0.95 : 1.0)
            }
            
            // Center play
            WorkflowPlayShape()
                .fill(Color.white.opacity(0.9))
                .frame(width: size * 0.5, height: size * 0.5)
        }
    }
}

// MARK: - Preview

#Preview("WorkflowKit Icon - Professional") {
    VStack(spacing: 30) {
        Text("WorkflowKit Icon")
            .font(.title.bold())
        
        HStack(spacing: 30) {
            VStack {
                WorkflowKitIcon(size: 128, variant: .inApp)
                Text("Standard")
                    .font(.caption)
            }
            
            VStack {
                WorkflowKitIconAnimated(size: 128)
                Text("Animated")
                    .font(.caption)
            }
        }
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
            ForEach([IconVariantType.darkMode, .lightMode, .outline, .accessible], id: \.self) { variant in
                VStack {
                    WorkflowKitIcon(size: 80, variant: variant)
                    Text(variant.displayName)
                        .font(.caption2)
                }
            }
        }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
