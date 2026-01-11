//
//  ChatError.swift
//  ChatKit
//

import Foundation

public enum ChatError: LocalizedError, Sendable {
    case conversationNotFound(UUID)
    case messageFailed(String)
    case connectionLost
    case rateLimited
    case invalidInput(String)
    
    public var errorDescription: String? {
        switch self {
        case .conversationNotFound(let id): return "Conversation not found: \(id)"
        case .messageFailed(let msg): return "Message failed: \(msg)"
        case .connectionLost: return "Connection lost"
        case .rateLimited: return "Rate limited, please wait"
        case .invalidInput(let msg): return "Invalid input: \(msg)"
        }
    }
    
    public var icon: String {
        switch self {
        case .conversationNotFound: return "bubble.left.and.bubble.right"
        case .messageFailed: return "exclamationmark.bubble"
        case .connectionLost: return "wifi.slash"
        case .rateLimited: return "clock"
        case .invalidInput: return "exclamationmark.triangle"
        }
    }
}
