//
//  SidebarItemAnalytics.swift
//  AnalyticsKit
//
//  Sidebar items provided by AnalyticsKit
//

import Foundation
import DataKit

/// Sidebar items provided by AnalyticsKit
public struct SidebarItemAnalytics {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "analytics",
            title: "Analytics",
            icon: "chart.bar.fill",
            colorCategory: "dashboard",
            route: "/analytics",
            priority: 35,
            providedBy: "AnalyticsKit",
            children: [
                SidebarItemDefinition(id: "analytics.dashboard", title: "Dashboard", icon: "square.grid.2x2.fill", colorCategory: "dashboard", route: "/analytics/dashboard", priority: 90, providedBy: "AnalyticsKit"),
                SidebarItemDefinition(id: "analytics.reports", title: "Reports", icon: "doc.text.fill", colorCategory: "info", route: "/analytics/reports", priority: 80, providedBy: "AnalyticsKit"),
                SidebarItemDefinition(id: "analytics.trends", title: "Trends", icon: "chart.xyaxis.line", colorCategory: "success", route: "/analytics/trends", priority: 70, providedBy: "AnalyticsKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
