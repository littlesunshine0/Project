//
//  SidebarItemKnowledge.swift
//  KnowledgeKit
//
//  Sidebar items provided by KnowledgeKit
//

import Foundation
import DataKit

/// Sidebar items provided by KnowledgeKit
public struct SidebarItemKnowledge {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "knowledge",
            title: "Knowledge",
            icon: "brain.head.profile",
            colorCategory: "knowledge",
            route: "/knowledge",
            priority: 55,
            providedBy: "KnowledgeKit",
            children: [
                SidebarItemDefinition(id: "knowledge.base", title: "Knowledge Base", icon: "books.vertical.fill", colorCategory: "knowledge", route: "/knowledge/base", priority: 90, providedBy: "KnowledgeKit"),
                SidebarItemDefinition(id: "knowledge.indexed", title: "Indexed", icon: "doc.text.magnifyingglass", colorCategory: "knowledge", route: "/knowledge/indexed", priority: 80, providedBy: "KnowledgeKit"),
                SidebarItemDefinition(id: "knowledge.sources", title: "Sources", icon: "link", colorCategory: "info", route: "/knowledge/sources", priority: 70, providedBy: "KnowledgeKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
