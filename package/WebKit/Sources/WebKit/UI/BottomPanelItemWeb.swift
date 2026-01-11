//
//  BottomPanelItemWeb.swift
//  WebKit
//
//  Bottom panel items provided by WebKit
//

import Foundation
import DataKit

/// Bottom panel items provided by WebKit
public struct BottomPanelItemWeb {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "web.console",
            title: "Web Console",
            icon: "globe",
            colorCategory: "web",
            hasInput: true,
            placeholder: "Enter JavaScript...",
            priority: 24,
            providedBy: "WebKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
