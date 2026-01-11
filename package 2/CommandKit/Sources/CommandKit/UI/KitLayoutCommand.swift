//
//  KitLayoutCommand.swift
//  CommandKit
//
//  Complete layout configuration for CommandKit
//

import Foundation
import DataKit

public struct KitLayoutCommand {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "commands",
            title: "Commands",
            icon: "terminal.fill",
            colorCategory: "command",
            route: "/commands",
            priority: 82,
            providedBy: "CommandKit",
            children: [
                SidebarItemDefinition(id: "commands.palette", title: "Command Palette", icon: "command", colorCategory: "command", route: "/commands/palette", priority: 90, providedBy: "CommandKit"),
                SidebarItemDefinition(id: "commands.shortcuts", title: "Shortcuts", icon: "keyboard.fill", colorCategory: "command", route: "/commands/shortcuts", priority: 80, providedBy: "CommandKit"),
                SidebarItemDefinition(id: "commands.history", title: "History", icon: "clock.arrow.circlepath", colorCategory: "command", route: "/commands/history", priority: 70, providedBy: "CommandKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "command.terminal", title: "Terminal", icon: "terminal.fill", colorCategory: "command", hasInput: true, placeholder: "Enter command...", priority: 98, providedBy: "CommandKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "command.properties", type: .properties, title: "Command Properties", colorCategory: "command", priority: 90, providedBy: "CommandKit", isDefault: true),
        InspectorDefinition(id: "command.quickHelp", type: .quickHelp, title: "Command Help", colorCategory: "command", priority: 85, providedBy: "CommandKit"),
        InspectorDefinition(id: "command.history", type: .historyInspector, title: "Command History", colorCategory: "command", priority: 80, providedBy: "CommandKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "command.inspectorPanel", title: "Command Inspector", icon: "terminal.fill", colorCategory: "command", priority: 88, providedBy: "CommandKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "command.main", title: "Commands", icon: "terminal.fill", colorCategory: "command", route: "/commands", providedBy: "CommandKit", supportedInspectors: [.properties, .quickHelp, .historyInspector], defaultRightSidebar: "command.inspectorPanel", defaultBottomPanel: "command.terminal")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "commandkit.layout", kitName: "CommandKit", displayName: "Commands", icon: "terminal.fill", colorCategory: "command",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
