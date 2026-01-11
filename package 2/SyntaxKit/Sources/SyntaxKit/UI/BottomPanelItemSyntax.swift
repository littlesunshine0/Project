//
//  BottomPanelItemSyntax.swift
//  SyntaxKit
//
//  Bottom panel items provided by SyntaxKit
//

import Foundation
import DataKit

/// Bottom panel items provided by SyntaxKit
public struct BottomPanelItemSyntax {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "syntax.inspector",
            title: "Syntax",
            icon: "chevron.left.forwardslash.chevron.right",
            colorCategory: "syntax",
            hasInput: false,
            placeholder: "",
            priority: 18,
            providedBy: "SyntaxKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
