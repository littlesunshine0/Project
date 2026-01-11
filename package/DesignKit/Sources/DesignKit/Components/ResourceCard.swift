//
//  ResourceCard.swift
//  DesignKit
//
//  Resource display card component
//

import SwiftUI

public struct ResourceCard: View {
    public let title: String
    public let count: Int
    public let icon: String
    public let color: Color
    public var action: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    public init(title: String, count: Int, icon: String, color: Color, action: (() -> Void)? = nil) {
        self.title = title
        self.count = count
        self.icon = icon
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: FlowRadius.md, style: .continuous).fill(color.opacity(0.12)).frame(width: 44, height: 44)
                    Image(systemName: icon).font(.system(size: 18, weight: .medium)).foregroundStyle(color)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(count)").font(FlowTypography.title3(.bold)).foregroundStyle(FlowColors.Text.primary(colorScheme))
                    Text(title).font(FlowTypography.caption()).foregroundStyle(FlowColors.Text.secondary(colorScheme))
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 11, weight: .semibold)).foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: FlowRadius.lg, style: .continuous).fill(FlowColors.Semantic.surface(colorScheme))
                    .overlay(RoundedRectangle(cornerRadius: FlowRadius.lg, style: .continuous)
                        .strokeBorder(isHovered ? color.opacity(0.3) : FlowColors.Border.subtle(colorScheme), lineWidth: 1))
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(FlowMotion.quick, value: isHovered)
            .onHover { isHovered = $0 }
        }
        .buttonStyle(.plain)
    }
}
