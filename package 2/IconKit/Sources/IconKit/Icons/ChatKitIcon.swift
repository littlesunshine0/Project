//
//  ChatKitIcon.swift
//  IconKit
//
//  HIG-Compliant Icon for ChatKit - Chat bubble symbol
//

import SwiftUI

public struct ChatKitIcon: View {
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
                    // Main bubble
                    ChatBubbleShape()
                        .fill(KitDesignSystem.fgPrimary)
                        .frame(width: w * 0.7, height: h * 0.5)
                        .offset(x: -w * 0.05, y: -h * 0.08)
                    
                    // Reply bubble
                    ChatBubbleShape()
                        .fill(KitDesignSystem.accentCyan)
                        .frame(width: w * 0.5, height: h * 0.35)
                        .scaleEffect(x: -1)
                        .offset(x: w * 0.12, y: h * 0.15)
                }
            }
        }
    }
}

struct ChatBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let r = rect.height * 0.25
        
        path.addRoundedRect(in: CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height * 0.85), cornerSize: CGSize(width: r, height: r))
        
        // Tail
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.maxY * 0.85))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.35, y: rect.maxY * 0.85))
        
        return path
    }
}
