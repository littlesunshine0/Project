//
//  UnifiedChatPanel.swift
//  FlowKit
//
//  Unified chat panel that includes chat messages and input area as one unit
//  Opens from toolbar toggle, shares space with right sidebar
//  Never touches toolbar, maintains gaps from all edges
//

import SwiftUI

struct UnifiedChatPanel: View {
    @ObservedObject var workspaceManager: WorkspaceManager
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var messages: [ChatMessage] = []
    @State private var inputText: String = ""
    @State private var selectedInputMode: ChatInputMode = .chat
    @FocusState private var isInputFocused: Bool
    
    private let panelInset: CGFloat = 12
    private let cornerRadius: CGFloat = 16
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat header with back button
            chatHeader
            
            // Messages area
            messagesArea
            
            // Divider
            FlowPalette.Border.subtle(colorScheme).frame(height: 1)
            
            // Input mode tabs
            inputModeTabs
            
            // Input area
            inputArea
        }
        .background(panelBackground)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(panelBorder)
        .floatingShadow(colorScheme)
    }
    
    // MARK: - Header
    
    private var chatHeader: some View {
        HStack(spacing: 12) {
            // Back button (closes chat)
            Button(action: {
                withAnimation(FlowMotion.panelTransition) {
                    workspaceManager.closeChat()
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FlowPalette.Text.secondary(colorScheme))
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(FlowPalette.Border.subtle(colorScheme)))
            }
            .buttonStyle(.plain)
            
            // Chat icon with glow
            ZStack {
                Circle()
                    .fill(FlowPalette.Category.chat.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .blur(radius: 4)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [FlowPalette.Category.chat, FlowPalette.Category.chat.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("FlowKit Assistant")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(FlowPalette.Text.primary(colorScheme))
                
                Text("Ready to help")
                    .font(.system(size: 11))
                    .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
            }
            
            Spacer()
            
            // Actions menu
            Menu {
                Button("Clear Chat", action: { messages.removeAll() })
                Button("Export Chat", action: {})
                Divider()
                Button("Settings", action: {})
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(FlowPalette.Text.secondary(colorScheme))
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(FlowPalette.Border.subtle(colorScheme)))
            }
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            ZStack {
                FlowGradients.panelHeader(colorScheme, accent: FlowPalette.Category.chat)
                
                VStack {
                    Spacer()
                    FlowPalette.Category.chat.opacity(0.2).frame(height: 1)
                }
            }
        )
    }
    
    // MARK: - Messages Area
    
    private var messagesArea: some View {
        Group {
            if messages.isEmpty {
                emptyState
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(messages) { message in
                                ChatMessageBubbleView(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(16)
                    }
                    .onChange(of: messages.count) { _, _ in
                        if let last = messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(FlowPalette.Category.chat.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 32))
                    .foregroundStyle(FlowPalette.Category.chat)
            }
            
            VStack(spacing: 8) {
                Text("How can I help?")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(FlowPalette.Text.primary(colorScheme))
                
                Text("Ask me anything about your code,\nproject, or workflows.")
                    .font(.system(size: 13))
                    .foregroundStyle(FlowPalette.Text.secondary(colorScheme))
                    .multilineTextAlignment(.center)
            }
            
            // Quick suggestions
            VStack(spacing: 8) {
                ForEach(["Explain this code", "Find bugs", "Refactor function"], id: \.self) { suggestion in
                    Button(action: { inputText = suggestion }) {
                        Text(suggestion)
                            .font(.system(size: 12))
                            .foregroundStyle(FlowPalette.Text.secondary(colorScheme))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(FlowPalette.Semantic.elevated(colorScheme))
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(FlowPalette.Border.subtle(colorScheme), lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Input Mode Tabs
    
    private var inputModeTabs: some View {
        HStack(spacing: 2) {
            ForEach(ChatInputMode.allCases) { mode in
                Button(action: {
                    withAnimation(FlowMotion.quick) {
                        selectedInputMode = mode
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: mode.icon)
                            .font(.system(size: 10))
                        Text(mode.title)
                            .font(.system(size: 11, weight: selectedInputMode == mode ? .medium : .regular))
                    }
                    .foregroundStyle(
                        selectedInputMode == mode
                            ? mode.color
                            : FlowPalette.Text.secondary(colorScheme)
                    )
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(selectedInputMode == mode ? mode.color.opacity(0.15) : Color.clear)
                    )
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(FlowPalette.Semantic.surface(colorScheme).opacity(0.5))
    }
    
    // MARK: - Input Area
    
    private var inputArea: some View {
        HStack(alignment: .bottom, spacing: 10) {
            // Attachment button
            Button(action: {}) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
            }
            .buttonStyle(.plain)
            
            // Text input
            TextField(selectedInputMode.placeholder, text: $inputText, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 14))
                .lineLimit(1...5)
                .focused($isInputFocused)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(FlowPalette.Semantic.surface(colorScheme))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(
                                    isInputFocused
                                        ? selectedInputMode.color.opacity(0.5)
                                        : FlowPalette.Border.subtle(colorScheme),
                                    lineWidth: 1
                                )
                        )
                )
                .onSubmit {
                    sendMessage()
                }
            
            // Send button
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(
                        inputText.isEmpty
                            ? FlowPalette.Text.tertiary(colorScheme)
                            : selectedInputMode.color
                    )
            }
            .buttonStyle(.plain)
            .disabled(inputText.isEmpty)
        }
        .padding(12)
    }
    
    // MARK: - Background
    
    private var panelBackground: some View {
        FlowPalette.Semantic.floating(colorScheme)
    }
    
    private var panelBorder: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .strokeBorder(
                LinearGradient(
                    colors: [
                        FlowPalette.Category.chat.opacity(0.3),
                        FlowPalette.Border.medium(colorScheme)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 1
            )
    }
    
    // MARK: - Actions
    
    private func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let userMessage = ChatMessage(content: inputText, isUser: true, mode: selectedInputMode)
        messages.append(userMessage)
        
        let sentText = inputText
        inputText = ""
        
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let response = ChatMessage(
                content: "I received: \"\(sentText)\". How can I help further?",
                isUser: false,
                mode: selectedInputMode
            )
            messages.append(response)
        }
    }
}

// MARK: - Chat Input Mode

enum ChatInputMode: String, CaseIterable, Identifiable {
    case chat
    case terminal
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .chat: return "Chat"
        case .terminal: return "Terminal"
        }
    }
    
    var icon: String {
        switch self {
        case .chat: return "bubble.right.fill"
        case .terminal: return "terminal.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .chat: return FlowPalette.Category.chat
        case .terminal: return FlowPalette.Category.terminal
        }
    }
    
    var placeholder: String {
        switch self {
        case .chat: return "Ask anything..."
        case .terminal: return "Enter command..."
        }
    }
}

// MARK: - Chat Message

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let mode: ChatInputMode
    let timestamp = Date()
}

// MARK: - Chat Message Bubble

struct ChatMessageBubbleView: View {
    let message: ChatMessage
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if !message.isUser {
                // AI avatar
                ZStack {
                    Circle()
                        .fill(message.mode.color.opacity(0.15))
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 12))
                        .foregroundStyle(message.mode.color)
                }
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.system(size: 13))
                    .foregroundStyle(message.isUser ? .white : FlowPalette.Text.primary(colorScheme))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                message.isUser
                                    ? message.mode.color
                                    : FlowPalette.Semantic.elevated(colorScheme)
                            )
                    )
                
                Text(message.timestamp, style: .time)
                    .font(.system(size: 10))
                    .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
            }
            .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)
            
            if message.isUser {
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
    }
}

// MARK: - Preview

#Preview {
    UnifiedChatPanel(workspaceManager: WorkspaceManager.shared)
        .frame(width: 380, height: 600)
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}
