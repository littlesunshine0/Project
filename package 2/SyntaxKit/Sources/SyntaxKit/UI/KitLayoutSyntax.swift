//
//  KitLayoutSyntax.swift
//  SyntaxKit
//
//  Complete layout configuration for SyntaxKit
//

import Foundation
import DataKit

public struct KitLayoutSyntax {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "syntax",
            title: "Syntax",
            icon: "chevron.left.forwardslash.chevron.right",
            colorCategory: "syntax",
            route: "/syntax",
            priority: 36,
            providedBy: "SyntaxKit",
            children: [
                SidebarItemDefinition(id: "syntax.highlighting", title: "Highlighting", icon: "paintbrush.fill", colorCategory: "syntax", route: "/syntax/highlighting", priority: 90, providedBy: "SyntaxKit"),
                SidebarItemDefinition(id: "syntax.themes", title: "Themes", icon: "paintpalette.fill", colorCategory: "design", route: "/syntax/themes", priority: 80, providedBy: "SyntaxKit"),
                SidebarItemDefinition(id: "syntax.languages", title: "Languages", icon: "globe", colorCategory: "info", route: "/syntax/languages", priority: 70, providedBy: "SyntaxKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "syntax.inspector", title: "Syntax", icon: "chevron.left.forwardslash.chevron.right", colorCategory: "syntax", hasInput: false, priority: 18, providedBy: "SyntaxKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "syntax.properties", type: .properties, title: "Syntax Properties", colorCategory: "syntax", priority: 90, providedBy: "SyntaxKit", isDefault: true),
        InspectorDefinition(id: "syntax.livePreview", type: .livePreview, title: "Syntax Preview", colorCategory: "syntax", priority: 85, providedBy: "SyntaxKit"),
        InspectorDefinition(id: "syntax.quickHelp", type: .quickHelp, title: "Syntax Help", colorCategory: "syntax", priority: 80, providedBy: "SyntaxKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "syntax.inspectorPanel", title: "Syntax Inspector", icon: "chevron.left.forwardslash.chevron.right", colorCategory: "syntax", priority: 52, providedBy: "SyntaxKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "syntax.editor", title: "Syntax Editor", icon: "chevron.left.forwardslash.chevron.right", colorCategory: "syntax", route: "/syntax", providedBy: "SyntaxKit", supportedInspectors: [.properties, .livePreview, .quickHelp], defaultRightSidebar: "syntax.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "syntaxkit.layout", kitName: "SyntaxKit", displayName: "Syntax", icon: "chevron.left.forwardslash.chevron.right", colorCategory: "syntax",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
