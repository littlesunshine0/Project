//
//  SidebarItemChat.swift
//  ChatKit
//
//  Sidebar items provided by ChatKit
//

import Foundation
import DataKit

/// Sidebar items provided by ChatKit
public struct SidebarItemChat {
    
    /// All sidebar items provided by ChatKit
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "chat",
            title: "Chat",
            icon: "bubble.left.and.bubble.right.fill",
            colorCategory: "chat",
            route: "/chat",
            priority: 100,
            providedBy: "ChatKit",
            children: [
                SidebarItemDefinition(
                    id: "chat.active",
                    title: "Active Sessions",
                    icon: "bubble.left.fill",
                    colorCategory: "chat",
                    route: "/chat/active",
                    priority: 90,
                    providedBy: "ChatKit"
                ),
                SidebarItemDefinition(
                    id: "chat.history",
                    title: "History",
                    icon: "clock.arrow.circlepath",
                    colorCategory: "chat",
                    route: "/chat/history",
                    priority: 80,
                    providedBy: "ChatKit"
                ),
                SidebarItemDefinition(
                    id: "chat.saved",
                    title: "Saved Prompts",
                    icon: "bookmark.fill",
                    colorCategory: "chat",
                    route: "/chat/saved",
                    priority: 70,
                    providedBy: "ChatKit"
                )
            ]
        )
    ]
    
    /// Register ChatKit's sidebar items
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
