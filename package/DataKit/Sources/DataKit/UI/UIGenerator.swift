//
//  UIGenerator.swift
//  DataKit
//
//  Auto-generates UI components from package contracts
//  Menus, views, animations, accessibility - all automatic
//

import SwiftUI

// MARK: - UI Generator

public actor UIGenerator {
    public static let shared = UIGenerator()
    
    private var generatedMenus: [String: GeneratedMenu] = [:]
    private var generatedViews: [String: GeneratedView] = [:]
    
    private init() {}
    
    // MARK: - Menu Generation
    
    public func generateMenus(from contract: PackageContract) -> [GeneratedMenu] {
        var menus: [GeneratedMenu] = []
        
        // Main menu from actions
        let mainMenu = GeneratedMenu(
            id: "\(contract.manifest.id).main",
            type: .main,
            title: contract.manifest.name,
            items: contract.actions.actions.map { action in
                GeneratedMenuItem(
                    id: action.id,
                    title: action.name,
                    icon: action.icon,
                    action: action.id,
                    shortcut: action.shortcut,
                    isEnabled: true
                )
            }
        )
        menus.append(mainMenu)
        generatedMenus[mainMenu.id] = mainMenu
        
        // Context menu
        let contextMenu = GeneratedMenu(
            id: "\(contract.manifest.id).context",
            type: .context,
            title: "Actions",
            items: contract.actions.actions
                .filter { [.create, .read, .update, .delete].contains($0.category) }
                .map { action in
                    GeneratedMenuItem(
                        id: action.id,
                        title: action.name,
                        icon: action.icon,
                        action: action.id,
                        shortcut: nil,
                        isEnabled: true
                    )
                }
        )
        menus.append(contextMenu)
        generatedMenus[contextMenu.id] = contextMenu
        
        // Help menu
        let helpMenu = GeneratedMenu(
            id: "\(contract.manifest.id).help",
            type: .help,
            title: "Help",
            items: [
                GeneratedMenuItem(id: "help.docs", title: "Documentation", icon: "book", action: "showDocs", shortcut: nil, isEnabled: true),
                GeneratedMenuItem(id: "help.shortcuts", title: "Keyboard Shortcuts", icon: "keyboard", action: "showShortcuts", shortcut: "⌘/", isEnabled: true),
                GeneratedMenuItem(id: "help.about", title: "About \(contract.manifest.name)", icon: "info.circle", action: "showAbout", shortcut: nil, isEnabled: true)
            ]
        )
        menus.append(helpMenu)
        generatedMenus[helpMenu.id] = helpMenu
        
        return menus
    }
    
    // MARK: - View Generation
    
    public func generateViews(from contract: PackageContract) -> [GeneratedView] {
        var views: [GeneratedView] = []
        
        // Browser view (always generated)
        let browserView = GeneratedView(
            id: "\(contract.manifest.id).browser",
            type: .browser,
            title: contract.manifest.name,
            icon: contract.ui.icons.first?.systemName ?? "folder",
            sections: [
                ViewSection(id: "all", title: "All", filter: nil),
                ViewSection(id: "recent", title: "Recent", filter: "recent"),
                ViewSection(id: "favorites", title: "Favorites", filter: "favorite")
            ],
            actions: contract.actions.actions.prefix(5).map { $0.id }
        )
        views.append(browserView)
        generatedViews[browserView.id] = browserView
        
        // List view
        let listView = GeneratedView(
            id: "\(contract.manifest.id).list",
            type: .list,
            title: "\(contract.manifest.name) List",
            icon: "list.bullet",
            sections: [],
            actions: ["select", "open", "delete"]
        )
        views.append(listView)
        generatedViews[listView.id] = listView
        
        // Detail/Editor view
        let editorView = GeneratedView(
            id: "\(contract.manifest.id).editor",
            type: .editor,
            title: "Edit",
            icon: "pencil",
            sections: [],
            actions: ["save", "cancel", "delete"]
        )
        views.append(editorView)
        generatedViews[editorView.id] = editorView
        
        // Settings view
        let settingsView = GeneratedView(
            id: "\(contract.manifest.id).settings",
            type: .settings,
            title: "Settings",
            icon: "gearshape",
            sections: [
                ViewSection(id: "general", title: "General", filter: nil),
                ViewSection(id: "appearance", title: "Appearance", filter: nil),
                ViewSection(id: "advanced", title: "Advanced", filter: nil)
            ],
            actions: ["save", "reset"]
        )
        views.append(settingsView)
        generatedViews[settingsView.id] = settingsView
        
        return views
    }
    
    // MARK: - Toolbar Generation
    
    public func generateToolbar(from contract: PackageContract) -> GeneratedToolbar {
        let primaryActions = contract.actions.actions
            .filter { $0.category == .create || $0.category == .execute }
            .prefix(3)
        
        let secondaryActions = contract.actions.actions
            .filter { $0.category == .export || $0.category == .share }
            .prefix(2)
        
        return GeneratedToolbar(
            id: "\(contract.manifest.id).toolbar",
            leading: primaryActions.map { GeneratedToolbarItem(id: $0.id, icon: $0.icon, action: $0.id, tooltip: $0.name) },
            trailing: secondaryActions.map { GeneratedToolbarItem(id: $0.id, icon: $0.icon, action: $0.id, tooltip: $0.name) }
        )
    }
    
    // MARK: - Sidebar Generation
    
    public func generateSidebar(from contracts: [PackageContract]) -> GeneratedSidebar {
        let sections = contracts.map { contract in
            GeneratedSidebarSection(
                id: contract.manifest.id,
                title: contract.manifest.name,
                icon: contract.ui.icons.first?.systemName ?? "folder",
                items: contract.capabilities.ui.prefix(3).map { cap in
                    GeneratedSidebarItem(id: "\(contract.manifest.id).\(cap.rawValue)", title: cap.rawValue.capitalized, icon: iconFor(cap), badge: nil)
                }
            )
        }
        
        return GeneratedSidebar(sections: sections)
    }
    
    private func iconFor(_ capability: PackageCapabilities.UICapability) -> String {
        switch capability {
        case .browser: return "folder"
        case .list: return "list.bullet"
        case .editor: return "pencil"
        case .timeline: return "calendar"
        case .gallery: return "square.grid.2x2"
        case .card: return "rectangle.portrait"
        case .table: return "tablecells"
        case .graph: return "chart.line.uptrend.xyaxis"
        case .canvas: return "scribble"
        case .settings: return "gearshape"
        }
    }
    
    // MARK: - Queries
    
    public func getMenu(_ id: String) -> GeneratedMenu? {
        generatedMenus[id]
    }
    
    public func getView(_ id: String) -> GeneratedView? {
        generatedViews[id]
    }
}

// MARK: - Generated Types

public struct GeneratedMenu: Identifiable, Sendable {
    public let id: String
    public let type: MenuType
    public let title: String
    public let items: [GeneratedMenuItem]
    
    public enum MenuType: Sendable {
        case main, context, help, toolbar, sidebar
    }
}

public struct GeneratedMenuItem: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let icon: String
    public let action: String
    public let shortcut: String?
    public let isEnabled: Bool
}

public struct GeneratedView: Identifiable, Sendable {
    public let id: String
    public let type: ViewType
    public let title: String
    public let icon: String
    public let sections: [ViewSection]
    public let actions: [String]
    
    public enum ViewType: Sendable {
        case browser, list, grid, editor, timeline, canvas, settings, detail
    }
}

public struct ViewSection: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let filter: String?
}

public struct GeneratedToolbar: Identifiable, Sendable {
    public let id: String
    public let leading: [GeneratedToolbarItem]
    public let trailing: [GeneratedToolbarItem]
}

public struct GeneratedToolbarItem: Identifiable, Sendable {
    public let id: String
    public let icon: String
    public let action: String
    public let tooltip: String
}

public struct GeneratedSidebar: Sendable {
    public let sections: [GeneratedSidebarSection]
}

public struct GeneratedSidebarSection: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let icon: String
    public let items: [GeneratedSidebarItem]
}

public struct GeneratedSidebarItem: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let icon: String
    public let badge: String?
}

// MARK: - SwiftUI View Builders

public struct AutoGeneratedMenuView: View {
    public let menu: GeneratedMenu
    public let onAction: (String) -> Void
    
    public init(menu: GeneratedMenu, onAction: @escaping (String) -> Void) {
        self.menu = menu
        self.onAction = onAction
    }
    
    public var body: some View {
        Menu(menu.title) {
            ForEach(menu.items) { item in
                Button {
                    onAction(item.action)
                } label: {
                    Label(item.title, systemImage: item.icon)
                }
                .disabled(!item.isEnabled)
                .keyboardShortcut(item.shortcut.flatMap { parseShortcut($0) } ?? .defaultAction)
            }
        }
    }
    
    private func parseShortcut(_ shortcut: String) -> KeyboardShortcut? {
        // Simple shortcut parsing
        guard let char = shortcut.last else { return nil }
        return KeyboardShortcut(KeyEquivalent(char))
    }
}

public struct AutoGeneratedToolbarView: View {
    public let toolbar: GeneratedToolbar
    public let onAction: (String) -> Void
    
    public init(toolbar: GeneratedToolbar, onAction: @escaping (String) -> Void) {
        self.toolbar = toolbar
        self.onAction = onAction
    }
    
    public var body: some View {
        HStack {
            ForEach(toolbar.leading) { item in
                Button {
                    onAction(item.action)
                } label: {
                    Image(systemName: item.icon)
                }
                .help(item.tooltip)
            }
            
            Spacer()
            
            ForEach(toolbar.trailing) { item in
                Button {
                    onAction(item.action)
                } label: {
                    Image(systemName: item.icon)
                }
                .help(item.tooltip)
            }
        }
        .padding(.horizontal)
    }
}

public struct AutoGeneratedSidebarView: View {
    public let sidebar: GeneratedSidebar
    @Binding public var selection: String?
    
    public init(sidebar: GeneratedSidebar, selection: Binding<String?>) {
        self.sidebar = sidebar
        self._selection = selection
    }
    
    public var body: some View {
        List(selection: $selection) {
            ForEach(sidebar.sections) { section in
                Section(section.title) {
                    ForEach(section.items) { item in
                        Label(item.title, systemImage: item.icon)
                            .tag(item.id)
                            .badge(item.badge ?? "")
                    }
                }
            }
        }
        .listStyle(.sidebar)
    }
}
