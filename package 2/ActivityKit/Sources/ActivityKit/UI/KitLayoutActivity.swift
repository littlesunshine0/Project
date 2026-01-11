//
//  KitLayoutActivity.swift
//  ActivityKit
//
//  Complete layout configuration for ActivityKit
//

import Foundation
import DataKit

public struct KitLayoutActivity {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
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
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "activity.log", title: "Activity", icon: "waveform.path.ecg", colorCategory: "activity", hasInput: false, priority: 40, providedBy: "ActivityKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "activity.properties", type: .properties, title: "Activity Properties", colorCategory: "activity", priority: 90, providedBy: "ActivityKit", isDefault: true),
        InspectorDefinition(id: "activity.history", type: .historyInspector, title: "Activity History", colorCategory: "activity", priority: 85, providedBy: "ActivityKit"),
        InspectorDefinition(id: "activity.performance", type: .performance, title: "Performance", colorCategory: "activity", priority: 80, providedBy: "ActivityKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "activity.inspectorPanel", title: "Activity Inspector", icon: "waveform.path.ecg", colorCategory: "activity", priority: 75, providedBy: "ActivityKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "activity.dashboard", title: "Activity Dashboard", icon: "waveform.path.ecg", colorCategory: "activity", route: "/activity", providedBy: "ActivityKit", supportedInspectors: [.properties, .historyInspector, .performance], defaultRightSidebar: "activity.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "activitykit.layout", kitName: "ActivityKit", displayName: "Activity", icon: "waveform.path.ecg", colorCategory: "activity",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
