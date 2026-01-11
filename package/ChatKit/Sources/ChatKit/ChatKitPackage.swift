//
//  ChatKitPackage.swift
//  ChatKit
//
//  Package definition with comprehensive chat commands, actions, workflows
//

import SwiftUI
import DataKit

public struct ChatKitPackage: @unchecked Sendable {
    public static let shared = ChatKitPackage()
    
    public let info: PackageInfo
    
    private init() {
        info = PackageInfo(
            identifier: "com.flowkit.chatkit",
            name: "ChatKit",
            version: "1.0.0",
            description: "Chat interface, conversations, AI interactions, and messaging",
            icon: "bubble.left.and.bubble.right",
            color: "teal",
            files: Self.indexedFiles,
            dependencies: ["DataKit", "CoreKit", "AIKit"],
            exports: ["Chat", "ChatManager", "ChatViewModel"],
            commandCount: Self.commands.count,
            actionCount: Self.actions.count,
            workflowCount: Self.workflows.count,
            agentCount: Self.agents.count,
            viewCount: 6,
            modelCount: 5,
            serviceCount: 3
        )
    }
    
    public func register() async {
        await PackageIndex.shared.register(info)
        await KitRegistry.shared.register(manifest)
    }
    
    public var manifest: KitManifest {
        KitManifest(
            identifier: info.identifier,
            name: info.name,
            version: info.version,
            description: info.description,
            commands: Self.commands,
            actions: Self.actions,
            shortcuts: Self.shortcuts,
            menuItems: Self.menuItems,
            contextMenus: Self.contextMenus,
            workflows: Self.workflows,
            agents: Self.agents
        )
    }
    
    // MARK: - Commands (20+)
    
    public static let commands: [KitCommand] = [
        KitCommand(id: "chat.new", name: "New Chat", description: "Start new conversation", syntax: "/chat new", kit: "ChatKit", handler: "newChat"),
        KitCommand(id: "chat.list", name: "List Chats", description: "List all conversations", syntax: "/chats", kit: "ChatKit", handler: "list"),
        KitCommand(id: "chat.open", name: "Open Chat", description: "Open a conversation", syntax: "/chat open <id>", kit: "ChatKit", handler: "open"),
        KitCommand(id: "chat.close", name: "Close Chat", description: "Close current chat", syntax: "/chat close", kit: "ChatKit", handler: "close"),
        KitCommand(id: "chat.delete", name: "Delete Chat", description: "Delete a conversation", syntax: "/chat delete <id>", kit: "ChatKit", handler: "delete"),
        KitCommand(id: "chat.clear", name: "Clear Chat", description: "Clear chat history", syntax: "/chat clear", kit: "ChatKit", handler: "clear"),
        KitCommand(id: "chat.export", name: "Export Chat", description: "Export conversation", syntax: "/chat export <format>", kit: "ChatKit", handler: "export"),
        KitCommand(id: "chat.search", name: "Search Chats", description: "Search in conversations", syntax: "/chat search <query>", kit: "ChatKit", handler: "search"),
        KitCommand(id: "chat.rename", name: "Rename Chat", description: "Rename conversation", syntax: "/chat rename <name>", kit: "ChatKit", handler: "rename"),
        KitCommand(id: "chat.pin", name: "Pin Chat", description: "Pin conversation", syntax: "/chat pin", kit: "ChatKit", handler: "pin"),
        KitCommand(id: "chat.unpin", name: "Unpin Chat", description: "Unpin conversation", syntax: "/chat unpin", kit: "ChatKit", handler: "unpin"),
        KitCommand(id: "chat.archive", name: "Archive Chat", description: "Archive conversation", syntax: "/chat archive", kit: "ChatKit", handler: "archive"),
        KitCommand(id: "chat.model", name: "Set Model", description: "Set AI model", syntax: "/chat model <name>", kit: "ChatKit", handler: "setModel"),
        KitCommand(id: "chat.context", name: "Set Context", description: "Set chat context", syntax: "/chat context <file>", kit: "ChatKit", handler: "setContext"),
        KitCommand(id: "chat.system", name: "System Prompt", description: "Set system prompt", syntax: "/chat system <prompt>", kit: "ChatKit", handler: "setSystem"),
        KitCommand(id: "chat.temperature", name: "Set Temperature", description: "Set AI temperature", syntax: "/chat temp <value>", kit: "ChatKit", handler: "setTemperature"),
        KitCommand(id: "chat.regenerate", name: "Regenerate", description: "Regenerate last response", syntax: "/chat regenerate", kit: "ChatKit", handler: "regenerate"),
        KitCommand(id: "chat.continue", name: "Continue", description: "Continue response", syntax: "/chat continue", kit: "ChatKit", handler: "continue"),
        KitCommand(id: "chat.stop", name: "Stop", description: "Stop generation", syntax: "/chat stop", kit: "ChatKit", handler: "stop"),
        KitCommand(id: "chat.share", name: "Share Chat", description: "Share conversation", syntax: "/chat share", kit: "ChatKit", handler: "share")
    ]
    
    // MARK: - Actions (15+)
    
    public static let actions: [KitAction] = [
        KitAction(id: "action.chat.new", name: "New Chat", description: "Start new chat", icon: "plus.bubble", kit: "ChatKit", handler: "newChat"),
        KitAction(id: "action.chat.send", name: "Send", description: "Send message", icon: "paperplane.fill", kit: "ChatKit", handler: "send"),
        KitAction(id: "action.chat.stop", name: "Stop", description: "Stop generation", icon: "stop.fill", kit: "ChatKit", handler: "stop"),
        KitAction(id: "action.chat.regenerate", name: "Regenerate", description: "Regenerate response", icon: "arrow.clockwise", kit: "ChatKit", handler: "regenerate"),
        KitAction(id: "action.chat.copy", name: "Copy", description: "Copy message", icon: "doc.on.doc", kit: "ChatKit", handler: "copy"),
        KitAction(id: "action.chat.edit", name: "Edit", description: "Edit message", icon: "pencil", kit: "ChatKit", handler: "edit"),
        KitAction(id: "action.chat.delete", name: "Delete", description: "Delete message", icon: "trash", kit: "ChatKit", handler: "delete"),
        KitAction(id: "action.chat.pin", name: "Pin", description: "Pin chat", icon: "pin", kit: "ChatKit", handler: "pin"),
        KitAction(id: "action.chat.share", name: "Share", description: "Share chat", icon: "square.and.arrow.up", kit: "ChatKit", handler: "share"),
        KitAction(id: "action.chat.export", name: "Export", description: "Export chat", icon: "square.and.arrow.down", kit: "ChatKit", handler: "export"),
        KitAction(id: "action.chat.clear", name: "Clear", description: "Clear chat", icon: "trash", kit: "ChatKit", handler: "clear"),
        KitAction(id: "action.chat.search", name: "Search", description: "Search chats", icon: "magnifyingglass", kit: "ChatKit", handler: "search"),
        KitAction(id: "action.chat.settings", name: "Settings", description: "Chat settings", icon: "gearshape", kit: "ChatKit", handler: "settings"),
        KitAction(id: "action.chat.context", name: "Add Context", description: "Add context", icon: "doc.badge.plus", kit: "ChatKit", handler: "addContext"),
        KitAction(id: "action.chat.feedback", name: "Feedback", description: "Rate response", icon: "hand.thumbsup", kit: "ChatKit", handler: "feedback")
    ]
    
    // MARK: - Shortcuts
    
    public static let shortcuts: [KitShortcut] = [
        KitShortcut(key: "N", modifiers: [.command, .shift], action: "chat.new", description: "New chat", kit: "ChatKit"),
        KitShortcut(key: "Return", modifiers: [.command], action: "action.chat.send", description: "Send message", kit: "ChatKit"),
        KitShortcut(key: ".", modifiers: [.command], action: "action.chat.stop", description: "Stop generation", kit: "ChatKit"),
        KitShortcut(key: "R", modifiers: [.command, .shift], action: "action.chat.regenerate", description: "Regenerate", kit: "ChatKit"),
        KitShortcut(key: "F", modifiers: [.command], action: "action.chat.search", description: "Search", kit: "ChatKit"),
        KitShortcut(key: "L", modifiers: [.command], action: "action.chat.clear", description: "Clear chat", kit: "ChatKit")
    ]
    
    // MARK: - Menu Items
    
    public static let menuItems: [KitMenuItem] = [
        KitMenuItem(title: "Chats", icon: "bubble.left.and.bubble.right", action: "showChats", kit: "ChatKit"),
        KitMenuItem(title: "New Chat", icon: "plus.bubble", action: "newChat", shortcut: "⇧⌘N", kit: "ChatKit"),
        KitMenuItem(title: "Search Chats", icon: "magnifyingglass", action: "searchChats", shortcut: "⌘F", kit: "ChatKit"),
        KitMenuItem(title: "Pinned Chats", icon: "pin", action: "showPinned", kit: "ChatKit"),
        KitMenuItem(title: "Archived Chats", icon: "archivebox", action: "showArchived", kit: "ChatKit"),
        KitMenuItem(title: "Export Chat", icon: "square.and.arrow.up", action: "exportChat", kit: "ChatKit"),
        KitMenuItem(title: "Chat Settings", icon: "gearshape", action: "chatSettings", kit: "ChatKit")
    ]
    
    // MARK: - Context Menus
    
    public static let contextMenus: [KitContextMenu] = [
        KitContextMenu(targetType: "Chat", items: [
            KitMenuItem(title: "Open", icon: "bubble.left", action: "open", kit: "ChatKit"),
            KitMenuItem(title: "Pin", icon: "pin", action: "pin", kit: "ChatKit"),
            KitMenuItem(title: "Rename", icon: "pencil", action: "rename", kit: "ChatKit"),
            KitMenuItem(title: "Export", icon: "square.and.arrow.up", action: "export", kit: "ChatKit"),
            KitMenuItem(title: "Archive", icon: "archivebox", action: "archive", kit: "ChatKit"),
            KitMenuItem(title: "Delete", icon: "trash", action: "delete", kit: "ChatKit")
        ], kit: "ChatKit"),
        KitContextMenu(targetType: "Message", items: [
            KitMenuItem(title: "Copy", icon: "doc.on.doc", action: "copy", kit: "ChatKit"),
            KitMenuItem(title: "Edit", icon: "pencil", action: "edit", kit: "ChatKit"),
            KitMenuItem(title: "Regenerate", icon: "arrow.clockwise", action: "regenerate", kit: "ChatKit"),
            KitMenuItem(title: "Delete", icon: "trash", action: "delete", kit: "ChatKit")
        ], kit: "ChatKit")
    ]
    
    // MARK: - Workflows (8+)
    
    public static let workflows: [KitWorkflow] = [
        KitWorkflow(name: "Start Conversation", description: "Start a new AI conversation", steps: ["New Chat", "Set context (optional)", "Send message", "Review response"], kit: "ChatKit"),
        KitWorkflow(name: "Code Review Chat", description: "Review code with AI", steps: ["New Chat", "Add code context", "Ask for review", "Discuss suggestions"], kit: "ChatKit"),
        KitWorkflow(name: "Debug Session", description: "Debug with AI assistance", steps: ["New Chat", "Describe problem", "Share error", "Follow suggestions", "Verify fix"], kit: "ChatKit"),
        KitWorkflow(name: "Export Conversation", description: "Export chat for sharing", steps: ["Open chat", "Select format", "Export", "Share"], kit: "ChatKit"),
        KitWorkflow(name: "Search History", description: "Find past conversations", steps: ["Open search", "Enter query", "Filter results", "Open chat"], kit: "ChatKit"),
        KitWorkflow(name: "Configure AI Model", description: "Configure chat AI settings", steps: ["Open settings", "Select model", "Set temperature", "Set context length", "Save"], kit: "ChatKit"),
        KitWorkflow(name: "Organize Chats", description: "Organize conversations", steps: ["Review chats", "Pin important", "Archive old", "Delete unused"], kit: "ChatKit"),
        KitWorkflow(name: "Share Conversation", description: "Share chat with others", steps: ["Open chat", "Generate share link", "Set permissions", "Share"], kit: "ChatKit")
    ]
    
    // MARK: - Agents (5+)
    
    public static let agents: [KitAgent] = [
        KitAgent(name: "Context Manager", description: "Manages chat context automatically", triggers: ["file.open", "selection.change", "chat.start"], actions: ["gather.context", "update.context", "suggest.context"], kit: "ChatKit"),
        KitAgent(name: "Response Enhancer", description: "Enhances AI responses", triggers: ["response.received", "code.detected"], actions: ["format.code", "add.links", "enhance.formatting"], kit: "ChatKit"),
        KitAgent(name: "History Organizer", description: "Organizes chat history", triggers: ["chat.end", "schedule.daily"], actions: ["categorize.chats", "suggest.archive", "cleanup.old"], kit: "ChatKit"),
        KitAgent(name: "Smart Suggester", description: "Suggests follow-up questions", triggers: ["response.received", "pause.detected"], actions: ["analyze.response", "generate.suggestions", "show.suggestions"], kit: "ChatKit"),
        KitAgent(name: "Code Extractor", description: "Extracts and manages code from chats", triggers: ["code.detected", "save.request"], actions: ["extract.code", "format.code", "save.snippet"], kit: "ChatKit")
    ]
    
    // MARK: - File Index
    
    private static let indexedFiles: [FileInfo] = [
        FileInfo(name: "Chat.swift", path: "Models/Chat.swift", type: .model),
        FileInfo(name: "ChatMessage.swift", path: "Models/ChatMessage.swift", type: .model),
        FileInfo(name: "ChatKind.swift", path: "Models/ChatKind.swift", type: .model),
        FileInfo(name: "ChatFormat.swift", path: "Models/ChatFormat.swift", type: .model),
        FileInfo(name: "ChatSection.swift", path: "Models/ChatSection.swift", type: .model),
        FileInfo(name: "ChatError.swift", path: "Models/ChatError.swift", type: .model),
        FileInfo(name: "ChatManager.swift", path: "Services/ChatManager.swift", type: .service),
        FileInfo(name: "ChatBrowser.swift", path: "Views/ChatBrowser.swift", type: .view),
        FileInfo(name: "ChatCard.swift", path: "Views/ChatCard.swift", type: .view),
        FileInfo(name: "ChatViewModel.swift", path: "ViewModels/ChatViewModel.swift", type: .viewModel)
    ]
}
