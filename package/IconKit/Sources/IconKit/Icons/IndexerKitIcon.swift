//
//  IndexerKitIcon.swift
//  IconKit
//
//  HIG-Compliant Icon for IndexerKit - Index/catalog symbol
//

import SwiftUI

public struct IndexerKitIcon: View {
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
                
                VStack(spacing: h * 0.08) {
                    ForEach(0..<3, id: \.self) { i in
                        HStack(spacing: w * 0.06) {
                            Circle()
                                .fill(i == 1 ? KitDesignSystem.accentCyan : KitDesignSystem.fgSecondary)
                                .frame(width: w * 0.12, height: h * 0.12)
                            RoundedRectangle(cornerRadius: w * 0.02)
                                .fill(KitDesignSystem.fgPrimary.opacity(0.8 - Double(i) * 0.2))
                                .frame(width: w * 0.5, height: h * 0.1)
                        }
                    }
                }
                .frame(width: w, height: h)
            }
        }
    }
}
