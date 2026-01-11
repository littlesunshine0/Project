//
//  BottomNavigationBar.swift
//  FlowKit
//
//  Bottom navigation bar spanning full width with panel toggles
//  Contains: Console, Terminal, Problems, Output, Debug, Search toggles
//

import SwiftUI
import DataKit

struct BottomNavigationBar: View {
    @ObservedObject var workspaceManager: WorkspaceManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            // Left side: Panel toggles
            HStack(spacing: 2) {
                ForEach(BottomBarTab.allCases) { tab in
                    BottomBarTabButton(
                        tab: tab,
                        isSelected: workspaceManager.selectedBottomTab == tab && workspaceManager.isBottomBarExpanded,
                        badge: badgeFor(tab)
                    ) {
                        withAnimation(FlowMotion.quick) {
                            if workspaceManager.selectedBottomTab == tab && workspaceManager.isBottomBarExpanded {
                                workspaceManager.isBottomBarExpanded = false
                            } else {
                                workspaceManager.selectedBottomTab = tab
                                workspaceManager.isBottomBarExpanded = true
                            }
                        }
                    }
                }
            }
            .padding(.leading, 12)
            
            Spacer()
            
            // Center: Status indicators
            HStack(spacing: 16) {
                StatusIndicator(icon: "checkmark.circle.fill", text: "Ready", color: FlowPalette.Status.success)
                StatusIndicator(icon: "arrow.triangle.branch", text: "main", color: FlowPalette.Category.explorer)
            }
            
            Spacer()
            
            // Right side: Quick actions
            HStack(spacing: 8) {
                // Line/Column indicator
                Text("Ln 42, Col 18")
                    .font(.system(size: 11))
                    .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
                
                Divider().frame(height: 12)
                
                // Encoding
                Text("UTF-8")
                    .font(.system(size: 11))
                    .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
                
                Divider().frame(height: 12)
                
                // Language
                Text("Swift")
                    .font(.system(size: 11))
                    .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
            }
            .padding(.trailing, 12)
        }
        .frame(height: 28)
        .background(barBackground)
    }
    
    private var barBackground: some View {
        ZStack {
            FlowPalette.Semantic.elevated(colorScheme)
            
            VStack {
                FlowPalette.Border.subtle(colorScheme).frame(height: 1)
                Spacer()
            }
        }
    }
    
    private func badgeFor(_ tab: BottomBarTab) -> Int? {
        switch tab {
        case .problems: return 3  // Example badge
        case .output: return nil
        default: return nil
        }
    }
}

// MARK: - Bottom Bar Tab Button

struct BottomBarTabButton: View {
    let tab: BottomBarTab
    let isSelected: Bool
    let badge: Int?
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 10))
                
                Text(tab.title)
                    .font(.system(size: 11, weight: isSelected ? .medium : .regular))
                
                if let badge = badge, badge > 0 {
                    Text("\(badge)")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(Capsule().fill(tab.accentColor))
                }
            }
            .foregroundStyle(
                isSelected ? tab.accentColor : FlowPalette.Text.secondary(colorScheme)
            )
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(backgroundColor)
            )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return tab.accentColor.opacity(0.15)
        } else if isHovered {
            return FlowPalette.Border.subtle(colorScheme)
        }
        return .clear
    }
}

// MARK: - Status Indicator

struct StatusIndicator: View {
    let icon: String
    let text: String
    let color: Color
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(color)
            
            Text(text)
                .font(.system(size: 11))
                .foregroundStyle(FlowPalette.Text.secondary(colorScheme))
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Spacer()
        BottomNavigationBar(workspaceManager: WorkspaceManager.shared)
    }
    .frame(width: 1000, height: 100)
    .preferredColorScheme(.dark)
}
