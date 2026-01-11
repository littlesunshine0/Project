//
//  WidgetCard.swift
//  DesignKit
//
//  Reusable card component for widgets
//

import SwiftUI

public struct WidgetCard<Content: View>: View {
    let style: WidgetCardStyle
    let size: WidgetCardSize
    let accentColor: Color
    let isInteractive: Bool
    @ViewBuilder let content: () -> Content
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    public init(
        style: WidgetCardStyle = .standard,
        size: WidgetCardSize = .medium,
        accentColor: Color = .accentColor,
        isInteractive: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.size = size
        self.accentColor = accentColor
        self.isInteractive = isInteractive
        self.content = content
    }
    
    public var body: some View {
        content()
            .frame(minWidth: size.minWidth, minHeight: size.minHeight)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: FlowRadius.lg, style: .continuous))
            .overlay(cardBorder)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
            .scaleEffect(isInteractive ? (isHovered ? 1.02 : 1.0) : 1.0)
            .animation(FlowMotion.quick, value: isHovered)
            .onHover { isHovered = isInteractive ? $0 : false }
    }
    
    @ViewBuilder
    private var cardBackground: some View {
        switch style {
        case .standard: FlowColors.Semantic.surface(colorScheme)
        case .elevated: FlowColors.Semantic.elevated(colorScheme)
        case .outlined: Color.clear
        case .glass: glassBackground
        case .gradient(let from, let to): LinearGradient(colors: [from, to], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .vibrant(let color): vibrantBackground(color)
        }
    }
    
    private var glassBackground: some View {
        ZStack {
            FlowColors.Semantic.surface(colorScheme).opacity(0.85)
            LinearGradient(
                colors: [Color.white.opacity(colorScheme == .dark ? 0.08 : 0.4), Color.white.opacity(0)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }
    
    private func vibrantBackground(_ color: Color) -> some View {
        ZStack {
            color.opacity(colorScheme == .dark ? 0.2 : 0.1)
            LinearGradient(
                colors: [color.opacity(colorScheme == .dark ? 0.15 : 0.08), color.opacity(0)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            if isHovered {
                RoundedRectangle(cornerRadius: FlowRadius.lg, style: .continuous).fill(color.opacity(0.1))
            }
        }
    }
    
    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: FlowRadius.lg, style: .continuous)
            .strokeBorder(borderColor, lineWidth: style == .outlined ? 1.5 : 1)
    }
    
    private var borderColor: Color {
        switch style {
        case .outlined: return isHovered ? accentColor.opacity(0.5) : FlowColors.Border.medium(colorScheme)
        case .vibrant(let color): return color.opacity(isHovered ? 0.4 : 0.2)
        default: return FlowColors.Border.subtle(colorScheme)
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .elevated, .glass: return FlowShadows.medium(colorScheme).color
        case .gradient, .vibrant: return accentColor.opacity(isHovered ? 0.3 : 0.2)
        default: return FlowShadows.subtle(colorScheme).color
        }
    }
    
    private var shadowRadius: CGFloat { isHovered ? 20 : (style == .elevated ? 12 : 6) }
    private var shadowY: CGFloat { isHovered ? 10 : (style == .elevated ? 6 : 3) }
}
