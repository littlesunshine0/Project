//
//  SidebarItemNLU.swift
//  NLUKit
//
//  Sidebar items provided by NLUKit
//

import Foundation
import DataKit

/// Sidebar items provided by NLUKit
public struct SidebarItemNLU {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "nlu",
            title: "NLU",
            icon: "text.magnifyingglass",
            colorCategory: "chat",
            route: "/nlu",
            priority: 25,
            providedBy: "NLUKit",
            children: [
                SidebarItemDefinition(id: "nlu.intents", title: "Intents", icon: "target", colorCategory: "chat", route: "/nlu/intents", priority: 90, providedBy: "NLUKit"),
                SidebarItemDefinition(id: "nlu.entities", title: "Entities", icon: "tag.fill", colorCategory: "info", route: "/nlu/entities", priority: 80, providedBy: "NLUKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
