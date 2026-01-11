//
//  KitLayoutDoc.swift
//  DocKit
//
//  Complete layout configuration for DocKit
//

import Foundation
import DataKit

public struct KitLayoutDoc {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "docs",
            title: "Documentation",
            icon: "book.fill",
            colorCategory: "doc",
            route: "/docs",
            priority: 75,
            providedBy: "DocKit",
            children: [
                SidebarItemDefinition(id: "docs.browse", title: "Browse", icon: "books.vertical.fill", colorCategory: "doc", route: "/docs/browse", priority: 90, providedBy: "DocKit"),
                SidebarItemDefinition(id: "docs.api", title: "API Reference", icon: "doc.text.magnifyingglass", colorCategory: "doc", route: "/docs/api", priority: 80, providedBy: "DocKit"),
                SidebarItemDefinition(id: "docs.guides", title: "Guides", icon: "map.fill", colorCategory: "doc", route: "/docs/guides", priority: 70, providedBy: "DocKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "docs.search", title: "Doc Search", icon: "magnifyingglass", colorCategory: "doc", hasInput: true, placeholder: "Search documentation...", priority: 60, providedBy: "DocKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "doc.quickHelp", type: .quickHelp, title: "Quick Help", colorCategory: "doc", priority: 100, providedBy: "DocKit", isDefault: true),
        InspectorDefinition(id: "doc.preview", type: .livePreview, title: "Doc Preview", colorCategory: "doc", priority: 90, providedBy: "DocKit"),
        InspectorDefinition(id: "doc.properties", type: .properties, title: "Doc Properties", colorCategory: "doc", priority: 80, providedBy: "DocKit"),
        InspectorDefinition(id: "doc.metadata", type: .metadataPreview, title: "Doc Metadata", colorCategory: "doc", priority: 70, providedBy: "DocKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "doc.helpPanel", title: "Quick Help", icon: "questionmark.circle.fill", colorCategory: "doc", priority: 95, providedBy: "DocKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "doc.tocPanel", title: "Table of Contents", icon: "list.bullet", colorCategory: "doc", priority: 85, providedBy: "DocKit", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "doc.viewer", title: "Documentation", icon: "book.fill", colorCategory: "doc", route: "/docs", providedBy: "DocKit", supportedInspectors: [.quickHelp, .livePreview, .properties, .metadataPreview], defaultRightSidebar: "doc.helpPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "dockit.layout", kitName: "DocKit", displayName: "Documentation", icon: "book.fill", colorCategory: "doc",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
