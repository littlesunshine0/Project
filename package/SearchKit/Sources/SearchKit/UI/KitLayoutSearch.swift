//
//  KitLayoutSearch.swift
//  SearchKit
//
//  Complete layout configuration for SearchKit
//

import Foundation
import DataKit

public struct KitLayoutSearch {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "search",
            title: "Search",
            icon: "magnifyingglass",
            colorCategory: "search",
            route: "/search",
            priority: 90,
            providedBy: "SearchKit",
            children: [
                SidebarItemDefinition(id: "search.global", title: "Global Search", icon: "magnifyingglass", colorCategory: "search", route: "/search/global", priority: 90, providedBy: "SearchKit"),
                SidebarItemDefinition(id: "search.files", title: "Find in Files", icon: "doc.text.magnifyingglass", colorCategory: "search", route: "/search/files", priority: 80, providedBy: "SearchKit"),
                SidebarItemDefinition(id: "search.replace", title: "Find & Replace", icon: "arrow.left.arrow.right", colorCategory: "search", route: "/search/replace", priority: 70, providedBy: "SearchKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "search.results", title: "Search Results", icon: "magnifyingglass", colorCategory: "search", hasInput: true, placeholder: "Search...", priority: 90, providedBy: "SearchKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "search.filePreview", type: .filePreview, title: "Result Preview", colorCategory: "search", priority: 90, providedBy: "SearchKit", isDefault: true),
        InspectorDefinition(id: "search.properties", type: .properties, title: "Search Options", colorCategory: "search", priority: 80, providedBy: "SearchKit"),
        InspectorDefinition(id: "search.history", type: .historyInspector, title: "Search History", colorCategory: "search", priority: 70, providedBy: "SearchKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "search.previewPanel", title: "Preview", icon: "eye.fill", colorCategory: "search", priority: 90, providedBy: "SearchKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "search.main", title: "Search", icon: "magnifyingglass", colorCategory: "search", route: "/search", providedBy: "SearchKit", supportedInspectors: [.filePreview, .properties, .historyInspector], defaultRightSidebar: "search.previewPanel", defaultBottomPanel: "search.results")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "searchkit.layout", kitName: "SearchKit", displayName: "Search", icon: "magnifyingglass", colorCategory: "search",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
