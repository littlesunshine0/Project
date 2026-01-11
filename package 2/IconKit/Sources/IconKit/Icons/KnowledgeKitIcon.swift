//
//  KnowledgeKitIcon.swift
//  IconKit
//
//  HIG-Compliant Icon for KnowledgeKit - Brain/book symbol
//

import SwiftUI

public struct KnowledgeKitIcon: View {
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
                    // Book base
                    RoundedRectangle(cornerRadius: w * 0.08)
                        .fill(KitDesignSystem.fgTertiary)
                        .frame(width: w * 0.7, height: h * 0.6)
                    
                    // Book spine
                    Rectangle()
                        .fill(KitDesignSystem.fgSecondary)
                        .frame(width: w * 0.06, height: h * 0.6)
                        .offset(x: -w * 0.32)
                    
                    // Knowledge glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [KitDesignSystem.accentGoldBright, KitDesignSystem.accentGold.opacity(0.3)],
                                center: .center,
                                startRadius: 0,
                                endRadius: w * 0.2
                            )
                        )
                        .frame(width: w * 0.35, height: h * 0.35)
                        .offset(y: -h * 0.15)
                }
            }
        }
    }
}
