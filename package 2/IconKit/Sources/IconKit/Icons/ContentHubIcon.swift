//
//  ContentHubIcon.swift
//  IconKit
//
//  HIG-Compliant Custom Icon for ContentHub - Centralized Content Storage
//
//  Design Concept:
//  - Hub/network representing centralized storage
//  - Multiple nodes connecting to central hub
//  - Filled, overlapping shapes (HIG guideline)
//

import SwiftUI

// MARK: - ContentHub Icon View

public struct ContentHubIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 128, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
    }
    
    public var body: some View {
        KitIconBase(size: size, variant: variant) {
            contentHubSymbol
        }
    }
    
    @ViewBuilder
    private var contentHubSymbol: some View {
        ZStack {
            // Layer 1: Connection lines
            connectionLines
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 2: Outer nodes
            outerNodes
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 3: Central hub
            centralHub
                .frame(width: size * 0.5, height: size * 0.5)
        }
    }
    
    private var connectionLines: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let center = CGPoint(x: w * 0.5, y: h * 0.5)
            
            // Node positions (6 nodes around center)
            let nodePositions: [(CGFloat, CGFloat)] = [
                (0.5, 0.15),  // Top
                (0.85, 0.35), // Top-right
                (0.85, 0.65), // Bottom-right
                (0.5, 0.85),  // Bottom
                (0.15, 0.65), // Bottom-left
                (0.15, 0.35)  // Top-left
            ]
            
            // Draw connections from center to each node
            for pos in nodePositions {
                var path = Path()
                path.move(to: center)
                path.addLine(to: CGPoint(x: w * pos.0, y: h * pos.1))
                
                context.stroke(
                    path,
                    with: .linearGradient(
                        Gradient(colors: [
                            KitDesignSystem.fgPrimary.opacity(0.7),
                            KitDesignSystem.fgSecondary.opacity(0.5)
                        ]),
                        startPoint: center,
                        endPoint: CGPoint(x: w * pos.0, y: h * pos.1)
                    ),
                    lineWidth: 2
                )
            }
        }
    }
    
    private var outerNodes: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let nodeRadius = w * 0.06
            
            // Node positions
            let nodePositions: [(CGFloat, CGFloat)] = [
                (0.5, 0.15),
                (0.85, 0.35),
                (0.85, 0.65),
                (0.5, 0.85),
                (0.15, 0.65),
                (0.15, 0.35)
            ]
            
            for pos in nodePositions {
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
                    x: w * pos.0 - nodeRadius * 0.4,
                    y: h * pos.1 - nodeRadius * 0.7,
                    width: nodeRadius * 0.8,
                    height: nodeRadius * 0.5
                )
                context.fill(
                    Ellipse().path(in: highlightRect),
                    with: .color(Color.white.opacity(0.4))
                )
            }
        }
    }
    
    private var centralHub: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let hubRadius = w * 0.15
            let center = CGPoint(x: w * 0.5, y: h * 0.5)
            
            // Glow
            let glowRect = CGRect(
                x: center.x - hubRadius * 1.5,
                y: center.y - hubRadius * 1.5,
                width: hubRadius * 3,
                height: hubRadius * 3
            )
            context.fill(
                Circle().path(in: glowRect),
                with: .radialGradient(
                    Gradient(colors: [
                        KitDesignSystem.accentCyan.opacity(0.4),
                        Color.clear
                    ]),
                    center: center,
                    startRadius: 0,
                    endRadius: hubRadius * 1.5
                )
            )
            
            // Hub circle
            let hubRect = CGRect(
                x: center.x - hubRadius,
                y: center.y - hubRadius,
                width: hubRadius * 2,
                height: hubRadius * 2
            )
            
            context.fill(
                Circle().path(in: hubRect),
                with: .linearGradient(
                    Gradient(colors: [
                        KitDesignSystem.accentCyan,
                        KitDesignSystem.accentCyanBright.opacity(0.8)
                    ]),
                    startPoint: CGPoint(x: hubRect.minX, y: hubRect.minY),
                    endPoint: CGPoint(x: hubRect.maxX, y: hubRect.maxY)
                )
            )
            
            // Hub highlight
            let highlightRect = CGRect(
                x: center.x - hubRadius * 0.5,
                y: center.y - hubRadius * 0.8,
                width: hubRadius,
                height: hubRadius * 0.6
            )
            context.fill(
                Ellipse().path(in: highlightRect),
                with: .color(Color.white.opacity(0.5))
            )
            
            // Inner icon (database symbol)
            let iconSize = hubRadius * 0.6
            let iconRect = CGRect(
                x: center.x - iconSize / 2,
                y: center.y - iconSize / 2,
                width: iconSize,
                height: iconSize
            )
            
            // Draw simplified database icon
            var dbPath = Path()
            let dbTop = iconRect.minY + iconSize * 0.2
            let dbBottom = iconRect.maxY - iconSize * 0.2
            let dbWidth = iconSize * 0.8
            let dbX = center.x - dbWidth / 2
            
            // Top ellipse
            dbPath.addEllipse(in: CGRect(x: dbX, y: dbTop - iconSize * 0.1, width: dbWidth, height: iconSize * 0.25))
            
            // Body
            dbPath.move(to: CGPoint(x: dbX, y: dbTop))
            dbPath.addLine(to: CGPoint(x: dbX, y: dbBottom))
            dbPath.addQuadCurve(
                to: CGPoint(x: dbX + dbWidth, y: dbBottom),
                control: CGPoint(x: center.x, y: dbBottom + iconSize * 0.15)
            )
            dbPath.addLine(to: CGPoint(x: dbX + dbWidth, y: dbTop))
            
            context.stroke(dbPath, with: .color(Color.white.opacity(0.9)), lineWidth: 1.5)
        }
    }
}

#Preview("ContentHub Icon") {
    VStack(spacing: 20) {
        ContentHubIcon(size: 128, variant: .inApp)
        Text("ContentHub")
            .font(.caption)
    }
    .padding()
}
