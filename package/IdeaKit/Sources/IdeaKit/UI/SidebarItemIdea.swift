//
//  SidebarItemIdea.swift
//  IdeaKit
//
//  Sidebar items provided by IdeaKit
//

import Foundation
import DataKit

/// Sidebar items provided by IdeaKit
public struct SidebarItemIdea {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "ideas",
            title: "Ideas",
            icon: "sparkles",
            colorCategory: "idea",
            route: "/ideas",
            priority: 52,
            providedBy: "IdeaKit",
            children: [
                SidebarItemDefinition(id: "ideas.capture", title: "Capture", icon: "plus.circle.fill", colorCategory: "idea", route: "/ideas/capture", priority: 90, providedBy: "IdeaKit"),
                SidebarItemDefinition(id: "ideas.organize", title: "Organize", icon: "folder.fill", colorCategory: "idea", route: "/ideas/organize", priority: 80, providedBy: "IdeaKit"),
                SidebarItemDefinition(id: "ideas.develop", title: "Develop", icon: "hammer.fill", colorCategory: "info", route: "/ideas/develop", priority: 70, providedBy: "IdeaKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
