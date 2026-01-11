//
//  ExportKitIcon.swift
//  IconKit
//
//  HIG-Compliant Icon for ExportKit - Export arrow symbol
//

import SwiftUI

public struct ExportKitIcon: View {
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
                    // Document
                    RoundedRectangle(cornerRadius: w * 0.08)
                        .fill(KitDesignSystem.fgTertiary)
                        .frame(width: w * 0.5, height: h * 0.65)
                        .offset(x: -w * 0.1)
                    
                    // Export arrow
                    ExportArrowShape()
                        .fill(KitDesignSystem.accentCyan)
                        .frame(width: w * 0.35, height: h * 0.5)
                        .offset(x: w * 0.15, y: -h * 0.05)
                }
            }
        }
    }
}

struct ExportArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Arrow shaft
        path.move(to: CGPoint(x: w * 0.3, y: h))
        path.addLine(to: CGPoint(x: w * 0.3, y: h * 0.4))
        path.addLine(to: CGPoint(x: 0, y: h * 0.4))
        path.addLine(to: CGPoint(x: w * 0.5, y: 0))
        path.addLine(to: CGPoint(x: w, y: h * 0.4))
        path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.4))
        path.addLine(to: CGPoint(x: w * 0.7, y: h))
        path.closeSubpath()
        
        return path
    }
}
