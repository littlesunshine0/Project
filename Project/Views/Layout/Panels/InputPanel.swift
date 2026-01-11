//
//  InputPanel.swift
//  FlowKit
//
//  Standalone input panel for terminal/console - separate from chat
//  Floats at bottom, never touches chat panel or other elements
//

import SwiftUI
import DesignKit
import DataKit

struct InputPanel: View {
    @ObservedObject var workspaceManager: WorkspaceManager
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var terminalHistory: [TerminalLine] = [
        TerminalLine(type: .system, text: "FlowKit Terminal v1.0"),
        TerminalLine(type: .prompt, text: "Ready for commands...")
    ]
    @State private var currentCommand: String = ""
    @SwiftUI.FocusState private var isInputFocused: Bool
    
    private let cornerRadius: CGFloat = 12
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            panelHeader
            
            // Terminal content
            terminalContent
            
            // Input line
            inputLine
        }
        .background(FlowPalette.Semantic.floating(colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            FlowPalette.Category.terminal.opacity(0.3),
                            FlowPalette.Border.medium(colorScheme)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
        .floatingShadow(colorScheme)
    }
    
    // MARK: - Header
    
    private var panelHeader: some View {
        HStack(spacing: 8) {
            // Drag handle
            RoundedRectangle(cornerRadius: 2)
                .fill(FlowPalette.Border.medium(colorScheme))
                .frame(width: 36, height: 4)
            
            // Tab buttons
            HStack(spacing: 2) {
                InputTabButton(
                    title: "Terminal",
                    icon: "terminal.fill",
                    isSelected: workspaceManager.selectedInputTab == .terminal,
                    color: FlowPalette.Category.terminal
                ) {
                    workspaceManager.selectedInputTab = .terminal
                }
                
                InputTabButton(
                    title: "Output",
                    icon: "doc.text.fill",
                    isSelected: workspaceManager.selectedInputTab == .output,
                    color: FlowPalette.Status.info
                ) {
                    workspaceManager.selectedInputTab = .output
                }
                
                InputTabButton(
                    title: "Problems",
                    icon: "exclamationmark.triangle.fill",
                    isSelected: workspaceManager.selectedInputTab == .problems,
                    color: FlowPalette.Status.warning,
                    badge: 3
                ) {
                    workspaceManager.selectedInputTab = .problems
                }
            }
            
            Spacer()
            
            // Height toggle
            Button(action: {
                withAnimation(FlowMotion.bottomPanel) {
                    workspaceManager.inputPanelHeight = workspaceManager.inputPanelHeight == 200 ? 350 : 200
                }
            }) {
                Image(systemName: workspaceManager.inputPanelHeight > 200 ? "chevron.down" : "chevron.up")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(FlowPalette.Border.subtle(colorScheme)))
            }
            .buttonStyle(.plain)
            
            // Close button
            Button(action: {
                withAnimation(FlowMotion.bottomPanel) {
                    workspaceManager.isInputPanelVisible = false
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(FlowPalette.Border.subtle(colorScheme)))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .frame(height: 40)
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        FlowPalette.Category.terminal.opacity(colorScheme == .dark ? 0.08 : 0.04),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                
                VStack {
                    Spacer()
                    FlowPalette.Category.terminal.opacity(0.3).frame(height: 1)
                }
            }
        )
    }
    
    // MARK: - Terminal Content
    
    private var terminalContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 2) {
                ForEach(terminalHistory) { line in
                    HStack(spacing: 6) {
                        if line.type == .command {
                            Text("$")
                                .foregroundStyle(FlowPalette.Category.terminal)
                        }
                        Text(line.text)
                            .foregroundStyle(line.type.color(colorScheme))
                    }
                    .font(.system(size: 12, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(12)
        }
        .background(Color.black.opacity(colorScheme == .dark ? 0.3 : 0.05))
        .frame(maxHeight: .infinity)
    }
    
    // MARK: - Input Line
    
    private var inputLine: some View {
        HStack(spacing: 8) {
            Text("$")
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundStyle(FlowPalette.Category.terminal)
            
            TextField("Enter command...", text: $currentCommand)
                .textFieldStyle(.plain)
                .font(.system(size: 13, design: .monospaced))
                .focused($isInputFocused)
                .onSubmit {
                    executeCommand()
                }
            
            Button(action: executeCommand) {
                Image(systemName: "return")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FlowPalette.Category.terminal)
                    .frame(width: 28, height: 28)
                    .background(
                        Circle()
                            .fill(FlowPalette.Category.terminal.opacity(0.15))
                    )
            }
            .buttonStyle(.plain)
            .disabled(currentCommand.isEmpty)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(FlowPalette.Border.subtle(colorScheme).opacity(0.5))
    }
    
    // MARK: - Actions
    
    private func executeCommand() {
        guard !currentCommand.isEmpty else { return }
        
        terminalHistory.append(TerminalLine(type: .command, text: currentCommand))
        terminalHistory.append(TerminalLine(type: .output, text: "Executed: \(currentCommand)"))
        currentCommand = ""
    }
}

// MARK: - Terminal Line Model

struct TerminalLine: Identifiable {
    let id = UUID()
    let type: LineType
    let text: String
    
    enum LineType {
        case system, prompt, command, output, error
        
        func color(_ scheme: ColorScheme) -> Color {
            switch self {
            case .system: return FlowPalette.Text.tertiary(scheme)
            case .prompt: return FlowPalette.Text.secondary(scheme)
            case .command: return FlowPalette.Text.primary(scheme)
            case .output: return FlowPalette.Text.secondary(scheme)
            case .error: return FlowPalette.Status.error
            }
        }
    }
}

// MARK: - Input Tab Button

struct InputTabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    var badge: Int? = nil
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                
                Text(title)
                    .font(.system(size: 11, weight: isSelected ? .medium : .regular))
                
                if let badge = badge, badge > 0 {
                    Text("\(badge)")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(Capsule().fill(color))
                }
            }
            .foregroundStyle(isSelected ? color : FlowPalette.Text.secondary(colorScheme))
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        isSelected ? color.opacity(0.15) :
                        isHovered ? FlowPalette.Border.subtle(colorScheme) :
                        Color.clear
                    )
            )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}

// MARK: - Preview

#Preview {
    InputPanel(workspaceManager: WorkspaceManager.shared)
        .frame(width: 600, height: 200)
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}

// MARK: - Initializer for external use
extension InputPanel {
    init(workspaceManager: WorkspaceManager, isInputFocused: Bool = false) {
        self._workspaceManager = ObservedObject(wrappedValue: workspaceManager)
    }
}
