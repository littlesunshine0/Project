//
//  BottomPanelItemSearch.swift
//  SearchKit
//
//  Bottom panel items provided by SearchKit
//

import Foundation
import DataKit

/// Bottom panel items provided by SearchKit
public struct BottomPanelItemSearch {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "search.results",
            title: "Search Results",
            icon: "magnifyingglass",
            colorCategory: "search",
            hasInput: true,
            placeholder: "Search...",
            priority: 65,
            providedBy: "SearchKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
