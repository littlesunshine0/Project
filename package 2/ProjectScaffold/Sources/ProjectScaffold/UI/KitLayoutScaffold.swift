//
//  KitLayoutScaffold.swift
//  ProjectScaffold
//
//  Complete layout configuration for ProjectScaffold
//

import Foundation
import DataKit

public struct KitLayoutScaffold {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "scaffold",
            title: "Scaffold",
            icon: "hammer.fill",
            colorCategory: "scaffold",
            route: "/scaffold",
            priority: 65,
            providedBy: "ProjectScaffold",
            children: [
                SidebarItemDefinition(id: "scaffold.new", title: "New Project", icon: "plus.circle.fill", colorCategory: "scaffold", route: "/scaffold/new", priority: 90, providedBy: "ProjectScaffold"),
                SidebarItemDefinition(id: "scaffold.templates", title: "Templates", icon: "doc.on.doc.fill", colorCategory: "scaffold", route: "/scaffold/templates", priority: 80, providedBy: "ProjectScaffold"),
                SidebarItemDefinition(id: "scaffold.recent", title: "Recent", icon: "clock.fill", colorCategory: "info", route: "/scaffold/recent", priority: 70, providedBy: "ProjectScaffold")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "scaffold.wizard", title: "Scaffold", icon: "hammer.fill", colorCategory: "scaffold", hasInput: false, priority: 42, providedBy: "ProjectScaffold")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "scaffold.properties", type: .properties, title: "Project Properties", colorCategory: "scaffold", priority: 90, providedBy: "ProjectScaffold", isDefault: true),
        InspectorDefinition(id: "scaffold.livePreview", type: .livePreview, title: "Structure Preview", colorCategory: "scaffold", priority: 85, providedBy: "ProjectScaffold"),
        InspectorDefinition(id: "scaffold.quickHelp", type: .quickHelp, title: "Template Help", colorCategory: "scaffold", priority: 80, providedBy: "ProjectScaffold")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "scaffold.inspectorPanel", title: "Scaffold Inspector", icon: "hammer.fill", colorCategory: "scaffold", priority: 78, providedBy: "ProjectScaffold", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "scaffold.structurePanel", title: "Structure", icon: "folder.fill", colorCategory: "scaffold", priority: 68, providedBy: "ProjectScaffold", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "scaffold.wizard", title: "Project Wizard", icon: "hammer.fill", colorCategory: "scaffold", route: "/scaffold", providedBy: "ProjectScaffold", supportedInspectors: [.properties, .livePreview, .quickHelp], defaultRightSidebar: "scaffold.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "projectscaffold.layout", kitName: "ProjectScaffold", displayName: "Scaffold", icon: "hammer.fill", colorCategory: "scaffold",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
