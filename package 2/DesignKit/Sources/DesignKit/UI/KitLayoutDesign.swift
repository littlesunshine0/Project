//
//  KitLayoutDesign.swift
//  DesignKit
//
//  Complete layout configuration for DesignKit
//

import Foundation
import DataKit

public struct KitLayoutDesign {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "design",
            title: "Design",
            icon: "paintbrush.fill",
            colorCategory: "design",
            route: "/design",
            priority: 70,
            providedBy: "DesignKit",
            children: [
                SidebarItemDefinition(id: "design.components", title: "Components", icon: "square.on.square.fill", colorCategory: "design", route: "/design/components", priority: 90, providedBy: "DesignKit"),
                SidebarItemDefinition(id: "design.tokens", title: "Design Tokens", icon: "paintpalette.fill", colorCategory: "design", route: "/design/tokens", priority: 80, providedBy: "DesignKit"),
                SidebarItemDefinition(id: "design.themes", title: "Themes", icon: "moon.fill", colorCategory: "design", route: "/design/themes", priority: 70, providedBy: "DesignKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "design.preview", title: "Design Preview", icon: "eye.fill", colorCategory: "design", hasInput: false, priority: 65, providedBy: "DesignKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "design.properties", type: .properties, title: "Design Properties", colorCategory: "design", priority: 95, providedBy: "DesignKit", isDefault: true),
        InspectorDefinition(id: "design.livePreview", type: .livePreview, title: "Live Preview", colorCategory: "design", priority: 90, providedBy: "DesignKit"),
        InspectorDefinition(id: "design.accessibility", type: .accessibility, title: "Accessibility", colorCategory: "design", priority: 85, providedBy: "DesignKit"),
        InspectorDefinition(id: "design.metadata", type: .metadataPreview, title: "Component Info", colorCategory: "design", priority: 75, providedBy: "DesignKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "design.inspectorPanel", title: "Design Inspector", icon: "slider.horizontal.3", colorCategory: "design", priority: 95, providedBy: "DesignKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "design.layersPanel", title: "Layers", icon: "square.3.layers.3d", colorCategory: "design", priority: 85, providedBy: "DesignKit", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "design.canvas", title: "Design Canvas", icon: "paintbrush.fill", colorCategory: "design", route: "/design", providedBy: "DesignKit", supportedInspectors: [.properties, .livePreview, .accessibility, .metadataPreview], defaultRightSidebar: "design.inspectorPanel", defaultBottomPanel: "design.preview")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "designkit.layout", kitName: "DesignKit", displayName: "Design", icon: "paintbrush.fill", colorCategory: "design",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
