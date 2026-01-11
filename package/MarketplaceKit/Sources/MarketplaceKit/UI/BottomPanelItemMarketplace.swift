//
//  BottomPanelItemMarketplace.swift
//  MarketplaceKit
//
//  Bottom panel items provided by MarketplaceKit
//

import Foundation
import DataKit

/// Bottom panel items provided by MarketplaceKit
public struct BottomPanelItemMarketplace {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "marketplace.search",
            title: "Marketplace",
            icon: "storefront.fill",
            colorCategory: "marketplace",
            hasInput: true,
            placeholder: "Search marketplace...",
            priority: 20,
            providedBy: "MarketplaceKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
