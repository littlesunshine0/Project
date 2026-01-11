//
//  BottomPanelItemKnowledge.swift
//  KnowledgeKit
//
//  Bottom panel items provided by KnowledgeKit
//

import Foundation
import DataKit

/// Bottom panel items provided by KnowledgeKit
public struct BottomPanelItemKnowledge {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "knowledge.browser",
            title: "Knowledge",
            icon: "brain.head.profile",
            colorCategory: "knowledge",
            hasInput: true,
            placeholder: "Ask knowledge base...",
            priority: 55,
            providedBy: "KnowledgeKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
