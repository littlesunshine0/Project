//
//  CapabilityIcon.swift
//  IconKit
//
//  Specialized icon component for Universal Capabilities
//  Drop-in ready - works with IdeaKit
//

import SwiftUI

/// Icon component for Universal Capabilities
public struct CapabilityIcon: View {
    public let capability: String
    public let size: CGFloat
    public let showLabel: Bool
    
    public init(capability: String, size: CGFloat = 48, showLabel: Bool = true) {
        self.capability = capability
        self.size = size
        self.showLabel = showLabel
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            IconDesign(style: styleFor(capability), size: size)
            
            if showLabel {
                Text(capability.capitalized)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func styleFor(_ capability: String) -> IconStyle {
        switch capability.lowercased() {
        case "intent": return .lightbulb
        case "context": return .layers
        case "structure": return .grid
        case "work": return .gear
        case "decisions": return .diamond
        case "risk": return .badge
        case "feedback": return .circuit
        case "outcome": return .star
        default: return .cube
        }
    }
}

/// All 8 Universal Capabilities as icons
public struct UniversalCapabilityIcons: View {
    public let size: CGFloat
    public let showLabels: Bool
    
    public init(size: CGFloat = 48, showLabels: Bool = true) {
        self.size = size
        self.showLabels = showLabels
    }
    
    private let capabilities = [
        "intent", "context", "structure", "work",
        "decisions", "risk", "feedback", "outcome"
    ]
    
    public var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: size + 20))], spacing: 16) {
            ForEach(capabilities, id: \.self) { cap in
                CapabilityIcon(capability: cap, size: size, showLabel: showLabels)
            }
        }
    }
}

/// Capability badge - small inline indicator
public struct CapabilityBadge: View {
    public let capability: String
    
    public init(capability: String) {
        self.capability = capability
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            CapabilityIcon(capability: capability, size: 16, showLabel: false)
            Text(capability.capitalized)
                .font(.caption2)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Capsule().fill(colorFor(capability).opacity(0.2)))
    }
    
    private func colorFor(_ capability: String) -> Color {
        switch capability.lowercased() {
        case "intent": return .yellow
        case "context": return .blue
        case "structure": return .purple
        case "work": return .green
        case "decisions": return .orange
        case "risk": return .red
        case "feedback": return .cyan
        case "outcome": return .mint
        default: return .gray
        }
    }
}

// MARK: - Preview

#Preview("Capability Icons") {
    VStack(spacing: 20) {
        Text("Universal Capabilities")
            .font(.headline)
        
        UniversalCapabilityIcons(size: 64)
        
        Divider()
        
        HStack(spacing: 8) {
            CapabilityBadge(capability: "intent")
            CapabilityBadge(capability: "risk")
            CapabilityBadge(capability: "outcome")
        }
    }
    .padding()
}
