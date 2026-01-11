//
//  BottomPanelItemActivity.swift
//  ActivityKit
//
//  Bottom panel items provided by ActivityKit
//

import Foundation
import DataKit

/// Bottom panel items provided by ActivityKit
public struct BottomPanelItemActivity {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "activity.log",
            title: "Activity",
            icon: "waveform.path.ecg",
            colorCategory: "activity",
            hasInput: false,
            placeholder: "",
            priority: 40,
            providedBy: "ActivityKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
