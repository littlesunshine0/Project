//
//  SidebarItemNetwork.swift
//  NetworkKit
//
//  Sidebar items provided by NetworkKit
//

import Foundation
import DataKit

/// Sidebar items provided by NetworkKit
public struct SidebarItemNetwork {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "network",
            title: "Network",
            icon: "network",
            colorCategory: "network",
            route: "/network",
            priority: 42,
            providedBy: "NetworkKit",
            children: [
                SidebarItemDefinition(id: "network.requests", title: "Requests", icon: "arrow.up.arrow.down", colorCategory: "network", route: "/network/requests", priority: 90, providedBy: "NetworkKit"),
                SidebarItemDefinition(id: "network.endpoints", title: "Endpoints", icon: "point.3.connected.trianglepath.dotted", colorCategory: "network", route: "/network/endpoints", priority: 80, providedBy: "NetworkKit"),
                SidebarItemDefinition(id: "network.monitor", title: "Monitor", icon: "waveform.path.ecg", colorCategory: "info", route: "/network/monitor", priority: 70, providedBy: "NetworkKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
