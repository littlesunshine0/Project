//
//  SidebarItemCollaboration.swift
//  CollaborationKit
//
//  Sidebar items provided by CollaborationKit
//

import Foundation
import DataKit

/// Sidebar items provided by CollaborationKit
public struct SidebarItemCollaboration {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "collaboration",
            title: "Collaboration",
            icon: "person.2.fill",
            colorCategory: "chat",
            route: "/collaboration",
            priority: 50,
            providedBy: "CollaborationKit",
            children: [
                SidebarItemDefinition(id: "collaboration.team", title: "Team", icon: "person.3.fill", colorCategory: "chat", route: "/collaboration/team", priority: 90, providedBy: "CollaborationKit"),
                SidebarItemDefinition(id: "collaboration.shared", title: "Shared", icon: "folder.badge.person.crop", colorCategory: "files", route: "/collaboration/shared", priority: 80, providedBy: "CollaborationKit"),
                SidebarItemDefinition(id: "collaboration.activity", title: "Activity", icon: "waveform.path.ecg", colorCategory: "success", route: "/collaboration/activity", priority: 70, providedBy: "CollaborationKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
