//
//  BottomPanelItemFeedback.swift
//  FeedbackKit
//
//  Bottom panel items provided by FeedbackKit
//

import Foundation
import DataKit

/// Bottom panel items provided by FeedbackKit
public struct BottomPanelItemFeedback {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "feedback.form",
            title: "Feedback",
            icon: "bubble.left.and.exclamationmark.bubble.right.fill",
            colorCategory: "info",
            hasInput: true,
            placeholder: "Share your feedback...",
            priority: 20,
            providedBy: "FeedbackKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
