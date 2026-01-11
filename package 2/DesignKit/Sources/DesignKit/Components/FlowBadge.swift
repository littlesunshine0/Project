//
//  FlowBadge.swift
//  DesignKit
//
//  Badge component for labels and tags
//

import SwiftUI

public struct FlowBadge: View {
    public let text: String
    public let color: Color
    public let style: BadgeStyle
    
    public enum BadgeStyle { case filled, subtle, outlined }
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(_ text: String, color: Color, style: BadgeStyle = .filled) {
        self.text = text
        self.color = color
        self.style = style
    }
    
    public var body: some View {
        Text(text)
            .font(FlowTypography.micro(.bold))
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(background)
    }
    
    private var foregroundColor: Color {
        switch style {
        case .filled: return .white
        case .subtle, .outlined: return color
        }
    }
    
    @ViewBuilder
    private var background: some View {
        switch style {
        case .filled: Capsule().fill(color)
        case .subtle: Capsule().fill(color.opacity(0.15))
        case .outlined: Capsule().strokeBorder(color, lineWidth: 1)
        }
    }
}
