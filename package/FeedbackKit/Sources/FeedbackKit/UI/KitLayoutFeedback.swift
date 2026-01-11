//
//  KitLayoutFeedback.swift
//  FeedbackKit
//
//  Complete layout configuration for FeedbackKit
//

import Foundation
import DataKit

public struct KitLayoutFeedback {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "feedback",
            title: "Feedback",
            icon: "bubble.left.and.exclamationmark.bubble.right.fill",
            colorCategory: "feedback",
            route: "/feedback",
            priority: 58,
            providedBy: "FeedbackKit",
            children: [
                SidebarItemDefinition(id: "feedback.submit", title: "Submit", icon: "plus.bubble.fill", colorCategory: "feedback", route: "/feedback/submit", priority: 90, providedBy: "FeedbackKit"),
                SidebarItemDefinition(id: "feedback.history", title: "History", icon: "clock.arrow.circlepath", colorCategory: "feedback", route: "/feedback/history", priority: 80, providedBy: "FeedbackKit"),
                SidebarItemDefinition(id: "feedback.status", title: "Status", icon: "checkmark.circle.fill", colorCategory: "success", route: "/feedback/status", priority: 70, providedBy: "FeedbackKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "feedback.input", title: "Feedback", icon: "bubble.left.and.exclamationmark.bubble.right.fill", colorCategory: "feedback", hasInput: true, placeholder: "Share your feedback...", priority: 48, providedBy: "FeedbackKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "feedback.properties", type: .properties, title: "Feedback Properties", colorCategory: "feedback", priority: 90, providedBy: "FeedbackKit", isDefault: true),
        InspectorDefinition(id: "feedback.history", type: .historyInspector, title: "Feedback History", colorCategory: "feedback", priority: 80, providedBy: "FeedbackKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "feedback.inspectorPanel", title: "Feedback Inspector", icon: "bubble.left.and.exclamationmark.bubble.right.fill", colorCategory: "feedback", priority: 75, providedBy: "FeedbackKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "feedback.main", title: "Feedback", icon: "bubble.left.and.exclamationmark.bubble.right.fill", colorCategory: "feedback", route: "/feedback", providedBy: "FeedbackKit", supportedInspectors: [.properties, .historyInspector], defaultRightSidebar: "feedback.inspectorPanel", defaultBottomPanel: "feedback.input")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "feedbackkit.layout", kitName: "FeedbackKit", displayName: "Feedback", icon: "bubble.left.and.exclamationmark.bubble.right.fill", colorCategory: "feedback",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
