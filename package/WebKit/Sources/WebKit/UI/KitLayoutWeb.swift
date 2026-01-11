//
//  KitLayoutWeb.swift
//  WebKit
//
//  Complete layout configuration for WebKit
//

import Foundation
import DataKit

public struct KitLayoutWeb {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "web",
            title: "Web",
            icon: "globe",
            colorCategory: "web",
            route: "/web",
            priority: 35,
            providedBy: "WebKit",
            children: [
                SidebarItemDefinition(id: "web.preview", title: "Preview", icon: "eye.fill", colorCategory: "web", route: "/web/preview", priority: 90, providedBy: "WebKit"),
                SidebarItemDefinition(id: "web.inspector", title: "Inspector", icon: "magnifyingglass", colorCategory: "web", route: "/web/inspector", priority: 80, providedBy: "WebKit"),
                SidebarItemDefinition(id: "web.console", title: "Console", icon: "terminal.fill", colorCategory: "info", route: "/web/console", priority: 70, providedBy: "WebKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "web.console", title: "Web Console", icon: "globe", colorCategory: "web", hasInput: true, placeholder: "Enter JavaScript...", priority: 24, providedBy: "WebKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "web.properties", type: .properties, title: "Element Properties", colorCategory: "web", priority: 90, providedBy: "WebKit", isDefault: true),
        InspectorDefinition(id: "web.livePreview", type: .livePreview, title: "Live Preview", colorCategory: "web", priority: 88, providedBy: "WebKit"),
        InspectorDefinition(id: "web.accessibility", type: .accessibility, title: "Accessibility", colorCategory: "web", priority: 82, providedBy: "WebKit"),
        InspectorDefinition(id: "web.performance", type: .performance, title: "Performance", colorCategory: "web", priority: 78, providedBy: "WebKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "web.inspectorPanel", title: "Web Inspector", icon: "globe", colorCategory: "web", priority: 50, providedBy: "WebKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "web.domPanel", title: "DOM Tree", icon: "list.bullet.indent", colorCategory: "web", priority: 40, providedBy: "WebKit", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "web.browser", title: "Web Browser", icon: "globe", colorCategory: "web", route: "/web", providedBy: "WebKit", supportedInspectors: [.properties, .livePreview, .accessibility, .performance], defaultRightSidebar: "web.inspectorPanel", defaultBottomPanel: "web.console")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "webkit.layout", kitName: "WebKit", displayName: "Web", icon: "globe", colorCategory: "web",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
