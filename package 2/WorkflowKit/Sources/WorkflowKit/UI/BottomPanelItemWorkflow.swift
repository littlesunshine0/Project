//
//  BottomPanelItemWorkflow.swift
//  WorkflowKit
//
//  Bottom panel items provided by WorkflowKit
//

import Foundation
import DataKit

/// Bottom panel items provided by WorkflowKit
public struct BottomPanelItemWorkflow {
    
    /// All bottom panel tabs provided by WorkflowKit
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "workflow.runner",
            title: "Workflow Runner",
            icon: "play.circle.fill",
            colorCategory: "workflows",
            hasInput: false,
            placeholder: "",
            priority: 60,
            providedBy: "WorkflowKit"
        )
    ]
    
    /// Register WorkflowKit's bottom panel items
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
