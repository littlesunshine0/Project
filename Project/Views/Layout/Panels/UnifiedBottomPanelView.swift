//
//  UnifiedBottomPanelView.swift
//  FlowKit
//
//  Unified floating bottom panel containing all bottom content types:
//  Terminal, Chat Input, Problems, Output, Debug
//
//  Layout Modes:
//  - Single: 1 panel takes full view
//  - Stacked: 2 panels - top slot + bottom-middle overflow
//  - Tabbed: 3+ panels - top + bottom-middle with tab bar
//  - Layered: Multiple of same type shown with stacked card effect
//

import SwiftUI
import DesignKit

struct UnifiedBottomPanelView: View {
    @ObservedObject var panelManager: InputPanelManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab bar header with dashboard-style colors
            panelHeader
            
            // Content area based on layout mode
            panelContentArea
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // MARK: - Header with Tab Bar
    
    private var panelHeader: some View {
        HStack(spacing: 0) {
            // Drag handle
            RoundedRectangle(cornerRadius: 2)
                .fill(FlowColors.Border.medium(colorScheme))
                .frame(width: 36, height: 4)
                .padding(.leading, 16)
            
            // Tab buttons with dashboard colors
            HStack(spacing: 2) {
                ForEach(InputPanelTab.allCases) { tab in
                    let count = panelManager.panelsByType[tab]?.count ?? 0
                    UnifiedPanelTabButton(
                        tab: tab,
                        isSelected: panelManager.selectedTab == tab,
                        badge: badgeFor(tab),
                        instanceCount: count
                    ) {
                        withAnimation(FlowMotion.quick) {
                            panelManager.selectTab(tab)
                        }
                    }
                }
            }
            .padding(.leading, 12)
            
            Spacer()
            
            // Open panel count indicator
            if panelManager.openPanels.count > 1 {
                HStack(spacing: 4) {
                    Image(systemName: "square.stack.fill")
                        .font(.system(size: 10))
                    Text("\(panelManager.openPanels.count)")
                        .font(FlowTypography.micro(.bold))
                }
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Capsule().fill(FlowColors.Border.subtle(colorScheme)))
            }
            
            // Controls
            HStack(spacing: 4) {
                // Width toggle
                PanelControlButton(
                    icon: panelManager.isWidthExtended ? "arrow.right.to.line" : "arrow.left.to.line",
                    color: panelManager.selectedTab.accentColor
                ) {
                    withAnimation(FlowMotion.standard) {
                        panelManager.toggleWidthMode()
                    }
                }
                .help(panelManager.isWidthExtended ? "Collapse width" : "Expand width")
                
                // Height toggle
                PanelControlButton(
                    icon: panelManager.isExpanded ? "chevron.down" : "chevron.up",
                    color: panelManager.selectedTab.accentColor
                ) {
                    withAnimation(FlowMotion.standard) {
                        panelManager.toggleExpand()
                    }
                }
                
                // Close button
                PanelControlButton(
                    icon: "xmark",
                    color: panelManager.selectedTab.accentColor
                ) {
                    withAnimation(FlowMotion.standard) {
                        panelManager.hide()
                    }
                }
            }
            .padding(.trailing, 12)
        }
        .frame(height: 44)
        .background(headerBackground)
    }
    
    private var headerBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    panelManager.selectedTab.accentColor.opacity(colorScheme == .dark ? 0.1 : 0.06),
                    Color.clear
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            
            VStack {
                Spacer()
                panelManager.selectedTab.accentColor.opacity(0.4).frame(height: 1)
            }
        }
    }
    
    // MARK: - Content Area (Layout Mode Aware)
    
    @ViewBuilder
    private var panelContentArea: some View {
        switch panelManager.layoutMode {
        case .single:
            singlePanelContent
            
        case .stacked:
            stackedPanelContent
            
        case .stackedWithTabs(let overflowCount):
            stackedWithTabsContent(overflowCount: overflowCount)
            
        case .layeredGroup(let type, let count):
            layeredGroupContent(type: type, count: count)
        }
    }
    
    // MARK: - Single Panel Layout
    
    private var singlePanelContent: some View {
        panelContent(for: panelManager.selectedTab)
    }
    
    // MARK: - Stacked Layout (2 panels)
    
    private var stackedPanelContent: some View {
        GeometryReader { geometry in
            VStack(spacing: 8) {
                // Top panel (60% height)
                if let topPanel = panelManager.topPanel {
                    panelCard(for: topPanel, height: geometry.size.height * 0.55)
                }
                
                // Bottom-middle panel (40% height)
                if let bottomPanel = panelManager.selectedOverflowPanel {
                    panelCard(for: bottomPanel, height: geometry.size.height * 0.40)
                }
            }
            .padding(8)
        }
    }
    
    // MARK: - Stacked with Tabs Layout (3+ panels)
    
    private func stackedWithTabsContent(overflowCount: Int) -> some View {
        GeometryReader { geometry in
            VStack(spacing: 8) {
                // Top panel (50% height)
                if let topPanel = panelManager.topPanel {
                    panelCard(for: topPanel, height: geometry.size.height * 0.48)
                }
                
                // Overflow tab bar
                overflowTabBar
                
                // Bottom-middle panel with selected overflow (remaining height)
                if let selectedOverflow = panelManager.selectedOverflowPanel {
                    panelCard(for: selectedOverflow, height: nil)
                        .frame(maxHeight: .infinity)
                }
            }
            .padding(8)
        }
    }
    
    // MARK: - Layered Group Layout (multiple of same type)
    
    private func layeredGroupContent(type: InputPanelTab, count: Int) -> some View {
        GeometryReader { geometry in
            ZStack {
                // Background layers (stacked cards effect)
                ForEach(0..<min(count - 1, 2), id: \.self) { index in
                    let offset = CGFloat(index + 1) * 4
                    let scale = 1.0 - (CGFloat(index + 1) * 0.02)
                    
                    RoundedRectangle(cornerRadius: FlowRadius.md)
                        .fill(FlowColors.Semantic.surface(colorScheme))
                        .overlay(
                            RoundedRectangle(cornerRadius: FlowRadius.md)
                                .strokeBorder(type.accentColor.opacity(0.2), lineWidth: 1)
                        )
                        .offset(y: offset)
                        .scaleEffect(scale)
                        .opacity(0.6 - Double(index) * 0.2)
                }
                
                // Front panel (active)
                VStack(spacing: 0) {
                    // Group header showing count
                    layeredGroupHeader(type: type, count: count)
                    
                    // Content
                    panelContent(for: type)
                        .frame(maxHeight: .infinity)
                }
                .background(
                    RoundedRectangle(cornerRadius: FlowRadius.md)
                        .fill(FlowColors.Semantic.surface(colorScheme))
                        .overlay(
                            RoundedRectangle(cornerRadius: FlowRadius.md)
                                .strokeBorder(type.accentColor.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .padding(8)
        }
    }
    
    private func layeredGroupHeader(type: InputPanelTab, count: Int) -> some View {
        HStack(spacing: 8) {
            // Layered icon
            ZStack {
                ForEach(0..<min(count, 3), id: \.self) { index in
                    Circle()
                        .fill(type.accentColor.opacity(0.3 - Double(index) * 0.1))
                        .frame(width: 20 - CGFloat(index) * 2, height: 20 - CGFloat(index) * 2)
                        .offset(x: CGFloat(index) * 3, y: CGFloat(index) * 2)
                }
                
                Image(systemName: type.icon)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(type.accentColor)
            }
            .frame(width: 28, height: 24)
            
            Text("\(count) \(type.title)s")
                .font(FlowTypography.caption(.medium))
                .foregroundStyle(FlowColors.Text.primary(colorScheme))
            
            Spacer()
            
            // Navigation between instances
            HStack(spacing: 4) {
                Button(action: { /* Previous instance */ }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                        .frame(width: 20, height: 20)
                        .background(Circle().fill(FlowColors.Border.subtle(colorScheme)))
                }
                .buttonStyle(.plain)
                
                Text("1 of \(count)")
                    .font(FlowTypography.micro())
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                
                Button(action: { /* Next instance */ }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                        .frame(width: 20, height: 20)
                        .background(Circle().fill(FlowColors.Border.subtle(colorScheme)))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            VStack {
                Spacer()
                type.accentColor.opacity(0.2).frame(height: 1)
            }
        )
    }
    
    // MARK: - Overflow Tab Bar
    
    private var overflowTabBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(Array(panelManager.overflowPanels.enumerated()), id: \.element.id) { index, panel in
                    OverflowTabButton(
                        panel: panel,
                        isSelected: index == panelManager.overflowSelectedIndex
                    ) {
                        withAnimation(FlowMotion.quick) {
                            panelManager.selectOverflowPanel(at: index)
                        }
                    } onClose: {
                        withAnimation(FlowMotion.quick) {
                            panelManager.closePanel(panel.id)
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 32)
        .background(FlowColors.Border.subtle(colorScheme).opacity(0.5))
    }
    
    // MARK: - Panel Card
    
    private func panelCard(for panel: OpenPanelInstance, height: CGFloat?) -> some View {
        VStack(spacing: 0) {
            // Mini header
            HStack(spacing: 6) {
                Circle()
                    .fill(panel.tab.accentColor)
                    .frame(width: 8, height: 8)
                
                Text(panel.title)
                    .font(FlowTypography.caption(.medium))
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                
                Spacer()
                
                // Close this panel
                Button(action: { panelManager.closePanel(panel.id) }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                        .frame(width: 16, height: 16)
                        .background(Circle().fill(FlowColors.Border.subtle(colorScheme)))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                VStack {
                    Spacer()
                    panel.tab.accentColor.opacity(0.2).frame(height: 1)
                }
            )
            
            // Content
            panelContent(for: panel.tab)
                .frame(maxHeight: .infinity)
        }
        .frame(height: height)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.md)
                .fill(FlowColors.Semantic.surface(colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: FlowRadius.md)
                .strokeBorder(panel.tab.accentColor.opacity(0.2), lineWidth: 1)
        )
    }
    
    // MARK: - Content Views
    
    @ViewBuilder
    private func panelContent(for tab: InputPanelTab) -> some View {
        switch tab {
        case .chatInput:
            UnifiedChatInputContent(panelManager: panelManager)
        case .terminal:
            UnifiedTerminalContent(panelManager: panelManager)
        case .output:
            UnifiedOutputContent()
        case .problems:
            UnifiedProblemsContent()
        case .debug:
            UnifiedDebugContent(panelManager: panelManager)
        }
    }
    
    private func badgeFor(_ tab: InputPanelTab) -> Int? {
        switch tab {
        case .problems: return panelManager.problemsCount > 0 ? panelManager.problemsCount : nil
        case .output: return panelManager.outputLinesCount > 0 ? panelManager.outputLinesCount : nil
        default: return nil
        }
    }
}

// MARK: - Unified Panel Tab Button (Dashboard Style)

struct UnifiedPanelTabButton: View {
    let tab: InputPanelTab
    let isSelected: Bool
    let badge: Int?
    var instanceCount: Int = 0
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                // Icon with layered effect if multiple instances
                ZStack {
                    if instanceCount > 1 {
                        // Layered circles for multiple instances
                        ForEach(0..<min(instanceCount - 1, 2), id: \.self) { index in
                            Circle()
                                .fill(tab.accentColor.opacity(0.15))
                                .frame(width: 18 - CGFloat(index) * 2, height: 18 - CGFloat(index) * 2)
                                .offset(x: CGFloat(index + 1) * 2, y: CGFloat(index + 1) * 1)
                        }
                    }
                    
                    if isSelected {
                        Circle()
                            .fill(tab.accentColor.opacity(0.2))
                            .frame(width: 20, height: 20)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 11, weight: isSelected ? .semibold : .medium))
                }
                
                Text(tab.title)
                    .font(FlowTypography.caption(isSelected ? .semibold : .medium))
                
                // Instance count badge
                if instanceCount > 1 {
                    Text("\(instanceCount)")
                        .font(FlowTypography.micro(.bold))
                        .foregroundStyle(tab.accentColor)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(
                            Capsule().fill(tab.accentColor.opacity(0.15))
                        )
                }
                
                if let badge = badge {
                    Text("\(badge)")
                        .font(FlowTypography.micro(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(tab.accentColor))
                }
            }
            .foregroundStyle(isSelected ? tab.accentColor : FlowColors.Text.secondary(colorScheme))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: FlowRadius.sm)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: FlowRadius.sm)
                    .strokeBorder(isSelected ? tab.accentColor.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return tab.accentColor.opacity(0.15)
        } else if isHovered {
            return FlowColors.Border.subtle(colorScheme)
        }
        return Color.clear
    }
}

// MARK: - Overflow Tab Button

struct OverflowTabButton: View {
    let panel: OpenPanelInstance
    let isSelected: Bool
    let action: () -> Void
    let onClose: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 4) {
            Button(action: action) {
                HStack(spacing: 4) {
                    Circle()
                        .fill(panel.tab.accentColor)
                        .frame(width: 6, height: 6)
                    
                    Text(panel.title)
                        .font(FlowTypography.micro(isSelected ? .semibold : .regular))
                        .foregroundStyle(isSelected ? panel.tab.accentColor : FlowColors.Text.secondary(colorScheme))
                        .lineLimit(1)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            .buttonStyle(.plain)
            
            // Close button (visible on hover)
            if isHovered {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                }
                .buttonStyle(.plain)
                .padding(.trailing, 4)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.xs)
                .fill(isSelected ? panel.tab.accentColor.opacity(0.15) : (isHovered ? FlowColors.Border.subtle(colorScheme) : Color.clear))
        )
        .overlay(
            RoundedRectangle(cornerRadius: FlowRadius.xs)
                .strokeBorder(isSelected ? panel.tab.accentColor.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .onHover { isHovered = $0 }
    }
}


// MARK: - Unified Chat Input Content

struct UnifiedChatInputContent: View {
    @ObservedObject var panelManager: InputPanelManager
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Quick suggestions (when expanded)
            if panelManager.isExpanded {
                quickSuggestions
            }
            
            Spacer()
            
            // Input area with dashboard styling
            HStack(spacing: 10) {
                // Attachment button
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(InputPanelTab.chatInput.accentColor.opacity(0.1))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(InputPanelTab.chatInput.accentColor.opacity(0.7))
                    }
                }
                .buttonStyle(.plain)
                
                // Text input
                TextField("Type a message...", text: $panelManager.chatInputText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(FlowTypography.body())
                    .lineLimit(1...4)
                    .focused($isFocused)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: FlowRadius.md)
                            .fill(FlowColors.Semantic.surface(colorScheme))
                            .overlay(
                                RoundedRectangle(cornerRadius: FlowRadius.md)
                                    .strokeBorder(
                                        isFocused ? InputPanelTab.chatInput.accentColor.opacity(0.5) : FlowColors.Border.subtle(colorScheme),
                                        lineWidth: 1
                                    )
                            )
                    )
                    .onSubmit {
                        panelManager.sendChatMessage()
                    }
                
                // Send button with dashboard styling
                Button(action: { panelManager.sendChatMessage() }) {
                    ZStack {
                        Circle()
                            .fill(panelManager.chatInputText.isEmpty 
                                ? FlowColors.Border.subtle(colorScheme) 
                                : InputPanelTab.chatInput.accentColor)
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "arrow.up")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(panelManager.chatInputText.isEmpty 
                                ? FlowColors.Text.tertiary(colorScheme) 
                                : .white)
                    }
                }
                .buttonStyle(.plain)
                .disabled(panelManager.chatInputText.isEmpty)
            }
            .padding(12)
        }
    }
    
    private var quickSuggestions: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(["Explain this code", "Fix the error", "Add documentation", "Refactor"], id: \.self) { suggestion in
                    Button(action: { panelManager.chatInputText = suggestion }) {
                        Text(suggestion)
                            .font(FlowTypography.caption())
                            .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(FlowColors.Semantic.surface(colorScheme))
                                    .overlay(Capsule().strokeBorder(InputPanelTab.chatInput.accentColor.opacity(0.2), lineWidth: 1))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
        }
    }
}

// MARK: - Unified Terminal Content

struct UnifiedTerminalContent: View {
    @ObservedObject var panelManager: InputPanelManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var commandHistory: [UnifiedTerminalLine] = [
        UnifiedTerminalLine(type: .system, text: "FlowKit Terminal v1.0"),
        UnifiedTerminalLine(type: .prompt, text: "Ready for commands...")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // History with dashboard styling
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(commandHistory) { line in
                        HStack(spacing: 6) {
                            if line.type == .command {
                                Text("$")
                                    .foregroundStyle(InputPanelTab.terminal.accentColor)
                            }
                            Text(line.text)
                                .foregroundStyle(line.type.color(colorScheme))
                        }
                        .font(.system(.caption, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(12)
            }
            .background(
                LinearGradient(
                    colors: [
                        InputPanelTab.terminal.accentColor.opacity(colorScheme == .dark ? 0.05 : 0.02),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Input with dashboard styling
            HStack(spacing: 8) {
                Text("$")
                    .font(.system(.body, design: .monospaced, weight: .bold))
                    .foregroundStyle(InputPanelTab.terminal.accentColor)
                
                TextField("Enter command...", text: $panelManager.terminalInputText)
                    .textFieldStyle(.plain)
                    .font(.system(.body, design: .monospaced))
                    .onSubmit {
                        executeCommand()
                    }
                
                Button(action: executeCommand) {
                    ZStack {
                        Circle()
                            .fill(InputPanelTab.terminal.accentColor.opacity(0.15))
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "return")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(InputPanelTab.terminal.accentColor)
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(12)
            .background(InputPanelTab.terminal.accentColor.opacity(0.05))
        }
    }
    
    private func executeCommand() {
        guard !panelManager.terminalInputText.isEmpty else { return }
        commandHistory.append(UnifiedTerminalLine(type: .command, text: panelManager.terminalInputText))
        commandHistory.append(UnifiedTerminalLine(type: .output, text: "Executed: \(panelManager.terminalInputText)"))
        panelManager.executeTerminalCommand()
    }
}

struct UnifiedTerminalLine: Identifiable {
    let id = UUID()
    let type: LineType
    let text: String
    
    enum LineType {
        case system, prompt, command, output, error
        
        func color(_ colorScheme: ColorScheme) -> Color {
            switch self {
            case .system: return FlowColors.Text.tertiary(colorScheme)
            case .prompt: return FlowColors.Text.secondary(colorScheme)
            case .command: return FlowColors.Text.primary(colorScheme)
            case .output: return FlowColors.Text.secondary(colorScheme)
            case .error: return FlowColors.Status.error
            }
        }
    }
}

// MARK: - Unified Output Content

struct UnifiedOutputContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var outputLines: [UnifiedOutputLine] = [
        UnifiedOutputLine(text: "[INFO] Build started at 10:42:15", type: .info),
        UnifiedOutputLine(text: "[INFO] Compiling 42 Swift files...", type: .info),
        UnifiedOutputLine(text: "[SUCCESS] Build completed in 3.2s", type: .success)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(outputLines.indices, id: \.self) { index in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(outputLines[index].type.color)
                            .frame(width: 6, height: 6)
                        
                        Text(outputLines[index].text)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(outputLines[index].type.color)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(12)
        }
        .background(
            LinearGradient(
                colors: [
                    InputPanelTab.output.accentColor.opacity(colorScheme == .dark ? 0.03 : 0.01),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct UnifiedOutputLine {
    let text: String
    let type: OutputType
    
    enum OutputType {
        case info, success, warning, error
        
        var color: Color {
            switch self {
            case .info: return FlowColors.Status.info
            case .success: return FlowColors.Status.success
            case .warning: return FlowColors.Status.warning
            case .error: return FlowColors.Status.error
            }
        }
    }
}

// MARK: - Unified Problems Content

struct UnifiedProblemsContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var problems: [UnifiedProblemItem] = [
        UnifiedProblemItem(severity: .warning, message: "Unused variable 'temp'", file: "ViewModel.swift", line: 42),
        UnifiedProblemItem(severity: .error, message: "Type mismatch in assignment", file: "Service.swift", line: 128)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                ForEach(problems) { problem in
                    UnifiedProblemRow(problem: problem)
                }
            }
            .padding(12)
        }
        .background(
            LinearGradient(
                colors: [
                    InputPanelTab.problems.accentColor.opacity(colorScheme == .dark ? 0.03 : 0.01),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct UnifiedProblemItem: Identifiable {
    let id = UUID()
    let severity: Severity
    let message: String
    let file: String
    let line: Int
    
    enum Severity {
        case warning, error
        var icon: String { self == .error ? "xmark.circle.fill" : "exclamationmark.triangle.fill" }
        var color: Color { self == .error ? FlowColors.Status.error : FlowColors.Status.warning }
    }
}

struct UnifiedProblemRow: View {
    let problem: UnifiedProblemItem
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(problem.severity.color.opacity(0.15))
                    .frame(width: 28, height: 28)
                
                Image(systemName: problem.severity.icon)
                    .font(.system(size: 12))
                    .foregroundStyle(problem.severity.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(problem.message)
                    .font(FlowTypography.caption(.medium))
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                
                Text("\(problem.file):\(problem.line)")
                    .font(FlowTypography.micro())
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                .opacity(isHovered ? 1 : 0.5)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.sm)
                .fill(isHovered ? problem.severity.color.opacity(0.1) : Color.clear)
        )
        .onHover { isHovered = $0 }
    }
}

// MARK: - Unified Debug Content

struct UnifiedDebugContent: View {
    @ObservedObject var panelManager: InputPanelManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            // Debug status
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(FlowColors.Status.neutral.opacity(0.15))
                        .frame(width: 28, height: 28)
                    
                    Circle()
                        .fill(FlowColors.Status.neutral)
                        .frame(width: 8, height: 8)
                }
                
                Text("No active debug session")
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                
                Spacer()
                
                Button("Start") {
                    // Start debugging
                }
                .buttonStyle(.borderedProminent)
                .tint(InputPanelTab.debug.accentColor)
                .controlSize(.small)
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            
            Spacer()
            
            // Expression input
            HStack(spacing: 8) {
                Text(">")
                    .font(.system(.body, design: .monospaced, weight: .bold))
                    .foregroundStyle(InputPanelTab.debug.accentColor)
                
                TextField("Evaluate expression...", text: $panelManager.debugInputText)
                    .textFieldStyle(.plain)
                    .font(.system(.body, design: .monospaced))
                    .disabled(true) // Disabled when no debug session
            }
            .padding(12)
            .background(InputPanelTab.debug.accentColor.opacity(0.05))
        }
    }
}
