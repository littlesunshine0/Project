//
//  SidebarItemFeedback.swift
//  FeedbackKit
//
//  Sidebar items provided by FeedbackKit
//

import Foundation
import DataKit

/// Sidebar items provided by FeedbackKit
public struct SidebarItemFeedback {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "feedback",
            title: "Feedback",
            icon: "bubble.left.and.exclamationmark.bubble.right.fill",
            colorCategory: "info",
            route: "/feedback",
            priority: 20,
            providedBy: "FeedbackKit",
            children: [
                SidebarItemDefinition(id: "feedback.submit", title: "Submit", icon: "paperplane.fill", colorCategory: "info", route: "/feedback/submit", priority: 90, providedBy: "FeedbackKit"),
                SidebarItemDefinition(id: "feedback.history", title: "History", icon: "clock.fill", colorCategory: "neutral", route: "/feedback/history", priority: 80, providedBy: "FeedbackKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
