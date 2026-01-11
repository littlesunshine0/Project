//
//  KitLayoutMarketplace.swift
//  MarketplaceKit
//
//  Complete layout configuration for MarketplaceKit
//

import Foundation
import DataKit

public struct KitLayoutMarketplace {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "marketplace",
            title: "Marketplace",
            icon: "storefront.fill",
            colorCategory: "marketplace",
            route: "/marketplace",
            priority: 40,
            providedBy: "MarketplaceKit",
            children: [
                SidebarItemDefinition(id: "marketplace.browse", title: "Browse", icon: "magnifyingglass", colorCategory: "marketplace", route: "/marketplace/browse", priority: 90, providedBy: "MarketplaceKit"),
                SidebarItemDefinition(id: "marketplace.installed", title: "Installed", icon: "checkmark.circle.fill", colorCategory: "success", route: "/marketplace/installed", priority: 80, providedBy: "MarketplaceKit"),
                SidebarItemDefinition(id: "marketplace.updates", title: "Updates", icon: "arrow.down.circle.fill", colorCategory: "info", route: "/marketplace/updates", priority: 70, providedBy: "MarketplaceKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "marketplace.search", title: "Marketplace", icon: "storefront.fill", colorCategory: "marketplace", hasInput: true, placeholder: "Search marketplace...", priority: 20, providedBy: "MarketplaceKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "marketplace.properties", type: .properties, title: "Package Properties", colorCategory: "marketplace", priority: 90, providedBy: "MarketplaceKit", isDefault: true),
        InspectorDefinition(id: "marketplace.preview", type: .filePreview, title: "Preview", colorCategory: "marketplace", priority: 85, providedBy: "MarketplaceKit"),
        InspectorDefinition(id: "marketplace.metadata", type: .metadataPreview, title: "Package Info", colorCategory: "marketplace", priority: 80, providedBy: "MarketplaceKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "marketplace.inspectorPanel", title: "Package Inspector", icon: "storefront.fill", colorCategory: "marketplace", priority: 58, providedBy: "MarketplaceKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "marketplace.browser", title: "Marketplace", icon: "storefront.fill", colorCategory: "marketplace", route: "/marketplace", providedBy: "MarketplaceKit", supportedInspectors: [.properties, .filePreview, .metadataPreview], defaultRightSidebar: "marketplace.inspectorPanel", defaultBottomPanel: "marketplace.search")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "marketplacekit.layout", kitName: "MarketplaceKit", displayName: "Marketplace", icon: "storefront.fill", colorCategory: "marketplace",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
