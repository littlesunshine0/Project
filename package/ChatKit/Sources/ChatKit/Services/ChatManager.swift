//
//  ChatManager.swift
//  ChatKit
//
//  Chat session management and conversation tracking
//

import Foundation
import Combine

// MARK: - Chat Manager

@MainActor
public class ChatManager: ObservableObject {
    public static let shared = ChatManager()
    
    @Published public var conversations: [Conversation] = []
    @Published public var activeConversation: Conversation?
    @Published public var isProcessing = false
    
    private let conversationsKey = "savedConversations"
    private let maxConversations = 50
    
    private init() {
        loadConversations()
    }
    
    // MARK: - Conversation Management
    
    public func createConversation(title: String? = nil) -> Conversation {
        let conversation = Conversation(title: title)
        conversations.insert(conversation, at: 0)
        activeConversation = conversation
        saveConversations()
        return conversation
    }
    
    public func deleteConversation(_ conversation: Conversation) {
        conversations.removeAll { $0.id == conversation.id }
        if activeConversation?.id == conversation.id {
            activeConversation = conversations.first
        }
        saveConversations()
    }
    
    public func setActive(_ conversation: Conversation) {
        activeConversation = conversation
    }
    
    // MARK: - Messaging
    
    public func sendMessage(_ content: String) {
        guard var conversation = activeConversation else { return }
        
        let message = ChatMessage(content: content, role: .user)
        conversation.messages.append(message)
        
        if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
            conversations[index] = conversation
            activeConversation = conversation
        }
        
        saveConversations()
    }
    
    public func addResponse(_ content: String) {
        guard var conversation = activeConversation else { return }
        
        let message = ChatMessage(content: content, role: .assistant)
        conversation.messages.append(message)
        
        if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
            conversations[index] = conversation
            activeConversation = conversation
        }
        
        saveConversations()
    }
    
    // MARK: - Statistics
    
    public var totalConversations: Int { conversations.count }
    
    public var totalMessages: Int {
        conversations.reduce(0) { $0 + $1.messages.count }
    }
    
    // MARK: - Persistence
    
    private func loadConversations() {
        // Conversations are managed by ChatEngine actor
        // This provides a MainActor-safe view
    }
    
    private func saveConversations() {
        // Persistence handled by ChatEngine
    }
}

// MARK: - Chat Composer

@MainActor
public class ChatComposer: ObservableObject {
    public static let shared = ChatComposer()
    
    @Published public var draftMessage: String = ""
    @Published public var suggestions: [String] = []
    @Published public var templates: [ChatTemplate] = []
    
    private init() {
        loadTemplates()
    }
    
    // MARK: - Composition
    
    public func setDraft(_ text: String) {
        draftMessage = text
        updateSuggestions()
    }
    
    public func clearDraft() {
        draftMessage = ""
        suggestions = []
    }
    
    public func applyTemplate(_ template: ChatTemplate) {
        draftMessage = template.content
    }
    
    private func updateSuggestions() {
        // Generate contextual suggestions based on draft
        if draftMessage.hasPrefix("/") {
            suggestions = ["/help", "/search", "/workflow", "/docs", "/clear"]
                .filter { $0.hasPrefix(draftMessage) }
        } else {
            suggestions = []
        }
    }
    
    // MARK: - Templates
    
    private func loadTemplates() {
        templates = ChatTemplate.builtInTemplates
    }
}

// MARK: - Chat Template

public struct ChatTemplate: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let description: String
    public let content: String
    public let category: String
    public let icon: String
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        content: String,
        category: String = "General",
        icon: String = "text.bubble"
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.content = content
        self.category = category
        self.icon = icon
    }
    
    public static let builtInTemplates: [ChatTemplate] = [
        ChatTemplate(
            name: "Help Request",
            description: "Ask for help with a topic",
            content: "Can you help me with ",
            category: "Support",
            icon: "questionmark.circle"
        ),
        ChatTemplate(
            name: "Search Query",
            description: "Search for documentation",
            content: "/search ",
            category: "Commands",
            icon: "magnifyingglass"
        ),
        ChatTemplate(
            name: "Run Workflow",
            description: "Execute a workflow",
            content: "/workflow run ",
            category: "Commands",
            icon: "play.circle"
        ),
        ChatTemplate(
            name: "Create Item",
            description: "Create a new item",
            content: "/create ",
            category: "Commands",
            icon: "plus.circle"
        )
    ]
}
