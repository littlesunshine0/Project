//
//  KitLayoutNotification.swift
//  NotificationKit
//
//  Complete layout configuration for NotificationKit
//

import Foundation
import DataKit

public struct KitLayoutNotification {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "notifications",
            title: "Notifications",
            icon: "bell.fill",
            colorCategory: "notification",
            route: "/notifications",
            priority: 92,
            providedBy: "NotificationKit",
            children: [
                SidebarItemDefinition(id: "notifications.all", title: "All", icon: "bell.fill", colorCategory: "notification", route: "/notifications/all", priority: 90, providedBy: "NotificationKit"),
                SidebarItemDefinition(id: "notifications.unread", title: "Unread", icon: "bell.badge.fill", colorCategory: "notification", route: "/notifications/unread", priority: 80, providedBy: "NotificationKit"),
                SidebarItemDefinition(id: "notifications.settings", title: "Settings", icon: "gearshape.fill", colorCategory: "notification", route: "/notifications/settings", priority: 70, providedBy: "NotificationKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "notifications.feed", title: "Notifications", icon: "bell.fill", colorCategory: "notification", hasInput: false, priority: 88, providedBy: "NotificationKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "notification.properties", type: .properties, title: "Notification Details", colorCategory: "notification", priority: 90, providedBy: "NotificationKit", isDefault: true),
        InspectorDefinition(id: "notification.history", type: .historyInspector, title: "History", colorCategory: "notification", priority: 80, providedBy: "NotificationKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "notification.panel", title: "Notifications", icon: "bell.fill", colorCategory: "notification", priority: 95, providedBy: "NotificationKit", inspectors: inspectors, supportsMultiple: false, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "notification.center", title: "Notification Center", icon: "bell.fill", colorCategory: "notification", route: "/notifications", providedBy: "NotificationKit", supportedInspectors: [.properties, .historyInspector], defaultRightSidebar: "notification.panel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "notificationkit.layout", kitName: "NotificationKit", displayName: "Notifications", icon: "bell.fill", colorCategory: "notification",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
