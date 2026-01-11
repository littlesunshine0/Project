//
//  SidebarItemParse.swift
//  ParseKit
//
//  Sidebar items provided by ParseKit
//

import Foundation
import DataKit

/// Sidebar items provided by ParseKit
public struct SidebarItemParse {
    
    public static let items: [SidebarItemDefinition] = [
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
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
