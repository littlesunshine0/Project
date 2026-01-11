//
//  DocKitIcon.swift
//  IconKit
//
//  HIG-Compliant Custom Icon for DocKit - Documentation Generation System
//
//  Design Concept:
//  - Document page with pen/pencil representing documentation creation
//  - Layered construction: Background + Page + Lines + Pen
//  - Filled, overlapping shapes (HIG guideline)
//

import SwiftUI

// MARK: - Custom Document Shapes

/// Document page shape
struct DocKitPageShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Document with folded corner
        let cornerFold = w * 0.18
        
        path.move(to: CGPoint(x: w * 0.15, y: h * 0.1))
        path.addLine(to: CGPoint(x: w * 0.85 - cornerFold, y: h * 0.1))
        path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.1 + cornerFold))
        path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.9))
        path.addLine(to: CGPoint(x: w * 0.15, y: h * 0.9))
        path.closeSubpath()
        
        return path
    }
}

/// Folded corner triangle
struct DocKitCornerFold: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cornerFold = w * 0.18
        
        path.move(to: CGPoint(x: w * 0.85 - cornerFold, y: h * 0.1))
        path.addLine(to: CGPoint(x: w * 0.85 - cornerFold, y: h * 0.1 + cornerFold))
        path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.1 + cornerFold))
        path.closeSubpath()
        
        return path
    }
}

/// Pen/pencil shape for writing
struct DocKitPenShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Pen body (angled)
        let penWidth = w * 0.08
        let startX = w * 0.55
        let startY = h * 0.45
        let endX = w * 0.85
        let endY = h * 0.75
        
        // Calculate perpendicular offset for pen width
        let dx = endX - startX
        let dy = endY - startY
        let len = sqrt(dx * dx + dy * dy)
        let px = -dy / len * penWidth / 2
        let py = dx / len * penWidth / 2
        
        // Pen body
        path.move(to: CGPoint(x: startX + px, y: startY + py))
        path.addLine(to: CGPoint(x: endX + px, y: endY + py))
        path.addLine(to: CGPoint(x: endX - px, y: endY - py))
        path.addLine(to: CGPoint(x: startX - px, y: startY - py))
        path.closeSubpath()
        
        // Pen tip (triangle)
        let tipLen = w * 0.08
        let tipX = endX + dx / len * tipLen
        let tipY = endY + dy / len * tipLen
        
        path.move(to: CGPoint(x: endX + px, y: endY + py))
        path.addLine(to: CGPoint(x: tipX, y: tipY))
        path.addLine(to: CGPoint(x: endX - px, y: endY - py))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - DocKit Icon View

public struct DocKitIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 128, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
    }
    
    public var body: some View {
        KitIconBase(size: size, variant: variant) {
            docKitSymbol
        }
    }
    
    @ViewBuilder
    private var docKitSymbol: some View {
        ZStack {
            // Layer 1: Document page
            DocKitPageShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.95),
                            Color.white.opacity(0.85)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 2: Corner fold shadow
            DocKitCornerFold()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.gray.opacity(0.3),
                            Color.gray.opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 3: Text lines
            documentLines
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 4: Pen
            DocKitPenShape()
                .fill(
                    LinearGradient(
                        colors: [
                            KitDesignSystem.fgPrimary,
                            KitDesignSystem.fgSecondary
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
        }
    }
    
    private var documentLines: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            
            let lineStartX = w * 0.25
            let lineEndX = w * 0.5
            let lineY1 = h * 0.35
            let lineY2 = h * 0.48
            let lineY3 = h * 0.61
            
            for y in [lineY1, lineY2, lineY3] {
                var path = Path()
                path.move(to: CGPoint(x: lineStartX, y: y))
                path.addLine(to: CGPoint(x: lineEndX, y: y))
                
                context.stroke(
                    path,
                    with: .color(Color.gray.opacity(0.4)),
                    lineWidth: 2
                )
            }
        }
    }
}

#Preview("DocKit Icon") {
    VStack(spacing: 20) {
        DocKitIcon(size: 128, variant: .inApp)
        Text("DocKit")
            .font(.caption)
    }
    .padding()
}
