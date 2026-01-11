//
//  KitLayoutAnalytics.swift
//  AnalyticsKit
//
//  Complete layout configuration for AnalyticsKit
//

import Foundation
import DataKit

public struct KitLayoutAnalytics {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "analytics",
            title: "Analytics",
            icon: "chart.bar.fill",
            colorCategory: "analytics",
            route: "/analytics",
            priority: 65,
            providedBy: "AnalyticsKit",
            children: [
                SidebarItemDefinition(id: "analytics.dashboard", title: "Dashboard", icon: "gauge.with.dots.needle.bottom.50percent", colorCategory: "analytics", route: "/analytics/dashboard", priority: 90, providedBy: "AnalyticsKit"),
                SidebarItemDefinition(id: "analytics.reports", title: "Reports", icon: "doc.text.fill", colorCategory: "analytics", route: "/analytics/reports", priority: 80, providedBy: "AnalyticsKit"),
                SidebarItemDefinition(id: "analytics.metrics", title: "Metrics", icon: "chart.line.uptrend.xyaxis", colorCategory: "analytics", route: "/analytics/metrics", priority: 70, providedBy: "AnalyticsKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "analytics.output", title: "Analytics", icon: "chart.bar.fill", colorCategory: "analytics", hasInput: false, priority: 55, providedBy: "AnalyticsKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "analytics.properties", type: .properties, title: "Chart Properties", colorCategory: "analytics", priority: 90, providedBy: "AnalyticsKit", isDefault: true),
        InspectorDefinition(id: "analytics.performance", type: .performance, title: "Performance", colorCategory: "analytics", priority: 85, providedBy: "AnalyticsKit"),
        InspectorDefinition(id: "analytics.metadata", type: .metadataPreview, title: "Data Info", colorCategory: "analytics", priority: 75, providedBy: "AnalyticsKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "analytics.inspectorPanel", title: "Analytics Inspector", icon: "chart.bar.fill", colorCategory: "analytics", priority: 85, providedBy: "AnalyticsKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "analytics.filtersPanel", title: "Filters", icon: "line.3.horizontal.decrease.circle.fill", colorCategory: "analytics", priority: 75, providedBy: "AnalyticsKit", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "analytics.dashboard", title: "Analytics Dashboard", icon: "chart.bar.fill", colorCategory: "analytics", route: "/analytics", providedBy: "AnalyticsKit", supportedInspectors: [.properties, .performance, .metadataPreview], defaultRightSidebar: "analytics.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "analyticskit.layout", kitName: "AnalyticsKit", displayName: "Analytics", icon: "chart.bar.fill", colorCategory: "analytics",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
