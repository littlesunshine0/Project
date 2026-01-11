//
//  BottomPanelItemBridge.swift
//  BridgeKit
//
//  Bottom panel items provided by BridgeKit
//

import Foundation
import DataKit

/// Bottom panel items provided by BridgeKit
public struct BottomPanelItemBridge {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "bridge.console",
            title: "Bridge",
            icon: "arrow.left.arrow.right",
            colorCategory: "bridge",
            hasInput: false,
            placeholder: "",
            priority: 25,
            providedBy: "BridgeKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
