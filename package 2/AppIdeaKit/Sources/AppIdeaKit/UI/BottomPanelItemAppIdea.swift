//
//  BottomPanelItemAppIdea.swift
//  AppIdeaKit
//
//  Bottom panel items provided by AppIdeaKit
//

import Foundation
import DataKit

/// Bottom panel items provided by AppIdeaKit
public struct BottomPanelItemAppIdea {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "appIdea.input",
            title: "Ideas",
            icon: "lightbulb.fill",
            colorCategory: "idea",
            hasInput: true,
            placeholder: "Describe your app idea...",
            priority: 35,
            providedBy: "AppIdeaKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
