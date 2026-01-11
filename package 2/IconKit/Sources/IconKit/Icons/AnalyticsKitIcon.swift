//
//  AnalyticsKitIcon.swift
//  IconKit
//
//  HIG-Compliant Icon for AnalyticsKit - Bar chart symbol
//

import SwiftUI

public struct AnalyticsKitIcon: View {
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
                
                HStack(alignment: .bottom, spacing: w * 0.08) {
                    // Bar 1
                    RoundedRectangle(cornerRadius: w * 0.04)
                        .fill(KitDesignSystem.fgTertiary)
                        .frame(width: w * 0.15, height: h * 0.4)
                    // Bar 2
                    RoundedRectangle(cornerRadius: w * 0.04)
                        .fill(KitDesignSystem.fgSecondary)
                        .frame(width: w * 0.15, height: h * 0.7)
                    // Bar 3
                    RoundedRectangle(cornerRadius: w * 0.04)
                        .fill(KitDesignSystem.fgPrimary)
                        .frame(width: w * 0.15, height: h * 0.55)
                    // Bar 4
                    RoundedRectangle(cornerRadius: w * 0.04)
                        .fill(KitDesignSystem.accentCyan)
                        .frame(width: w * 0.15, height: h * 0.85)
                }
                .frame(width: w, height: h, alignment: .bottom)
            }
        }
    }
}
