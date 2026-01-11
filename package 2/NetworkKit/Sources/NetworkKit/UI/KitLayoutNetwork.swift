//
//  KitLayoutNetwork.swift
//  NetworkKit
//
//  Complete layout configuration for NetworkKit
//

import Foundation
import DataKit

public struct KitLayoutNetwork {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "network",
            title: "Network",
            icon: "network",
            colorCategory: "network",
            route: "/network",
            priority: 42,
            providedBy: "NetworkKit",
            children: [
                SidebarItemDefinition(id: "network.requests", title: "Requests", icon: "arrow.up.arrow.down", colorCategory: "network", route: "/network/requests", priority: 90, providedBy: "NetworkKit"),
                SidebarItemDefinition(id: "network.endpoints", title: "Endpoints", icon: "point.3.connected.trianglepath.dotted", colorCategory: "network", route: "/network/endpoints", priority: 80, providedBy: "NetworkKit"),
                SidebarItemDefinition(id: "network.monitor", title: "Monitor", icon: "waveform.path.ecg", colorCategory: "info", route: "/network/monitor", priority: 70, providedBy: "NetworkKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "network.inspector", title: "Network", icon: "network", colorCategory: "network", hasInput: false, priority: 45, providedBy: "NetworkKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "network.properties", type: .properties, title: "Request Properties", colorCategory: "network", priority: 90, providedBy: "NetworkKit", isDefault: true),
        InspectorDefinition(id: "network.preview", type: .filePreview, title: "Response Preview", colorCategory: "network", priority: 85, providedBy: "NetworkKit"),
        InspectorDefinition(id: "network.performance", type: .performance, title: "Performance", colorCategory: "network", priority: 80, providedBy: "NetworkKit"),
        InspectorDefinition(id: "network.debug", type: .debug, title: "Debug", colorCategory: "network", priority: 75, providedBy: "NetworkKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "network.inspectorPanel", title: "Network Inspector", icon: "network", colorCategory: "network", priority: 60, providedBy: "NetworkKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "network.dashboard", title: "Network Dashboard", icon: "network", colorCategory: "network", route: "/network", providedBy: "NetworkKit", supportedInspectors: [.properties, .filePreview, .performance, .debug], defaultRightSidebar: "network.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "networkkit.layout", kitName: "NetworkKit", displayName: "Network", icon: "network", colorCategory: "network",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
