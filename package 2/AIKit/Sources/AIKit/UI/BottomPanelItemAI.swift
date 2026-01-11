//
//  BottomPanelItemAI.swift
//  AIKit
//
//  Bottom panel items provided by AIKit
//

import Foundation
import DataKit

/// Bottom panel items provided by AIKit
public struct BottomPanelItemAI {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "ai.assistant",
            title: "AI Assistant",
            icon: "sparkles",
            colorCategory: "chat",
            hasInput: true,
            placeholder: "Ask AI...",
            priority: 98,
            providedBy: "AIKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
