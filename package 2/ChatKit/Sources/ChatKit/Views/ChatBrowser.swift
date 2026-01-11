//
//  ChatBrowser.swift
//  ChatKit
//

import SwiftUI

public struct ChatBrowser: View {
    @StateObject private var viewModel = ChatViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            if let conversation = viewModel.currentConversation {
                ChatConversationView(conversation: conversation, viewModel: viewModel)
            } else {
                ContentUnavailableView("No Conversation", systemImage: "bubble.left.and.bubble.right", description: Text("Select or create a conversation"))
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: { Task { await viewModel.createConversation() } }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    private var sidebar: some View {
        List(selection: $viewModel.selectedSection) {
            Section("Sections") {
                ForEach(ChatSection.allCases, id: \.self) { section in
                    Label(section.rawValue, systemImage: section.icon)
                        .tag(section)
                }
            }
            
            Section("Conversations") {
                ForEach(viewModel.conversations) { conversation in
                    Label(conversation.title ?? "Untitled", systemImage: "bubble.left")
                        .onTapGesture { viewModel.currentConversation = conversation }
                }
            }
        }
        .navigationTitle("Chat")
    }
}

public struct ChatConversationView: View {
    public let conversation: Conversation
    @ObservedObject public var viewModel: ChatViewModel
    
    public init(conversation: Conversation, viewModel: ChatViewModel) {
        self.conversation = conversation
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(conversation.messages) { message in
                        ChatMessageRow(message: message)
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("Message...", text: $viewModel.inputText)
                    .textFieldStyle(.roundedBorder)
                
                Button(action: { Task { await viewModel.sendMessage() } }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                }
                .disabled(viewModel.inputText.isEmpty || viewModel.isLoading)
            }
            .padding()
        }
        .navigationTitle(conversation.title ?? "Conversation")
    }
}

public struct ChatMessageRow: View {
    public let message: ChatMessage
    
    public init(message: ChatMessage) {
        self.message = message
    }
    
    public var body: some View {
        HStack {
            if message.role == .user { Spacer() }
            
            VStack(alignment: message.role == .user ? .trailing : .leading) {
                Text(message.content)
                    .padding(12)
                    .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundStyle(message.role == .user ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            if message.role != .user { Spacer() }
        }
    }
}
