//
//  KitLayoutBridge.swift
//  BridgeKit
//
//  Complete layout configuration for BridgeKit
//

import Foundation
import DataKit

public struct KitLayoutBridge {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "bridge",
            title: "Bridge",
            icon: "arrow.left.arrow.right",
            colorCategory: "bridge",
            route: "/bridge",
            priority: 45,
            providedBy: "BridgeKit",
            children: [
                SidebarItemDefinition(id: "bridge.connections", title: "Connections", icon: "link", colorCategory: "bridge", route: "/bridge/connections", priority: 90, providedBy: "BridgeKit"),
                SidebarItemDefinition(id: "bridge.registry", title: "Registry", icon: "list.bullet.rectangle", colorCategory: "info", route: "/bridge/registry", priority: 80, providedBy: "BridgeKit"),
                SidebarItemDefinition(id: "bridge.logs", title: "Logs", icon: "doc.text.fill", colorCategory: "bridge", route: "/bridge/logs", priority: 70, providedBy: "BridgeKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "bridge.console", title: "Bridge", icon: "arrow.left.arrow.right", colorCategory: "bridge", hasInput: false, priority: 25, providedBy: "BridgeKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "bridge.properties", type: .properties, title: "Bridge Properties", colorCategory: "bridge", priority: 90, providedBy: "BridgeKit", isDefault: true),
        InspectorDefinition(id: "bridge.connections", type: .connections, title: "Connections", colorCategory: "bridge", priority: 85, providedBy: "BridgeKit"),
        InspectorDefinition(id: "bridge.debug", type: .debug, title: "Debug", colorCategory: "bridge", priority: 80, providedBy: "BridgeKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "bridge.inspectorPanel", title: "Bridge Inspector", icon: "arrow.left.arrow.right", colorCategory: "bridge", priority: 62, providedBy: "BridgeKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "bridge.dashboard", title: "Bridge Dashboard", icon: "arrow.left.arrow.right", colorCategory: "bridge", route: "/bridge", providedBy: "BridgeKit", supportedInspectors: [.properties, .connections, .debug], defaultRightSidebar: "bridge.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "bridgekit.layout", kitName: "BridgeKit", displayName: "Bridge", icon: "arrow.left.arrow.right", colorCategory: "bridge",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
