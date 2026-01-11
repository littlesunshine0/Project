//
//  KitLayoutLearn.swift
//  LearnKit
//
//  Complete layout configuration for LearnKit
//

import Foundation
import DataKit

public struct KitLayoutLearn {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "learn",
            title: "Learn",
            icon: "graduationcap.fill",
            colorCategory: "learn",
            route: "/learn",
            priority: 68,
            providedBy: "LearnKit",
            children: [
                SidebarItemDefinition(id: "learn.tutorials", title: "Tutorials", icon: "play.rectangle.fill", colorCategory: "learn", route: "/learn/tutorials", priority: 90, providedBy: "LearnKit"),
                SidebarItemDefinition(id: "learn.courses", title: "Courses", icon: "book.fill", colorCategory: "learn", route: "/learn/courses", priority: 80, providedBy: "LearnKit"),
                SidebarItemDefinition(id: "learn.progress", title: "Progress", icon: "chart.bar.fill", colorCategory: "learn", route: "/learn/progress", priority: 70, providedBy: "LearnKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "learn.output", title: "Learn", icon: "graduationcap.fill", colorCategory: "learn", hasInput: false, priority: 52, providedBy: "LearnKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "learn.properties", type: .properties, title: "Lesson Properties", colorCategory: "learn", priority: 90, providedBy: "LearnKit", isDefault: true),
        InspectorDefinition(id: "learn.livePreview", type: .livePreview, title: "Live Preview", colorCategory: "learn", priority: 85, providedBy: "LearnKit"),
        InspectorDefinition(id: "learn.quickHelp", type: .quickHelp, title: "Help", colorCategory: "learn", priority: 80, providedBy: "LearnKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "learn.inspectorPanel", title: "Learn Inspector", icon: "graduationcap.fill", colorCategory: "learn", priority: 80, providedBy: "LearnKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "learn.outlinePanel", title: "Outline", icon: "list.bullet", colorCategory: "learn", priority: 70, providedBy: "LearnKit", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "learn.viewer", title: "Learning", icon: "graduationcap.fill", colorCategory: "learn", route: "/learn", providedBy: "LearnKit", supportedInspectors: [.properties, .livePreview, .quickHelp], defaultRightSidebar: "learn.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "learnkit.layout", kitName: "LearnKit", displayName: "Learn", icon: "graduationcap.fill", colorCategory: "learn",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
