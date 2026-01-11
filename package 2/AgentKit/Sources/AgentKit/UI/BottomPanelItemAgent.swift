//
//  BottomPanelItemAgent.swift
//  AgentKit
//
//  Bottom panel items provided by AgentKit
//

import Foundation
import DataKit

/// Bottom panel items provided by AgentKit
public struct BottomPanelItemAgent {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "agent.runner",
            title: "Agent Runner",
            icon: "cpu.fill",
            colorCategory: "agents",
            hasInput: true,
            placeholder: "Enter agent command...",
            priority: 75,
            providedBy: "AgentKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
