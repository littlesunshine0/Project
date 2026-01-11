//
//  BottomPanelItemAnalytics.swift
//  AnalyticsKit
//
//  Bottom panel items provided by AnalyticsKit
//

import Foundation
import DataKit

/// Bottom panel items provided by AnalyticsKit
public struct BottomPanelItemAnalytics {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "analytics.metrics",
            title: "Metrics",
            icon: "chart.bar.fill",
            colorCategory: "dashboard",
            hasInput: false,
            placeholder: "",
            priority: 40,
            providedBy: "AnalyticsKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
