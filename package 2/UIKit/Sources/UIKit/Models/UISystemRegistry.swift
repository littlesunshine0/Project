//
//  UISystemRegistry.swift
//  UIKit
//
//  Central registry for all UI systems
//

import Foundation
import DataKit

// MARK: - UI System Registry

public class UISystemRegistry: @unchecked Sendable {
    public static let shared = UISystemRegistry()
    
    private var systems: [String: any UISystemProtocol] = [:]
    private let lock = NSLock()
    
    private init() {}
    
    public func register<T: UISystemProtocol>(system: T) {
        lock.lock()
        defer { lock.unlock() }
        systems[system.id] = system
    }
    
    public func system(withId id: String) -> (any UISystemProtocol)? {
        lock.lock()
        defer { lock.unlock() }
        return systems[id]
    }
    
    public var allSystems: [any UISystemProtocol] {
        lock.lock()
        defer { lock.unlock() }
        return Array(systems.values)
    }
    
    public func registerAll() {
        // Layout Systems
        register(system: DoubleSidebarSystem())
        register(system: SplitViewSystem())
        register(system: GridSystem())
        
        // Panel Systems
        register(system: FloatingPanelSystem())
        register(system: FloatingGridPanelSystem())
        register(system: BottomBarSystem())
        register(system: BottomPanelSystem())
        register(system: InspectorSystem())
        register(system: QuickHelpSystem())
        
        // Navigation Systems
        register(system: ToolbarSystem())
        register(system: ActionBarSystem())
        register(system: BreadcrumbSystem())
        register(system: PathBarSystem())
        register(system: NavigationSystem())
        register(system: OutlineSystem())
        register(system: FileTreeSystem())
        register(system: TabSystem())
        register(system: SegmentedControlSystem())
        
        // Modal Systems
        register(system: ModalSystem())
        register(system: AlertSystem())
        register(system: PopoverSystem())
        register(system: DrawerSystem())
        
        // Notification Systems
        register(system: ToastSystem())
        register(system: SnackbarSystem())
        register(system: BannerSystem())
        
        // Command Systems
        register(system: ContextMenuSystem())
        register(system: CommandPaletteSystem())
        register(system: QuickActionsSystem())
        
        // Content Systems
        register(system: CardSystem())
        register(system: ListSystem())
    }
    
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        systems.removeAll()
    }
}

// MARK: - Layout Template Registry

public class LayoutTemplateRegistry: @unchecked Sendable {
    public static let shared = LayoutTemplateRegistry()
    
    private var templates: [String: LayoutTemplate] = [:]
    private let lock = NSLock()
    
    private init() {}
    
    public func register(template: LayoutTemplate) {
        lock.lock()
        defer { lock.unlock() }
        templates[template.id] = template
    }
    
    public func template(withId id: String) -> LayoutTemplate? {
        lock.lock()
        defer { lock.unlock() }
        return templates[id]
    }
    
    public var allTemplates: [LayoutTemplate] {
        lock.lock()
        defer { lock.unlock() }
        return Array(templates.values)
    }
    
    public func templates(for category: LayoutCategory) -> [LayoutTemplate] {
        lock.lock()
        defer { lock.unlock() }
        return templates.values.filter { $0.category == category }
    }
    
    public func registerAll() {
        // IDE Templates
        register(template: LayoutTemplate.ideClassic)
        register(template: LayoutTemplate.ideMinimal)
        register(template: LayoutTemplate.ideFocused)
        
        // Dashboard Templates
        register(template: LayoutTemplate.dashboardGrid)
        register(template: LayoutTemplate.dashboardList)
        register(template: LayoutTemplate.dashboardCards)
        
        // Editor Templates
        register(template: LayoutTemplate.editorSingle)
        register(template: LayoutTemplate.editorSplit)
        register(template: LayoutTemplate.editorTabs)
        
        // Browser Templates
        register(template: LayoutTemplate.browserThreeColumn)
        register(template: LayoutTemplate.browserTwoColumn)
        register(template: LayoutTemplate.browserSingle)
    }
    
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        templates.removeAll()
    }
}

// MARK: - Layout Template

public struct LayoutTemplate: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let category: LayoutCategory
    public let thumbnail: String?
    public let systems: [String]
    public let configuration: LayoutConfiguration
    
    public init(id: String, name: String, description: String, category: LayoutCategory, thumbnail: String? = nil, systems: [String], configuration: LayoutConfiguration) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.thumbnail = thumbnail
        self.systems = systems
        self.configuration = configuration
    }
}

public enum LayoutCategory: String, Codable, Sendable, CaseIterable {
    case ide
    case dashboard
    case editor
    case browser
    case settings
    case wizard
    case presentation
    case custom
}

public struct LayoutConfiguration: Codable, Sendable, Hashable {
    public let showLeftSidebar: Bool
    public let showRightSidebar: Bool
    public let showBottomPanel: Bool
    public let showToolbar: Bool
    public let showBreadcrumbs: Bool
    public let showBottomBar: Bool
    public let leftSidebarWidth: CGFloat
    public let rightSidebarWidth: CGFloat
    public let bottomPanelHeight: CGFloat
    
    public init(showLeftSidebar: Bool = true, showRightSidebar: Bool = true, showBottomPanel: Bool = false, showToolbar: Bool = true, showBreadcrumbs: Bool = true, showBottomBar: Bool = true, leftSidebarWidth: CGFloat = 280, rightSidebarWidth: CGFloat = 320, bottomPanelHeight: CGFloat = 250) {
        self.showLeftSidebar = showLeftSidebar
        self.showRightSidebar = showRightSidebar
        self.showBottomPanel = showBottomPanel
        self.showToolbar = showToolbar
        self.showBreadcrumbs = showBreadcrumbs
        self.showBottomBar = showBottomBar
        self.leftSidebarWidth = leftSidebarWidth
        self.rightSidebarWidth = rightSidebarWidth
        self.bottomPanelHeight = bottomPanelHeight
    }
    
    public static let `default` = LayoutConfiguration()
}

// MARK: - Predefined Templates

extension LayoutTemplate {
    public static let ideClassic = LayoutTemplate(
        id: "ide.classic",
        name: "Classic IDE",
        description: "Traditional IDE layout with sidebars and bottom panel",
        category: .ide,
        systems: ["doubleSidebar", "toolbar", "breadcrumb", "bottomPanel", "bottomBar", "inspector"],
        configuration: LayoutConfiguration(showLeftSidebar: true, showRightSidebar: true, showBottomPanel: true, showToolbar: true, showBreadcrumbs: true, showBottomBar: true)
    )
    
    public static let ideMinimal = LayoutTemplate(
        id: "ide.minimal",
        name: "Minimal IDE",
        description: "Clean layout with minimal distractions",
        category: .ide,
        systems: ["doubleSidebar", "toolbar"],
        configuration: LayoutConfiguration(showLeftSidebar: true, showRightSidebar: false, showBottomPanel: false, showToolbar: true, showBreadcrumbs: false, showBottomBar: false)
    )
    
    public static let ideFocused = LayoutTemplate(
        id: "ide.focused",
        name: "Focused IDE",
        description: "Distraction-free writing mode",
        category: .ide,
        systems: ["toolbar"],
        configuration: LayoutConfiguration(showLeftSidebar: false, showRightSidebar: false, showBottomPanel: false, showToolbar: true, showBreadcrumbs: false, showBottomBar: false)
    )
    
    public static let dashboardGrid = LayoutTemplate(
        id: "dashboard.grid",
        name: "Grid Dashboard",
        description: "Card-based grid dashboard",
        category: .dashboard,
        systems: ["toolbar", "grid", "card"],
        configuration: LayoutConfiguration(showLeftSidebar: true, showRightSidebar: false, showBottomPanel: false)
    )
    
    public static let dashboardList = LayoutTemplate(
        id: "dashboard.list",
        name: "List Dashboard",
        description: "List-based dashboard",
        category: .dashboard,
        systems: ["toolbar", "list", "navigation"],
        configuration: LayoutConfiguration(showLeftSidebar: true, showRightSidebar: true)
    )
    
    public static let dashboardCards = LayoutTemplate(
        id: "dashboard.cards",
        name: "Cards Dashboard",
        description: "Large card dashboard",
        category: .dashboard,
        systems: ["toolbar", "card"],
        configuration: LayoutConfiguration(showLeftSidebar: false, showRightSidebar: false)
    )
    
    public static let editorSingle = LayoutTemplate(
        id: "editor.single",
        name: "Single Editor",
        description: "Single editor pane",
        category: .editor,
        systems: ["toolbar", "tab", "inspector"],
        configuration: LayoutConfiguration(showLeftSidebar: true, showRightSidebar: true)
    )
    
    public static let editorSplit = LayoutTemplate(
        id: "editor.split",
        name: "Split Editor",
        description: "Side-by-side editors",
        category: .editor,
        systems: ["toolbar", "tab", "splitView", "inspector"],
        configuration: LayoutConfiguration(showLeftSidebar: true, showRightSidebar: true)
    )
    
    public static let editorTabs = LayoutTemplate(
        id: "editor.tabs",
        name: "Tabbed Editor",
        description: "Multiple editor tabs",
        category: .editor,
        systems: ["toolbar", "tab"],
        configuration: LayoutConfiguration(showLeftSidebar: true, showRightSidebar: false)
    )
    
    public static let browserThreeColumn = LayoutTemplate(
        id: "browser.threeColumn",
        name: "Three Column Browser",
        description: "Mail-style three column layout",
        category: .browser,
        systems: ["toolbar", "navigation", "list", "inspector"],
        configuration: LayoutConfiguration(showLeftSidebar: true, showRightSidebar: true)
    )
    
    public static let browserTwoColumn = LayoutTemplate(
        id: "browser.twoColumn",
        name: "Two Column Browser",
        description: "Sidebar and content",
        category: .browser,
        systems: ["toolbar", "navigation"],
        configuration: LayoutConfiguration(showLeftSidebar: true, showRightSidebar: false)
    )
    
    public static let browserSingle = LayoutTemplate(
        id: "browser.single",
        name: "Single Column Browser",
        description: "Full-width content",
        category: .browser,
        systems: ["toolbar"],
        configuration: LayoutConfiguration(showLeftSidebar: false, showRightSidebar: false)
    )
}
