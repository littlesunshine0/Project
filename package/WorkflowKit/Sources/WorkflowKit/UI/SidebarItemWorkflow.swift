//
//  SidebarItemWorkflow.swift
//  WorkflowKit
//
//  Sidebar items provided by WorkflowKit
//

import Foundation
import DataKit

/// Sidebar items provided by WorkflowKit
public struct SidebarItemWorkflow {
    
    /// All sidebar items provided by WorkflowKit
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "workflows",
            title: "Workflows",
            icon: "arrow.triangle.branch",
            colorCategory: "workflows",
            route: "/workflows",
            priority: 85,
            providedBy: "WorkflowKit",
            children: [
                SidebarItemDefinition(
                    id: "workflows.all",
                    title: "All Workflows",
                    icon: "list.bullet",
                    colorCategory: "workflows",
                    route: "/workflows/all",
                    priority: 90,
                    providedBy: "WorkflowKit"
                ),
                SidebarItemDefinition(
                    id: "workflows.development",
                    title: "Development",
                    icon: "hammer.fill",
                    colorCategory: "workflows",
                    route: "/workflows/development",
                    priority: 80,
                    providedBy: "WorkflowKit"
                ),
                SidebarItemDefinition(
                    id: "workflows.testing",
                    title: "Testing",
                    icon: "checkmark.seal.fill",
                    colorCategory: "success",
                    route: "/workflows/testing",
                    priority: 70,
                    providedBy: "WorkflowKit"
                ),
                SidebarItemDefinition(
                    id: "workflows.templates",
                    title: "Templates",
                    icon: "doc.on.doc.fill",
                    colorCategory: "neutral",
                    route: "/workflows/templates",
                    priority: 60,
                    providedBy: "WorkflowKit"
                )
            ]
        )
    ]
    
    /// Register WorkflowKit's sidebar items
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
