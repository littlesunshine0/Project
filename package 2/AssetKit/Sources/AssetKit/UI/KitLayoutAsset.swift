//
//  KitLayoutAsset.swift
//  AssetKit
//
//  Complete layout configuration for AssetKit
//

import Foundation
import DataKit

public struct KitLayoutAsset {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
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
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "assets.browser", title: "Assets", icon: "photo.on.rectangle.angled", colorCategory: "asset", hasInput: false, priority: 30, providedBy: "AssetKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "asset.fileInspector", type: .fileInspector, title: "Asset Inspector", colorCategory: "asset", priority: 95, providedBy: "AssetKit", isDefault: true),
        InspectorDefinition(id: "asset.preview", type: .filePreview, title: "Asset Preview", colorCategory: "asset", priority: 90, providedBy: "AssetKit"),
        InspectorDefinition(id: "asset.metadata", type: .metadataPreview, title: "Metadata", colorCategory: "asset", priority: 85, providedBy: "AssetKit"),
        InspectorDefinition(id: "asset.accessibility", type: .accessibility, title: "Accessibility", colorCategory: "asset", priority: 80, providedBy: "AssetKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "asset.inspectorPanel", title: "Asset Inspector", icon: "photo.on.rectangle.angled", colorCategory: "asset", priority: 68, providedBy: "AssetKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "asset.previewPanel", title: "Preview", icon: "eye.fill", colorCategory: "asset", priority: 58, providedBy: "AssetKit", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "asset.browser", title: "Asset Browser", icon: "photo.on.rectangle.angled", colorCategory: "asset", route: "/assets", providedBy: "AssetKit", supportedInspectors: [.fileInspector, .filePreview, .metadataPreview, .accessibility], defaultRightSidebar: "asset.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "assetkit.layout", kitName: "AssetKit", displayName: "Assets", icon: "photo.on.rectangle.angled", colorCategory: "asset",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
