//
//  IconStyle.swift
//  IconKit
//
//  Defines the visual styles for icons
//

import SwiftUI

/// Icon visual styles
public enum IconStyle: String, CaseIterable, Sendable {
    // Project styles
    case glowOrb = "glow_orb"
    case gradient = "gradient"
    case minimal = "minimal"
    
    // Package styles
    case cube = "cube"
    case box = "box"
    case hexagon = "hexagon"
    
    // Feature styles
    case star = "star"
    case diamond = "diamond"
    case badge = "badge"
    
    // Service styles
    case gear = "gear"
    case cog = "cog"
    case circuit = "circuit"
    
    // Module styles
    case layers = "layers"
    case stack = "stack"
    case grid = "grid"
    
    // Capability styles
    case lightbulb = "lightbulb"
    case brain = "brain"
    case spark = "spark"
    
    /// Default colors for each style
    public var defaultColors: [Color] {
        switch self {
        case .glowOrb:
            return [
                Color(red: 1.0, green: 0.6, blue: 0.2),
                Color(red: 0.9, green: 0.3, blue: 0.5),
                Color(red: 0.6, green: 0.2, blue: 0.9)
            ]
        case .gradient:
            return [.blue, .purple, .pink]
        case .minimal:
            return [.primary, .secondary]
        case .cube, .box:
            return [.blue, .cyan, .teal]
        case .hexagon:
            return [.orange, .yellow, .red]
        case .star, .diamond:
            return [.yellow, .orange, .red]
        case .badge:
            return [.green, .mint, .teal]
        case .gear, .cog:
            return [.gray, .blue, .indigo]
        case .circuit:
            return [.green, .cyan, .blue]
        case .layers, .stack:
            return [.purple, .indigo, .blue]
        case .grid:
            return [.teal, .cyan, .blue]
        case .lightbulb:
            return [.yellow, .orange, .red]
        case .brain:
            return [.pink, .purple, .indigo]
        case .spark:
            return [.white, .yellow, .orange]
        }
    }
}

/// Icon color scheme
public struct IconColorScheme: Sendable {
    public let primary: Color
    public let secondary: Color
    public let accent: Color
    public let background: Color
    
    public init(
        primary: Color = .blue,
        secondary: Color = .purple,
        accent: Color = .white,
        background: Color = .clear
    ) {
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
        self.background = background
    }
    
    public static let `default` = IconColorScheme()
    
    public static let warm = IconColorScheme(
        primary: Color(red: 1.0, green: 0.6, blue: 0.2),
        secondary: Color(red: 0.9, green: 0.3, blue: 0.5),
        accent: .white
    )
    
    public static let cool = IconColorScheme(
        primary: .blue,
        secondary: .cyan,
        accent: .white
    )
    
    public static let nature = IconColorScheme(
        primary: .green,
        secondary: .teal,
        accent: .white
    )
}
