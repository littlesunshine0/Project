//
//  BottomPanelItemSystem.swift
//  SystemKit
//
//  Bottom panel items provided by SystemKit
//

import Foundation
import DataKit

/// Bottom panel items provided by SystemKit
public struct BottomPanelItemSystem {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "system.monitor",
            title: "System",
            icon: "gearshape.fill",
            colorCategory: "system",
            hasInput: false,
            placeholder: "",
            priority: 15,
            providedBy: "SystemKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
