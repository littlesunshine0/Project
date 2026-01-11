//
//  KitLayoutWorkflow.swift
//  WorkflowKit
//
//  Complete layout configuration for WorkflowKit
//

import Foundation
import DataKit

public struct KitLayoutWorkflow {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "workflows",
            title: "Workflows",
            icon: "arrow.triangle.branch",
            colorCategory: "workflow",
            route: "/workflows",
            priority: 78,
            providedBy: "WorkflowKit",
            children: [
                SidebarItemDefinition(id: "workflows.active", title: "Active", icon: "play.circle.fill", colorCategory: "success", route: "/workflows/active", priority: 90, providedBy: "WorkflowKit"),
                SidebarItemDefinition(id: "workflows.library", title: "Library", icon: "folder.fill", colorCategory: "workflow", route: "/workflows/library", priority: 80, providedBy: "WorkflowKit"),
                SidebarItemDefinition(id: "workflows.templates", title: "Templates", icon: "doc.on.doc.fill", colorCategory: "workflow", route: "/workflows/templates", priority: 70, providedBy: "WorkflowKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "workflow.output", title: "Workflow Output", icon: "arrow.triangle.branch", colorCategory: "workflow", hasInput: false, priority: 72, providedBy: "WorkflowKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "workflow.properties", type: .properties, title: "Workflow Properties", colorCategory: "workflow", priority: 90, providedBy: "WorkflowKit", isDefault: true),
        InspectorDefinition(id: "workflow.livePreview", type: .livePreview, title: "Live Preview", colorCategory: "workflow", priority: 85, providedBy: "WorkflowKit"),
        InspectorDefinition(id: "workflow.connections", type: .connections, title: "Node Connections", colorCategory: "workflow", priority: 80, providedBy: "WorkflowKit"),
        InspectorDefinition(id: "workflow.debug", type: .debug, title: "Debug", colorCategory: "workflow", priority: 75, providedBy: "WorkflowKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "workflow.inspectorPanel", title: "Workflow Inspector", icon: "slider.horizontal.3", colorCategory: "workflow", priority: 90, providedBy: "WorkflowKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "workflow.nodeLibrary", title: "Node Library", icon: "square.grid.2x2.fill", colorCategory: "workflow", priority: 80, providedBy: "WorkflowKit", defaultPosition: .bottom)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "workflow.canvas", title: "Workflow Canvas", icon: "arrow.triangle.branch", colorCategory: "workflow", route: "/workflows", providedBy: "WorkflowKit", supportedInspectors: [.properties, .livePreview, .connections, .debug], defaultRightSidebar: "workflow.inspectorPanel", defaultBottomPanel: "workflow.output")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "workflowkit.layout", kitName: "WorkflowKit", displayName: "Workflows", icon: "arrow.triangle.branch", colorCategory: "workflow",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
