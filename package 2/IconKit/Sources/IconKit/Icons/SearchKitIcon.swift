//
//  SearchKitIcon.swift
//  IconKit
//
//  HIG-Compliant Custom Icon for SearchKit - Universal Search System
//
//  Design Concept:
//  - Magnifying glass representing search functionality
//  - Layered construction: Background + Glass + Handle + Shine
//  - Filled, overlapping shapes (HIG guideline)
//

import SwiftUI

// MARK: - Custom Search Shapes

/// Magnifying glass lens (circle)
struct SearchKitLensShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Lens circle
        let centerX = w * 0.4
        let centerY = h * 0.4
        let radius = w * 0.25
        
        path.addEllipse(in: CGRect(
            x: centerX - radius,
            y: centerY - radius,
            width: radius * 2,
            height: radius * 2
        ))
        
        return path
    }
}

/// Magnifying glass handle
struct SearchKitHandleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Handle (angled rectangle)
        let handleWidth = w * 0.1
        let startX = w * 0.55
        let startY = h * 0.55
        let endX = w * 0.8
        let endY = h * 0.8
        
        // Calculate perpendicular offset
        let dx = endX - startX
        let dy = endY - startY
        let len = sqrt(dx * dx + dy * dy)
        let px = -dy / len * handleWidth / 2
        let py = dx / len * handleWidth / 2
        
        path.move(to: CGPoint(x: startX + px, y: startY + py))
        path.addLine(to: CGPoint(x: endX + px, y: endY + py))
        
        // Rounded end
        path.addQuadCurve(
            to: CGPoint(x: endX - px, y: endY - py),
            control: CGPoint(x: endX + dx / len * handleWidth * 0.3, y: endY + dy / len * handleWidth * 0.3)
        )
        
        path.addLine(to: CGPoint(x: startX - px, y: startY - py))
        path.closeSubpath()
        
        return path
    }
}

/// Lens shine highlight
struct SearchKitShineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Small shine arc
        let centerX = w * 0.32
        let centerY = h * 0.32
        
        path.addArc(
            center: CGPoint(x: centerX, y: centerY),
            radius: w * 0.08,
            startAngle: .degrees(200),
            endAngle: .degrees(320),
            clockwise: false
        )
        
        return path
    }
}

// MARK: - SearchKit Icon View

public struct SearchKitIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 128, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
    }
    
    public var body: some View {
        KitIconBase(size: size, variant: variant) {
            searchKitSymbol
        }
    }
    
    @ViewBuilder
    private var searchKitSymbol: some View {
        ZStack {
            // Layer 1: Handle (behind lens)
            SearchKitHandleShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.6, green: 0.6, blue: 0.65),
                            Color(red: 0.45, green: 0.45, blue: 0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 2: Lens outer ring
            SearchKitLensShape()
                .stroke(
                    LinearGradient(
                        colors: [
                            KitDesignSystem.fgPrimary,
                            KitDesignSystem.fgSecondary
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: size * 0.035
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 3: Lens glass fill
            SearchKitLensShape()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.1),
                            KitDesignSystem.fgPrimary.opacity(0.15)
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size * 0.2
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 4: Shine highlight
            SearchKitShineShape()
                .stroke(
                    Color.white.opacity(0.7),
                    style: StrokeStyle(lineWidth: size * 0.015, lineCap: .round)
                )
                .frame(width: size * 0.5, height: size * 0.5)
        }
    }
}

#Preview("SearchKit Icon") {
    VStack(spacing: 20) {
        SearchKitIcon(size: 128, variant: .inApp)
        Text("SearchKit")
            .font(.caption)
    }
    .padding()
}
