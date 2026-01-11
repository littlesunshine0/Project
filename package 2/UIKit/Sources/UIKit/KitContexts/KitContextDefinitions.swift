//
//  KitContextDefinitions.swift
//  UIKit
//
//  Predefined kit UI contexts
//

import Foundation
import DataKit

// MARK: - Kit Context Definitions

extension KitUIContext {
    
    // MARK: - ChatKit
    
    public static let chat = KitUIContext(
        id: "chat.context", kitId: "ChatKit", displayName: "Chat", icon: "bubble.left.and.bubble.right.fill", colorCategory: "chat", priority: 100,
        sidebarItems: [
            SidebarItemConfig(id: "chat", title: "Chat", icon: "bubble.left.and.bubble.right.fill", route: "/chat", children: [
                SidebarItemConfig(id: "chat.active", title: "Active", icon: "bubble.left.fill", route: "/chat/active"),
                SidebarItemConfig(id: "chat.history", title: "History", icon: "clock.arrow.circlepath", route: "/chat/history"),
                SidebarItemConfig(id: "chat.saved", title: "Saved", icon: "bookmark.fill", route: "/chat/saved")
            ])
        ],
        bottomPanelTabs: [BottomPanelTabConfig(id: "chat.input", title: "Chat", icon: "text.bubble.fill", hasInput: true, placeholder: "Type a message...")],
        inspectorTabs: [
            InspectorTabConfig(id: "chat.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "chat.history", title: "History", icon: "clock.arrow.circlepath", type: "history"),
            InspectorTabConfig(id: "chat.context", title: "Context", icon: "doc.text.fill", type: "context")
        ],
        mainContexts: [MainContextConfig(id: "chat.main", title: "Chat", route: "/chat", defaultInspector: "chat.properties", defaultBottomPanel: "chat.input")],
        supportedSystems: ["doubleSidebar", "floatingPanel", "bottomPanel", "inspector"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - FileKit
    
    public static let file = KitUIContext(
        id: "file.context", kitId: "FileKit", displayName: "Files", icon: "folder.fill", colorCategory: "file", priority: 95,
        sidebarItems: [
            SidebarItemConfig(id: "files", title: "Files", icon: "folder.fill", route: "/files", children: [
                SidebarItemConfig(id: "files.explorer", title: "Explorer", icon: "folder.fill", route: "/files/explorer"),
                SidebarItemConfig(id: "files.recent", title: "Recent", icon: "clock.fill", route: "/files/recent"),
                SidebarItemConfig(id: "files.favorites", title: "Favorites", icon: "star.fill", route: "/files/favorites")
            ])
        ],
        bottomPanelTabs: [BottomPanelTabConfig(id: "files.output", title: "Output", icon: "doc.text.fill")],
        inspectorTabs: [
            InspectorTabConfig(id: "file.inspector", title: "File Inspector", icon: "doc.text.fill", type: "fileInspector", isDefault: true),
            InspectorTabConfig(id: "file.preview", title: "Preview", icon: "eye.fill", type: "filePreview"),
            InspectorTabConfig(id: "file.history", title: "History", icon: "clock.arrow.circlepath", type: "history"),
            InspectorTabConfig(id: "file.quickHelp", title: "Quick Help", icon: "questionmark.circle.fill", type: "quickHelp")
        ],
        mainContexts: [MainContextConfig(id: "file.editor", title: "Editor", route: "/files", defaultInspector: "file.inspector")],
        supportedSystems: ["doubleSidebar", "fileTree", "tab", "inspector", "bottomPanel"],
        defaultLayoutTemplate: "ide.classic"
    )

    
    // MARK: - SearchKit
    
    public static let search = KitUIContext(
        id: "search.context", kitId: "SearchKit", displayName: "Search", icon: "magnifyingglass", colorCategory: "search", priority: 90,
        sidebarItems: [SidebarItemConfig(id: "search", title: "Search", icon: "magnifyingglass", route: "/search", children: [
            SidebarItemConfig(id: "search.global", title: "Global", icon: "magnifyingglass", route: "/search/global"),
            SidebarItemConfig(id: "search.files", title: "Find in Files", icon: "doc.text.magnifyingglass", route: "/search/files"),
            SidebarItemConfig(id: "search.replace", title: "Replace", icon: "arrow.left.arrow.right", route: "/search/replace")
        ])],
        bottomPanelTabs: [BottomPanelTabConfig(id: "search.results", title: "Search", icon: "magnifyingglass", hasInput: true, placeholder: "Search...")],
        inspectorTabs: [InspectorTabConfig(id: "search.preview", title: "Preview", icon: "eye.fill", type: "filePreview", isDefault: true)],
        mainContexts: [MainContextConfig(id: "search.main", title: "Search", route: "/search", defaultBottomPanel: "search.results")],
        supportedSystems: ["doubleSidebar", "bottomPanel", "list"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - AgentKit
    
    public static let agent = KitUIContext(
        id: "agent.context", kitId: "AgentKit", displayName: "Agents", icon: "cpu.fill", colorCategory: "agent", priority: 80,
        sidebarItems: [SidebarItemConfig(id: "agents", title: "Agents", icon: "cpu.fill", route: "/agents", children: [
            SidebarItemConfig(id: "agents.active", title: "Active", icon: "play.circle.fill", route: "/agents/active"),
            SidebarItemConfig(id: "agents.all", title: "All", icon: "list.bullet", route: "/agents/all"),
            SidebarItemConfig(id: "agents.history", title: "History", icon: "clock.arrow.circlepath", route: "/agents/history")
        ])],
        bottomPanelTabs: [
            BottomPanelTabConfig(id: "agent.console", title: "Console", icon: "terminal.fill", hasInput: true, placeholder: "Agent command..."),
            BottomPanelTabConfig(id: "agent.logs", title: "Logs", icon: "doc.text.fill")
        ],
        inspectorTabs: [
            InspectorTabConfig(id: "agent.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "agent.performance", title: "Performance", icon: "gauge.with.dots.needle.bottom.50percent", type: "performance"),
            InspectorTabConfig(id: "agent.debug", title: "Debug", icon: "ant.fill", type: "debug")
        ],
        mainContexts: [MainContextConfig(id: "agent.dashboard", title: "Agents", route: "/agents", defaultInspector: "agent.properties", defaultBottomPanel: "agent.console")],
        supportedSystems: ["doubleSidebar", "bottomPanel", "inspector", "card"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - WorkflowKit
    
    public static let workflow = KitUIContext(
        id: "workflow.context", kitId: "WorkflowKit", displayName: "Workflows", icon: "arrow.triangle.branch", colorCategory: "workflow", priority: 78,
        sidebarItems: [SidebarItemConfig(id: "workflows", title: "Workflows", icon: "arrow.triangle.branch", route: "/workflows", children: [
            SidebarItemConfig(id: "workflows.active", title: "Active", icon: "play.circle.fill", route: "/workflows/active"),
            SidebarItemConfig(id: "workflows.library", title: "Library", icon: "folder.fill", route: "/workflows/library")
        ])],
        bottomPanelTabs: [BottomPanelTabConfig(id: "workflow.output", title: "Output", icon: "arrow.triangle.branch")],
        inspectorTabs: [
            InspectorTabConfig(id: "workflow.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "workflow.preview", title: "Preview", icon: "play.rectangle.fill", type: "livePreview"),
            InspectorTabConfig(id: "workflow.connections", title: "Connections", icon: "point.3.connected.trianglepath.dotted", type: "connections")
        ],
        mainContexts: [MainContextConfig(id: "workflow.canvas", title: "Canvas", route: "/workflows", defaultInspector: "workflow.properties")],
        supportedSystems: ["doubleSidebar", "bottomPanel", "inspector"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - DocKit
    
    public static let doc = KitUIContext(
        id: "doc.context", kitId: "DocKit", displayName: "Documentation", icon: "book.fill", colorCategory: "doc", priority: 75,
        sidebarItems: [SidebarItemConfig(id: "docs", title: "Docs", icon: "book.fill", route: "/docs", children: [
            SidebarItemConfig(id: "docs.browse", title: "Browse", icon: "books.vertical.fill", route: "/docs/browse"),
            SidebarItemConfig(id: "docs.api", title: "API", icon: "doc.text.magnifyingglass", route: "/docs/api")
        ])],
        bottomPanelTabs: [BottomPanelTabConfig(id: "docs.search", title: "Doc Search", icon: "magnifyingglass", hasInput: true, placeholder: "Search docs...")],
        inspectorTabs: [
            InspectorTabConfig(id: "doc.quickHelp", title: "Quick Help", icon: "questionmark.circle.fill", type: "quickHelp", isDefault: true),
            InspectorTabConfig(id: "doc.preview", title: "Preview", icon: "eye.fill", type: "livePreview")
        ],
        mainContexts: [MainContextConfig(id: "doc.viewer", title: "Documentation", route: "/docs", defaultInspector: "doc.quickHelp")],
        supportedSystems: ["doubleSidebar", "outline", "inspector"],
        defaultLayoutTemplate: "browser.twoColumn"
    )

    
    // MARK: - ErrorKit
    
    public static let error = KitUIContext(
        id: "error.context", kitId: "ErrorKit", displayName: "Problems", icon: "exclamationmark.triangle.fill", colorCategory: "error", priority: 85,
        sidebarItems: [SidebarItemConfig(id: "errors", title: "Problems", icon: "exclamationmark.triangle.fill", route: "/errors")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "errors.problems", title: "Problems", icon: "exclamationmark.triangle.fill")],
        inspectorTabs: [InspectorTabConfig(id: "error.diagnostics", title: "Diagnostics", icon: "exclamationmark.triangle.fill", type: "diagnostics", isDefault: true)],
        mainContexts: [MainContextConfig(id: "error.list", title: "Problems", route: "/errors", defaultBottomPanel: "errors.problems")],
        supportedSystems: ["bottomPanel", "list"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - CommandKit
    
    public static let command = KitUIContext(
        id: "command.context", kitId: "CommandKit", displayName: "Commands", icon: "terminal.fill", colorCategory: "command", priority: 82,
        sidebarItems: [SidebarItemConfig(id: "commands", title: "Commands", icon: "terminal.fill", route: "/commands")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "command.terminal", title: "Terminal", icon: "terminal.fill", hasInput: true, placeholder: "Enter command...")],
        inspectorTabs: [InspectorTabConfig(id: "command.help", title: "Help", icon: "questionmark.circle.fill", type: "quickHelp", isDefault: true)],
        mainContexts: [MainContextConfig(id: "command.main", title: "Commands", route: "/commands", defaultBottomPanel: "command.terminal")],
        supportedSystems: ["bottomPanel", "commandPalette"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - DesignKit
    
    public static let design = KitUIContext(
        id: "design.context", kitId: "DesignKit", displayName: "Design", icon: "paintbrush.fill", colorCategory: "design", priority: 70,
        sidebarItems: [SidebarItemConfig(id: "design", title: "Design", icon: "paintbrush.fill", route: "/design", children: [
            SidebarItemConfig(id: "design.components", title: "Components", icon: "square.on.square.fill", route: "/design/components"),
            SidebarItemConfig(id: "design.tokens", title: "Tokens", icon: "paintpalette.fill", route: "/design/tokens")
        ])],
        bottomPanelTabs: [BottomPanelTabConfig(id: "design.preview", title: "Preview", icon: "eye.fill")],
        inspectorTabs: [
            InspectorTabConfig(id: "design.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "design.preview", title: "Preview", icon: "play.rectangle.fill", type: "livePreview"),
            InspectorTabConfig(id: "design.accessibility", title: "Accessibility", icon: "accessibility", type: "accessibility")
        ],
        mainContexts: [MainContextConfig(id: "design.canvas", title: "Canvas", route: "/design", defaultInspector: "design.properties")],
        supportedSystems: ["doubleSidebar", "inspector", "grid"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - AnalyticsKit
    
    public static let analytics = KitUIContext(
        id: "analytics.context", kitId: "AnalyticsKit", displayName: "Analytics", icon: "chart.bar.fill", colorCategory: "analytics", priority: 65,
        sidebarItems: [SidebarItemConfig(id: "analytics", title: "Analytics", icon: "chart.bar.fill", route: "/analytics")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "analytics.output", title: "Analytics", icon: "chart.bar.fill")],
        inspectorTabs: [InspectorTabConfig(id: "analytics.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "analytics.dashboard", title: "Dashboard", route: "/analytics")],
        supportedSystems: ["doubleSidebar", "card", "grid"],
        defaultLayoutTemplate: "dashboard.grid"
    )
    
    // MARK: - AIKit
    
    public static let ai = KitUIContext(
        id: "ai.context", kitId: "AIKit", displayName: "AI", icon: "brain.head.profile", colorCategory: "ai", priority: 88,
        sidebarItems: [SidebarItemConfig(id: "ai", title: "AI", icon: "brain.head.profile", route: "/ai", children: [
            SidebarItemConfig(id: "ai.models", title: "Models", icon: "cpu.fill", route: "/ai/models"),
            SidebarItemConfig(id: "ai.prompts", title: "Prompts", icon: "text.bubble.fill", route: "/ai/prompts")
        ])],
        bottomPanelTabs: [BottomPanelTabConfig(id: "ai.output", title: "AI Output", icon: "brain.head.profile")],
        inspectorTabs: [
            InspectorTabConfig(id: "ai.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "ai.performance", title: "Performance", icon: "gauge.with.dots.needle.bottom.50percent", type: "performance")
        ],
        mainContexts: [MainContextConfig(id: "ai.dashboard", title: "AI", route: "/ai", defaultInspector: "ai.properties")],
        supportedSystems: ["doubleSidebar", "inspector", "bottomPanel"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - LearnKit
    
    public static let learn = KitUIContext(
        id: "learn.context", kitId: "LearnKit", displayName: "Learn", icon: "graduationcap.fill", colorCategory: "learn", priority: 68,
        sidebarItems: [SidebarItemConfig(id: "learn", title: "Learn", icon: "graduationcap.fill", route: "/learn")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "learn.output", title: "Learn", icon: "graduationcap.fill")],
        inspectorTabs: [InspectorTabConfig(id: "learn.preview", title: "Preview", icon: "play.rectangle.fill", type: "livePreview", isDefault: true)],
        mainContexts: [MainContextConfig(id: "learn.viewer", title: "Learning", route: "/learn")],
        supportedSystems: ["doubleSidebar", "outline"],
        defaultLayoutTemplate: "browser.twoColumn"
    )
    
    // MARK: - KnowledgeKit
    
    public static let knowledge = KitUIContext(
        id: "knowledge.context", kitId: "KnowledgeKit", displayName: "Knowledge", icon: "brain.fill", colorCategory: "knowledge", priority: 72,
        sidebarItems: [SidebarItemConfig(id: "knowledge", title: "Knowledge", icon: "brain.fill", route: "/knowledge")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "knowledge.search", title: "Search", icon: "brain.fill", hasInput: true, placeholder: "Search knowledge...")],
        inspectorTabs: [
            InspectorTabConfig(id: "knowledge.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "knowledge.connections", title: "Connections", icon: "point.3.connected.trianglepath.dotted", type: "connections")
        ],
        mainContexts: [MainContextConfig(id: "knowledge.browser", title: "Knowledge", route: "/knowledge", defaultInspector: "knowledge.properties")],
        supportedSystems: ["doubleSidebar", "inspector", "navigation"],
        defaultLayoutTemplate: "browser.threeColumn"
    )

    
    // MARK: - CollaborationKit
    
    public static let collaboration = KitUIContext(
        id: "collaboration.context", kitId: "CollaborationKit", displayName: "Collaboration", icon: "person.2.fill", colorCategory: "collaboration", priority: 74,
        sidebarItems: [SidebarItemConfig(id: "collaboration", title: "Collaboration", icon: "person.2.fill", route: "/collaboration")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "collaboration.activity", title: "Activity", icon: "person.2.fill")],
        inspectorTabs: [InspectorTabConfig(id: "collaboration.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "collaboration.hub", title: "Collaboration", route: "/collaboration")],
        supportedSystems: ["doubleSidebar", "list"],
        defaultLayoutTemplate: "browser.twoColumn"
    )
    
    // MARK: - NotificationKit
    
    public static let notification = KitUIContext(
        id: "notification.context", kitId: "NotificationKit", displayName: "Notifications", icon: "bell.fill", colorCategory: "notification", priority: 92,
        sidebarItems: [SidebarItemConfig(id: "notifications", title: "Notifications", icon: "bell.fill", route: "/notifications")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "notifications.feed", title: "Notifications", icon: "bell.fill")],
        inspectorTabs: [InspectorTabConfig(id: "notification.properties", title: "Details", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "notification.center", title: "Notifications", route: "/notifications")],
        supportedSystems: ["toast", "banner", "list"],
        defaultLayoutTemplate: "browser.single"
    )
    
    // MARK: - NavigationKit
    
    public static let navigation = KitUIContext(
        id: "navigation.context", kitId: "NavigationKit", displayName: "Navigation", icon: "arrow.triangle.turn.up.right.diamond.fill", colorCategory: "navigation", priority: 98,
        sidebarItems: [SidebarItemConfig(id: "navigation", title: "Navigation", icon: "arrow.triangle.turn.up.right.diamond.fill", route: "/navigation")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "navigation.quickNav", title: "Quick Nav", icon: "arrow.triangle.turn.up.right.diamond.fill", hasInput: true, placeholder: "Go to...")],
        inspectorTabs: [InspectorTabConfig(id: "navigation.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "navigation.main", title: "Navigation", route: "/navigation")],
        supportedSystems: ["breadcrumb", "pathBar", "navigation"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - FeedbackKit
    
    public static let feedback = KitUIContext(
        id: "feedback.context", kitId: "FeedbackKit", displayName: "Feedback", icon: "bubble.left.and.exclamationmark.bubble.right.fill", colorCategory: "feedback", priority: 58,
        sidebarItems: [SidebarItemConfig(id: "feedback", title: "Feedback", icon: "bubble.left.and.exclamationmark.bubble.right.fill", route: "/feedback")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "feedback.input", title: "Feedback", icon: "bubble.left.and.exclamationmark.bubble.right.fill", hasInput: true, placeholder: "Share feedback...")],
        inspectorTabs: [InspectorTabConfig(id: "feedback.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "feedback.main", title: "Feedback", route: "/feedback", defaultBottomPanel: "feedback.input")],
        supportedSystems: ["bottomPanel", "modal"],
        defaultLayoutTemplate: "browser.single"
    )
    
    // MARK: - ExportKit
    
    public static let export = KitUIContext(
        id: "export.context", kitId: "ExportKit", displayName: "Export", icon: "square.and.arrow.up.fill", colorCategory: "export", priority: 45,
        sidebarItems: [SidebarItemConfig(id: "export", title: "Export", icon: "square.and.arrow.up.fill", route: "/export")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "export.output", title: "Export", icon: "square.and.arrow.up.fill")],
        inspectorTabs: [InspectorTabConfig(id: "export.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "export.main", title: "Export", route: "/export")],
        supportedSystems: ["modal", "inspector"],
        defaultLayoutTemplate: "browser.single"
    )
    
    // MARK: - UserKit
    
    public static let user = KitUIContext(
        id: "user.context", kitId: "UserKit", displayName: "User", icon: "person.fill", colorCategory: "user", priority: 50,
        sidebarItems: [SidebarItemConfig(id: "user", title: "User", icon: "person.fill", route: "/user")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "user.activity", title: "Activity", icon: "person.fill")],
        inspectorTabs: [InspectorTabConfig(id: "user.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "user.profile", title: "Profile", route: "/user")],
        supportedSystems: ["inspector", "card"],
        defaultLayoutTemplate: "browser.single"
    )
    
    // MARK: - IndexerKit
    
    public static let indexer = KitUIContext(
        id: "indexer.context", kitId: "IndexerKit", displayName: "Indexer", icon: "list.bullet.rectangle.fill", colorCategory: "indexer", priority: 55,
        sidebarItems: [SidebarItemConfig(id: "indexer", title: "Indexer", icon: "list.bullet.rectangle.fill", route: "/indexer")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "indexer.output", title: "Indexer", icon: "list.bullet.rectangle.fill")],
        inspectorTabs: [InspectorTabConfig(id: "indexer.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "indexer.dashboard", title: "Indexer", route: "/indexer")],
        supportedSystems: ["bottomPanel", "list"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - NLUKit
    
    public static let nlu = KitUIContext(
        id: "nlu.context", kitId: "NLUKit", displayName: "NLU", icon: "text.word.spacing", colorCategory: "nlu", priority: 62,
        sidebarItems: [SidebarItemConfig(id: "nlu", title: "NLU", icon: "text.word.spacing", route: "/nlu")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "nlu.test", title: "Test", icon: "text.word.spacing", hasInput: true, placeholder: "Test utterance...")],
        inspectorTabs: [InspectorTabConfig(id: "nlu.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "nlu.dashboard", title: "NLU", route: "/nlu", defaultBottomPanel: "nlu.test")],
        supportedSystems: ["bottomPanel", "inspector"],
        defaultLayoutTemplate: "ide.classic"
    )

    
    // MARK: - ActivityKit
    
    public static let activity = KitUIContext(
        id: "activity.context", kitId: "ActivityKit", displayName: "Activity", icon: "waveform.path.ecg", colorCategory: "activity", priority: 60,
        sidebarItems: [SidebarItemConfig(id: "activity", title: "Activity", icon: "waveform.path.ecg", route: "/activity")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "activity.log", title: "Activity", icon: "waveform.path.ecg")],
        inspectorTabs: [InspectorTabConfig(id: "activity.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "activity.dashboard", title: "Activity", route: "/activity")],
        supportedSystems: ["list", "card"],
        defaultLayoutTemplate: "dashboard.list"
    )
    
    // MARK: - AppIdeaKit
    
    public static let appIdea = KitUIContext(
        id: "appIdea.context", kitId: "AppIdeaKit", displayName: "App Ideas", icon: "lightbulb.fill", colorCategory: "idea", priority: 55,
        sidebarItems: [SidebarItemConfig(id: "appIdea", title: "App Ideas", icon: "lightbulb.fill", route: "/app-ideas")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "appIdea.input", title: "Ideas", icon: "lightbulb.fill", hasInput: true, placeholder: "Describe your idea...")],
        inspectorTabs: [InspectorTabConfig(id: "appIdea.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "appIdea.canvas", title: "Ideas", route: "/app-ideas", defaultBottomPanel: "appIdea.input")],
        supportedSystems: ["card", "grid"],
        defaultLayoutTemplate: "dashboard.cards"
    )
    
    // MARK: - AssetKit
    
    public static let asset = KitUIContext(
        id: "asset.context", kitId: "AssetKit", displayName: "Assets", icon: "photo.on.rectangle.angled", colorCategory: "asset", priority: 50,
        sidebarItems: [SidebarItemConfig(id: "assets", title: "Assets", icon: "photo.on.rectangle.angled", route: "/assets")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "assets.browser", title: "Assets", icon: "photo.on.rectangle.angled")],
        inspectorTabs: [
            InspectorTabConfig(id: "asset.inspector", title: "Inspector", icon: "doc.text.fill", type: "fileInspector", isDefault: true),
            InspectorTabConfig(id: "asset.preview", title: "Preview", icon: "eye.fill", type: "filePreview")
        ],
        mainContexts: [MainContextConfig(id: "asset.browser", title: "Assets", route: "/assets", defaultInspector: "asset.inspector")],
        supportedSystems: ["grid", "inspector"],
        defaultLayoutTemplate: "browser.threeColumn"
    )
    
    // MARK: - BridgeKit
    
    public static let bridge = KitUIContext(
        id: "bridge.context", kitId: "BridgeKit", displayName: "Bridge", icon: "arrow.left.arrow.right", colorCategory: "bridge", priority: 45,
        sidebarItems: [SidebarItemConfig(id: "bridge", title: "Bridge", icon: "arrow.left.arrow.right", route: "/bridge")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "bridge.console", title: "Bridge", icon: "arrow.left.arrow.right")],
        inspectorTabs: [InspectorTabConfig(id: "bridge.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "bridge.dashboard", title: "Bridge", route: "/bridge")],
        supportedSystems: ["list", "inspector"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - CoreKit
    
    public static let core = KitUIContext(
        id: "core.context", kitId: "CoreKit", displayName: "Core", icon: "cube.fill", colorCategory: "core", priority: 95,
        sidebarItems: [SidebarItemConfig(id: "core", title: "Core", icon: "cube.fill", route: "/core")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "core.inspector", title: "Core", icon: "cube.fill")],
        inspectorTabs: [
            InspectorTabConfig(id: "core.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "core.connections", title: "Connections", icon: "point.3.connected.trianglepath.dotted", type: "connections")
        ],
        mainContexts: [MainContextConfig(id: "core.editor", title: "Core", route: "/core", defaultInspector: "core.properties")],
        supportedSystems: ["doubleSidebar", "inspector"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - IconKit
    
    public static let icon = KitUIContext(
        id: "icon.context", kitId: "IconKit", displayName: "Icons", icon: "star.square.fill", colorCategory: "design", priority: 48,
        sidebarItems: [SidebarItemConfig(id: "icons", title: "Icons", icon: "star.square.fill", route: "/icons")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "icons.preview", title: "Icons", icon: "star.square.fill")],
        inspectorTabs: [
            InspectorTabConfig(id: "icon.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "icon.preview", title: "Preview", icon: "eye.fill", type: "livePreview")
        ],
        mainContexts: [MainContextConfig(id: "icon.browser", title: "Icons", route: "/icons", defaultInspector: "icon.properties")],
        supportedSystems: ["grid", "inspector"],
        defaultLayoutTemplate: "browser.threeColumn"
    )
    
    // MARK: - IdeaKit
    
    public static let idea = KitUIContext(
        id: "idea.context", kitId: "IdeaKit", displayName: "Ideas", icon: "sparkles", colorCategory: "idea", priority: 52,
        sidebarItems: [SidebarItemConfig(id: "ideas", title: "Ideas", icon: "sparkles", route: "/ideas")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "ideas.quick", title: "Ideas", icon: "sparkles", hasInput: true, placeholder: "Quick idea...")],
        inspectorTabs: [InspectorTabConfig(id: "idea.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "idea.board", title: "Ideas", route: "/ideas", defaultBottomPanel: "ideas.quick")],
        supportedSystems: ["card", "grid"],
        defaultLayoutTemplate: "dashboard.cards"
    )
    
    // MARK: - MarketplaceKit
    
    public static let marketplace = KitUIContext(
        id: "marketplace.context", kitId: "MarketplaceKit", displayName: "Marketplace", icon: "storefront.fill", colorCategory: "marketplace", priority: 40,
        sidebarItems: [SidebarItemConfig(id: "marketplace", title: "Marketplace", icon: "storefront.fill", route: "/marketplace")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "marketplace.search", title: "Marketplace", icon: "storefront.fill", hasInput: true, placeholder: "Search...")],
        inspectorTabs: [InspectorTabConfig(id: "marketplace.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "marketplace.browser", title: "Marketplace", route: "/marketplace", defaultBottomPanel: "marketplace.search")],
        supportedSystems: ["grid", "card", "inspector"],
        defaultLayoutTemplate: "browser.threeColumn"
    )

    
    // MARK: - NetworkKit
    
    public static let network = KitUIContext(
        id: "network.context", kitId: "NetworkKit", displayName: "Network", icon: "network", colorCategory: "network", priority: 42,
        sidebarItems: [SidebarItemConfig(id: "network", title: "Network", icon: "network", route: "/network")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "network.inspector", title: "Network", icon: "network")],
        inspectorTabs: [
            InspectorTabConfig(id: "network.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "network.preview", title: "Response", icon: "eye.fill", type: "filePreview")
        ],
        mainContexts: [MainContextConfig(id: "network.dashboard", title: "Network", route: "/network", defaultInspector: "network.properties")],
        supportedSystems: ["list", "inspector", "bottomPanel"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - ParseKit
    
    public static let parse = KitUIContext(
        id: "parse.context", kitId: "ParseKit", displayName: "Parser", icon: "doc.text.magnifyingglass", colorCategory: "parse", priority: 38,
        sidebarItems: [SidebarItemConfig(id: "parse", title: "Parser", icon: "doc.text.magnifyingglass", route: "/parse")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "parse.output", title: "Parser", icon: "doc.text.magnifyingglass")],
        inspectorTabs: [
            InspectorTabConfig(id: "parse.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "parse.preview", title: "AST", icon: "play.rectangle.fill", type: "livePreview")
        ],
        mainContexts: [MainContextConfig(id: "parse.viewer", title: "Parser", route: "/parse", defaultInspector: "parse.properties")],
        supportedSystems: ["outline", "inspector"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - SyntaxKit
    
    public static let syntax = KitUIContext(
        id: "syntax.context", kitId: "SyntaxKit", displayName: "Syntax", icon: "chevron.left.forwardslash.chevron.right", colorCategory: "syntax", priority: 36,
        sidebarItems: [SidebarItemConfig(id: "syntax", title: "Syntax", icon: "chevron.left.forwardslash.chevron.right", route: "/syntax")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "syntax.inspector", title: "Syntax", icon: "chevron.left.forwardslash.chevron.right")],
        inspectorTabs: [InspectorTabConfig(id: "syntax.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true)],
        mainContexts: [MainContextConfig(id: "syntax.editor", title: "Syntax", route: "/syntax")],
        supportedSystems: ["inspector"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - SystemKit
    
    public static let system = KitUIContext(
        id: "system.context", kitId: "SystemKit", displayName: "System", icon: "gearshape.fill", colorCategory: "system", priority: 30,
        sidebarItems: [SidebarItemConfig(id: "system", title: "System", icon: "gearshape.fill", route: "/system")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "system.monitor", title: "System", icon: "gearshape.fill")],
        inspectorTabs: [
            InspectorTabConfig(id: "system.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "system.performance", title: "Performance", icon: "gauge.with.dots.needle.bottom.50percent", type: "performance")
        ],
        mainContexts: [MainContextConfig(id: "system.dashboard", title: "System", route: "/system", defaultInspector: "system.properties")],
        supportedSystems: ["inspector", "list"],
        defaultLayoutTemplate: "browser.twoColumn"
    )
    
    // MARK: - WebKit
    
    public static let web = KitUIContext(
        id: "web.context", kitId: "WebKit", displayName: "Web", icon: "globe", colorCategory: "web", priority: 35,
        sidebarItems: [SidebarItemConfig(id: "web", title: "Web", icon: "globe", route: "/web")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "web.console", title: "Console", icon: "globe", hasInput: true, placeholder: "JavaScript...")],
        inspectorTabs: [
            InspectorTabConfig(id: "web.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "web.preview", title: "Preview", icon: "play.rectangle.fill", type: "livePreview")
        ],
        mainContexts: [MainContextConfig(id: "web.browser", title: "Web", route: "/web", defaultInspector: "web.properties", defaultBottomPanel: "web.console")],
        supportedSystems: ["inspector", "bottomPanel"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - ContentHub
    
    public static let contentHub = KitUIContext(
        id: "contentHub.context", kitId: "ContentHub", displayName: "Content Hub", icon: "square.stack.3d.up.fill", colorCategory: "content", priority: 58,
        sidebarItems: [SidebarItemConfig(id: "contentHub", title: "Content", icon: "square.stack.3d.up.fill", route: "/content-hub")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "contentHub.browser", title: "Content", icon: "square.stack.3d.up.fill")],
        inspectorTabs: [
            InspectorTabConfig(id: "contentHub.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "contentHub.preview", title: "Preview", icon: "eye.fill", type: "filePreview")
        ],
        mainContexts: [MainContextConfig(id: "contentHub.browser", title: "Content", route: "/content-hub", defaultInspector: "contentHub.properties")],
        supportedSystems: ["grid", "list", "inspector"],
        defaultLayoutTemplate: "browser.threeColumn"
    )
    
    // MARK: - KitOrchestrator
    
    public static let orchestrator = KitUIContext(
        id: "orchestrator.context", kitId: "KitOrchestrator", displayName: "Orchestrator", icon: "wand.and.stars", colorCategory: "orchestrator", priority: 90,
        sidebarItems: [SidebarItemConfig(id: "orchestrator", title: "Orchestrator", icon: "wand.and.stars", route: "/orchestrator")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "orchestrator.console", title: "Orchestrator", icon: "wand.and.stars")],
        inspectorTabs: [
            InspectorTabConfig(id: "orchestrator.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "orchestrator.connections", title: "Connections", icon: "point.3.connected.trianglepath.dotted", type: "connections")
        ],
        mainContexts: [MainContextConfig(id: "orchestrator.dashboard", title: "Orchestrator", route: "/orchestrator", defaultInspector: "orchestrator.properties")],
        supportedSystems: ["doubleSidebar", "inspector", "card"],
        defaultLayoutTemplate: "ide.classic"
    )
    
    // MARK: - ProjectScaffold
    
    public static let scaffold = KitUIContext(
        id: "scaffold.context", kitId: "ProjectScaffold", displayName: "Scaffold", icon: "hammer.fill", colorCategory: "scaffold", priority: 65,
        sidebarItems: [SidebarItemConfig(id: "scaffold", title: "Scaffold", icon: "hammer.fill", route: "/scaffold")],
        bottomPanelTabs: [BottomPanelTabConfig(id: "scaffold.wizard", title: "Scaffold", icon: "hammer.fill")],
        inspectorTabs: [
            InspectorTabConfig(id: "scaffold.properties", title: "Properties", icon: "slider.horizontal.3", type: "properties", isDefault: true),
            InspectorTabConfig(id: "scaffold.preview", title: "Preview", icon: "play.rectangle.fill", type: "livePreview")
        ],
        mainContexts: [MainContextConfig(id: "scaffold.wizard", title: "Scaffold", route: "/scaffold", defaultInspector: "scaffold.properties")],
        supportedSystems: ["modal", "inspector", "fileTree"],
        defaultLayoutTemplate: "browser.twoColumn"
    )
}
