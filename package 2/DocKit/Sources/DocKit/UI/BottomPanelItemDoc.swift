//
//  BottomPanelItemDoc.swift
//  DocKit
//
//  Bottom panel items provided by DocKit
//

import Foundation
import DataKit

/// Bottom panel items provided by DocKit
public struct BottomPanelItemDoc {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "doc.preview",
            title: "Doc Preview",
            icon: "doc.text.magnifyingglass",
            colorCategory: "documentation",
            hasInput: false,
            placeholder: "",
            priority: 50,
            providedBy: "DocKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
