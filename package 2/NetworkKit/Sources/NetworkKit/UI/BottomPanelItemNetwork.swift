//
//  BottomPanelItemNetwork.swift
//  NetworkKit
//
//  Bottom panel items provided by NetworkKit
//

import Foundation
import DataKit

/// Bottom panel items provided by NetworkKit
public struct BottomPanelItemNetwork {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "network.inspector",
            title: "Network",
            icon: "network",
            colorCategory: "network",
            hasInput: false,
            placeholder: "",
            priority: 45,
            providedBy: "NetworkKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
