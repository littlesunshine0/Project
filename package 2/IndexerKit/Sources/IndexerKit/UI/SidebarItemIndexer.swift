//
//  SidebarItemIndexer.swift
//  IndexerKit
//
//  Sidebar items provided by IndexerKit
//

import Foundation
import DataKit

/// Sidebar items provided by IndexerKit
public struct SidebarItemIndexer {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "indexer",
            title: "Indexer",
            icon: "doc.text.magnifyingglass",
            colorCategory: "info",
            route: "/indexer",
            priority: 30,
            providedBy: "IndexerKit",
            children: [
                SidebarItemDefinition(id: "indexer.docs", title: "Documents", icon: "doc.fill", colorCategory: "documentation", route: "/indexer/docs", priority: 90, providedBy: "IndexerKit"),
                SidebarItemDefinition(id: "indexer.code", title: "Code", icon: "chevron.left.forwardslash.chevron.right", colorCategory: "projects", route: "/indexer/code", priority: 80, providedBy: "IndexerKit"),
                SidebarItemDefinition(id: "indexer.status", title: "Status", icon: "chart.bar.fill", colorCategory: "success", route: "/indexer/status", priority: 70, providedBy: "IndexerKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
