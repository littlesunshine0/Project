//
//  KitLayoutSystem.swift
//  SystemKit
//
//  Complete layout configuration for SystemKit
//

import Foundation
import DataKit

public struct KitLayoutSystem {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "system",
            title: "System",
            icon: "gearshape.fill",
            colorCategory: "system",
            route: "/system",
            priority: 30,
            providedBy: "SystemKit",
            children: [
                SidebarItemDefinition(id: "system.settings", title: "Settings", icon: "slider.horizontal.3", colorCategory: "system", route: "/system/settings", priority: 90, providedBy: "SystemKit"),
                SidebarItemDefinition(id: "system.performance", title: "Performance", icon: "gauge.with.dots.needle.bottom.50percent", colorCategory: "info", route: "/system/performance", priority: 80, providedBy: "SystemKit"),
                SidebarItemDefinition(id: "system.logs", title: "Logs", icon: "doc.text.fill", colorCategory: "system", route: "/system/logs", priority: 70, providedBy: "SystemKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "system.monitor", title: "System", icon: "gearshape.fill", colorCategory: "system", hasInput: false, priority: 15, providedBy: "SystemKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "system.properties", type: .properties, title: "System Properties", colorCategory: "system", priority: 90, providedBy: "SystemKit", isDefault: true),
        InspectorDefinition(id: "system.performance", type: .performance, title: "Performance", colorCategory: "system", priority: 85, providedBy: "SystemKit"),
        InspectorDefinition(id: "system.diagnostics", type: .diagnostics, title: "Diagnostics", colorCategory: "system", priority: 80, providedBy: "SystemKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "system.inspectorPanel", title: "System Inspector", icon: "gearshape.fill", colorCategory: "system", priority: 48, providedBy: "SystemKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "system.dashboard", title: "System Dashboard", icon: "gearshape.fill", colorCategory: "system", route: "/system", providedBy: "SystemKit", supportedInspectors: [.properties, .performance, .diagnostics], defaultRightSidebar: "system.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "systemkit.layout", kitName: "SystemKit", displayName: "System", icon: "gearshape.fill", colorCategory: "system",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
