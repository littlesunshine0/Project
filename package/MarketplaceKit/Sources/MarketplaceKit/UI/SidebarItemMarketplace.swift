//
//  SidebarItemMarketplace.swift
//  MarketplaceKit
//
//  Sidebar items provided by MarketplaceKit
//

import Foundation
import DataKit

/// Sidebar items provided by MarketplaceKit
public struct SidebarItemMarketplace {
    
    public static let items: [SidebarItemDefinition] = [
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
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
