//
//  BottomPanelItemLearn.swift
//  LearnKit
//
//  Bottom panel items provided by LearnKit
//

import Foundation
import DataKit

/// Bottom panel items provided by LearnKit
public struct BottomPanelItemLearn {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "learn.walkthrough",
            title: "Walkthrough",
            icon: "graduationcap.fill",
            colorCategory: "learn",
            hasInput: false,
            placeholder: "",
            priority: 35,
            providedBy: "LearnKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
