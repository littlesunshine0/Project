//
//  ChatKit.swift
//  ChatKit
//
//  Chat execution, conversations, and help system
//

import Foundation

public struct ChatKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.chatkit"
    public init() {}
}

// MARK: - Chat Engine

public actor ChatEngine {
    public static let shared = ChatEngine()
    
    private var conversations: [UUID: Conversation] = [:]
    private var handlers: [String: MessageHandler] = [:]
    
    private init() {}
    
    // MARK: - Conversations
    
    public func createConversation(title: String? = nil) -> Conversation {
        let conversation = Conversation(title: title)
        conversations[conversation.id] = conversation
        return conversation
    }
    
    public func getConversation(_ id: UUID) -> Conversation? { conversations[id] }
    
    public func deleteConversation(_ id: UUID) { conversations.removeValue(forKey: id) }
    
    public func getAllConversations() -> [Conversation] { Array(conversations.values) }
    
    // MARK: - Messaging
    
    public func send(_ content: String, to conversationId: UUID, role: MessageRole = .user) -> ChatMessage? {
        guard var conversation = conversations[conversationId] else { return nil }
        
        let message = ChatMessage(content: content, role: role)
        conversation.messages.append(message)
        conversations[conversationId] = conversation
        
        return message
    }
    
    public func respond(to conversationId: UUID, content: String) -> ChatMessage? {
        send(content, to: conversationId, role: .assistant)
    }
    
    // MARK: - Handlers
    
    public func registerHandler(_ handler: MessageHandler, for pattern: String) {
        handlers[pattern] = handler
    }
    
    public func processMessage(_ message: ChatMessage) async -> String? {
        for (pattern, handler) in handlers {
            if message.content.lowercased().contains(pattern.lowercased()) {
                return await handler.handle(message)
            }
        }
        return nil
    }
    
    public var stats: ChatStats {
        let totalMessages = conversations.values.reduce(0) { $0 + $1.messages.count }
        return ChatStats(
            conversationCount: conversations.count,
            totalMessages: totalMessages,
            handlerCount: handlers.count
        )
    }
}

// MARK: - Help System

public actor HelpSystem {
    public static let shared = HelpSystem()
    
    private var topics: [String: HelpTopic] = [
        "getting-started": HelpTopic(id: "getting-started", title: "Getting Started", content: "Welcome! Here's how to get started...", category: .tutorial),
        "commands": HelpTopic(id: "commands", title: "Commands", content: "Available commands: /help, /search, /create", category: .reference),
        "faq": HelpTopic(id: "faq", title: "FAQ", content: "Frequently asked questions...", category: .faq)
    ]
    private var searchIndex: [String: Set<String>] = [:]
    
    private init() {}
    
    public func register(_ topic: HelpTopic) {
        topics[topic.id] = topic
        
        // Index for search
        let words = tokenize(topic.title) + tokenize(topic.content)
        for word in words {
            searchIndex[word, default: []].insert(topic.id)
        }
    }
    
    public func getTopic(_ id: String) -> HelpTopic? { topics[id] }
    
    public func search(_ query: String) -> [HelpTopic] {
        let words = tokenize(query)
        var matchingIds: Set<String>?
        
        for word in words {
            if let ids = searchIndex[word] {
                matchingIds = matchingIds == nil ? ids : matchingIds?.intersection(ids)
            }
        }
        
        return (matchingIds ?? []).compactMap { topics[$0] }
    }
    
    public func getByCategory(_ category: HelpCategory) -> [HelpTopic] {
        topics.values.filter { $0.category == category }
    }
    
    public func getAllTopics() -> [HelpTopic] { Array(topics.values) }
    
    private func tokenize(_ text: String) -> [String] {
        text.lowercased().components(separatedBy: CharacterSet.alphanumerics.inverted).filter { $0.count > 2 }
    }
}

// MARK: - Proactive Messages

public actor ProactiveMessageService {
    public static let shared = ProactiveMessageService()
    
    private var rules: [ProactiveRule] = []
    private var sentMessages: [UUID] = []
    
    private init() {}
    
    public func addRule(_ rule: ProactiveRule) {
        rules.append(rule)
    }
    
    public func checkTriggers(context: [String: String]) -> [String] {
        var messages: [String] = []
        
        for rule in rules {
            if rule.shouldTrigger(context: context) {
                messages.append(rule.message)
            }
        }
        
        return messages
    }
    
    public func getRules() -> [ProactiveRule] { rules }
}

// MARK: - Models

public struct Conversation: Identifiable, Sendable {
    public let id: UUID
    public var title: String?
    public var messages: [ChatMessage]
    public let createdAt: Date
    
    public init(id: UUID = UUID(), title: String? = nil, messages: [ChatMessage] = [], createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.messages = messages
        self.createdAt = createdAt
    }
}

public struct ChatMessage: Identifiable, Sendable {
    public let id: UUID
    public let content: String
    public let role: MessageRole
    public let timestamp: Date
    
    public init(id: UUID = UUID(), content: String, role: MessageRole, timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.role = role
        self.timestamp = timestamp
    }
}

public enum MessageRole: String, Sendable, CaseIterable, Codable {
    case user, assistant, system
    
    public var icon: String {
        switch self {
        case .user: return "person"
        case .assistant: return "sparkles"
        case .system: return "gearshape"
        }
    }
}

// MARK: - Chat Section

public enum ChatSection: String, CaseIterable, Sendable {
    case conversations = "Conversations"
    case help = "Help"
    case templates = "Templates"
    case history = "History"
    
    public var icon: String {
        switch self {
        case .conversations: return "bubble.left.and.bubble.right"
        case .help: return "questionmark.circle"
        case .templates: return "doc.on.doc"
        case .history: return "clock.arrow.circlepath"
        }
    }
}

public protocol MessageHandler: Sendable {
    func handle(_ message: ChatMessage) async -> String
}

public struct HelpTopic: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let content: String
    public let category: HelpCategory
    public let relatedTopics: [String]
    
    public init(id: String, title: String, content: String, category: HelpCategory = .general, relatedTopics: [String] = []) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.relatedTopics = relatedTopics
    }
}

public enum HelpCategory: String, Sendable, CaseIterable {
    case general, tutorial, reference, faq, troubleshooting
}

public struct ProactiveRule: Identifiable, Sendable {
    public let id: UUID
    public let trigger: String
    public let message: String
    public let conditions: [String: String]
    
    public init(id: UUID = UUID(), trigger: String, message: String, conditions: [String: String] = [:]) {
        self.id = id
        self.trigger = trigger
        self.message = message
        self.conditions = conditions
    }
    
    public func shouldTrigger(context: [String: String]) -> Bool {
        for (key, value) in conditions {
            if context[key] != value { return false }
        }
        return true
    }
}

public struct ChatStats: Sendable {
    public let conversationCount: Int
    public let totalMessages: Int
    public let handlerCount: Int
}
