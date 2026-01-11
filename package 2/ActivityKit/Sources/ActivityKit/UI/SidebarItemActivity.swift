//
//  SidebarItemActivity.swift
//  ActivityKit
//
//  Sidebar items provided by ActivityKit
//

import Foundation
import DataKit

/// Sidebar items provided by ActivityKit
public struct SidebarItemActivity {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "activity",
            title: "Activity",
            icon: "waveform.path.ecg",
            colorCategory: "activity",
            route: "/activity",
            priority: 60,
            providedBy: "ActivityKit",
            children: [
                SidebarItemDefinition(id: "activity.recent", title: "Recent", icon: "clock.fill", colorCategory: "activity", route: "/activity/recent", priority: 90, providedBy: "ActivityKit"),
                SidebarItemDefinition(id: "activity.timeline", title: "Timeline", icon: "timeline.selection", colorCategory: "activity", route: "/activity/timeline", priority: 80, providedBy: "ActivityKit"),
                SidebarItemDefinition(id: "activity.stats", title: "Statistics", icon: "chart.bar.fill", colorCategory: "info", route: "/activity/stats", priority: 70, providedBy: "ActivityKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
