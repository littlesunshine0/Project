//
//  BottomPanelItemScaffold.swift
//  ProjectScaffold
//
//  Bottom panel items provided by ProjectScaffold
//

import Foundation
import DataKit

/// Bottom panel items provided by ProjectScaffold
public struct BottomPanelItemScaffold {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "scaffold.wizard",
            title: "Scaffold",
            icon: "hammer.fill",
            colorCategory: "scaffold",
            hasInput: false,
            placeholder: "",
            priority: 42,
            providedBy: "ProjectScaffold"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
