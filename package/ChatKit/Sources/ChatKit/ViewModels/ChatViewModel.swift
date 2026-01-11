//
//  ChatViewModel.swift
//  ChatKit
//

import Foundation
import Combine

@MainActor
public class ChatViewModel: ObservableObject {
    @Published public var conversations: [Conversation] = []
    @Published public var currentConversation: Conversation?
    @Published public var inputText = ""
    @Published public var selectedSection: ChatSection = .conversations
    @Published public var isLoading = false
    @Published public var error: ChatError?
    
    private let engine: ChatEngine
    
    public init() {
        self.engine = ChatEngine.shared
        Task { await loadConversations() }
    }
    
    // MARK: - CRUD Operations
    
    public func loadConversations() async {
        conversations = await engine.getAllConversations()
    }
    
    public func createConversation(title: String? = nil) async {
        let conversation = await engine.createConversation(title: title)
        currentConversation = conversation
        await loadConversations()
    }
    
    public func deleteConversation(_ conversation: Conversation) async {
        await engine.deleteConversation(conversation.id)
        if currentConversation?.id == conversation.id {
            currentConversation = nil
        }
        await loadConversations()
    }
    
    public func sendMessage() async {
        guard !inputText.isEmpty, let conversation = currentConversation else { return }
        
        isLoading = true
        let _ = await engine.send(inputText, to: conversation.id)
        inputText = ""
        
        // Simulate response
        try? await Task.sleep(nanoseconds: 500_000_000)
        let _ = await engine.respond(to: conversation.id, content: "I received your message.")
        
        await loadConversations()
        if let updated = conversations.first(where: { $0.id == conversation.id }) {
            currentConversation = updated
        }
        isLoading = false
    }
    
    // MARK: - Filtering
    
    public var filteredConversations: [Conversation] {
        switch selectedSection {
        case .conversations: return conversations
        case .help: return []
        case .templates: return []
        case .history: return conversations.sorted { $0.createdAt > $1.createdAt }
        }
    }
}
