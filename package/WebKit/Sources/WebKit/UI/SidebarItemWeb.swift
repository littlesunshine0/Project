//
//  SidebarItemWeb.swift
//  WebKit
//
//  Sidebar items provided by WebKit
//

import Foundation
import DataKit

/// Sidebar items provided by WebKit
public struct SidebarItemWeb {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "web",
            title: "Web",
            icon: "globe",
            colorCategory: "web",
            route: "/web",
            priority: 35,
            providedBy: "WebKit",
            children: [
                SidebarItemDefinition(id: "web.preview", title: "Preview", icon: "eye.fill", colorCategory: "web", route: "/web/preview", priority: 90, providedBy: "WebKit"),
                SidebarItemDefinition(id: "web.inspector", title: "Inspector", icon: "magnifyingglass", colorCategory: "web", route: "/web/inspector", priority: 80, providedBy: "WebKit"),
                SidebarItemDefinition(id: "web.console", title: "Console", icon: "terminal.fill", colorCategory: "info", route: "/web/console", priority: 70, providedBy: "WebKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
