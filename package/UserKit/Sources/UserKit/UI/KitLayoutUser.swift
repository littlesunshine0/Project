//
//  KitLayoutUser.swift
//  UserKit
//
//  Complete layout configuration for UserKit
//

import Foundation
import DataKit

public struct KitLayoutUser {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "user",
            title: "User",
            icon: "person.fill",
            colorCategory: "user",
            route: "/user",
            priority: 50,
            providedBy: "UserKit",
            children: [
                SidebarItemDefinition(id: "user.profile", title: "Profile", icon: "person.circle.fill", colorCategory: "user", route: "/user/profile", priority: 90, providedBy: "UserKit"),
                SidebarItemDefinition(id: "user.settings", title: "Settings", icon: "gearshape.fill", colorCategory: "user", route: "/user/settings", priority: 80, providedBy: "UserKit"),
                SidebarItemDefinition(id: "user.preferences", title: "Preferences", icon: "slider.horizontal.3", colorCategory: "user", route: "/user/preferences", priority: 70, providedBy: "UserKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "user.activity", title: "User Activity", icon: "person.fill", colorCategory: "user", hasInput: false, priority: 30, providedBy: "UserKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "user.properties", type: .properties, title: "User Properties", colorCategory: "user", priority: 90, providedBy: "UserKit", isDefault: true),
        InspectorDefinition(id: "user.history", type: .historyInspector, title: "Activity History", colorCategory: "user", priority: 80, providedBy: "UserKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "user.inspectorPanel", title: "User Inspector", icon: "person.fill", colorCategory: "user", priority: 65, providedBy: "UserKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "user.profile", title: "User Profile", icon: "person.fill", colorCategory: "user", route: "/user", providedBy: "UserKit", supportedInspectors: [.properties, .historyInspector], defaultRightSidebar: "user.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "userkit.layout", kitName: "UserKit", displayName: "User", icon: "person.fill", colorCategory: "user",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
