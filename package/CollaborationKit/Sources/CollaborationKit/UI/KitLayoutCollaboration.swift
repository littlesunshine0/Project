//
//  KitLayoutCollaboration.swift
//  CollaborationKit
//
//  Complete layout configuration for CollaborationKit
//

import Foundation
import DataKit

public struct KitLayoutCollaboration {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "collaboration",
            title: "Collaboration",
            icon: "person.2.fill",
            colorCategory: "collaboration",
            route: "/collaboration",
            priority: 74,
            providedBy: "CollaborationKit",
            children: [
                SidebarItemDefinition(id: "collaboration.team", title: "Team", icon: "person.3.fill", colorCategory: "collaboration", route: "/collaboration/team", priority: 90, providedBy: "CollaborationKit"),
                SidebarItemDefinition(id: "collaboration.shared", title: "Shared", icon: "folder.badge.person.crop", colorCategory: "collaboration", route: "/collaboration/shared", priority: 80, providedBy: "CollaborationKit"),
                SidebarItemDefinition(id: "collaboration.activity", title: "Activity", icon: "waveform.path.ecg", colorCategory: "collaboration", route: "/collaboration/activity", priority: 70, providedBy: "CollaborationKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "collaboration.activity", title: "Team Activity", icon: "person.2.fill", colorCategory: "collaboration", hasInput: false, priority: 56, providedBy: "CollaborationKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "collaboration.properties", type: .properties, title: "Collaboration Properties", colorCategory: "collaboration", priority: 90, providedBy: "CollaborationKit", isDefault: true),
        InspectorDefinition(id: "collaboration.history", type: .historyInspector, title: "Activity History", colorCategory: "collaboration", priority: 85, providedBy: "CollaborationKit"),
        InspectorDefinition(id: "collaboration.connections", type: .connections, title: "Team Members", colorCategory: "collaboration", priority: 80, providedBy: "CollaborationKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "collaboration.inspectorPanel", title: "Collaboration Inspector", icon: "person.2.fill", colorCategory: "collaboration", priority: 82, providedBy: "CollaborationKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "collaboration.presencePanel", title: "Presence", icon: "circle.fill", colorCategory: "success", priority: 72, providedBy: "CollaborationKit", defaultPosition: .bottom)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "collaboration.hub", title: "Collaboration Hub", icon: "person.2.fill", colorCategory: "collaboration", route: "/collaboration", providedBy: "CollaborationKit", supportedInspectors: [.properties, .historyInspector, .connections], defaultRightSidebar: "collaboration.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "collaborationkit.layout", kitName: "CollaborationKit", displayName: "Collaboration", icon: "person.2.fill", colorCategory: "collaboration",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
