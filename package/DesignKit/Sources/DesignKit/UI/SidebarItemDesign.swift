//
//  SidebarItemDesign.swift
//  DesignKit
//
//  Sidebar items provided by DesignKit
//

import Foundation
import DataKit

/// Sidebar items provided by DesignKit
public struct SidebarItemDesign {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "design",
            title: "Design",
            icon: "paintbrush.fill",
            colorCategory: "chat",
            route: "/design",
            priority: 45,
            providedBy: "DesignKit",
            children: [
                SidebarItemDefinition(id: "design.components", title: "Components", icon: "square.on.square.fill", colorCategory: "chat", route: "/design/components", priority: 90, providedBy: "DesignKit"),
                SidebarItemDefinition(id: "design.colors", title: "Colors", icon: "paintpalette.fill", colorCategory: "success", route: "/design/colors", priority: 80, providedBy: "DesignKit"),
                SidebarItemDefinition(id: "design.typography", title: "Typography", icon: "textformat", colorCategory: "neutral", route: "/design/typography", priority: 70, providedBy: "DesignKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
