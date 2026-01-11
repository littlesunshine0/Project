//
//  KitLayoutExport.swift
//  ExportKit
//
//  Complete layout configuration for ExportKit
//

import Foundation
import DataKit

public struct KitLayoutExport {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "export",
            title: "Export",
            icon: "square.and.arrow.up.fill",
            colorCategory: "export",
            route: "/export",
            priority: 45,
            providedBy: "ExportKit",
            children: [
                SidebarItemDefinition(id: "export.formats", title: "Formats", icon: "doc.fill", colorCategory: "export", route: "/export/formats", priority: 90, providedBy: "ExportKit"),
                SidebarItemDefinition(id: "export.history", title: "History", icon: "clock.arrow.circlepath", colorCategory: "export", route: "/export/history", priority: 80, providedBy: "ExportKit"),
                SidebarItemDefinition(id: "export.presets", title: "Presets", icon: "slider.horizontal.3", colorCategory: "export", route: "/export/presets", priority: 70, providedBy: "ExportKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "export.output", title: "Export", icon: "square.and.arrow.up.fill", colorCategory: "export", hasInput: false, priority: 28, providedBy: "ExportKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "export.properties", type: .properties, title: "Export Properties", colorCategory: "export", priority: 90, providedBy: "ExportKit", isDefault: true),
        InspectorDefinition(id: "export.preview", type: .filePreview, title: "Export Preview", colorCategory: "export", priority: 85, providedBy: "ExportKit"),
        InspectorDefinition(id: "export.metadata", type: .metadataPreview, title: "Export Info", colorCategory: "export", priority: 80, providedBy: "ExportKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "export.inspectorPanel", title: "Export Inspector", icon: "square.and.arrow.up.fill", colorCategory: "export", priority: 60, providedBy: "ExportKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "export.main", title: "Export", icon: "square.and.arrow.up.fill", colorCategory: "export", route: "/export", providedBy: "ExportKit", supportedInspectors: [.properties, .filePreview, .metadataPreview], defaultRightSidebar: "export.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "exportkit.layout", kitName: "ExportKit", displayName: "Export", icon: "square.and.arrow.up.fill", colorCategory: "export",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
