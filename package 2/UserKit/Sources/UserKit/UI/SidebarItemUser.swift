//
//  SidebarItemUser.swift
//  UserKit
//
//  Sidebar items provided by UserKit
//

import Foundation
import DataKit

/// Sidebar items provided by UserKit
public struct SidebarItemUser {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "user",
            title: "User",
            icon: "person.circle.fill",
            colorCategory: "neutral",
            route: "/user",
            priority: 10,
            providedBy: "UserKit",
            children: [
                SidebarItemDefinition(id: "user.profile", title: "Profile", icon: "person.fill", colorCategory: "neutral", route: "/user/profile", priority: 90, providedBy: "UserKit"),
                SidebarItemDefinition(id: "user.settings", title: "Settings", icon: "gearshape.fill", colorCategory: "neutral", route: "/user/settings", priority: 80, providedBy: "UserKit"),
                SidebarItemDefinition(id: "user.preferences", title: "Preferences", icon: "slider.horizontal.3", colorCategory: "neutral", route: "/user/preferences", priority: 70, providedBy: "UserKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
