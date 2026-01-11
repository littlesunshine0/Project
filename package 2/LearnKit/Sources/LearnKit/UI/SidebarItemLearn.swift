//
//  SidebarItemLearn.swift
//  LearnKit
//
//  Sidebar items provided by LearnKit
//

import Foundation
import DataKit

/// Sidebar items provided by LearnKit
public struct SidebarItemLearn {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "learn",
            title: "Learn",
            icon: "graduationcap.fill",
            colorCategory: "learn",
            route: "/learn",
            priority: 30,
            providedBy: "LearnKit",
            children: [
                SidebarItemDefinition(id: "learn.tutorials", title: "Tutorials", icon: "play.rectangle.fill", colorCategory: "learn", route: "/learn/tutorials", priority: 90, providedBy: "LearnKit"),
                SidebarItemDefinition(id: "learn.guides", title: "Guides", icon: "book.fill", colorCategory: "learn", route: "/learn/guides", priority: 80, providedBy: "LearnKit"),
                SidebarItemDefinition(id: "learn.progress", title: "Progress", icon: "chart.line.uptrend.xyaxis", colorCategory: "success", route: "/learn/progress", priority: 70, providedBy: "LearnKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
