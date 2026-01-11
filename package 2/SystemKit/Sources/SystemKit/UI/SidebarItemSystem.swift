//
//  SidebarItemSystem.swift
//  SystemKit
//
//  Sidebar items provided by SystemKit
//

import Foundation
import DataKit

/// Sidebar items provided by SystemKit
public struct SidebarItemSystem {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "system",
            title: "System",
            icon: "gearshape.fill",
            colorCategory: "system",
            route: "/system",
            priority: 30,
            providedBy: "SystemKit",
            children: [
                SidebarItemDefinition(id: "system.settings", title: "Settings", icon: "slider.horizontal.3", colorCategory: "system", route: "/system/settings", priority: 90, providedBy: "SystemKit"),
                SidebarItemDefinition(id: "system.performance", title: "Performance", icon: "gauge.with.dots.needle.bottom.50percent", colorCategory: "info", route: "/system/performance", priority: 80, providedBy: "SystemKit"),
                SidebarItemDefinition(id: "system.logs", title: "Logs", icon: "doc.text.fill", colorCategory: "system", route: "/system/logs", priority: 70, providedBy: "SystemKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
