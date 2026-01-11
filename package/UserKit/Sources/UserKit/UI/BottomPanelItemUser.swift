//
//  BottomPanelItemUser.swift
//  UserKit
//
//  Bottom panel items provided by UserKit
//

import Foundation
import DataKit

/// Bottom panel items provided by UserKit
public struct BottomPanelItemUser {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "user.profile",
            title: "Profile",
            icon: "person.circle.fill",
            colorCategory: "neutral",
            hasInput: false,
            placeholder: "",
            priority: 10,
            providedBy: "UserKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
