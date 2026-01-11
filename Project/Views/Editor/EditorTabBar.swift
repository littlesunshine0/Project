//
//  EditorTabBar.swift
//  FlowKit
//
//  Tab bar for managing open editor files
//

import SwiftUI

struct EditorTabBar: View {
    @ObservedObject var workspaceManager: WorkspaceManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(workspaceManager.openTabs) { tab in
                    EditorTabItem(
                        tab: tab,
                        isActive: workspaceManager.activeTabId == tab.id,
                        onSelect: { workspaceManager.activeTabId = tab.id },
                        onClose: { workspaceManager.closeTab(tab.id) }
                    )
                }
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 36)
        .background(tabBarBackground)
    }
    
    private var tabBarBackground: some View {
        ZStack {
            FlowPalette.Semantic.surface(colorScheme)
            
            VStack {
                Spacer()
                FlowPalette.Border.subtle(colorScheme).frame(height: 1)
            }
        }
    }
}

struct EditorTabItem: View {
    let tab: EditorTab
    let isActive: Bool
    let onSelect: () -> Void
    let onClose: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 6) {
            // File icon
            Image(systemName: tab.icon)
                .font(.system(size: 11))
                .foregroundStyle(tab.color)
            
            // File name
            Text(tab.fileName)
                .font(.system(size: 12, weight: isActive ? .medium : .regular))
                .foregroundStyle(
                    isActive
                        ? FlowPalette.Text.primary(colorScheme)
                        : FlowPalette.Text.secondary(colorScheme)
                )
                .lineLimit(1)
            
            // Modified indicator
            if tab.isModified {
                Circle()
                    .fill(FlowPalette.Status.warning)
                    .frame(width: 6, height: 6)
            }
            
            // Close button
            if isHovered || isActive {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
                        .frame(width: 16, height: 16)
                        .background(
                            Circle()
                                .fill(FlowPalette.Border.subtle(colorScheme))
                                .opacity(isHovered ? 1 : 0)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(tabBackground)
        .onTapGesture(perform: onSelect)
        .onHover { isHovered = $0 }
    }
    
    private var tabBackground: some View {
        ZStack {
            if isActive {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(FlowPalette.Semantic.elevated(colorScheme))
                
                // Active indicator
                VStack {
                    Spacer()
                    tab.color.frame(height: 2)
                        .clipShape(Capsule())
                        .padding(.horizontal, 8)
                }
            } else if isHovered {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(FlowPalette.Border.subtle(colorScheme))
            }
        }
    }
}

// MARK: - Preview

#Preview {
    EditorTabBar(workspaceManager: WorkspaceManager.shared)
        .frame(width: 600)
        .preferredColorScheme(.dark)
}
