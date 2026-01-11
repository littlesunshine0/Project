//
//  KitLayoutCore.swift
//  CoreKit
//
//  Complete layout configuration for CoreKit
//

import Foundation
import DataKit

public struct KitLayoutCore {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "core",
            title: "Core",
            icon: "cube.fill",
            colorCategory: "core",
            route: "/core",
            priority: 95,
            providedBy: "CoreKit",
            children: [
                SidebarItemDefinition(id: "core.nodes", title: "Nodes", icon: "circle.grid.3x3.fill", colorCategory: "core", route: "/core/nodes", priority: 90, providedBy: "CoreKit"),
                SidebarItemDefinition(id: "core.graph", title: "Graph", icon: "point.3.connected.trianglepath.dotted", colorCategory: "core", route: "/core/graph", priority: 80, providedBy: "CoreKit"),
                SidebarItemDefinition(id: "core.crud", title: "CRUD", icon: "square.stack.3d.up.fill", colorCategory: "info", route: "/core/crud", priority: 70, providedBy: "CoreKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "core.inspector", title: "Core", icon: "cube.fill", colorCategory: "core", hasInput: false, priority: 50, providedBy: "CoreKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "core.properties", type: .properties, title: "Core Properties", colorCategory: "core", priority: 95, providedBy: "CoreKit", isDefault: true),
        InspectorDefinition(id: "core.connections", type: .connections, title: "Node Connections", colorCategory: "core", priority: 90, providedBy: "CoreKit"),
        InspectorDefinition(id: "core.debug", type: .debug, title: "Debug", colorCategory: "core", priority: 85, providedBy: "CoreKit"),
        InspectorDefinition(id: "core.metadata", type: .metadataPreview, title: "Node Info", colorCategory: "core", priority: 80, providedBy: "CoreKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "core.inspectorPanel", title: "Core Inspector", icon: "cube.fill", colorCategory: "core", priority: 98, providedBy: "CoreKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "core.graphPanel", title: "Graph View", icon: "point.3.connected.trianglepath.dotted", colorCategory: "core", priority: 88, providedBy: "CoreKit", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "core.editor", title: "Core Editor", icon: "cube.fill", colorCategory: "core", route: "/core", providedBy: "CoreKit", supportedInspectors: [.properties, .connections, .debug, .metadataPreview], defaultRightSidebar: "core.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "corekit.layout", kitName: "CoreKit", displayName: "Core", icon: "cube.fill", colorCategory: "core",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
