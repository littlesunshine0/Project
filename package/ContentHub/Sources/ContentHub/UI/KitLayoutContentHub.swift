//
//  KitLayoutContentHub.swift
//  ContentHub
//
//  Complete layout configuration for ContentHub
//

import Foundation
import DataKit

public struct KitLayoutContentHub {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "contentHub",
            title: "Content Hub",
            icon: "square.stack.3d.up.fill",
            colorCategory: "content",
            route: "/content-hub",
            priority: 58,
            providedBy: "ContentHub",
            children: [
                SidebarItemDefinition(id: "contentHub.all", title: "All Content", icon: "doc.fill", colorCategory: "content", route: "/content-hub/all", priority: 90, providedBy: "ContentHub"),
                SidebarItemDefinition(id: "contentHub.recent", title: "Recent", icon: "clock.fill", colorCategory: "content", route: "/content-hub/recent", priority: 80, providedBy: "ContentHub"),
                SidebarItemDefinition(id: "contentHub.favorites", title: "Favorites", icon: "star.fill", colorCategory: "info", route: "/content-hub/favorites", priority: 70, providedBy: "ContentHub")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "contentHub.browser", title: "Content", icon: "square.stack.3d.up.fill", colorCategory: "content", hasInput: false, priority: 38, providedBy: "ContentHub")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "contentHub.properties", type: .properties, title: "Content Properties", colorCategory: "content", priority: 90, providedBy: "ContentHub", isDefault: true),
        InspectorDefinition(id: "contentHub.preview", type: .filePreview, title: "Content Preview", colorCategory: "content", priority: 85, providedBy: "ContentHub"),
        InspectorDefinition(id: "contentHub.metadata", type: .metadataPreview, title: "Metadata", colorCategory: "content", priority: 80, providedBy: "ContentHub"),
        InspectorDefinition(id: "contentHub.history", type: .historyInspector, title: "History", colorCategory: "content", priority: 75, providedBy: "ContentHub")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "contentHub.inspectorPanel", title: "Content Inspector", icon: "square.stack.3d.up.fill", colorCategory: "content", priority: 74, providedBy: "ContentHub", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "contentHub.browser", title: "Content Browser", icon: "square.stack.3d.up.fill", colorCategory: "content", route: "/content-hub", providedBy: "ContentHub", supportedInspectors: [.properties, .filePreview, .metadataPreview, .historyInspector], defaultRightSidebar: "contentHub.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "contenthub.layout", kitName: "ContentHub", displayName: "Content Hub", icon: "square.stack.3d.up.fill", colorCategory: "content",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
