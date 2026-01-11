//
//  BottomPanelItemNLU.swift
//  NLUKit
//
//  Bottom panel items provided by NLUKit
//

import Foundation
import DataKit

/// Bottom panel items provided by NLUKit
public struct BottomPanelItemNLU {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "nlu.intent",
            title: "Intent Analysis",
            icon: "text.magnifyingglass",
            colorCategory: "chat",
            hasInput: true,
            placeholder: "Analyze intent...",
            priority: 25,
            providedBy: "NLUKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
