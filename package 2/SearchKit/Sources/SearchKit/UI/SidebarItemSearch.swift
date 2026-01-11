//
//  SidebarItemSearch.swift
//  SearchKit
//
//  Sidebar items provided by SearchKit
//

import Foundation
import DataKit

/// Sidebar items provided by SearchKit
public struct SidebarItemSearch {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "search",
            title: "Search",
            icon: "magnifyingglass",
            colorCategory: "search",
            route: "/search",
            priority: 95,
            providedBy: "SearchKit",
            children: [
                SidebarItemDefinition(id: "search.files", title: "Files", icon: "doc.fill", colorCategory: "search", route: "/search/files", priority: 90, providedBy: "SearchKit"),
                SidebarItemDefinition(id: "search.symbols", title: "Symbols", icon: "number", colorCategory: "search", route: "/search/symbols", priority: 80, providedBy: "SearchKit"),
                SidebarItemDefinition(id: "search.recent", title: "Recent", icon: "clock.fill", colorCategory: "search", route: "/search/recent", priority: 70, providedBy: "SearchKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
