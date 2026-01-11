//
//  KitLayoutAI.swift
//  AIKit
//
//  Complete layout configuration for AIKit
//

import Foundation
import DataKit

public struct KitLayoutAI {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "ai",
            title: "AI",
            icon: "brain.head.profile",
            colorCategory: "ai",
            route: "/ai",
            priority: 88,
            providedBy: "AIKit",
            children: [
                SidebarItemDefinition(id: "ai.models", title: "Models", icon: "cpu.fill", colorCategory: "ai", route: "/ai/models", priority: 90, providedBy: "AIKit"),
                SidebarItemDefinition(id: "ai.prompts", title: "Prompts", icon: "text.bubble.fill", colorCategory: "ai", route: "/ai/prompts", priority: 80, providedBy: "AIKit"),
                SidebarItemDefinition(id: "ai.training", title: "Training", icon: "chart.line.uptrend.xyaxis", colorCategory: "ai", route: "/ai/training", priority: 70, providedBy: "AIKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "ai.output", title: "AI Output", icon: "brain.head.profile", colorCategory: "ai", hasInput: false, priority: 80, providedBy: "AIKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "ai.properties", type: .properties, title: "Model Properties", colorCategory: "ai", priority: 90, providedBy: "AIKit", isDefault: true),
        InspectorDefinition(id: "ai.performance", type: .performance, title: "Performance", colorCategory: "ai", priority: 85, providedBy: "AIKit"),
        InspectorDefinition(id: "ai.debug", type: .debug, title: "Debug", colorCategory: "ai", priority: 80, providedBy: "AIKit"),
        InspectorDefinition(id: "ai.metadata", type: .metadataPreview, title: "Model Info", colorCategory: "ai", priority: 75, providedBy: "AIKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "ai.inspectorPanel", title: "AI Inspector", icon: "brain.head.profile", colorCategory: "ai", priority: 92, providedBy: "AIKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "ai.contextPanel", title: "Context", icon: "doc.text.fill", colorCategory: "ai", priority: 82, providedBy: "AIKit", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "ai.dashboard", title: "AI Dashboard", icon: "brain.head.profile", colorCategory: "ai", route: "/ai", providedBy: "AIKit", supportedInspectors: [.properties, .performance, .debug, .metadataPreview], defaultRightSidebar: "ai.inspectorPanel", defaultBottomPanel: "ai.output")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "aikit.layout", kitName: "AIKit", displayName: "AI", icon: "brain.head.profile", colorCategory: "ai",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
