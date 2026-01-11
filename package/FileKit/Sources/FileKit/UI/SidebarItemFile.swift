//
//  SidebarItemFile.swift
//  FileKit
//
//  Sidebar items provided by FileKit
//

import Foundation
import DataKit

/// Sidebar items provided by FileKit
public struct SidebarItemFile {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "files",
            title: "Files",
            icon: "folder.fill",
            colorCategory: "files",
            route: "/files",
            priority: 90,
            providedBy: "FileKit",
            children: [
                SidebarItemDefinition(id: "files.explorer", title: "Explorer", icon: "folder.badge.gearshape", colorCategory: "files", route: "/files/explorer", priority: 90, providedBy: "FileKit"),
                SidebarItemDefinition(id: "files.recent", title: "Recent", icon: "clock.fill", colorCategory: "files", route: "/files/recent", priority: 80, providedBy: "FileKit"),
                SidebarItemDefinition(id: "files.favorites", title: "Favorites", icon: "star.fill", colorCategory: "warning", route: "/files/favorites", priority: 70, providedBy: "FileKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
