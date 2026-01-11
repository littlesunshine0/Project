//
//  KitLayoutParse.swift
//  ParseKit
//
//  Complete layout configuration for ParseKit
//

import Foundation
import DataKit

public struct KitLayoutParse {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "parse",
            title: "Parser",
            icon: "doc.text.magnifyingglass",
            colorCategory: "parse",
            route: "/parse",
            priority: 38,
            providedBy: "ParseKit",
            children: [
                SidebarItemDefinition(id: "parse.ast", title: "AST View", icon: "tree", colorCategory: "parse", route: "/parse/ast", priority: 90, providedBy: "ParseKit"),
                SidebarItemDefinition(id: "parse.tokens", title: "Tokens", icon: "list.bullet.rectangle", colorCategory: "parse", route: "/parse/tokens", priority: 80, providedBy: "ParseKit"),
                SidebarItemDefinition(id: "parse.rules", title: "Rules", icon: "checklist", colorCategory: "info", route: "/parse/rules", priority: 70, providedBy: "ParseKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "parse.output", title: "Parser", icon: "doc.text.magnifyingglass", colorCategory: "parse", hasInput: false, priority: 22, providedBy: "ParseKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "parse.properties", type: .properties, title: "Parse Properties", colorCategory: "parse", priority: 90, providedBy: "ParseKit", isDefault: true),
        InspectorDefinition(id: "parse.livePreview", type: .livePreview, title: "AST Preview", colorCategory: "parse", priority: 85, providedBy: "ParseKit"),
        InspectorDefinition(id: "parse.debug", type: .debug, title: "Parse Debug", colorCategory: "parse", priority: 80, providedBy: "ParseKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "parse.inspectorPanel", title: "Parse Inspector", icon: "doc.text.magnifyingglass", colorCategory: "parse", priority: 55, providedBy: "ParseKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "parse.viewer", title: "Parser Viewer", icon: "doc.text.magnifyingglass", colorCategory: "parse", route: "/parse", providedBy: "ParseKit", supportedInspectors: [.properties, .livePreview, .debug], defaultRightSidebar: "parse.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "parsekit.layout", kitName: "ParseKit", displayName: "Parser", icon: "doc.text.magnifyingglass", colorCategory: "parse",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
