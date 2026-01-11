//
//  SidebarItemBridge.swift
//  BridgeKit
//
//  Sidebar items provided by BridgeKit
//

import Foundation
import DataKit

/// Sidebar items provided by BridgeKit
public struct SidebarItemBridge {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "bridge",
            title: "Bridge",
            icon: "arrow.left.arrow.right",
            colorCategory: "bridge",
            route: "/bridge",
            priority: 45,
            providedBy: "BridgeKit",
            children: [
                SidebarItemDefinition(id: "bridge.connections", title: "Connections", icon: "link", colorCategory: "bridge", route: "/bridge/connections", priority: 90, providedBy: "BridgeKit"),
                SidebarItemDefinition(id: "bridge.registry", title: "Registry", icon: "list.bullet.rectangle", colorCategory: "info", route: "/bridge/registry", priority: 80, providedBy: "BridgeKit"),
                SidebarItemDefinition(id: "bridge.logs", title: "Logs", icon: "doc.text.fill", colorCategory: "bridge", route: "/bridge/logs", priority: 70, providedBy: "BridgeKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
