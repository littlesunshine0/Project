//
//  KitLayoutError.swift
//  ErrorKit
//
//  Complete layout configuration for ErrorKit
//

import Foundation
import DataKit

public struct KitLayoutError {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "errors",
            title: "Problems",
            icon: "exclamationmark.triangle.fill",
            colorCategory: "error",
            route: "/errors",
            priority: 85,
            providedBy: "ErrorKit",
            children: [
                SidebarItemDefinition(id: "errors.all", title: "All Issues", icon: "exclamationmark.triangle.fill", colorCategory: "error", route: "/errors/all", priority: 90, providedBy: "ErrorKit"),
                SidebarItemDefinition(id: "errors.warnings", title: "Warnings", icon: "exclamationmark.circle.fill", colorCategory: "warning", route: "/errors/warnings", priority: 80, providedBy: "ErrorKit"),
                SidebarItemDefinition(id: "errors.info", title: "Info", icon: "info.circle.fill", colorCategory: "info", route: "/errors/info", priority: 70, providedBy: "ErrorKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "errors.problems", title: "Problems", icon: "exclamationmark.triangle.fill", colorCategory: "error", hasInput: false, priority: 95, providedBy: "ErrorKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "error.diagnostics", type: .diagnostics, title: "Diagnostics", colorCategory: "error", priority: 95, providedBy: "ErrorKit", isDefault: true),
        InspectorDefinition(id: "error.quickHelp", type: .quickHelp, title: "Error Help", colorCategory: "error", priority: 85, providedBy: "ErrorKit"),
        InspectorDefinition(id: "error.filePreview", type: .filePreview, title: "Source Preview", colorCategory: "error", priority: 80, providedBy: "ErrorKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "error.inspectorPanel", title: "Error Inspector", icon: "exclamationmark.triangle.fill", colorCategory: "error", priority: 95, providedBy: "ErrorKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "error.list", title: "Problems", icon: "exclamationmark.triangle.fill", colorCategory: "error", route: "/errors", providedBy: "ErrorKit", supportedInspectors: [.diagnostics, .quickHelp, .filePreview], defaultRightSidebar: "error.inspectorPanel", defaultBottomPanel: "errors.problems")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "errorkit.layout", kitName: "ErrorKit", displayName: "Problems", icon: "exclamationmark.triangle.fill", colorCategory: "error",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
