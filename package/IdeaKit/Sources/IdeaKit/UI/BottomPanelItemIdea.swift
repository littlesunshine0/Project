//
//  BottomPanelItemIdea.swift
//  IdeaKit
//
//  Bottom panel items provided by IdeaKit
//

import Foundation
import DataKit

/// Bottom panel items provided by IdeaKit
public struct BottomPanelItemIdea {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "ideas.quick",
            title: "Ideas",
            icon: "sparkles",
            colorCategory: "idea",
            hasInput: true,
            placeholder: "Quick idea...",
            priority: 32,
            providedBy: "IdeaKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
