//
//  SidebarItemOrchestrator.swift
//  KitOrchestrator
//
//  Sidebar items provided by KitOrchestrator
//

import Foundation
import DataKit

/// Sidebar items provided by KitOrchestrator
public struct SidebarItemOrchestrator {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "orchestrator",
            title: "Orchestrator",
            icon: "wand.and.stars",
            colorCategory: "orchestrator",
            route: "/orchestrator",
            priority: 90,
            providedBy: "KitOrchestrator",
            children: [
                SidebarItemDefinition(id: "orchestrator.kits", title: "Kits", icon: "shippingbox.fill", colorCategory: "orchestrator", route: "/orchestrator/kits", priority: 90, providedBy: "KitOrchestrator"),
                SidebarItemDefinition(id: "orchestrator.pipelines", title: "Pipelines", icon: "arrow.triangle.branch", colorCategory: "orchestrator", route: "/orchestrator/pipelines", priority: 80, providedBy: "KitOrchestrator"),
                SidebarItemDefinition(id: "orchestrator.status", title: "Status", icon: "checkmark.circle.fill", colorCategory: "success", route: "/orchestrator/status", priority: 70, providedBy: "KitOrchestrator")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
