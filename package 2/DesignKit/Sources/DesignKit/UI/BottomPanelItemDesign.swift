//
//  BottomPanelItemDesign.swift
//  DesignKit
//
//  Bottom panel items provided by DesignKit
//

import Foundation
import DataKit

/// Bottom panel items provided by DesignKit
public struct BottomPanelItemDesign {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "design.inspector",
            title: "Inspector",
            icon: "slider.horizontal.3",
            colorCategory: "neutral",
            hasInput: false,
            placeholder: "",
            priority: 45,
            providedBy: "DesignKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
