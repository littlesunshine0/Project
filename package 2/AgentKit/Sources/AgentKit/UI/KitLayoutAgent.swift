//
//  KitLayoutAgent.swift
//  AgentKit
//
//  Complete layout configuration for AgentKit
//

import Foundation
import DataKit

public struct KitLayoutAgent {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "agents",
            title: "Agents",
            icon: "cpu.fill",
            colorCategory: "agent",
            route: "/agents",
            priority: 80,
            providedBy: "AgentKit",
            children: [
                SidebarItemDefinition(id: "agents.active", title: "Active", icon: "play.circle.fill", colorCategory: "success", route: "/agents/active", priority: 90, providedBy: "AgentKit"),
                SidebarItemDefinition(id: "agents.all", title: "All Agents", icon: "list.bullet", colorCategory: "agent", route: "/agents/all", priority: 80, providedBy: "AgentKit"),
                SidebarItemDefinition(id: "agents.history", title: "Run History", icon: "clock.arrow.circlepath", colorCategory: "info", route: "/agents/history", priority: 70, providedBy: "AgentKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "agent.console", title: "Agent Console", icon: "terminal.fill", colorCategory: "agent", hasInput: true, placeholder: "Agent command...", priority: 85, providedBy: "AgentKit"),
        BottomPanelTabDefinition(id: "agent.logs", title: "Agent Logs", icon: "doc.text.fill", colorCategory: "agent", hasInput: false, priority: 75, providedBy: "AgentKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "agent.properties", type: .properties, title: "Agent Properties", colorCategory: "agent", priority: 90, providedBy: "AgentKit", isDefault: true),
        InspectorDefinition(id: "agent.performance", type: .performance, title: "Performance", colorCategory: "agent", priority: 85, providedBy: "AgentKit"),
        InspectorDefinition(id: "agent.debug", type: .debug, title: "Debug", colorCategory: "agent", priority: 80, providedBy: "AgentKit"),
        InspectorDefinition(id: "agent.connections", type: .connections, title: "Connections", colorCategory: "agent", priority: 75, providedBy: "AgentKit"),
        InspectorDefinition(id: "agent.history", type: .historyInspector, title: "Run History", colorCategory: "agent", priority: 70, providedBy: "AgentKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "agent.inspectorPanel", title: "Agent Inspector", icon: "cpu.fill", colorCategory: "agent", priority: 90, providedBy: "AgentKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "agent.livePanel", title: "Live Status", icon: "waveform.path.ecg", colorCategory: "agent", priority: 80, providedBy: "AgentKit", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "agent.dashboard", title: "Agent Dashboard", icon: "cpu.fill", colorCategory: "agent", route: "/agents", providedBy: "AgentKit", supportedInspectors: [.properties, .performance, .debug, .connections, .historyInspector], defaultRightSidebar: "agent.inspectorPanel", defaultBottomPanel: "agent.console")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "agentkit.layout", kitName: "AgentKit", displayName: "Agents", icon: "cpu.fill", colorCategory: "agent",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
