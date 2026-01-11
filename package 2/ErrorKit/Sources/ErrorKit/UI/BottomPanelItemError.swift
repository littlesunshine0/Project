//
//  BottomPanelItemError.swift
//  ErrorKit
//
//  Bottom panel items provided by ErrorKit
//

import Foundation
import DataKit

/// Bottom panel items provided by ErrorKit
public struct BottomPanelItemError {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "error.problems",
            title: "Problems",
            icon: "exclamationmark.triangle.fill",
            colorCategory: "warning",
            hasInput: false,
            placeholder: "",
            priority: 85,
            providedBy: "ErrorKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
