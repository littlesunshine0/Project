//
//  SidebarItemNavigation.swift
//  NavigationKit
//
//  Sidebar items provided by NavigationKit
//

import Foundation
import DataKit

/// Sidebar items provided by NavigationKit
public struct SidebarItemNavigation {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "navigation",
            title: "Navigation",
            icon: "arrow.triangle.branch",
            colorCategory: "neutral",
            route: "/navigation",
            priority: 15,
            providedBy: "NavigationKit",
            children: [
                SidebarItemDefinition(id: "navigation.history", title: "History", icon: "clock.arrow.circlepath", colorCategory: "neutral", route: "/navigation/history", priority: 90, providedBy: "NavigationKit"),
                SidebarItemDefinition(id: "navigation.bookmarks", title: "Bookmarks", icon: "bookmark.fill", colorCategory: "warning", route: "/navigation/bookmarks", priority: 80, providedBy: "NavigationKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
