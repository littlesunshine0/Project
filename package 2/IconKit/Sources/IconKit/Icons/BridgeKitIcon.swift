//
//  BridgeKitIcon.swift
//  IconKit
//
//  HIG-Compliant Icon for BridgeKit Package
//  Symbol: Two connected nodes with bridge arc
//

import SwiftUI

/// BridgeKit icon - two nodes connected by a bridge arc
public struct BridgeKitIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 100, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
    }
    
    public var body: some View {
        KitIconBase(size: size, variant: variant) {
            BridgeSymbol()
        }
    }
}

/// Bridge symbol - two nodes connected by arc
struct BridgeSymbol: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            ZStack {
                // Bridge arc connecting the nodes
                BridgeArcShape()
                    .stroke(
                        LinearGradient(
                            colors: [
                                KitDesignSystem.fgPrimary,
                                KitDesignSystem.fgSecondary
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: w * 0.06, lineCap: .round)
                    )
                    .frame(width: w * 0.7, height: h * 0.4)
                    .offset(y: -h * 0.05)
                
                // Left node
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                KitDesignSystem.accentCyanBright,
                                KitDesignSystem.accentCyan
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: w * 0.15
                        )
                    )
                    .frame(width: w * 0.28, height: h * 0.28)
                    .offset(x: -w * 0.25, y: h * 0.12)
                
                // Right node
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                KitDesignSystem.accentGoldBright,
                                KitDesignSystem.accentGold
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: w * 0.15
                        )
                    )
                    .frame(width: w * 0.28, height: h * 0.28)
                    .offset(x: w * 0.25, y: h * 0.12)
                
                // Data flow dots on bridge
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Color.white.opacity(0.8))
                        .frame(width: w * 0.05, height: h * 0.05)
                        .offset(
                            x: CGFloat(i - 1) * w * 0.18,
                            y: -h * 0.15 + CGFloat(abs(i - 1)) * h * 0.05
                        )
                }
            }
        }
    }
}

/// Bridge arc shape
struct BridgeArcShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let startX = rect.minX
        let endX = rect.maxX
        let midX = rect.midX
        let bottomY = rect.maxY
        let topY = rect.minY
        
        path.move(to: CGPoint(x: startX, y: bottomY))
        path.addQuadCurve(
            to: CGPoint(x: endX, y: bottomY),
            control: CGPoint(x: midX, y: topY)
        )
        
        return path
    }
}

// MARK: - Preview

#Preview("BridgeKit Icon") {
    VStack(spacing: 20) {
        BridgeKitIcon(size: 200)
        
        HStack(spacing: 20) {
            BridgeKitIcon(size: 80, variant: .inApp)
            BridgeKitIcon(size: 80, variant: .darkMode)
            BridgeKitIcon(size: 80, variant: .lightMode)
        }
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}
