//
//  BottomPanelItemParse.swift
//  ParseKit
//
//  Bottom panel items provided by ParseKit
//

import Foundation
import DataKit

/// Bottom panel items provided by ParseKit
public struct BottomPanelItemParse {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "parse.output",
            title: "Parser",
            icon: "doc.text.magnifyingglass",
            colorCategory: "parse",
            hasInput: false,
            placeholder: "",
            priority: 22,
            providedBy: "ParseKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
