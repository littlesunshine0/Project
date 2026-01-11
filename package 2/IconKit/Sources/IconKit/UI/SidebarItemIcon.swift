//
//  SidebarItemIcon.swift
//  IconKit
//
//  Sidebar items provided by IconKit
//

import Foundation
import DataKit

/// Sidebar items provided by IconKit
public struct SidebarItemIcon {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "icons",
            title: "Icons",
            icon: "star.square.fill",
            colorCategory: "design",
            route: "/icons",
            priority: 48,
            providedBy: "IconKit",
            children: [
                SidebarItemDefinition(id: "icons.library", title: "Library", icon: "square.grid.2x2.fill", colorCategory: "design", route: "/icons/library", priority: 90, providedBy: "IconKit"),
                SidebarItemDefinition(id: "icons.custom", title: "Custom", icon: "paintbrush.fill", colorCategory: "design", route: "/icons/custom", priority: 80, providedBy: "IconKit"),
                SidebarItemDefinition(id: "icons.export", title: "Export", icon: "square.and.arrow.up.fill", colorCategory: "info", route: "/icons/export", priority: 70, providedBy: "IconKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
