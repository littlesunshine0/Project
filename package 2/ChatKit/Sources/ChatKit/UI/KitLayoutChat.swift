//
//  KitLayoutChat.swift
//  ChatKit
//
//  Complete layout configuration for ChatKit
//

import Foundation
import DataKit

/// Complete layout configuration for ChatKit
public struct KitLayoutChat {
    
    // MARK: - Sidebar Items
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "chat",
            title: "Chat",
            icon: "bubble.left.and.bubble.right.fill",
            colorCategory: "chat",
            route: "/chat",
            priority: 100,
            providedBy: "ChatKit",
            children: [
                SidebarItemDefinition(id: "chat.active", title: "Active Sessions", icon: "bubble.left.fill", colorCategory: "chat", route: "/chat/active", priority: 90, providedBy: "ChatKit"),
                SidebarItemDefinition(id: "chat.history", title: "History", icon: "clock.arrow.circlepath", colorCategory: "chat", route: "/chat/history", priority: 80, providedBy: "ChatKit"),
                SidebarItemDefinition(id: "chat.saved", title: "Saved Prompts", icon: "bookmark.fill", colorCategory: "chat", route: "/chat/saved", priority: 70, providedBy: "ChatKit")
            ]
        )
    ]
    
    // MARK: - Bottom Panel Tabs
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
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
    
    // MARK: - Inspectors
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "chat.properties", type: .properties, title: "Chat Properties", colorCategory: "chat", priority: 90, providedBy: "ChatKit", isDefault: true),
        InspectorDefinition(id: "chat.history", type: .historyInspector, title: "Message History", colorCategory: "chat", priority: 80, providedBy: "ChatKit"),
        InspectorDefinition(id: "chat.quickHelp", type: .quickHelp, title: "Chat Help", colorCategory: "info", priority: 70, providedBy: "ChatKit"),
        InspectorDefinition(id: "chat.metadata", type: .metadataPreview, title: "Session Info", colorCategory: "chat", priority: 60, providedBy: "ChatKit")
    ]
    
    // MARK: - Right Sidebar Panels
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(
            id: "chat.inspector",
            title: "Chat Inspector",
            icon: "bubble.left.and.bubble.right.fill",
            colorCategory: "chat",
            priority: 90,
            providedBy: "ChatKit",
            inspectors: inspectors,
            defaultPosition: .top
        ),
        RightSidebarPanelDefinition(
            id: "chat.context",
            title: "Context",
            icon: "doc.text.fill",
            colorCategory: "chat",
            priority: 80,
            providedBy: "ChatKit",
            defaultPosition: .middle
        )
    ]
    
    // MARK: - Main Contexts
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(
            id: "chat.conversation",
            title: "Conversation",
            icon: "bubble.left.and.bubble.right.fill",
            colorCategory: "chat",
            route: "/chat",
            providedBy: "ChatKit",
            supportedInspectors: [.properties, .historyInspector, .quickHelp, .metadataPreview],
            defaultRightSidebar: "chat.inspector",
            defaultBottomPanel: "chat.input"
        )
    ]
    
    // MARK: - Full Configuration
    
    public static let configuration = KitLayoutConfiguration(
        id: "chatkit.layout",
        kitName: "ChatKit",
        displayName: "Chat",
        icon: "bubble.left.and.bubble.right.fill",
        colorCategory: "chat",
        sidebarItems: sidebarItems,
        bottomPanelTabs: bottomPanelTabs,
        rightSidebarPanels: rightSidebarPanels,
        mainContexts: mainContexts,
        inspectors: inspectors
    )
    
    // MARK: - Registration
    
    public static func register() {
        KitLayoutRegistry.shared.register(configuration: configuration)
    }
}
