//
//  SidebarItemError.swift
//  ErrorKit
//
//  Sidebar items provided by ErrorKit
//

import Foundation
import DataKit

/// Sidebar items provided by ErrorKit
public struct SidebarItemError {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "errors",
            title: "Errors",
            icon: "exclamationmark.triangle.fill",
            colorCategory: "error",
            route: "/errors",
            priority: 40,
            providedBy: "ErrorKit",
            children: [
                SidebarItemDefinition(id: "errors.current", title: "Current", icon: "xmark.circle.fill", colorCategory: "error", route: "/errors/current", priority: 90, providedBy: "ErrorKit"),
                SidebarItemDefinition(id: "errors.history", title: "History", icon: "clock.fill", colorCategory: "error", route: "/errors/history", priority: 80, providedBy: "ErrorKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
