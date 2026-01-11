//
//  SidebarItemCore.swift
//  CoreKit
//
//  Sidebar items provided by CoreKit
//

import Foundation
import DataKit

/// Sidebar items provided by CoreKit
public struct SidebarItemCore {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "core",
            title: "Core",
            icon: "cube.fill",
            colorCategory: "core",
            route: "/core",
            priority: 95,
            providedBy: "CoreKit",
            children: [
                SidebarItemDefinition(id: "core.nodes", title: "Nodes", icon: "circle.grid.3x3.fill", colorCategory: "core", route: "/core/nodes", priority: 90, providedBy: "CoreKit"),
                SidebarItemDefinition(id: "core.graph", title: "Graph", icon: "point.3.connected.trianglepath.dotted", colorCategory: "core", route: "/core/graph", priority: 80, providedBy: "CoreKit"),
                SidebarItemDefinition(id: "core.crud", title: "CRUD", icon: "square.stack.3d.up.fill", colorCategory: "info", route: "/core/crud", priority: 70, providedBy: "CoreKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
