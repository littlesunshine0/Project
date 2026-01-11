//
//  ChatKind.swift
//  ChatKit
//

import Foundation

public enum ChatKind: String, CaseIterable, Codable, Sendable {
    case conversation = "Conversation"
    case command = "Command"
    case help = "Help"
    case feedback = "Feedback"
    case notification = "Notification"
    
    public var icon: String {
        switch self {
        case .conversation: return "bubble.left.and.bubble.right"
        case .command: return "terminal"
        case .help: return "questionmark.circle"
        case .feedback: return "hand.thumbsup"
        case .notification: return "bell"
        }
    }
}
