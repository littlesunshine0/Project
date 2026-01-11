//
//  BottomPanelItemAsset.swift
//  AssetKit
//
//  Bottom panel items provided by AssetKit
//

import Foundation
import DataKit

/// Bottom panel items provided by AssetKit
public struct BottomPanelItemAsset {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "assets.browser",
            title: "Assets",
            icon: "photo.on.rectangle.angled",
            colorCategory: "asset",
            hasInput: false,
            placeholder: "",
            priority: 30,
            providedBy: "AssetKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
