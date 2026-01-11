//
//  KitLayoutAppIdea.swift
//  AppIdeaKit
//
//  Complete layout configuration for AppIdeaKit
//

import Foundation
import DataKit

public struct KitLayoutAppIdea {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "appIdea",
            title: "App Ideas",
            icon: "lightbulb.fill",
            colorCategory: "idea",
            route: "/app-ideas",
            priority: 55,
            providedBy: "AppIdeaKit",
            children: [
                SidebarItemDefinition(id: "appIdea.brainstorm", title: "Brainstorm", icon: "brain.head.profile", colorCategory: "idea", route: "/app-ideas/brainstorm", priority: 90, providedBy: "AppIdeaKit"),
                SidebarItemDefinition(id: "appIdea.saved", title: "Saved Ideas", icon: "bookmark.fill", colorCategory: "idea", route: "/app-ideas/saved", priority: 80, providedBy: "AppIdeaKit"),
                SidebarItemDefinition(id: "appIdea.templates", title: "Templates", icon: "doc.on.doc.fill", colorCategory: "info", route: "/app-ideas/templates", priority: 70, providedBy: "AppIdeaKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "appIdea.input", title: "Ideas", icon: "lightbulb.fill", colorCategory: "idea", hasInput: true, placeholder: "Describe your app idea...", priority: 35, providedBy: "AppIdeaKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "appIdea.properties", type: .properties, title: "Idea Properties", colorCategory: "idea", priority: 90, providedBy: "AppIdeaKit", isDefault: true),
        InspectorDefinition(id: "appIdea.livePreview", type: .livePreview, title: "Concept Preview", colorCategory: "idea", priority: 85, providedBy: "AppIdeaKit"),
        InspectorDefinition(id: "appIdea.connections", type: .connections, title: "Related Ideas", colorCategory: "idea", priority: 80, providedBy: "AppIdeaKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "appIdea.inspectorPanel", title: "Idea Inspector", icon: "lightbulb.fill", colorCategory: "idea", priority: 72, providedBy: "AppIdeaKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "appIdea.canvas", title: "Idea Canvas", icon: "lightbulb.fill", colorCategory: "idea", route: "/app-ideas", providedBy: "AppIdeaKit", supportedInspectors: [.properties, .livePreview, .connections], defaultRightSidebar: "appIdea.inspectorPanel", defaultBottomPanel: "appIdea.input")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "appideakit.layout", kitName: "AppIdeaKit", displayName: "App Ideas", icon: "lightbulb.fill", colorCategory: "idea",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
