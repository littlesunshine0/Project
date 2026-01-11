//
//  SidebarItemCommand.swift
//  CommandKit
//
//  Sidebar items provided by CommandKit
//

import Foundation
import DataKit

/// Sidebar items provided by CommandKit
public struct SidebarItemCommand {
    
    /// All sidebar items provided by CommandKit
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "commands",
            title: "Commands",
            icon: "terminal.fill",
            colorCategory: "commands",
            route: "/commands",
            priority: 70,
            providedBy: "CommandKit",
            children: [
                SidebarItemDefinition(
                    id: "commands.library",
                    title: "Library",
                    icon: "books.vertical.fill",
                    colorCategory: "commands",
                    route: "/commands/library",
                    priority: 90,
                    providedBy: "CommandKit"
                ),
                SidebarItemDefinition(
                    id: "commands.shell",
                    title: "Shell",
                    icon: "terminal",
                    colorCategory: "commands",
                    route: "/commands/shell",
                    priority: 80,
                    providedBy: "CommandKit"
                ),
                SidebarItemDefinition(
                    id: "commands.favorites",
                    title: "Favorites",
                    icon: "star.fill",
                    colorCategory: "warning",
                    route: "/commands/favorites",
                    priority: 70,
                    providedBy: "CommandKit"
                ),
                SidebarItemDefinition(
                    id: "commands.history",
                    title: "History",
                    icon: "clock.arrow.circlepath",
                    colorCategory: "commands",
                    route: "/commands/history",
                    priority: 60,
                    providedBy: "CommandKit"
                )
            ]
        )
    ]
    
    /// Register CommandKit's sidebar items
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
