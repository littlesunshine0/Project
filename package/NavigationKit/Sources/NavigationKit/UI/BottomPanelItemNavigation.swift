//
//  BottomPanelItemNavigation.swift
//  NavigationKit
//
//  Bottom panel items provided by NavigationKit
//

import Foundation
import DataKit

/// Bottom panel items provided by NavigationKit
public struct BottomPanelItemNavigation {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "navigation.breadcrumb",
            title: "Breadcrumb",
            icon: "arrow.triangle.branch",
            colorCategory: "neutral",
            hasInput: false,
            placeholder: "",
            priority: 15,
            providedBy: "NavigationKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
