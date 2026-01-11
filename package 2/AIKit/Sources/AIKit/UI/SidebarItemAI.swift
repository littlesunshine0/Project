//
//  SidebarItemAI.swift
//  AIKit
//
//  Sidebar items provided by AIKit
//

import Foundation
import DataKit

/// Sidebar items provided by AIKit
public struct SidebarItemAI {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "ai",
            title: "AI Assistant",
            icon: "sparkles",
            colorCategory: "chat",
            route: "/ai",
            priority: 98,
            providedBy: "AIKit",
            children: [
                SidebarItemDefinition(id: "ai.chat", title: "Chat", icon: "bubble.left.and.bubble.right.fill", colorCategory: "chat", route: "/ai/chat", priority: 90, providedBy: "AIKit"),
                SidebarItemDefinition(id: "ai.suggestions", title: "Suggestions", icon: "lightbulb.fill", colorCategory: "warning", route: "/ai/suggestions", priority: 80, providedBy: "AIKit"),
                SidebarItemDefinition(id: "ai.models", title: "Models", icon: "cpu.fill", colorCategory: "agents", route: "/ai/models", priority: 70, providedBy: "AIKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
