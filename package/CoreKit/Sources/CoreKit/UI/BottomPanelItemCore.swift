//
//  BottomPanelItemCore.swift
//  CoreKit
//
//  Bottom panel items provided by CoreKit
//

import Foundation
import DataKit

/// Bottom panel items provided by CoreKit
public struct BottomPanelItemCore {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "core.inspector",
            title: "Core",
            icon: "cube.fill",
            colorCategory: "core",
            hasInput: false,
            placeholder: "",
            priority: 50,
            providedBy: "CoreKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
