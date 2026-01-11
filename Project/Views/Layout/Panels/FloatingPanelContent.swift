//
//  FloatingPanelContent.swift
//  FlowKit
//
//  Content views for each floating panel type
//

import SwiftUI
import DesignKit
import DataKit
import DataKit

// MARK: - Floating Chat Content

struct FloatingChatContent: View {
    @State private var inputText = ""
    @State private var messages: [FloatingChatMessage] = []
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    if messages.isEmpty {
                        emptyState
                    } else {
                        ForEach(messages) { message in
                            FloatingChatBubble(message: message)
                        }
                    }
                }
                .padding(12)
            }
            
            // Input area
            chatInputBar
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "sparkles")
                .font(.system(size: 28))
                .foregroundStyle(ContextPanelType.chat.accentColor)
            Text("How can I help?")
                .font(FlowTypography.body())
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 30)
    }
    
    private var chatInputBar: some View {
        HStack(spacing: 8) {
            TextField("Ask anything...", text: $inputText)
                .textFieldStyle(.plain)
                .font(FlowTypography.body())
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: FlowRadius.md)
                        .fill(FlowColors.Semantic.surface(colorScheme))
                        .overlay(
                            RoundedRectangle(cornerRadius: FlowRadius.md)
                                .strokeBorder(FlowColors.Border.subtle(colorScheme), lineWidth: 1)
                        )
                )
                .onSubmit { sendMessage() }
            
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(inputText.isEmpty ? FlowColors.Text.tertiary(colorScheme) : ContextPanelType.chat.accentColor)
            }
            .buttonStyle(.plain)
            .disabled(inputText.isEmpty)
        }
        .padding(10)
        .background(FlowColors.Border.subtle(colorScheme).opacity(0.5))
    }
    
    private func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        messages.append(FloatingChatMessage(content: inputText, isUser: true))
        let query = inputText
        inputText = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            messages.append(FloatingChatMessage(content: "I received: \"\(query)\". How can I help further?", isUser: false))
        }
    }
}

struct FloatingChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

struct FloatingChatBubble: View {
    let message: FloatingChatMessage
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            if message.isUser { Spacer(minLength: 40) }
            
            Text(message.content)
                .font(FlowTypography.body())
                .foregroundStyle(message.isUser ? .white : FlowColors.Text.primary(colorScheme))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: FlowRadius.md)
                        .fill(message.isUser ? ContextPanelType.chat.accentColor : FlowColors.Semantic.surface(colorScheme))
                )
            
            if !message.isUser { Spacer(minLength: 40) }
        }
    }
}

// MARK: - Floating Terminal Content

struct FloatingTerminalContent: View {
    @State private var commandHistory: [FloatingTerminalLine] = [
        FloatingTerminalLine(type: .prompt, text: "~ flowkit"),
        FloatingTerminalLine(type: .output, text: "FlowKit v1.0.0 - Ready"),
        FloatingTerminalLine(type: .prompt, text: "~")
    ]
    @State private var currentInput = ""
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(commandHistory) { line in
                        FloatingTerminalLineView(line: line)
                    }
                    
                    // Current input line
                    HStack(spacing: 4) {
                        Text("$")
                            .foregroundStyle(ContextPanelType.terminal.accentColor)
                        TextField("", text: $currentInput)
                            .textFieldStyle(.plain)
                            .foregroundStyle(FlowColors.Text.primary(colorScheme))
                            .onSubmit { executeCommand() }
                    }
                    .font(.system(.body, design: .monospaced))
                    .padding(.horizontal, 12)
                }
                .padding(.vertical, 8)
            }
            .background(Color.black.opacity(colorScheme == .dark ? 0.3 : 0.05))
        }
    }
    
    private func executeCommand() {
        guard !currentInput.isEmpty else { return }
        commandHistory.append(FloatingTerminalLine(type: .command, text: "$ \(currentInput)"))
        commandHistory.append(FloatingTerminalLine(type: .output, text: "Command executed: \(currentInput)"))
        currentInput = ""
    }
}

struct FloatingTerminalLine: Identifiable {
    let id = UUID()
    let type: FloatingTerminalLineType
    let text: String
}

enum FloatingTerminalLineType {
    case prompt, command, output, error
}

struct FloatingTerminalLineView: View {
    let line: FloatingTerminalLine
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Text(line.text)
            .font(.system(.body, design: .monospaced))
            .foregroundStyle(lineColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 1)
    }
    
    private var lineColor: Color {
        switch line.type {
        case .prompt: return ContextPanelType.terminal.accentColor
        case .command: return FlowColors.Text.primary(colorScheme)
        case .output: return FlowColors.Text.secondary(colorScheme)
        case .error: return FlowColors.Status.error
        }
    }
}

// MARK: - Floating Output Line Type (for FloatingOutputLine)

// MARK: - Floating Output Content

struct FloatingOutputContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                FloatingOutputLine(text: "[INFO] Build started...", type: .info)
                FloatingOutputLine(text: "[INFO] Compiling sources...", type: .info)
                FloatingOutputLine(text: "[SUCCESS] Build completed in 2.3s", type: .success)
            }
            .padding(12)
        }
    }
}

struct FloatingOutputLine: View {
    let text: String
    let type: FloatingOutputType
    @Environment(\.colorScheme) private var colorScheme
    
    enum FloatingOutputType {
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
    
    var body: some View {
        Text(text)
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(type.color)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Floating Problems Content

struct FloatingProblemsContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                FloatingProblemRow(severity: .warning, message: "Unused variable 'temp'", file: "ViewModel.swift", line: 42)
                FloatingProblemRow(severity: .error, message: "Type mismatch", file: "Service.swift", line: 128)
            }
            .padding(12)
        }
    }
}

struct FloatingProblemRow: View {
    let severity: FloatingProblemSeverity
    let message: String
    let file: String
    let line: Int
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    enum FloatingProblemSeverity {
        case warning, error
        var icon: String { self == .error ? "xmark.circle.fill" : "exclamationmark.triangle.fill" }
        var color: Color { self == .error ? FlowColors.Status.error : FlowColors.Status.warning }
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: severity.icon)
                .foregroundStyle(severity.color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(message)
                    .font(FlowTypography.body())
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                Text("\(file):\(line)")
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
            
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.sm)
                .fill(isHovered ? severity.color.opacity(0.1) : Color.clear)
        )
        .onHover { isHovered = $0 }
    }
}

// MARK: - Floating Debug Content

struct FloatingDebugContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            Text("No active debug session")
                .font(FlowTypography.body())
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            
            Button("Start Debugging") {
                // Start debug
            }
            .buttonStyle(.borderedProminent)
            .tint(ContextPanelType.debug.accentColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Floating Walkthrough Content

struct FloatingWalkthroughContent: View {
    @State private var currentStep = 0
    @Environment(\.colorScheme) private var colorScheme
    
    private let steps = [
        WalkthroughStep(title: "Welcome to FlowKit", description: "Let's get you started with the basics."),
        WalkthroughStep(title: "Create a Workflow", description: "Workflows automate your development tasks."),
        WalkthroughStep(title: "Run an Agent", description: "Agents execute AI-powered operations.")
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            // Progress
            HStack(spacing: 4) {
                ForEach(0..<steps.count, id: \.self) { index in
                    Capsule()
                        .fill(index <= currentStep ? ContextPanelType.walkthrough.accentColor : FlowColors.Border.subtle(colorScheme))
                        .frame(height: 4)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // Current step
            VStack(alignment: .leading, spacing: 8) {
                Text(steps[currentStep].title)
                    .font(FlowTypography.headline())
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                
                Text(steps[currentStep].description)
                    .font(FlowTypography.body())
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            Spacer()
            
            // Navigation
            HStack {
                if currentStep > 0 {
                    Button("Back") { currentStep -= 1 }
                        .buttonStyle(.plain)
                        .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                }
                
                Spacer()
                
                Button(currentStep < steps.count - 1 ? "Next" : "Done") {
                    if currentStep < steps.count - 1 {
                        currentStep += 1
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(ContextPanelType.walkthrough.accentColor)
            }
            .padding(16)
        }
    }
}

struct WalkthroughStep {
    let title: String
    let description: String
}

// MARK: - Floating Documentation Content

struct FloatingDocumentationContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Quick Reference")
                    .font(FlowTypography.headline())
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                
                Text("Select a topic from the sidebar to view documentation here.")
                    .font(FlowTypography.body())
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Floating Preview Content

struct FloatingPreviewContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "eye.slash")
                .font(.system(size: 32))
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            
            Text("No preview available")
                .font(FlowTypography.body())
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
