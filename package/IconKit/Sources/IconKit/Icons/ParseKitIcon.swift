//
//  ParseKitIcon.swift
//  IconKit
//
//  HIG-Compliant Custom Icon for ParseKit - Universal File Parsing System
//
//  Design Concept:
//  - File with parsing brackets { } representing code/data parsing
//  - Layered construction: Background + File + Brackets
//  - Filled, overlapping shapes (HIG guideline)
//

import SwiftUI

// MARK: - Custom Parse Shapes

/// File shape for parsing
struct ParseKitFileShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Simple file rectangle
        let inset = w * 0.2
        path.addRoundedRect(
            in: CGRect(x: inset, y: h * 0.12, width: w - inset * 2, height: h * 0.76),
            cornerSize: CGSize(width: w * 0.05, height: w * 0.05)
        )
        
        return path
    }
}

/// Left curly bracket shape
struct ParseKitLeftBracket: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w * 0.35
        let cy = h * 0.5
        
        // Left curly bracket {
        path.move(to: CGPoint(x: cx + w * 0.08, y: h * 0.25))
        path.addQuadCurve(
            to: CGPoint(x: cx, y: h * 0.35),
            control: CGPoint(x: cx + w * 0.02, y: h * 0.25)
        )
        path.addLine(to: CGPoint(x: cx, y: cy - h * 0.05))
        path.addQuadCurve(
            to: CGPoint(x: cx - w * 0.06, y: cy),
            control: CGPoint(x: cx - w * 0.04, y: cy - h * 0.02)
        )
        path.addQuadCurve(
            to: CGPoint(x: cx, y: cy + h * 0.05),
            control: CGPoint(x: cx - w * 0.04, y: cy + h * 0.02)
        )
        path.addLine(to: CGPoint(x: cx, y: h * 0.65))
        path.addQuadCurve(
            to: CGPoint(x: cx + w * 0.08, y: h * 0.75),
            control: CGPoint(x: cx + w * 0.02, y: h * 0.75)
        )
        
        return path
    }
}

/// Right curly bracket shape
struct ParseKitRightBracket: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w * 0.65
        let cy = h * 0.5
        
        // Right curly bracket }
        path.move(to: CGPoint(x: cx - w * 0.08, y: h * 0.25))
        path.addQuadCurve(
            to: CGPoint(x: cx, y: h * 0.35),
            control: CGPoint(x: cx - w * 0.02, y: h * 0.25)
        )
        path.addLine(to: CGPoint(x: cx, y: cy - h * 0.05))
        path.addQuadCurve(
            to: CGPoint(x: cx + w * 0.06, y: cy),
            control: CGPoint(x: cx + w * 0.04, y: cy - h * 0.02)
        )
        path.addQuadCurve(
            to: CGPoint(x: cx, y: cy + h * 0.05),
            control: CGPoint(x: cx + w * 0.04, y: cy + h * 0.02)
        )
        path.addLine(to: CGPoint(x: cx, y: h * 0.65))
        path.addQuadCurve(
            to: CGPoint(x: cx - w * 0.08, y: h * 0.75),
            control: CGPoint(x: cx - w * 0.02, y: h * 0.75)
        )
        
        return path
    }
}

// MARK: - ParseKit Icon View

public struct ParseKitIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 128, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
    }
    
    public var body: some View {
        KitIconBase(size: size, variant: variant) {
            parseKitSymbol
        }
    }
    
    @ViewBuilder
    private var parseKitSymbol: some View {
        ZStack {
            // Layer 1: File background
            ParseKitFileShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.9),
                            Color.white.opacity(0.75)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 2: Left bracket
            ParseKitLeftBracket()
                .stroke(
                    LinearGradient(
                        colors: [
                            KitDesignSystem.fgPrimary,
                            KitDesignSystem.fgSecondary
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: StrokeStyle(lineWidth: size * 0.025, lineCap: .round)
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 3: Right bracket
            ParseKitRightBracket()
                .stroke(
                    LinearGradient(
                        colors: [
                            KitDesignSystem.fgPrimary,
                            KitDesignSystem.fgSecondary
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: StrokeStyle(lineWidth: size * 0.025, lineCap: .round)
                )
                .frame(width: size * 0.5, height: size * 0.5)
        }
    }
}

#Preview("ParseKit Icon") {
    VStack(spacing: 20) {
        ParseKitIcon(size: 128, variant: .inApp)
        Text("ParseKit")
            .font(.caption)
    }
    .padding()
}
