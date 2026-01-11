//
//  SidebarItemContentHub.swift
//  ContentHub
//
//  Sidebar items provided by ContentHub
//

import Foundation
import DataKit

/// Sidebar items provided by ContentHub
public struct SidebarItemContentHub {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "contentHub",
            title: "Content Hub",
            icon: "square.stack.3d.up.fill",
            colorCategory: "content",
            route: "/content-hub",
            priority: 58,
            providedBy: "ContentHub",
            children: [
                SidebarItemDefinition(id: "contentHub.all", title: "All Content", icon: "doc.fill", colorCategory: "content", route: "/content-hub/all", priority: 90, providedBy: "ContentHub"),
                SidebarItemDefinition(id: "contentHub.recent", title: "Recent", icon: "clock.fill", colorCategory: "content", route: "/content-hub/recent", priority: 80, providedBy: "ContentHub"),
                SidebarItemDefinition(id: "contentHub.favorites", title: "Favorites", icon: "star.fill", colorCategory: "info", route: "/content-hub/favorites", priority: 70, providedBy: "ContentHub")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
