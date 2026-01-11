//
//  CommandKitIcon.swift
//  IconKit
//
//  HIG-Compliant Custom Icon for CommandKit - Command System
//
//  Design Concept:
//  - Terminal/command prompt with > cursor
//  - Layered construction: Background + Terminal window + Prompt
//  - Filled, overlapping shapes (HIG guideline)
//

import SwiftUI

// MARK: - Custom Command Shapes

/// Terminal window shape
struct CommandKitTerminalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cornerRadius = w * 0.08
        
        // Terminal window with title bar
        path.addRoundedRect(
            in: CGRect(x: w * 0.1, y: h * 0.15, width: w * 0.8, height: h * 0.7),
            cornerSize: CGSize(width: cornerRadius, height: cornerRadius)
        )
        
        return path
    }
}

/// Terminal title bar
struct CommandKitTitleBar: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cornerRadius = w * 0.08
        
        // Title bar at top
        path.move(to: CGPoint(x: w * 0.1 + cornerRadius, y: h * 0.15))
        path.addLine(to: CGPoint(x: w * 0.9 - cornerRadius, y: h * 0.15))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.9, y: h * 0.15 + cornerRadius),
            control: CGPoint(x: w * 0.9, y: h * 0.15)
        )
        path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.28))
        path.addLine(to: CGPoint(x: w * 0.1, y: h * 0.28))
        path.addLine(to: CGPoint(x: w * 0.1, y: h * 0.15 + cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.1 + cornerRadius, y: h * 0.15),
            control: CGPoint(x: w * 0.1, y: h * 0.15)
        )
        path.closeSubpath()
        
        return path
    }
}

/// Command prompt chevron >
struct CommandKitPromptShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // > chevron
        let startX = w * 0.2
        let midX = w * 0.35
        let endX = w * 0.2
        let topY = h * 0.42
        let midY = h * 0.52
        let bottomY = h * 0.62
        
        path.move(to: CGPoint(x: startX, y: topY))
        path.addLine(to: CGPoint(x: midX, y: midY))
        path.addLine(to: CGPoint(x: endX, y: bottomY))
        
        return path
    }
}

/// Cursor line
struct CommandKitCursorShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Blinking cursor line
        path.move(to: CGPoint(x: w * 0.42, y: h * 0.45))
        path.addLine(to: CGPoint(x: w * 0.42, y: h * 0.6))
        
        return path
    }
}

// MARK: - CommandKit Icon View

public struct CommandKitIcon: View {
    public let size: CGFloat
    public let variant: IconVariantType
    
    public init(size: CGFloat = 128, variant: IconVariantType = .inApp) {
        self.size = size
        self.variant = variant
    }
    
    public var body: some View {
        KitIconBase(size: size, variant: variant) {
            commandKitSymbol
        }
    }
    
    @ViewBuilder
    private var commandKitSymbol: some View {
        ZStack {
            // Layer 1: Terminal window background
            CommandKitTerminalShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.15, green: 0.15, blue: 0.18),
                            Color(red: 0.1, green: 0.1, blue: 0.12)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 2: Title bar
            CommandKitTitleBar()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.25, green: 0.25, blue: 0.28),
                            Color(red: 0.2, green: 0.2, blue: 0.22)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 3: Title bar buttons
            titleBarButtons
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 4: Command prompt
            CommandKitPromptShape()
                .stroke(
                    LinearGradient(
                        colors: [
                            KitDesignSystem.fgPrimary,
                            KitDesignSystem.fgSecondary
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: StrokeStyle(lineWidth: size * 0.025, lineCap: .round, lineJoin: .round)
                )
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Layer 5: Cursor
            CommandKitCursorShape()
                .stroke(
                    KitDesignSystem.accentCyan,
                    style: StrokeStyle(lineWidth: size * 0.02, lineCap: .round)
                )
                .frame(width: size * 0.5, height: size * 0.5)
        }
    }
    
    private var titleBarButtons: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let buttonY = h * 0.215
            let buttonRadius = w * 0.025
            let spacing = w * 0.06
            
            let colors: [Color] = [
                Color(red: 1.0, green: 0.4, blue: 0.4),
                Color(red: 1.0, green: 0.8, blue: 0.3),
                Color(red: 0.4, green: 0.8, blue: 0.4)
            ]
            
            for (i, color) in colors.enumerated() {
                let x = w * 0.18 + CGFloat(i) * spacing
                let rect = CGRect(x: x - buttonRadius, y: buttonY - buttonRadius, width: buttonRadius * 2, height: buttonRadius * 2)
                context.fill(Circle().path(in: rect), with: .color(color))
            }
        }
    }
}

#Preview("CommandKit Icon") {
    VStack(spacing: 20) {
        CommandKitIcon(size: 128, variant: .inApp)
        Text("CommandKit")
            .font(.caption)
    }
    .padding()
}
