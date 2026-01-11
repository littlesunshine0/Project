//
//  SidebarItemSyntax.swift
//  SyntaxKit
//
//  Sidebar items provided by SyntaxKit
//

import Foundation
import DataKit

/// Sidebar items provided by SyntaxKit
public struct SidebarItemSyntax {
    
    public static let items: [SidebarItemDefinition] = [
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
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
