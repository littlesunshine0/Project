//
//  ToolbarComponents.swift
//  FlowKit
//
//  Toolbar UI components for DoubleSidebarLayout
//

import SwiftUI
import DesignKit
import DataKit

// MARK: - Search Field

struct SearchField: View {
    @Binding var text: String
    @State private var isFocused = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            
            TextField("Search...", text: $text)
                .textFieldStyle(.plain)
                .font(FlowTypography.body())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.md, style: .continuous)
                .fill(FlowColors.Semantic.surface(colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: FlowRadius.md, style: .continuous)
                        .strokeBorder(isFocused ? Color.accentColor.opacity(0.5) : FlowColors.Border.subtle(colorScheme), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
        .accessibilityLabel("Search")
    }
}

// MARK: - Custom Window Controls

struct CustomWindowControls: View {
    @State private var isHovered = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            ToolbarWindowButton(type: .close, isGroupHovered: isHovered)
            ToolbarWindowButton(type: .minimize, isGroupHovered: isHovered)
            ToolbarWindowButton(type: .zoom, isGroupHovered: isHovered)
        }
        .onHover { isHovered = $0 }
    }
}

struct ToolbarWindowButton: View {
    enum WindowControlType {
        case close, minimize, zoom
        
        var color: Color {
            switch self {
            case .close: return Color(red: 1.0, green: 0.38, blue: 0.34)
            case .minimize: return Color(red: 1.0, green: 0.74, blue: 0.21)
            case .zoom: return Color(red: 0.15, green: 0.78, blue: 0.25)
            }
        }
        
        var icon: String {
            switch self {
            case .close: return "xmark"
            case .minimize: return "minus"
            case .zoom: return "plus"
            }
        }
    }
    
    let type: WindowControlType
    let isGroupHovered: Bool
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: performAction) {
            ZStack {
                Circle()
                    .fill(type.color)
                    .frame(width: 12, height: 12)
                
                if isGroupHovered {
                    Image(systemName: type.icon)
                        .font(.system(size: 7, weight: .bold))
                        .foregroundStyle(Color.black.opacity(0.6))
                }
            }
            .scaleEffect(isHovered ? 1.1 : 1.0)
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .accessibilityLabel(accessibilityLabel)
    }
    
    private var accessibilityLabel: String {
        switch type {
        case .close: return "Close window"
        case .minimize: return "Minimize window"
        case .zoom: return "Zoom window"
        }
    }
    
    private func performAction() {
        guard let window = NSApp.keyWindow else { return }
        
        switch type {
        case .close: window.close()
        case .minimize: window.miniaturize(nil)
        case .zoom: window.zoom(nil)
        }
    }
}

// MARK: - Toolbar Navigation Button

struct ToolbarNavButton: View {
    let icon: String
    let enabled: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(enabled ? (isHovered ? FlowColors.Text.primary(colorScheme) : FlowColors.Text.secondary(colorScheme)) : FlowColors.Text.tertiary(colorScheme))
                .frame(width: 28, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: FlowRadius.sm, style: .continuous)
                        .fill(isHovered && enabled ? FlowColors.Border.subtle(colorScheme) : .clear)
                )
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .onHover { isHovered = $0 }
    }
}

// MARK: - Toolbar Toggle

struct ToolbarToggle: View {
    let icon: String
    let isActive: Bool
    let tooltip: String
    let action: () -> Void
    
    @State private var isHovered = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(isActive ? .accentColor : (isHovered ? FlowColors.Text.primary(colorScheme) : FlowColors.Text.secondary(colorScheme)))
                .frame(width: 32, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: FlowRadius.sm, style: .continuous)
                        .fill(isActive ? Color.accentColor.opacity(0.12) : (isHovered ? FlowColors.Border.subtle(colorScheme) : .clear))
                )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .help(tooltip)
        .accessibilityLabel(tooltip)
        .accessibilityAddTraits(isActive ? .isSelected : [])
    }
}

// MARK: - Context Button

struct ContextButton: View {
    let icon: String
    let action: () -> Void
    
    @State private var isHovered = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(isHovered ? FlowColors.Text.primary(colorScheme) : FlowColors.Text.tertiary(colorScheme))
                .frame(width: 26, height: 26)
                .background(
                    RoundedRectangle(cornerRadius: FlowRadius.xs, style: .continuous)
                        .fill(isHovered ? FlowColors.Border.subtle(colorScheme) : .clear)
                )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}

// MARK: - Bottom Tab Item

struct BottomTabItem: View {
    let tab: BottomPanelTab
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: tab.icon)
                    .font(.system(size: 10))
                Text(tab.title)
                    .font(FlowTypography.caption(isSelected ? .medium : .regular))
            }
            .foregroundStyle(isSelected ? FlowColors.Text.primary(colorScheme) : FlowColors.Text.secondary(colorScheme))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: FlowRadius.xs, style: .continuous)
                    .fill(isSelected ? Color.accentColor.opacity(0.12) : (isHovered ? FlowColors.Border.subtle(colorScheme) : .clear))
            )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
