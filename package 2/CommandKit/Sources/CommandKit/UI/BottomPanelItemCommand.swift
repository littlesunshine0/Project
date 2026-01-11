//
//  BottomPanelItemCommand.swift
//  CommandKit
//
//  Bottom panel items provided by CommandKit
//

import Foundation
import DataKit

/// Bottom panel items provided by CommandKit
public struct BottomPanelItemCommand {
    
    /// All bottom panel tabs provided by CommandKit
    public static let tabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(
            id: "command.terminal",
            title: "Terminal",
            icon: "terminal.fill",
            colorCategory: "commands",
            hasInput: true,
            placeholder: "Enter command...",
            priority: 90,
            providedBy: "CommandKit"
        ),
        BottomPanelTabDefinition(
            id: "command.output",
            title: "Output",
            icon: "doc.text.fill",
            colorCategory: "info",
            hasInput: false,
            placeholder: "",
            priority: 70,
            providedBy: "CommandKit"
        )
    ]
    
    /// Register CommandKit's bottom panel items
    public static func register() {
        BottomPanelRegistry.shared.register(tabs: tabs)
    }
}
