//
//  SidebarItemScaffold.swift
//  ProjectScaffold
//
//  Sidebar items provided by ProjectScaffold
//

import Foundation
import DataKit

/// Sidebar items provided by ProjectScaffold
public struct SidebarItemScaffold {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "scaffold",
            title: "Scaffold",
            icon: "hammer.fill",
            colorCategory: "scaffold",
            route: "/scaffold",
            priority: 65,
            providedBy: "ProjectScaffold",
            children: [
                SidebarItemDefinition(id: "scaffold.new", title: "New Project", icon: "plus.circle.fill", colorCategory: "scaffold", route: "/scaffold/new", priority: 90, providedBy: "ProjectScaffold"),
                SidebarItemDefinition(id: "scaffold.templates", title: "Templates", icon: "doc.on.doc.fill", colorCategory: "scaffold", route: "/scaffold/templates", priority: 80, providedBy: "ProjectScaffold"),
                SidebarItemDefinition(id: "scaffold.recent", title: "Recent", icon: "clock.fill", colorCategory: "info", route: "/scaffold/recent", priority: 70, providedBy: "ProjectScaffold")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
