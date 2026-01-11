//
//  ChatPanel.swift
//  FlowKit
//
//  Standalone chat panel - separate from input panel
//  Opens from toolbar toggle, floats on right side
//  Never touches toolbar or other panels (maintains gaps)
//

import SwiftUI
import DesignKit

struct ChatPanel: View {
    @ObservedObject var workspaceManager: WorkspaceManager
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var messages: [ChatPanelMessage] = []
    @State private var inputText: String = ""
    @FocusState private var isInputFocused: Bool
    
    private let cornerRadius: CGFloat = 16
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with back button
            chatHeader
            
            // Messages area
            messagesArea
            
            // Input area (chat-specific)
            chatInputArea
        }
        .background(FlowPalette.Semantic.floating(colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
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
        )
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
                LinearGradient(
                    colors: [
                        FlowPalette.Category.chat.opacity(colorScheme == .dark ? 0.08 : 0.05),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                
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
                                ChatPanelBubble(message: message)
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
    
    // MARK: - Chat Input Area
    
    private var chatInputArea: some View {
        VStack(spacing: 0) {
            FlowPalette.Border.subtle(colorScheme).frame(height: 1)
            
            HStack(alignment: .bottom, spacing: 10) {
                // Attachment button
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
                }
                .buttonStyle(.plain)
                
                // Text input
                TextField("Ask anything...", text: $inputText, axis: .vertical)
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
                                            ? FlowPalette.Category.chat.opacity(0.5)
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
                                : FlowPalette.Category.chat
                        )
                }
                .buttonStyle(.plain)
                .disabled(inputText.isEmpty)
            }
            .padding(12)
        }
    }
    
    // MARK: - Actions
    
    private func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let userMessage = ChatPanelMessage(content: inputText, isUser: true)
        messages.append(userMessage)
        
        let sentText = inputText
        inputText = ""
        
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let response = ChatPanelMessage(
                content: "I received: \"\(sentText)\". How can I help further?",
                isUser: false
            )
            messages.append(response)
        }
    }
}

// MARK: - Chat Message Model

struct ChatPanelMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp = Date()
}

// MARK: - Chat Bubble

struct ChatPanelBubble: View {
    let message: ChatPanelMessage
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if !message.isUser {
                ZStack {
                    Circle()
                        .fill(FlowPalette.Category.chat.opacity(0.15))
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 12))
                        .foregroundStyle(FlowPalette.Category.chat)
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
                                    ? FlowPalette.Category.chat
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
    ChatPanel(workspaceManager: WorkspaceManager.shared)
        .frame(width: 380, height: 600)
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}
