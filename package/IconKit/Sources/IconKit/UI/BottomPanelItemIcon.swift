//
//  BottomPanelItemIcon.swift
//  IconKit
//
//  Bottom panel items provided by IconKit
//

import Foundation
import DataKit

/// Bottom panel items provided by IconKit
public struct BottomPanelItemIcon {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "icons.preview",
            title: "Icons",
            icon: "star.square.fill",
            colorCategory: "design",
            hasInput: false,
            placeholder: "",
            priority: 28,
            providedBy: "IconKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
