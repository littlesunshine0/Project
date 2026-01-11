//
//  FeedbackKitIcon.swift
//  IconKit
//
//  HIG-Compliant Icon for FeedbackKit - Star/rating symbol
//

import SwiftUI

public struct FeedbackKitIcon: View {
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
                    // Star
                    FeedbackStarShape(points: 5)
                        .fill(
                            LinearGradient(
                                colors: [KitDesignSystem.accentGoldBright, KitDesignSystem.accentGold],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: w * 0.7, height: h * 0.7)
                    
                    // Inner glow
                    FeedbackStarShape(points: 5)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: w * 0.35, height: h * 0.35)
                }
            }
        }
    }
}

struct FeedbackStarShape: Shape {
    let points: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        
        for i in 0..<(points * 2) {
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = Double(i) * .pi / Double(points) - .pi / 2
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )
            if i == 0 { path.move(to: point) }
            else { path.addLine(to: point) }
        }
        path.closeSubpath()
        return path
    }
}
