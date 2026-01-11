//
//  NavigationIcons.swift
//  IconKit
//
//  Custom SwiftUI navigation icons for FlowKit - HIG compliant
//  Replaces SF Symbols with custom-drawn icons
//

import SwiftUI

// MARK: - Navigation Icon Protocol

public protocol NavigationIconStyle {
    var size: CGFloat { get }
    var primaryColor: Color { get }
    var isSelected: Bool { get }
}

// MARK: - Dashboard Icon

public struct DashboardIcon: View {
    public let size: CGFloat
    public let color: Color
    public let isSelected: Bool
    
    public init(size: CGFloat = 24, color: Color = .primary, isSelected: Bool = false) {
        self.size = size
        self.color = color
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Canvas { context, canvasSize in
            let s = min(canvasSize.width, canvasSize.height)
            let padding = s * 0.15
            let gridSize = s - (padding * 2)
            let cellSize = gridSize * 0.45
            let gap = gridSize * 0.1
            
            // Top-left (large)
            let topLeft = Path(roundedRect: CGRect(x: padding, y: padding, width: cellSize, height: cellSize), cornerRadius: s * 0.08)
            context.fill(topLeft, with: .color(color.opacity(isSelected ? 1.0 : 0.8)))
            
            // Top-right
            let topRight = Path(roundedRect: CGRect(x: padding + cellSize + gap, y: padding, width: cellSize, height: cellSize * 0.6), cornerRadius: s * 0.06)
            context.fill(topRight, with: .color(color.opacity(isSelected ? 0.9 : 0.6)))
            
            // Bottom-left
            let bottomLeft = Path(roundedRect: CGRect(x: padding, y: padding + cellSize + gap, width: cellSize * 0.6, height: cellSize), cornerRadius: s * 0.06)
            context.fill(bottomLeft, with: .color(color.opacity(isSelected ? 0.9 : 0.6)))
            
            // Bottom-right
            let bottomRight = Path(roundedRect: CGRect(x: padding + cellSize * 0.7 + gap, y: padding + cellSize * 0.7 + gap, width: cellSize * 0.75, height: cellSize * 0.75), cornerRadius: s * 0.06)
            context.fill(bottomRight, with: .color(color.opacity(isSelected ? 0.85 : 0.5)))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Workflows Icon

public struct WorkflowsIcon: View {
    public let size: CGFloat
    public let color: Color
    public let isSelected: Bool
    
    public init(size: CGFloat = 24, color: Color = .primary, isSelected: Bool = false) {
        self.size = size
        self.color = color
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Canvas { context, canvasSize in
            let s = min(canvasSize.width, canvasSize.height)
            let cx = s / 2
            let cy = s / 2
            let nodeRadius = s * 0.12
            
            // Draw connecting lines first
            var linePath = Path()
            linePath.move(to: CGPoint(x: cx, y: s * 0.2))
            linePath.addLine(to: CGPoint(x: cx, y: cy))
            linePath.addLine(to: CGPoint(x: s * 0.25, y: s * 0.75))
            linePath.move(to: CGPoint(x: cx, y: cy))
            linePath.addLine(to: CGPoint(x: s * 0.75, y: s * 0.75))
            context.stroke(linePath, with: .color(color.opacity(isSelected ? 0.7 : 0.4)), lineWidth: s * 0.04)
            
            // Top node
            let topNode = Path(ellipseIn: CGRect(x: cx - nodeRadius, y: s * 0.2 - nodeRadius, width: nodeRadius * 2, height: nodeRadius * 2))
            context.fill(topNode, with: .color(color.opacity(isSelected ? 1.0 : 0.8)))
            
            // Center node
            let centerNode = Path(ellipseIn: CGRect(x: cx - nodeRadius, y: cy - nodeRadius, width: nodeRadius * 2, height: nodeRadius * 2))
            context.fill(centerNode, with: .color(color))
            
            // Bottom-left node
            let blNode = Path(ellipseIn: CGRect(x: s * 0.25 - nodeRadius, y: s * 0.75 - nodeRadius, width: nodeRadius * 2, height: nodeRadius * 2))
            context.fill(blNode, with: .color(color.opacity(isSelected ? 0.9 : 0.6)))
            
            // Bottom-right node
            let brNode = Path(ellipseIn: CGRect(x: s * 0.75 - nodeRadius, y: s * 0.75 - nodeRadius, width: nodeRadius * 2, height: nodeRadius * 2))
            context.fill(brNode, with: .color(color.opacity(isSelected ? 0.9 : 0.6)))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Agents Icon (CPU/Brain)

public struct AgentsIcon: View {
    public let size: CGFloat
    public let color: Color
    public let isSelected: Bool
    
    public init(size: CGFloat = 24, color: Color = .primary, isSelected: Bool = false) {
        self.size = size
        self.color = color
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Canvas { context, canvasSize in
            let s = min(canvasSize.width, canvasSize.height)
            let padding = s * 0.2
            let coreSize = s - (padding * 2)
            
            // Core chip
            let core = Path(roundedRect: CGRect(x: padding, y: padding, width: coreSize, height: coreSize), cornerRadius: s * 0.1)
            context.fill(core, with: .color(color.opacity(isSelected ? 1.0 : 0.8)))
            
            // Inner detail
            let inner = Path(roundedRect: CGRect(x: padding + coreSize * 0.2, y: padding + coreSize * 0.2, width: coreSize * 0.6, height: coreSize * 0.6), cornerRadius: s * 0.05)
            context.fill(inner, with: .color(color.opacity(0.3)))
            
            // Pins
            let pinWidth = s * 0.06
            let pinLength = s * 0.12
            let pinPositions: [CGFloat] = [0.35, 0.5, 0.65]
            
            for pos in pinPositions {
                // Top pins
                let topPin = Path(roundedRect: CGRect(x: s * pos - pinWidth/2, y: padding - pinLength, width: pinWidth, height: pinLength), cornerRadius: pinWidth * 0.3)
                context.fill(topPin, with: .color(color.opacity(isSelected ? 0.7 : 0.5)))
                
                // Bottom pins
                let bottomPin = Path(roundedRect: CGRect(x: s * pos - pinWidth/2, y: padding + coreSize, width: pinWidth, height: pinLength), cornerRadius: pinWidth * 0.3)
                context.fill(bottomPin, with: .color(color.opacity(isSelected ? 0.7 : 0.5)))
                
                // Left pins
                let leftPin = Path(roundedRect: CGRect(x: padding - pinLength, y: s * pos - pinWidth/2, width: pinLength, height: pinWidth), cornerRadius: pinWidth * 0.3)
                context.fill(leftPin, with: .color(color.opacity(isSelected ? 0.7 : 0.5)))
                
                // Right pins
                let rightPin = Path(roundedRect: CGRect(x: padding + coreSize, y: s * pos - pinWidth/2, width: pinLength, height: pinWidth), cornerRadius: pinWidth * 0.3)
                context.fill(rightPin, with: .color(color.opacity(isSelected ? 0.7 : 0.5)))
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Projects Icon (Folder)

public struct ProjectsIcon: View {
    public let size: CGFloat
    public let color: Color
    public let isSelected: Bool
    
    public init(size: CGFloat = 24, color: Color = .primary, isSelected: Bool = false) {
        self.size = size
        self.color = color
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Canvas { context, canvasSize in
            let s = min(canvasSize.width, canvasSize.height)
            let padding = s * 0.12
            
            // Folder back
            var backPath = Path()
            backPath.move(to: CGPoint(x: padding, y: s * 0.35))
            backPath.addLine(to: CGPoint(x: padding, y: s - padding))
            backPath.addLine(to: CGPoint(x: s - padding, y: s - padding))
            backPath.addLine(to: CGPoint(x: s - padding, y: s * 0.35))
            backPath.addLine(to: CGPoint(x: s * 0.55, y: s * 0.35))
            backPath.addLine(to: CGPoint(x: s * 0.45, y: s * 0.25))
            backPath.addLine(to: CGPoint(x: padding, y: s * 0.25))
            backPath.closeSubpath()
            context.fill(backPath, with: .color(color.opacity(isSelected ? 1.0 : 0.8)))
            
            // Folder front highlight
            var frontPath = Path()
            frontPath.move(to: CGPoint(x: padding + s * 0.05, y: s * 0.45))
            frontPath.addLine(to: CGPoint(x: s - padding - s * 0.05, y: s * 0.45))
            frontPath.addLine(to: CGPoint(x: s - padding - s * 0.05, y: s - padding - s * 0.05))
            frontPath.addLine(to: CGPoint(x: padding + s * 0.05, y: s - padding - s * 0.05))
            frontPath.closeSubpath()
            context.fill(frontPath, with: .color(color.opacity(0.3)))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Commands Icon (Terminal)

public struct CommandsIcon: View {
    public let size: CGFloat
    public let color: Color
    public let isSelected: Bool
    
    public init(size: CGFloat = 24, color: Color = .primary, isSelected: Bool = false) {
        self.size = size
        self.color = color
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Canvas { context, canvasSize in
            let s = min(canvasSize.width, canvasSize.height)
            let padding = s * 0.15
            
            // Terminal window
            let window = Path(roundedRect: CGRect(x: padding, y: padding, width: s - padding * 2, height: s - padding * 2), cornerRadius: s * 0.1)
            context.fill(window, with: .color(color.opacity(isSelected ? 0.2 : 0.1)))
            context.stroke(window, with: .color(color.opacity(isSelected ? 1.0 : 0.7)), lineWidth: s * 0.04)
            
            // Prompt chevron >_
            var chevron = Path()
            chevron.move(to: CGPoint(x: s * 0.28, y: s * 0.4))
            chevron.addLine(to: CGPoint(x: s * 0.42, y: s * 0.5))
            chevron.addLine(to: CGPoint(x: s * 0.28, y: s * 0.6))
            context.stroke(chevron, with: .color(color), style: StrokeStyle(lineWidth: s * 0.06, lineCap: .round, lineJoin: .round))
            
            // Cursor line
            let cursor = Path(roundedRect: CGRect(x: s * 0.5, y: s * 0.45, width: s * 0.22, height: s * 0.1), cornerRadius: s * 0.02)
            context.fill(cursor, with: .color(color.opacity(isSelected ? 0.8 : 0.5)))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Documentation Icon (Book)

public struct DocumentationIcon: View {
    public let size: CGFloat
    public let color: Color
    public let isSelected: Bool
    
    public init(size: CGFloat = 24, color: Color = .primary, isSelected: Bool = false) {
        self.size = size
        self.color = color
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Canvas { context, canvasSize in
            let s = min(canvasSize.width, canvasSize.height)
            let padding = s * 0.12
            
            // Book spine
            let spine = Path(roundedRect: CGRect(x: padding, y: padding, width: s * 0.15, height: s - padding * 2), cornerRadius: s * 0.03)
            context.fill(spine, with: .color(color))
            
            // Book cover
            var cover = Path()
            cover.move(to: CGPoint(x: padding + s * 0.12, y: padding))
            cover.addLine(to: CGPoint(x: s - padding, y: padding))
            cover.addLine(to: CGPoint(x: s - padding, y: s - padding))
            cover.addLine(to: CGPoint(x: padding + s * 0.12, y: s - padding))
            cover.closeSubpath()
            context.fill(cover, with: .color(color.opacity(isSelected ? 0.9 : 0.7)))
            
            // Page lines
            let lineY: [CGFloat] = [0.35, 0.5, 0.65]
            for y in lineY {
                let line = Path(roundedRect: CGRect(x: s * 0.38, y: s * y, width: s * 0.4, height: s * 0.04), cornerRadius: s * 0.01)
                context.fill(line, with: .color(color.opacity(0.3)))
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Chat Icon (Sparkles/AI)

public struct ChatIcon: View {
    public let size: CGFloat
    public let color: Color
    public let isSelected: Bool
    
    public init(size: CGFloat = 24, color: Color = .primary, isSelected: Bool = false) {
        self.size = size
        self.color = color
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Canvas { context, canvasSize in
            let s = min(canvasSize.width, canvasSize.height)
            
            // Main sparkle (4-point star)
            func drawSparkle(at center: CGPoint, radius: CGFloat, opacity: Double) {
                var path = Path()
                path.move(to: CGPoint(x: center.x, y: center.y - radius))
                path.addQuadCurve(to: CGPoint(x: center.x + radius, y: center.y), control: CGPoint(x: center.x + radius * 0.15, y: center.y - radius * 0.15))
                path.addQuadCurve(to: CGPoint(x: center.x, y: center.y + radius), control: CGPoint(x: center.x + radius * 0.15, y: center.y + radius * 0.15))
                path.addQuadCurve(to: CGPoint(x: center.x - radius, y: center.y), control: CGPoint(x: center.x - radius * 0.15, y: center.y + radius * 0.15))
                path.addQuadCurve(to: CGPoint(x: center.x, y: center.y - radius), control: CGPoint(x: center.x - radius * 0.15, y: center.y - radius * 0.15))
                context.fill(path, with: .color(color.opacity(opacity)))
            }
            
            // Large sparkle
            drawSparkle(at: CGPoint(x: s * 0.45, y: s * 0.45), radius: s * 0.32, opacity: isSelected ? 1.0 : 0.8)
            
            // Small sparkle top-right
            drawSparkle(at: CGPoint(x: s * 0.78, y: s * 0.22), radius: s * 0.15, opacity: isSelected ? 0.9 : 0.6)
            
            // Tiny sparkle bottom-right
            drawSparkle(at: CGPoint(x: s * 0.75, y: s * 0.72), radius: s * 0.1, opacity: isSelected ? 0.7 : 0.4)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Settings Icon (Gear)

public struct SettingsIcon: View {
    public let size: CGFloat
    public let color: Color
    public let isSelected: Bool
    
    public init(size: CGFloat = 24, color: Color = .primary, isSelected: Bool = false) {
        self.size = size
        self.color = color
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Canvas { context, canvasSize in
            let s = min(canvasSize.width, canvasSize.height)
            let cx = s / 2
            let cy = s / 2
            let outerR = s * 0.42
            let innerR = s * 0.28
            let toothCount = 8
            let toothDepth = s * 0.1
            
            // Gear teeth
            var gearPath = Path()
            for i in 0..<toothCount {
                let angle1 = CGFloat(i) * 2 * .pi / CGFloat(toothCount)
                let angle2 = angle1 + .pi / CGFloat(toothCount) * 0.6
                let angle3 = angle1 + .pi / CGFloat(toothCount)
                
                let p1 = CGPoint(x: cx + innerR * cos(angle1), y: cy + innerR * sin(angle1))
                let p2 = CGPoint(x: cx + outerR * cos(angle1 + 0.1), y: cy + outerR * sin(angle1 + 0.1))
                let p3 = CGPoint(x: cx + outerR * cos(angle2 - 0.1), y: cy + outerR * sin(angle2 - 0.1))
                let p4 = CGPoint(x: cx + innerR * cos(angle3), y: cy + innerR * sin(angle3))
                
                if i == 0 { gearPath.move(to: p1) }
                gearPath.addLine(to: p2)
                gearPath.addLine(to: p3)
                gearPath.addLine(to: p4)
            }
            gearPath.closeSubpath()
            context.fill(gearPath, with: .color(color.opacity(isSelected ? 1.0 : 0.8)))
            
            // Center hole
            let centerHole = Path(ellipseIn: CGRect(x: cx - s * 0.12, y: cy - s * 0.12, width: s * 0.24, height: s * 0.24))
            context.blendMode = .destinationOut
            context.fill(centerHole, with: .color(.black))
        }
        .frame(width: size, height: size)
        .compositingGroup()
    }
}

// MARK: - Search Icon

public struct SearchIcon: View {
    public let size: CGFloat
    public let color: Color
    public let isSelected: Bool
    
    public init(size: CGFloat = 24, color: Color = .primary, isSelected: Bool = false) {
        self.size = size
        self.color = color
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Canvas { context, canvasSize in
            let s = min(canvasSize.width, canvasSize.height)
            let glassRadius = s * 0.28
            let glassCenterX = s * 0.4
            let glassCenterY = s * 0.4
            
            // Magnifying glass circle
            let glass = Path(ellipseIn: CGRect(x: glassCenterX - glassRadius, y: glassCenterY - glassRadius, width: glassRadius * 2, height: glassRadius * 2))
            context.stroke(glass, with: .color(color.opacity(isSelected ? 1.0 : 0.8)), lineWidth: s * 0.08)
            
            // Handle
            var handle = Path()
            handle.move(to: CGPoint(x: glassCenterX + glassRadius * 0.7, y: glassCenterY + glassRadius * 0.7))
            handle.addLine(to: CGPoint(x: s * 0.85, y: s * 0.85))
            context.stroke(handle, with: .color(color.opacity(isSelected ? 1.0 : 0.8)), style: StrokeStyle(lineWidth: s * 0.1, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Files Icon

public struct FilesIcon: View {
    public let size: CGFloat
    public let color: Color
    public let isSelected: Bool
    
    public init(size: CGFloat = 24, color: Color = .primary, isSelected: Bool = false) {
        self.size = size
        self.color = color
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Canvas { context, canvasSize in
            let s = min(canvasSize.width, canvasSize.height)
            let padding = s * 0.12
            
            // Back file
            let backFile = Path(roundedRect: CGRect(x: padding + s * 0.08, y: padding, width: s * 0.55, height: s * 0.7), cornerRadius: s * 0.06)
            context.fill(backFile, with: .color(color.opacity(isSelected ? 0.5 : 0.3)))
            
            // Front file
            var frontFile = Path()
            frontFile.move(to: CGPoint(x: padding, y: padding + s * 0.15))
            frontFile.addLine(to: CGPoint(x: padding, y: s - padding))
            frontFile.addLine(to: CGPoint(x: s - padding - s * 0.08, y: s - padding))
            frontFile.addLine(to: CGPoint(x: s - padding - s * 0.08, y: padding + s * 0.3))
            frontFile.addLine(to: CGPoint(x: s - padding - s * 0.23, y: padding + s * 0.15))
            frontFile.closeSubpath()
            context.fill(frontFile, with: .color(color.opacity(isSelected ? 1.0 : 0.8)))
            
            // Corner fold
            var fold = Path()
            fold.move(to: CGPoint(x: s - padding - s * 0.23, y: padding + s * 0.15))
            fold.addLine(to: CGPoint(x: s - padding - s * 0.23, y: padding + s * 0.3))
            fold.addLine(to: CGPoint(x: s - padding - s * 0.08, y: padding + s * 0.3))
            fold.closeSubpath()
            context.fill(fold, with: .color(color.opacity(0.4)))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - AI Assistant Icon (Brain)

public struct AIAssistantIcon: View {
    public let size: CGFloat
    public let color: Color
    public let isSelected: Bool
    
    public init(size: CGFloat = 24, color: Color = .purple, isSelected: Bool = false) {
        self.size = size
        self.color = color
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Canvas { context, canvasSize in
            let s = min(canvasSize.width, canvasSize.height)
            let cx = s / 2
            let cy = s / 2
            
            // Head outline
            let headPath = Path(ellipseIn: CGRect(x: s * 0.18, y: s * 0.15, width: s * 0.64, height: s * 0.7))
            context.fill(headPath, with: .color(color.opacity(isSelected ? 1.0 : 0.8)))
            
            // Brain folds (simplified)
            var folds = Path()
            folds.move(to: CGPoint(x: cx - s * 0.15, y: cy - s * 0.1))
            folds.addQuadCurve(to: CGPoint(x: cx + s * 0.15, y: cy - s * 0.1), control: CGPoint(x: cx, y: cy - s * 0.25))
            folds.move(to: CGPoint(x: cx - s * 0.12, y: cy + s * 0.05))
            folds.addQuadCurve(to: CGPoint(x: cx + s * 0.12, y: cy + s * 0.05), control: CGPoint(x: cx, y: cy + s * 0.15))
            context.stroke(folds, with: .color(color.opacity(0.3)), lineWidth: s * 0.04)
            
            // Neural dots
            let dotPositions: [(CGFloat, CGFloat)] = [(0.35, 0.35), (0.65, 0.35), (0.5, 0.5), (0.38, 0.6), (0.62, 0.6)]
            for (px, py) in dotPositions {
                let dot = Path(ellipseIn: CGRect(x: s * px - s * 0.03, y: s * py - s * 0.03, width: s * 0.06, height: s * 0.06))
                context.fill(dot, with: .color(color.opacity(0.4)))
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Inventory Icon (Box)

public struct InventoryIcon: View {
    public let size: CGFloat
    public let color: Color
    public let isSelected: Bool
    
    public init(size: CGFloat = 24, color: Color = .orange, isSelected: Bool = false) {
        self.size = size
        self.color = color
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Canvas { context, canvasSize in
            let s = min(canvasSize.width, canvasSize.height)
            let padding = s * 0.12
            
            // Box body
            var boxPath = Path()
            boxPath.move(to: CGPoint(x: padding, y: s * 0.35))
            boxPath.addLine(to: CGPoint(x: padding, y: s - padding))
            boxPath.addLine(to: CGPoint(x: s - padding, y: s - padding))
            boxPath.addLine(to: CGPoint(x: s - padding, y: s * 0.35))
            boxPath.closeSubpath()
            context.fill(boxPath, with: .color(color.opacity(isSelected ? 1.0 : 0.8)))
            
            // Box lid
            var lidPath = Path()
            lidPath.move(to: CGPoint(x: padding - s * 0.05, y: s * 0.35))
            lidPath.addLine(to: CGPoint(x: s / 2, y: s * 0.18))
            lidPath.addLine(to: CGPoint(x: s - padding + s * 0.05, y: s * 0.35))
            lidPath.closeSubpath()
            context.fill(lidPath, with: .color(color.opacity(isSelected ? 0.9 : 0.6)))
            
            // Center tape
            let tape = Path(roundedRect: CGRect(x: s * 0.42, y: s * 0.35, width: s * 0.16, height: s * 0.5), cornerRadius: s * 0.02)
            context.fill(tape, with: .color(color.opacity(0.3)))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Navigation Icon Factory

public struct NavigationIcons {
    
    /// Get the appropriate custom icon for a navigation item
    @ViewBuilder
    public static func icon(for name: String, size: CGFloat = 24, color: Color = .primary, isSelected: Bool = false) -> some View {
        switch name.lowercased() {
        case "dashboard", "home":
            DashboardIcon(size: size, color: color, isSelected: isSelected)
        case "workflows", "workflow", "flow":
            WorkflowsIcon(size: size, color: color, isSelected: isSelected)
        case "agents", "agent", "cpu":
            AgentsIcon(size: size, color: color, isSelected: isSelected)
        case "projects", "project", "folder":
            ProjectsIcon(size: size, color: color, isSelected: isSelected)
        case "commands", "command", "terminal":
            CommandsIcon(size: size, color: color, isSelected: isSelected)
        case "documentation", "docs", "book":
            DocumentationIcon(size: size, color: color, isSelected: isSelected)
        case "chat", "ai", "sparkles":
            ChatIcon(size: size, color: color, isSelected: isSelected)
        case "settings", "gear":
            SettingsIcon(size: size, color: color, isSelected: isSelected)
        case "search", "find":
            SearchIcon(size: size, color: color, isSelected: isSelected)
        case "files", "file":
            FilesIcon(size: size, color: color, isSelected: isSelected)
        case "aiassistant", "brain":
            AIAssistantIcon(size: size, color: color, isSelected: isSelected)
        case "inventory", "box":
            InventoryIcon(size: size, color: color, isSelected: isSelected)
        default:
            // Fallback to a generic icon
            DashboardIcon(size: size, color: color, isSelected: isSelected)
        }
    }
}

// MARK: - Preview

#Preview("Navigation Icons") {
    VStack(spacing: 20) {
        Text("Custom Navigation Icons")
            .font(.title.bold())
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
            ForEach(["Dashboard", "Workflows", "Agents", "Projects", "Commands", "Documentation", "Chat", "Settings", "Search", "Files", "AIAssistant", "Inventory"], id: \.self) { name in
                VStack(spacing: 8) {
                    NavigationIcons.icon(for: name, size: 32, color: .accentColor, isSelected: true)
                    Text(name)
                        .font(.caption2)
                }
            }
        }
    }
    .padding()
}
