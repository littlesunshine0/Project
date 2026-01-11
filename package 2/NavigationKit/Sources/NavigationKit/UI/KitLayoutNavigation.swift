//
//  KitLayoutNavigation.swift
//  NavigationKit
//
//  Complete layout configuration for NavigationKit
//

import Foundation
import DataKit

public struct KitLayoutNavigation {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "navigation",
            title: "Navigation",
            icon: "arrow.triangle.turn.up.right.diamond.fill",
            colorCategory: "navigation",
            route: "/navigation",
            priority: 98,
            providedBy: "NavigationKit",
            children: [
                SidebarItemDefinition(id: "navigation.breadcrumbs", title: "Breadcrumbs", icon: "chevron.right", colorCategory: "navigation", route: "/navigation/breadcrumbs", priority: 90, providedBy: "NavigationKit"),
                SidebarItemDefinition(id: "navigation.tabs", title: "Tabs", icon: "rectangle.stack.fill", colorCategory: "navigation", route: "/navigation/tabs", priority: 80, providedBy: "NavigationKit"),
                SidebarItemDefinition(id: "navigation.history", title: "History", icon: "clock.arrow.circlepath", colorCategory: "navigation", route: "/navigation/history", priority: 70, providedBy: "NavigationKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "navigation.quickNav", title: "Quick Nav", icon: "arrow.triangle.turn.up.right.diamond.fill", colorCategory: "navigation", hasInput: true, placeholder: "Go to...", priority: 92, providedBy: "NavigationKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "navigation.properties", type: .properties, title: "Route Properties", colorCategory: "navigation", priority: 90, providedBy: "NavigationKit", isDefault: true),
        InspectorDefinition(id: "navigation.history", type: .historyInspector, title: "Navigation History", colorCategory: "navigation", priority: 85, providedBy: "NavigationKit"),
        InspectorDefinition(id: "navigation.connections", type: .connections, title: "Route Map", colorCategory: "navigation", priority: 80, providedBy: "NavigationKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "navigation.inspectorPanel", title: "Navigation Inspector", icon: "arrow.triangle.turn.up.right.diamond.fill", colorCategory: "navigation", priority: 90, providedBy: "NavigationKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "navigation.main", title: "Navigation", icon: "arrow.triangle.turn.up.right.diamond.fill", colorCategory: "navigation", route: "/navigation", providedBy: "NavigationKit", supportedInspectors: [.properties, .historyInspector, .connections], defaultRightSidebar: "navigation.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "navigationkit.layout", kitName: "NavigationKit", displayName: "Navigation", icon: "arrow.triangle.turn.up.right.diamond.fill", colorCategory: "navigation",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
