//
//  KitLayoutKnowledge.swift
//  KnowledgeKit
//
//  Complete layout configuration for KnowledgeKit
//

import Foundation
import DataKit

public struct KitLayoutKnowledge {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "knowledge",
            title: "Knowledge",
            icon: "brain.fill",
            colorCategory: "knowledge",
            route: "/knowledge",
            priority: 72,
            providedBy: "KnowledgeKit",
            children: [
                SidebarItemDefinition(id: "knowledge.base", title: "Knowledge Base", icon: "books.vertical.fill", colorCategory: "knowledge", route: "/knowledge/base", priority: 90, providedBy: "KnowledgeKit"),
                SidebarItemDefinition(id: "knowledge.graph", title: "Knowledge Graph", icon: "point.3.connected.trianglepath.dotted", colorCategory: "knowledge", route: "/knowledge/graph", priority: 80, providedBy: "KnowledgeKit"),
                SidebarItemDefinition(id: "knowledge.search", title: "Search", icon: "magnifyingglass", colorCategory: "knowledge", route: "/knowledge/search", priority: 70, providedBy: "KnowledgeKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "knowledge.search", title: "Knowledge Search", icon: "brain.fill", colorCategory: "knowledge", hasInput: true, placeholder: "Search knowledge...", priority: 58, providedBy: "KnowledgeKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "knowledge.properties", type: .properties, title: "Entry Properties", colorCategory: "knowledge", priority: 90, providedBy: "KnowledgeKit", isDefault: true),
        InspectorDefinition(id: "knowledge.connections", type: .connections, title: "Connections", colorCategory: "knowledge", priority: 85, providedBy: "KnowledgeKit"),
        InspectorDefinition(id: "knowledge.preview", type: .filePreview, title: "Preview", colorCategory: "knowledge", priority: 80, providedBy: "KnowledgeKit"),
        InspectorDefinition(id: "knowledge.metadata", type: .metadataPreview, title: "Metadata", colorCategory: "knowledge", priority: 75, providedBy: "KnowledgeKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "knowledge.inspectorPanel", title: "Knowledge Inspector", icon: "brain.fill", colorCategory: "knowledge", priority: 85, providedBy: "KnowledgeKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "knowledge.relatedPanel", title: "Related", icon: "link", colorCategory: "knowledge", priority: 75, providedBy: "KnowledgeKit", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "knowledge.browser", title: "Knowledge Browser", icon: "brain.fill", colorCategory: "knowledge", route: "/knowledge", providedBy: "KnowledgeKit", supportedInspectors: [.properties, .connections, .filePreview, .metadataPreview], defaultRightSidebar: "knowledge.inspectorPanel", defaultBottomPanel: "knowledge.search")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "knowledgekit.layout", kitName: "KnowledgeKit", displayName: "Knowledge", icon: "brain.fill", colorCategory: "knowledge",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
