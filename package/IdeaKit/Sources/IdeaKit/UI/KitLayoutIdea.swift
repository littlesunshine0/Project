//
//  KitLayoutIdea.swift
//  IdeaKit
//
//  Complete layout configuration for IdeaKit
//

import Foundation
import DataKit

public struct KitLayoutIdea {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "ideas",
            title: "Ideas",
            icon: "sparkles",
            colorCategory: "idea",
            route: "/ideas",
            priority: 52,
            providedBy: "IdeaKit",
            children: [
                SidebarItemDefinition(id: "ideas.capture", title: "Capture", icon: "plus.circle.fill", colorCategory: "idea", route: "/ideas/capture", priority: 90, providedBy: "IdeaKit"),
                SidebarItemDefinition(id: "ideas.organize", title: "Organize", icon: "folder.fill", colorCategory: "idea", route: "/ideas/organize", priority: 80, providedBy: "IdeaKit"),
                SidebarItemDefinition(id: "ideas.develop", title: "Develop", icon: "hammer.fill", colorCategory: "info", route: "/ideas/develop", priority: 70, providedBy: "IdeaKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "ideas.quick", title: "Ideas", icon: "sparkles", colorCategory: "idea", hasInput: true, placeholder: "Quick idea...", priority: 32, providedBy: "IdeaKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "idea.properties", type: .properties, title: "Idea Properties", colorCategory: "idea", priority: 90, providedBy: "IdeaKit", isDefault: true),
        InspectorDefinition(id: "idea.connections", type: .connections, title: "Related Ideas", colorCategory: "idea", priority: 85, providedBy: "IdeaKit"),
        InspectorDefinition(id: "idea.history", type: .historyInspector, title: "Idea History", colorCategory: "idea", priority: 80, providedBy: "IdeaKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "idea.inspectorPanel", title: "Idea Inspector", icon: "sparkles", colorCategory: "idea", priority: 70, providedBy: "IdeaKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "idea.board", title: "Idea Board", icon: "sparkles", colorCategory: "idea", route: "/ideas", providedBy: "IdeaKit", supportedInspectors: [.properties, .connections, .historyInspector], defaultRightSidebar: "idea.inspectorPanel", defaultBottomPanel: "ideas.quick")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "ideakit.layout", kitName: "IdeaKit", displayName: "Ideas", icon: "sparkles", colorCategory: "idea",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
