//
//  SidebarItemAsset.swift
//  AssetKit
//
//  Sidebar items provided by AssetKit
//

import Foundation
import DataKit

/// Sidebar items provided by AssetKit
public struct SidebarItemAsset {
    
    public static let items: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "assets",
            title: "Assets",
            icon: "photo.on.rectangle.angled",
            colorCategory: "asset",
            route: "/assets",
            priority: 50,
            providedBy: "AssetKit",
            children: [
                SidebarItemDefinition(id: "assets.images", title: "Images", icon: "photo.fill", colorCategory: "asset", route: "/assets/images", priority: 90, providedBy: "AssetKit"),
                SidebarItemDefinition(id: "assets.colors", title: "Colors", icon: "paintpalette.fill", colorCategory: "design", route: "/assets/colors", priority: 80, providedBy: "AssetKit"),
                SidebarItemDefinition(id: "assets.fonts", title: "Fonts", icon: "textformat", colorCategory: "asset", route: "/assets/fonts", priority: 70, providedBy: "AssetKit")
            ]
        )
    ]
    
    public static func register() {
        SidebarItemRegistry.shared.register(items: items)
    }
}
