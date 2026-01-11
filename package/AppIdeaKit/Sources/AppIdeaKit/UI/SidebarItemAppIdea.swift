//
//  SidebarItemAppIdea.swift
//  AppIdeaKit
//
//  Sidebar items provided by AppIdeaKit
//

import Foundation
import DataKit

/// Sidebar items provided by AppIdeaKit
public struct SidebarItemAppIdea {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "appIdea",
            title: "App Ideas",
            icon: "lightbulb.fill",
            colorCategory: "idea",
            route: "/app-ideas",
            priority: 55,
            providedBy: "AppIdeaKit",
            children: [
                SidebarItemDefinition(id: "appIdea.brainstorm", title: "Brainstorm", icon: "brain.head.profile", colorCategory: "idea", route: "/app-ideas/brainstorm", priority: 90, providedBy: "AppIdeaKit"),
                SidebarItemDefinition(id: "appIdea.saved", title: "Saved Ideas", icon: "bookmark.fill", colorCategory: "idea", route: "/app-ideas/saved", priority: 80, providedBy: "AppIdeaKit"),
                SidebarItemDefinition(id: "appIdea.templates", title: "Templates", icon: "doc.on.doc.fill", colorCategory: "info", route: "/app-ideas/templates", priority: 70, providedBy: "AppIdeaKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
