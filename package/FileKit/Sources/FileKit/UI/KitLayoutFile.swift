//
//  KitLayoutFile.swift
//  FileKit
//
//  Complete layout configuration for FileKit
//

import Foundation
import DataKit

public struct KitLayoutFile {
    
    public static let sidebarItems: [SidebarItemDefinition] = [
        SidebarItemDefinition(
            id: "files",
            title: "Files",
            icon: "folder.fill",
            colorCategory: "file",
            route: "/files",
            priority: 95,
            providedBy: "FileKit",
            children: [
                SidebarItemDefinition(id: "files.explorer", title: "Explorer", icon: "folder.fill", colorCategory: "file", route: "/files/explorer", priority: 90, providedBy: "FileKit"),
                SidebarItemDefinition(id: "files.recent", title: "Recent", icon: "clock.fill", colorCategory: "file", route: "/files/recent", priority: 80, providedBy: "FileKit"),
                SidebarItemDefinition(id: "files.favorites", title: "Favorites", icon: "star.fill", colorCategory: "file", route: "/files/favorites", priority: 70, providedBy: "FileKit")
            ]
        )
    ]
    
    public static let bottomPanelTabs: [BottomPanelTabDefinition] = [
        BottomPanelTabDefinition(id: "files.output", title: "Output", icon: "doc.text.fill", colorCategory: "file", hasInput: false, priority: 70, providedBy: "FileKit")
    ]
    
    public static let inspectors: [InspectorDefinition] = [
        InspectorDefinition(id: "file.inspector", type: .fileInspector, title: "File Inspector", colorCategory: "file", priority: 100, providedBy: "FileKit", isDefault: true),
        InspectorDefinition(id: "file.preview", type: .filePreview, title: "File Preview", colorCategory: "file", priority: 95, providedBy: "FileKit"),
        InspectorDefinition(id: "file.history", type: .historyInspector, title: "File History", colorCategory: "file", priority: 85, providedBy: "FileKit"),
        InspectorDefinition(id: "file.metadata", type: .metadataPreview, title: "Metadata", colorCategory: "file", priority: 80, providedBy: "FileKit"),
        InspectorDefinition(id: "file.quickHelp", type: .quickHelp, title: "Quick Help", colorCategory: "info", priority: 70, providedBy: "FileKit")
    ]
    
    public static let rightSidebarPanels: [RightSidebarPanelDefinition] = [
        RightSidebarPanelDefinition(id: "file.inspectorPanel", title: "File Inspector", icon: "doc.text.fill", colorCategory: "file", priority: 100, providedBy: "FileKit", inspectors: inspectors, defaultPosition: .top),
        RightSidebarPanelDefinition(id: "file.previewPanel", title: "Preview", icon: "eye.fill", colorCategory: "file", priority: 90, providedBy: "FileKit", defaultPosition: .middle)
    ]
    
    public static let mainContexts: [MainContextDefinition] = [
        MainContextDefinition(id: "file.editor", title: "Editor", icon: "doc.text.fill", colorCategory: "file", route: "/files", providedBy: "FileKit", supportedInspectors: [.fileInspector, .filePreview, .historyInspector, .metadataPreview, .quickHelp], defaultRightSidebar: "file.inspectorPanel")
    ]
    
    public static let configuration = KitLayoutConfiguration(
        id: "filekit.layout", kitName: "FileKit", displayName: "Files", icon: "folder.fill", colorCategory: "file",
        sidebarItems: sidebarItems, bottomPanelTabs: bottomPanelTabs, rightSidebarPanels: rightSidebarPanels, mainContexts: mainContexts, inspectors: inspectors
    )
    
    public static func register() { KitLayoutRegistry.shared.register(configuration: configuration) }
}
