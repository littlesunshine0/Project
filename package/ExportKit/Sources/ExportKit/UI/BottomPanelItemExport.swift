//
//  BottomPanelItemExport.swift
//  ExportKit
//
//  Bottom panel items provided by ExportKit
//

import Foundation
import DataKit

/// Bottom panel items provided by ExportKit
public struct BottomPanelItemExport {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "export.progress",
            title: "Export",
            icon: "square.and.arrow.up.fill",
            colorCategory: "success",
            hasInput: false,
            placeholder: "",
            priority: 25,
            providedBy: "ExportKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
