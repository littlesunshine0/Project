//
//  BottomPanelItemFile.swift
//  FileKit
//
//  Bottom panel items provided by FileKit
//

import Foundation
import DataKit

/// Bottom panel items provided by FileKit
public struct BottomPanelItemFile {
    
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "file.explorer",
            title: "File Explorer",
            icon: "folder.fill",
            colorCategory: "files",
            hasInput: false,
            placeholder: "",
            priority: 45,
            providedBy: "FileKit"
        )
    ]
    
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
