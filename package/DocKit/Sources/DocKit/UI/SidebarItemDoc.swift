//
//  SidebarItemDoc.swift
//  DocKit
//
//  Sidebar items provided by DocKit
//

import Foundation
import DataKit

/// Sidebar items provided by DocKit
public struct SidebarItemDoc {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "documentation",
            title: "Documentation",
            icon: "book.closed.fill",
            colorCategory: "documentation",
            route: "/documentation",
            priority: 60,
            providedBy: "DocKit",
            children: [
                SidebarItemDefinition(id: "documentation.apple", title: "Apple Docs", icon: "apple.logo", colorCategory: "documentation", route: "/documentation/apple", priority: 90, providedBy: "DocKit"),
                SidebarItemDefinition(id: "documentation.swift", title: "Swift.org", icon: "swift", colorCategory: "agents", route: "/documentation/swift", priority: 80, providedBy: "DocKit"),
                SidebarItemDefinition(id: "documentation.search", title: "Search", icon: "magnifyingglass", colorCategory: "search", route: "/documentation/search", priority: 70, providedBy: "DocKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
