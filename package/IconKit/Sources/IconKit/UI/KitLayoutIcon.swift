//
//  KitLayoutIcon.swift
//  IconKit
//
//  Complete layout configuration for IconKit
//

import Foundation
import DataKit

public struct KitLayoutIcon {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "icons",
            title: "Icons",
            icon: "star.square.fill",
            colorCategory: "design",
            route: "/icons",
            priority: 48,
            providedBy: "IconKit",
            children: [
                SidebarItemDefinition(id: "icons.library", title: "Library", icon: "square.grid.2x2.fill", colorCategory: "design", route: "/icons/library", priority: 90, providedBy: "IconKit"),
                SidebarItemDefinition(id: "icons.custom", title: "Custom", icon: "paintbrush.fill", colorCategory: "design", route: "/icons/custom", priority: 80, providedBy: "IconKit"),
                SidebarItemDefinition(id: "icons.export", title: "Export", icon: "square.and.arrow.up.fill", colorCategory: "info", route: "/icons/export", priority: 70, providedBy: "IconKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "icons.preview", title: "Icons", icon: "star.square.fill", colorCategory: "design", hasInput: false, priority: 28, providedBy: "IconKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "icon.properties", type: .properties, title: "Icon Properties", colorCategory: "design", priority: 90, providedBy: "IconKit", isDefault: true),
        InspectorDefinition(id: "icon.preview", type: .livePreview, title: "Icon Preview", colorCategory: "design", priority: 88, providedBy: "IconKit"),
        InspectorDefinition(id: "icon.metadata", type: .metadataPreview, title: "Icon Info", colorCategory: "design", priority: 82, providedBy: "IconKit"),
        InspectorDefinition(id: "icon.accessibility", type: .accessibility, title: "Accessibility", colorCategory: "design", priority: 78, providedBy: "IconKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "icon.inspectorPanel", title: "Icon Inspector", icon: "star.square.fill", colorCategory: "design", priority: 65, providedBy: "IconKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "icon.variantsPanel", title: "Variants", icon: "square.on.square", colorCategory: "design", priority: 55, providedBy: "IconKit", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "icon.browser", title: "Icon Browser", icon: "star.square.fill", colorCategory: "design", route: "/icons", providedBy: "IconKit", supportedInspectors: [.properties, .livePreview, .metadataPreview, .accessibility], defaultRightSidebar: "icon.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "iconkit.layout", kitName: "IconKit", displayName: "Icons", icon: "star.square.fill", colorCategory: "design",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
