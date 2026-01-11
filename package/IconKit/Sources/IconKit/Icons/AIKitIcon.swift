//
//  AIKitIcon.swift
//  IconKit
//
//  HIG-Compliant Icon for AIKit - Neural network symbol
//

import SwiftUI

public struct AIKitIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 100, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
    }
    
    public var body: some View {
        KitIconBase(size: size, variant: variant) {
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                
                ZStack {
                    // Neural connections
                    ForEach(0..<3, id: \.self) { i in
                        Path { path in
                            path.move(to: CGPoint(x: w * 0.2, y: h * (0.25 + Double(i) * 0.25)))
                            path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.35))
                            path.addLine(to: CGPoint(x: w * 0.8, y: h * (0.25 + Double(i) * 0.25)))
                        }
                        .stroke(KitDesignSystem.fgTertiary, lineWidth: w * 0.02)
                    }
                    
                    // Input nodes
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(KitDesignSystem.fgSecondary)
                            .frame(width: w * 0.15, height: h * 0.15)
                            .offset(x: -w * 0.3, y: h * (-0.25 + Double(i) * 0.25))
                    }
                    
                    // Hidden node
                    Circle()
                        .fill(KitDesignSystem.accentGold)
                        .frame(width: w * 0.2, height: h * 0.2)
                        .offset(y: -h * 0.15)
                    
                    // Output nodes
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(KitDesignSystem.fgPrimary)
                            .frame(width: w * 0.15, height: h * 0.15)
                            .offset(x: w * 0.3, y: h * (-0.25 + Double(i) * 0.25))
                    }
                }
            }
        }
    }
}
