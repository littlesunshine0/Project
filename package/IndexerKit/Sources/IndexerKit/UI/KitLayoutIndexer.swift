//
//  KitLayoutIndexer.swift
//  IndexerKit
//
//  Complete layout configuration for IndexerKit
//

import Foundation
import DataKit

public struct KitLayoutIndexer {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "indexer",
            title: "Indexer",
            icon: "list.bullet.rectangle.fill",
            colorCategory: "indexer",
            route: "/indexer",
            priority: 55,
            providedBy: "IndexerKit",
            children: [
                SidebarItemDefinition(id: "indexer.status", title: "Status", icon: "checkmark.circle.fill", colorCategory: "success", route: "/indexer/status", priority: 90, providedBy: "IndexerKit"),
                SidebarItemDefinition(id: "indexer.indexes", title: "Indexes", icon: "list.bullet.rectangle.fill", colorCategory: "indexer", route: "/indexer/indexes", priority: 80, providedBy: "IndexerKit"),
                SidebarItemDefinition(id: "indexer.settings", title: "Settings", icon: "gearshape.fill", colorCategory: "indexer", route: "/indexer/settings", priority: 70, providedBy: "IndexerKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "indexer.output", title: "Indexer", icon: "list.bullet.rectangle.fill", colorCategory: "indexer", hasInput: false, priority: 35, providedBy: "IndexerKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "indexer.properties", type: .properties, title: "Index Properties", colorCategory: "indexer", priority: 90, providedBy: "IndexerKit", isDefault: true),
        InspectorDefinition(id: "indexer.performance", type: .performance, title: "Performance", colorCategory: "indexer", priority: 85, providedBy: "IndexerKit"),
        InspectorDefinition(id: "indexer.metadata", type: .metadataPreview, title: "Index Info", colorCategory: "indexer", priority: 80, providedBy: "IndexerKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "indexer.inspectorPanel", title: "Indexer Inspector", icon: "list.bullet.rectangle.fill", colorCategory: "indexer", priority: 70, providedBy: "IndexerKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "indexer.dashboard", title: "Indexer Dashboard", icon: "list.bullet.rectangle.fill", colorCategory: "indexer", route: "/indexer", providedBy: "IndexerKit", supportedInspectors: [.properties, .performance, .metadataPreview], defaultRightSidebar: "indexer.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "indexerkit.layout", kitName: "IndexerKit", displayName: "Indexer", icon: "list.bullet.rectangle.fill", colorCategory: "indexer",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
