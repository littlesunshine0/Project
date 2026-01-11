//
//  FloatingPanelContainer.swift
//  FlowKit
//
//  Container for floating panels with widget-style appearance
//

import SwiftUI
import DesignKit
import DataKit

/// A floating panel that matches the dashboard widget style
struct FloatingPanel<Content: View>: View {
    let panelType: ContextPanelType
    let isExpanded: Bool
    let onClose: () -> Void
    let onToggleExpand: () -> Void
    @ViewBuilder let content: () -> Content
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Panel header with accent color
            panelHeader
            
            // Panel content
            if isExpanded {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(panelBackground)
        .clipShape(RoundedRectangle(cornerRadius: FlowRadius.lg, style: .continuous))
        .overlay(panelBorder)
        .shadow(color: panelType.accentColor.opacity(colorScheme == .dark ? 0.15 : 0.08), radius: 12, y: 4)
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 8, y: 2)
        .onHover { isHovered = $0 }
    }
    
    private var panelHeader: some View {
        HStack(spacing: 10) {
            // Icon with accent glow
            ZStack {
                Circle()
                    .fill(panelType.accentColor.opacity(0.2))
                    .frame(width: 28, height: 28)
                    .blur(radius: 3)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [panelType.accentColor, panelType.accentColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24, height: 24)
                
                Image(systemName: panelType.icon)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            Text(panelType.title)
                .font(FlowTypography.headline())
                .foregroundStyle(FlowColors.Text.primary(colorScheme))
            
            Spacer()
            
            // Panel controls
            HStack(spacing: 4) {
                PanelControlButton(
                    icon: isExpanded ? "chevron.down" : "chevron.up",
                    color: panelType.accentColor
                ) {
                    onToggleExpand()
                }
                
                PanelControlButton(icon: "xmark", color: panelType.accentColor) {
                    onClose()
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            ZStack {
                // Subtle accent gradient in header
                LinearGradient(
                    colors: [
                        panelType.accentColor.opacity(colorScheme == .dark ? 0.08 : 0.04),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                
                // Bottom border
                VStack {
                    Spacer()
                    panelType.accentColor.opacity(0.2).frame(height: 1)
                }
            }
        )
    }
    
    private var panelBackground: some View {
        ZStack {
            FlowColors.Semantic.floating(colorScheme)
            
            // Subtle accent tint
            LinearGradient(
                colors: [
                    panelType.accentColor.opacity(colorScheme == .dark ? 0.03 : 0.01),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var panelBorder: some View {
        RoundedRectangle(cornerRadius: FlowRadius.lg, style: .continuous)
            .strokeBorder(
                LinearGradient(
                    colors: [
                        panelType.accentColor.opacity(isHovered ? 0.4 : 0.2),
                        FlowColors.Border.medium(colorScheme)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
    }
}

// MARK: - Panel Control Button

struct PanelControlButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(isHovered ? color : FlowColors.Text.secondary(colorScheme))
                .frame(width: 22, height: 22)
                .background(
                    Circle()
                        .fill(isHovered ? color.opacity(0.15) : FlowColors.Border.subtle(colorScheme))
                )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}

// MARK: - Floating Panel Area

/// Container that manages the floating panel area with split view support
struct FloatingPanelArea: View {
    @ObservedObject var panelManager: FloatingPanelManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            let availableHeight = geometry.size.height
            let topPanels = panelManager.panels(at: .top)
            let bottomPanels = panelManager.panels(at: .bottom)
            
            VStack(spacing: 8) {
                // Top panels (walkthroughs, docs, etc.)
                if !topPanels.isEmpty {
                    panelStack(for: topPanels, height: calculateHeight(for: .top, total: availableHeight, hasTop: !topPanels.isEmpty, hasBottom: !bottomPanels.isEmpty))
                }
                
                // Bottom panels (terminal, chat, etc.)
                if !bottomPanels.isEmpty {
                    panelStack(for: bottomPanels, height: calculateHeight(for: .bottom, total: availableHeight, hasTop: !topPanels.isEmpty, hasBottom: !bottomPanels.isEmpty))
                }
            }
            .padding(12)
        }
    }
    
    private func calculateHeight(for position: PanelPosition, total: CGFloat, hasTop: Bool, hasBottom: Bool) -> CGFloat {
        let padding: CGFloat = 32 // Top + bottom padding + spacing
        let usableHeight = total - padding
        
        if hasTop && hasBottom {
            return usableHeight * 0.5
        }
        return usableHeight
    }
    
    @ViewBuilder
    private func panelStack(for panels: [FloatingPanelState], height: CGFloat) -> some View {
        if panels.count == 1, let panel = panels.first {
            singlePanel(panel)
                .frame(height: height)
        } else {
            // Multiple panels in same position - use tabs
            tabbedPanels(panels)
                .frame(height: height)
        }
    }
    
    @ViewBuilder
    private func singlePanel(_ state: FloatingPanelState) -> some View {
        FloatingPanel(
            panelType: state.type,
            isExpanded: state.isExpanded,
            onClose: { panelManager.hidePanel(state.type) },
            onToggleExpand: { toggleExpand(state) }
        ) {
            panelContent(for: state.type)
        }
    }
    
    @ViewBuilder
    private func tabbedPanels(_ panels: [FloatingPanelState]) -> some View {
        VStack(spacing: 0) {
            // Tab bar
            HStack(spacing: 4) {
                ForEach(panels) { panel in
                    PanelTabButton(
                        type: panel.type,
                        isSelected: panelManager.focusedPanelId == panel.id
                    ) {
                        panelManager.focusPanel(panel.type)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(FlowColors.Semantic.elevated(colorScheme))
            
            // Active panel content
            if let focused = panels.first(where: { $0.id == panelManager.focusedPanelId }) ?? panels.first {
                FloatingPanel(
                    panelType: focused.type,
                    isExpanded: focused.isExpanded,
                    onClose: { panelManager.hidePanel(focused.type) },
                    onToggleExpand: { toggleExpand(focused) }
                ) {
                    panelContent(for: focused.type)
                }
            }
        }
    }
    
    private func toggleExpand(_ state: FloatingPanelState) {
        if let index = panelManager.activePanels.firstIndex(where: { $0.id == state.id }) {
            panelManager.activePanels[index].isExpanded.toggle()
        }
    }
    
    @ViewBuilder
    private func panelContent(for type: ContextPanelType) -> some View {
        switch type {
        case .chat:
            FloatingChatContent()
        case .terminal:
            FloatingTerminalContent()
        case .output:
            FloatingOutputContent()
        case .problems:
            FloatingProblemsContent()
        case .debug:
            FloatingDebugContent()
        case .walkthrough:
            FloatingWalkthroughContent()
        case .documentation:
            FloatingDocumentationContent()
        case .preview:
            FloatingPreviewContent()
        }
    }
}

// MARK: - Panel Tab Button

struct PanelTabButton: View {
    let type: ContextPanelType
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: type.icon)
                    .font(.system(size: 11, weight: .medium))
                Text(type.title)
                    .font(FlowTypography.caption(.medium))
            }
            .foregroundStyle(isSelected ? type.accentColor : FlowColors.Text.secondary(colorScheme))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: FlowRadius.sm)
                    .fill(isSelected ? type.accentColor.opacity(0.15) : (isHovered ? FlowColors.Border.subtle(colorScheme) : Color.clear))
            )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}
