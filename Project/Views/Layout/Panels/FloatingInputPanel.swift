//
//  FloatingInputPanel.swift
//  FlowKit
//
//  Floating bottom panel for input (chat, terminal, etc.)
//  Matches dashboard widget style with color-coded tabs
//

import SwiftUI
import DesignKit

struct FloatingInputPanel: View {
    @ObservedObject var panelManager: InputPanelManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab bar with drag handle
            panelHeader
            
            // Content area based on selected tab
            panelContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        // Note: Parent handles frame, background, corner radius, and shadow for floating effect
    }
    
    // MARK: - Header
    
    private var panelHeader: some View {
        HStack(spacing: 0) {
            // Drag handle
            RoundedRectangle(cornerRadius: 2)
                .fill(FlowColors.Border.medium(colorScheme))
                .frame(width: 36, height: 4)
                .padding(.leading, 16)
            
            // Tabs
            HStack(spacing: 2) {
                ForEach(InputPanelTab.allCases) { tab in
                    InputPanelTabButton(
                        tab: tab,
                        isSelected: panelManager.selectedTab == tab,
                        badge: badgeFor(tab)
                    ) {
                        withAnimation(FlowMotion.quick) {
                            panelManager.selectTab(tab)
                        }
                    }
                }
            }
            .padding(.leading, 12)
            
            Spacer()
            
            // Controls
            HStack(spacing: 4) {
                // Width toggle - expand/collapse horizontally
                PanelControlButton(
                    icon: panelManager.isWidthExtended ? "arrow.right.to.line" : "arrow.left.to.line",
                    color: panelManager.selectedTab.accentColor
                ) {
                    withAnimation(FlowMotion.standard) {
                        panelManager.toggleWidthMode()
                    }
                }
                .help(panelManager.isWidthExtended ? "Collapse width" : "Expand width")
                
                // Height toggle - expand/collapse vertically
                PanelControlButton(
                    icon: panelManager.isExpanded ? "chevron.down" : "chevron.up",
                    color: panelManager.selectedTab.accentColor
                ) {
                    withAnimation(FlowMotion.standard) {
                        panelManager.toggleExpand()
                    }
                }
                
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
            // Subtle accent gradient
            LinearGradient(
                colors: [
                    panelManager.selectedTab.accentColor.opacity(colorScheme == .dark ? 0.08 : 0.04),
                    Color.clear
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            
            // Bottom border with accent
            VStack {
                Spacer()
                panelManager.selectedTab.accentColor.opacity(0.3).frame(height: 1)
            }
        }
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private var panelContent: some View {
        switch panelManager.selectedTab {
        case .chatInput:
            ChatInputContent(panelManager: panelManager)
        case .terminal:
            TerminalInputContent(panelManager: panelManager)
        case .output:
            OutputContent()
        case .problems:
            ProblemsContent()
        case .debug:
            DebugInputContent(panelManager: panelManager)
        }
    }
    
    // MARK: - Styling
    
    private var panelBackground: some View {
        ZStack {
            FlowColors.Semantic.floating(colorScheme)
            
            // Subtle accent tint
            LinearGradient(
                colors: [
                    panelManager.selectedTab.accentColor.opacity(colorScheme == .dark ? 0.02 : 0.01),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    private var panelBorder: some View {
        RoundedRectangle(cornerRadius: FlowRadius.lg, style: .continuous)
            .strokeBorder(
                LinearGradient(
                    colors: [
                        panelManager.selectedTab.accentColor.opacity(0.3),
                        FlowColors.Border.medium(colorScheme)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 1
            )
    }
    
    private func badgeFor(_ tab: InputPanelTab) -> Int? {
        switch tab {
        case .problems: return panelManager.problemsCount > 0 ? panelManager.problemsCount : nil
        case .output: return panelManager.outputLinesCount > 0 ? panelManager.outputLinesCount : nil
        default: return nil
        }
    }
}

// MARK: - Tab Button

struct InputPanelTabButton: View {
    let tab: InputPanelTab
    let isSelected: Bool
    let badge: Int?
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: tab.icon)
                    .font(.system(size: 11, weight: .medium))
                
                Text(tab.title)
                    .font(FlowTypography.caption(.medium))
                
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


// MARK: - Chat Input Content

struct ChatInputContent: View {
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
            
            // Input area
            HStack(spacing: 10) {
                // Attachment button
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
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
                
                // Send button
                Button(action: { panelManager.sendChatMessage() }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(
                            panelManager.chatInputText.isEmpty
                                ? FlowColors.Text.tertiary(colorScheme)
                                : InputPanelTab.chatInput.accentColor
                        )
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
                                    .overlay(Capsule().strokeBorder(FlowColors.Border.subtle(colorScheme), lineWidth: 1))
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

// MARK: - Terminal Input Content

struct TerminalInputContent: View {
    @ObservedObject var panelManager: InputPanelManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var commandHistory: [TerminalHistoryLine] = [
        TerminalHistoryLine(type: .system, text: "FlowKit Terminal v1.0"),
        TerminalHistoryLine(type: .prompt, text: "Ready for commands...")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // History
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
            .background(Color.black.opacity(colorScheme == .dark ? 0.2 : 0.03))
            
            // Input
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
                    Image(systemName: "return")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(InputPanelTab.terminal.accentColor)
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(InputPanelTab.terminal.accentColor.opacity(0.15)))
                }
                .buttonStyle(.plain)
            }
            .padding(12)
            .background(FlowColors.Border.subtle(colorScheme).opacity(0.3))
        }
    }
    
    private func executeCommand() {
        guard !panelManager.terminalInputText.isEmpty else { return }
        commandHistory.append(TerminalHistoryLine(type: .command, text: panelManager.terminalInputText))
        commandHistory.append(TerminalHistoryLine(type: .output, text: "Executed: \(panelManager.terminalInputText)"))
        panelManager.executeTerminalCommand()
    }
}

struct TerminalHistoryLine: Identifiable {
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

// MARK: - Output Content

struct OutputContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var outputLines: [OutputLine] = [
        OutputLine(text: "[INFO] Build started at 10:42:15", type: .info),
        OutputLine(text: "[INFO] Compiling 42 Swift files...", type: .info),
        OutputLine(text: "[SUCCESS] Build completed in 3.2s", type: .success)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 2) {
                ForEach(outputLines.indices, id: \.self) { index in
                    Text(outputLines[index].text)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(outputLines[index].type.color)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(12)
        }
    }
}

struct OutputLine {
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

// MARK: - Problems Content

struct ProblemsContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var problems: [ProblemItem] = [
        ProblemItem(severity: .warning, message: "Unused variable 'temp'", file: "ViewModel.swift", line: 42),
        ProblemItem(severity: .error, message: "Type mismatch in assignment", file: "Service.swift", line: 128)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                ForEach(problems) { problem in
                    ProblemItemRow(problem: problem)
                }
            }
            .padding(12)
        }
    }
}

struct ProblemItem: Identifiable {
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

struct ProblemItemRow: View {
    let problem: ProblemItem
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: problem.severity.icon)
                .font(.system(size: 14))
                .foregroundStyle(problem.severity.color)
            
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
                .fill(isHovered ? problem.severity.color.opacity(0.08) : Color.clear)
        )
        .onHover { isHovered = $0 }
    }
}

// MARK: - Debug Input Content

struct DebugInputContent: View {
    @ObservedObject var panelManager: InputPanelManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            // Debug status
            HStack(spacing: 10) {
                Circle()
                    .fill(FlowColors.Status.neutral)
                    .frame(width: 8, height: 8)
                
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
            .background(FlowColors.Border.subtle(colorScheme).opacity(0.3))
        }
    }
}
