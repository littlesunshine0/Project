//
//  KitLayoutOrchestrator.swift
//  KitOrchestrator
//
//  Complete layout configuration for KitOrchestrator
//

import Foundation
import DataKit

public struct KitLayoutOrchestrator {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "orchestrator",
            title: "Orchestrator",
            icon: "wand.and.stars",
            colorCategory: "orchestrator",
            route: "/orchestrator",
            priority: 90,
            providedBy: "KitOrchestrator",
            children: [
                SidebarItemDefinition(id: "orchestrator.kits", title: "Kits", icon: "shippingbox.fill", colorCategory: "orchestrator", route: "/orchestrator/kits", priority: 90, providedBy: "KitOrchestrator"),
                SidebarItemDefinition(id: "orchestrator.pipelines", title: "Pipelines", icon: "arrow.triangle.branch", colorCategory: "orchestrator", route: "/orchestrator/pipelines", priority: 80, providedBy: "KitOrchestrator"),
                SidebarItemDefinition(id: "orchestrator.status", title: "Status", icon: "checkmark.circle.fill", colorCategory: "success", route: "/orchestrator/status", priority: 70, providedBy: "KitOrchestrator")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "orchestrator.console", title: "Orchestrator", icon: "wand.and.stars", colorCategory: "orchestrator", hasInput: false, priority: 55, providedBy: "KitOrchestrator")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "orchestrator.properties", type: .properties, title: "Kit Properties", colorCategory: "orchestrator", priority: 95, providedBy: "KitOrchestrator", isDefault: true),
        InspectorDefinition(id: "orchestrator.connections", type: .connections, title: "Kit Connections", colorCategory: "orchestrator", priority: 90, providedBy: "KitOrchestrator"),
        InspectorDefinition(id: "orchestrator.performance", type: .performance, title: "Performance", colorCategory: "orchestrator", priority: 85, providedBy: "KitOrchestrator"),
        InspectorDefinition(id: "orchestrator.debug", type: .debug, title: "Debug", colorCategory: "orchestrator", priority: 80, providedBy: "KitOrchestrator")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "orchestrator.inspectorPanel", title: "Orchestrator Inspector", icon: "wand.and.stars", colorCategory: "orchestrator", priority: 92, providedBy: "KitOrchestrator", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "orchestrator.kitListPanel", title: "Kit List", icon: "list.bullet", colorCategory: "orchestrator", priority: 82, providedBy: "KitOrchestrator", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "orchestrator.dashboard", title: "Orchestrator Dashboard", icon: "wand.and.stars", colorCategory: "orchestrator", route: "/orchestrator", providedBy: "KitOrchestrator", supportedInspectors: [.properties, .connections, .performance, .debug], defaultRightSidebar: "orchestrator.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "kitorchestrator.layout", kitName: "KitOrchestrator", displayName: "Orchestrator", icon: "wand.and.stars", colorCategory: "orchestrator",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
