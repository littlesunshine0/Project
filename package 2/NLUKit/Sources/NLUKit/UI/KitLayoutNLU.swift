//
//  KitLayoutNLU.swift
//  NLUKit
//
//  Complete layout configuration for NLUKit
//

import Foundation
import DataKit

public struct KitLayoutNLU {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "nlu",
            title: "NLU",
            icon: "text.word.spacing",
            colorCategory: "nlu",
            route: "/nlu",
            priority: 62,
            providedBy: "NLUKit",
            children: [
                SidebarItemDefinition(id: "nlu.intents", title: "Intents", icon: "target", colorCategory: "nlu", route: "/nlu/intents", priority: 90, providedBy: "NLUKit"),
                SidebarItemDefinition(id: "nlu.entities", title: "Entities", icon: "tag.fill", colorCategory: "nlu", route: "/nlu/entities", priority: 80, providedBy: "NLUKit"),
                SidebarItemDefinition(id: "nlu.training", title: "Training", icon: "chart.line.uptrend.xyaxis", colorCategory: "nlu", route: "/nlu/training", priority: 70, providedBy: "NLUKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "nlu.test", title: "NLU Test", icon: "text.word.spacing", colorCategory: "nlu", hasInput: true, placeholder: "Test utterance...", priority: 45, providedBy: "NLUKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "nlu.properties", type: .properties, title: "NLU Properties", colorCategory: "nlu", priority: 90, providedBy: "NLUKit", isDefault: true),
        InspectorDefinition(id: "nlu.debug", type: .debug, title: "Parse Debug", colorCategory: "nlu", priority: 85, providedBy: "NLUKit"),
        InspectorDefinition(id: "nlu.performance", type: .performance, title: "Performance", colorCategory: "nlu", priority: 80, providedBy: "NLUKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "nlu.inspectorPanel", title: "NLU Inspector", icon: "text.word.spacing", colorCategory: "nlu", priority: 78, providedBy: "NLUKit", inspectors: inspectors, defaultPosition: .top)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "nlu.dashboard", title: "NLU Dashboard", icon: "text.word.spacing", colorCategory: "nlu", route: "/nlu", providedBy: "NLUKit", supportedInspectors: [.properties, .debug, .performance], defaultRightSidebar: "nlu.inspectorPanel", defaultBottomPanel: "nlu.test")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "nlukit.layout", kitName: "NLUKit", displayName: "NLU", icon: "text.word.spacing", colorCategory: "nlu",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
