//
//  BottomPanelItemContentHub.swift
//  ContentHub
//
//  Bottom panel items provided by ContentHub
//

import Foundation
import DataKit

/// Bottom panel items provided by ContentHub
public struct BottomPanelItemContentHub {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "contentHub.browser",
            title: "Content",
            icon: "square.stack.3d.up.fill",
            colorCategory: "content",
            hasInput: false,
            placeholder: "",
            priority: 38,
            providedBy: "ContentHub"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
