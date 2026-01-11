//
//  CollaborationKitIcon.swift
//  IconKit
//
//  HIG-Compliant Icon for CollaborationKit - People/team symbol
//

import SwiftUI

public struct CollaborationKitIcon: View {
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
                    // Person 1 (left)
                    PersonShape()
                        .fill(KitDesignSystem.fgTertiary)
                        .frame(width: w * 0.35, height: h * 0.5)
                        .offset(x: -w * 0.2, y: h * 0.05)
                    
                    // Person 2 (center, front)
                    PersonShape()
                        .fill(KitDesignSystem.fgPrimary)
                        .frame(width: w * 0.4, height: h * 0.55)
                        .offset(y: h * 0.1)
                    
                    // Person 3 (right)
                    PersonShape()
                        .fill(KitDesignSystem.fgSecondary)
                        .frame(width: w * 0.35, height: h * 0.5)
                        .offset(x: w * 0.2, y: h * 0.05)
                    
                    // Connection arc
                    Arc()
                        .stroke(KitDesignSystem.accentCyan, lineWidth: w * 0.03)
                        .frame(width: w * 0.6, height: h * 0.2)
                        .offset(y: -h * 0.25)
                }
            }
        }
    }
}

struct PersonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Head
        let headRadius = rect.width * 0.3
        path.addEllipse(in: CGRect(x: rect.midX - headRadius, y: rect.minY, width: headRadius * 2, height: headRadius * 2))
        // Body
        path.addEllipse(in: CGRect(x: rect.midX - rect.width * 0.4, y: rect.minY + headRadius * 1.8, width: rect.width * 0.8, height: rect.height * 0.6))
        return path
    }
}

struct Arc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY), radius: rect.width / 2, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        return path
    }
}
