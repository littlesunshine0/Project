//
//  NavigationComponents.swift
//  FlowKit
//
//  Navigation UI components for DoubleSidebarLayout
//

import SwiftUI
import DesignKit
import DataKit

// MARK: - App Icon Badge

struct AppIconBadge: View {
    @State private var isHovered = false
    @State private var glowPhase: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Animated glow
            Circle()
                .fill(
                    AngularGradient(
                        colors: [.purple, .blue, .cyan, .purple],
                        center: .center,
                        startAngle: .degrees(glowPhase),
                        endAngle: .degrees(glowPhase + 360)
                    )
                )
                .frame(width: 40, height: 40)
                .blur(radius: isHovered ? 10 : 6)
                .opacity(isHovered ? 0.8 : 0.5)
            
            // Icon background
            Circle()
                .fill(FlowColors.Semantic.elevated(colorScheme))
                .frame(width: 38, height: 38)
            
            // Icon
            Image(systemName: "sparkles")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
        }
        .scaleEffect(isHovered ? 1.08 : 1.0)
        .animation(FlowMotion.bouncy, value: isHovered)
        .onHover { isHovered = $0 }
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                glowPhase = 360
            }
        }
        .accessibilityLabel("FlowKit")
    }
}

// MARK: - Glowing User Button

struct GlowingUserButton: View {
    let action: () -> Void
    
    @State private var isHovered = false
    @State private var glowPhase: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Animated glow ring
                Circle()
                    .fill(
                        AngularGradient(
                            colors: [.cyan, .blue, .purple, .pink, .cyan],
                            center: .center,
                            startAngle: .degrees(glowPhase),
                            endAngle: .degrees(glowPhase + 360)
                        )
                    )
                    .frame(width: 42, height: 42)
                    .blur(radius: isHovered ? 8 : 5)
                    .opacity(isHovered ? 0.9 : 0.6)
                
                // User icon background
                Circle()
                    .fill(FlowColors.Semantic.elevated(colorScheme))
                    .frame(width: 38, height: 38)
                
                // User icon
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(isHovered ? 1.08 : 1.0)
            .animation(FlowMotion.bouncy, value: isHovered)
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                glowPhase = 360
            }
        }
        .help("User Account")
        .accessibilityLabel("User Account")
    }
}

// MARK: - Icon Rail Item

struct IconRailItem: View {
    let item: PrimaryNavItem
    let isSelected: Bool
    let isHovered: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Selection/hover background
            RoundedRectangle(cornerRadius: FlowRadius.md, style: .continuous)
                .fill(backgroundColor)
                .frame(width: 44, height: 44)
            
            // Icon
            Image(systemName: item.icon)
                .font(.system(size: 18, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(iconColor)
            
            // Selection indicator
            if isSelected {
                HStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(item.color)
                        .frame(width: 3, height: 20)
                    Spacer()
                }
                .frame(width: 44)
            }
        }
        .frame(width: 48, height: 48)
        .contentShape(Rectangle())
        .help(item.title)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return item.color.opacity(0.15)
        } else if isHovered {
            return FlowColors.Border.subtle(colorScheme)
        }
        return .clear
    }
    
    private var iconColor: Color {
        if isSelected {
            return item.color
        } else if isHovered {
            return FlowColors.Text.primary(colorScheme)
        }
        return FlowColors.Text.secondary(colorScheme)
    }
}

// MARK: - Category Row

struct CategoryRow: View {
    let category: SecondaryCategory
    let isCollapsed: Bool
    let isSelected: Bool
    let isExpanded: Bool
    let isHovered: Bool
    var isChild: Bool = false
    let onTap: () -> Void
    let onToggle: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: isCollapsed ? 0 : 10) {
            // Color indicator + Icon
            ZStack {
                if isCollapsed {
                    RoundedRectangle(cornerRadius: FlowRadius.sm, style: .continuous)
                        .fill(backgroundColor)
                        .frame(width: 36, height: 36)
                }
                
                Image(systemName: category.icon)
                    .font(.system(size: isCollapsed ? 14 : 12, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? category.color : (isHovered ? FlowColors.Text.primary(colorScheme) : FlowColors.Text.secondary(colorScheme)))
            }
            .frame(width: isCollapsed ? 36 : 22, height: isCollapsed ? 36 : 22)
            
            if !isCollapsed {
                Text(category.title)
                    .font(FlowTypography.body(isSelected ? .medium : .regular))
                    .foregroundStyle(isSelected ? FlowColors.Text.primary(colorScheme) : FlowColors.Text.secondary(colorScheme))
                    .lineLimit(1)
                
                Spacer()
                
                if !category.children.isEmpty {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                        .onTapGesture { onToggle() }
                }
            }
        }
        .padding(.horizontal, isCollapsed ? 0 : 10)
        .padding(.vertical, isCollapsed ? 0 : 8)
        .padding(.leading, isChild ? 16 : 0)
        .frame(maxWidth: .infinity, alignment: isCollapsed ? .center : .leading)
        .background(
            Group {
                if !isCollapsed {
                    RoundedRectangle(cornerRadius: FlowRadius.sm, style: .continuous)
                        .fill(backgroundColor)
                }
            }
        )
        .overlay(
            Group {
                if isSelected && !isCollapsed {
                    HStack {
                        RoundedRectangle(cornerRadius: 1)
                            .fill(category.color)
                            .frame(width: 2)
                        Spacer()
                    }
                }
            }
        )
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
        .accessibilityLabel(category.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return category.color.opacity(0.12)
        } else if isHovered {
            return FlowColors.Border.subtle(colorScheme)
        }
        return .clear
    }
}

// MARK: - Chat Size Button

struct ChatSizeButton: View {
    let icon: String
    let tooltip: String
    let action: () -> Void
    
    @State private var isHovered = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(isHovered ? FlowColors.Text.primary(colorScheme) : FlowColors.Text.secondary(colorScheme))
                .frame(width: 26, height: 26)
                .background(
                    Circle()
                        .fill(isHovered ? FlowColors.Border.medium(colorScheme) : FlowColors.Border.subtle(colorScheme))
                )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .help(tooltip)
    }
}
