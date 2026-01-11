//
//  SidebarItemExport.swift
//  ExportKit
//
//  Sidebar items provided by ExportKit
//

import Foundation
import DataKit

/// Sidebar items provided by ExportKit
public struct SidebarItemExport {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "export",
            title: "Export",
            icon: "square.and.arrow.up.fill",
            colorCategory: "success",
            route: "/export",
            priority: 25,
            providedBy: "ExportKit",
            children: [
                SidebarItemDefinition(id: "export.formats", title: "Formats", icon: "doc.badge.gearshape", colorCategory: "success", route: "/export/formats", priority: 90, providedBy: "ExportKit"),
                SidebarItemDefinition(id: "export.history", title: "History", icon: "clock.fill", colorCategory: "neutral", route: "/export/history", priority: 80, providedBy: "ExportKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
