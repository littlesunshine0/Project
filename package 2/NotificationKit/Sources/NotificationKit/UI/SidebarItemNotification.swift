//
//  SidebarItemNotification.swift
//  NotificationKit
//
//  Sidebar items provided by NotificationKit
//

import Foundation
import DataKit

/// Sidebar items provided by NotificationKit
public struct SidebarItemNotification {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "notifications",
            title: "Notifications",
            icon: "bell.fill",
            colorCategory: "info",
            route: "/notifications",
            priority: 45,
            providedBy: "NotificationKit",
            children: [
                SidebarItemDefinition(id: "notifications.all", title: "All", icon: "bell.badge.fill", colorCategory: "info", route: "/notifications/all", priority: 90, providedBy: "NotificationKit"),
                SidebarItemDefinition(id: "notifications.unread", title: "Unread", icon: "bell.circle.fill", colorCategory: "warning", route: "/notifications/unread", priority: 80, providedBy: "NotificationKit"),
                SidebarItemDefinition(id: "notifications.settings", title: "Settings", icon: "gearshape.fill", colorCategory: "neutral", route: "/notifications/settings", priority: 70, providedBy: "NotificationKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
