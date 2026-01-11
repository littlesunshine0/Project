//
//  BottomPanelItemNotification.swift
//  NotificationKit
//
//  Bottom panel items provided by NotificationKit
//

import Foundation
import DataKit

/// Bottom panel items provided by NotificationKit
public struct BottomPanelItemNotification {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "notification.activity",
            title: "Activity",
            icon: "bell.fill",
            colorCategory: "info",
            hasInput: false,
            placeholder: "",
            priority: 30,
            providedBy: "NotificationKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
