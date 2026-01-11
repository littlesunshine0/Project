//
//  BottomPanelItemIndexer.swift
//  IndexerKit
//
//  Bottom panel items provided by IndexerKit
//

import Foundation
import DataKit

/// Bottom panel items provided by IndexerKit
public struct BottomPanelItemIndexer {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "indexer.status",
            title: "Index Status",
            icon: "doc.text.magnifyingglass",
            colorCategory: "info",
            hasInput: false,
            placeholder: "",
            priority: 30,
            providedBy: "IndexerKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
