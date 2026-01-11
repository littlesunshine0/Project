//
//  BottomPanelItemOrchestrator.swift
//  KitOrchestrator
//
//  Bottom panel items provided by KitOrchestrator
//

import Foundation
import DataKit

/// Bottom panel items provided by KitOrchestrator
public struct BottomPanelItemOrchestrator {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "orchestrator.console",
            title: "Orchestrator",
            icon: "wand.and.stars",
            colorCategory: "orchestrator",
            hasInput: false,
            placeholder: "",
            priority: 55,
            providedBy: "KitOrchestrator"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
