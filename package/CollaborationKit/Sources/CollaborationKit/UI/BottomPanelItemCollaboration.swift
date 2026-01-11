//
//  BottomPanelItemCollaboration.swift
//  CollaborationKit
//
//  Bottom panel items provided by CollaborationKit
//

import Foundation
import DataKit

/// Bottom panel items provided by CollaborationKit
public struct BottomPanelItemCollaboration {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "collaboration.live",
            title: "Live Session",
            icon: "person.2.fill",
            colorCategory: "chat",
            hasInput: true,
            placeholder: "Message team...",
            priority: 50,
            providedBy: "CollaborationKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
