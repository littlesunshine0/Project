//
//  SidebarItemAgent.swift
//  AgentKit
//
//  Sidebar items provided by AgentKit
//

import Foundation
import DataKit

/// Sidebar items provided by AgentKit
public struct SidebarItemAgent {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "agents",
            title: "Agents",
            icon: "cpu.fill",
            colorCategory: "agents",
            route: "/agents",
            priority: 80,
            providedBy: "AgentKit",
            children: [
                SidebarItemDefinition(id: "agents.active", title: "Active", icon: "play.circle.fill", colorCategory: "success", route: "/agents/active", priority: 90, providedBy: "AgentKit"),
                SidebarItemDefinition(id: "agents.all", title: "All Agents", icon: "list.bullet", colorCategory: "agents", route: "/agents/all", priority: 80, providedBy: "AgentKit"),
                SidebarItemDefinition(id: "agents.history", title: "Run History", icon: "clock.arrow.circlepath", colorCategory: "info", route: "/agents/history", priority: 70, providedBy: "AgentKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
