//
//  BottomPanelItemChat.swift
//  ChatKit
//
//  Bottom panel items provided by ChatKit
//

import Foundation
import DataKit

/// Bottom panel items provided by ChatKit
public struct BottomPanelItemChat {
    
    /// All bottom panel tabs provided by ChatKit
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "chat.input",
            title: "Chat",
            icon: "text.bubble.fill",
            colorCategory: "chat",
            hasInput: true,
            placeholder: "Type a message...",
            priority: 100,
            providedBy: "ChatKit"
        )
    ]
    
    /// Register ChatKit's bottom panel items
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
