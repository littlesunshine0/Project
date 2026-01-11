//
//  NavigationCoordinator.swift
//  NavigationKit
//
//  Central navigation coordinator for FlowKit
//

import Foundation
import Combine

// MARK: - Alert Info

public struct AlertInfo: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String
    public let primaryButton: String
    public let primaryAction: () -> Void
    public let secondaryButton: String?
    public let secondaryAction: (() -> Void)?
    
    public init(title: String, message: String, primaryButton: String = "OK", primaryAction: @escaping () -> Void = {}, secondaryButton: String? = nil, secondaryAction: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.primaryAction = primaryAction
        self.secondaryButton = secondaryButton
        self.secondaryAction = secondaryAction
    }
}

// MARK: - Sheet Type (for DoubleSidebarLayout compatibility)

extension NavigationCoordinator {
    public enum SheetType: Identifiable {
        case newWorkflow
        case newProject(template: String?)
        case newAgent
        case addInventoryItem
        case connectMarketplace(marketplace: String?)
        case exportData
        case importData
        case search
        case help
        case onboarding
        case settings
        case workflowEditor(workflowId: String?)
        case projectDetails(projectId: String)
        case marketplaceConnection
        
        public var id: String {
            switch self {
            case .newWorkflow: return "newWorkflow"
            case .newProject(let t): return "newProject-\(t ?? "none")"
            case .newAgent: return "newAgent"
            case .addInventoryItem: return "addInventoryItem"
            case .connectMarketplace(let m): return "connectMarketplace-\(m ?? "none")"
            case .exportData: return "exportData"
            case .importData: return "importData"
            case .search: return "search"
            case .help: return "help"
            case .onboarding: return "onboarding"
            case .settings: return "settings"
            case .workflowEditor(let id): return "workflowEditor-\(id ?? "new")"
            case .projectDetails(let id): return "projectDetails-\(id)"
            case .marketplaceConnection: return "marketplaceConnection"
            }
        }
    }
}

@MainActor
public class NavigationCoordinator: ObservableObject {
    public static let shared = NavigationCoordinator()
    
    @Published public var currentDestination: NavigationDestination = .dashboard()
    @Published public var navigationPath: [NavigationDestination] = []
    @Published public var presentedSheet: SheetDestination?
    @Published public var isShowingSheet = false
    @Published public var showingSheet: SheetType? {
        didSet {
            if showingSheet != nil {
                isShowingSheet = true
            }
        }
    }
    @Published public var showingAlert: AlertInfo?
    @Published public var sidebarSelection: String? = "dashboard"
    
    // For DoubleSidebarLayout sync
    @Published public var currentPrimaryTab: String = "dashboard"
    @Published public var currentSecondarySection: String? = nil
    
    private var history: [NavigationDestination] = []
    private let maxHistorySize = 50
    
    private init() {}
    
    // MARK: - Navigation
    
    public func navigate(to destination: NavigationDestination) {
        // Add current to history
        history.append(currentDestination)
        if history.count > maxHistorySize {
            history.removeFirst()
        }
        
        currentDestination = destination
        navigationPath.append(destination)
        
        // Update sidebar selection
        switch destination {
        case .dashboard: sidebarSelection = "dashboard"
        case .workflows: sidebarSelection = "workflows"
        case .agents: sidebarSelection = "agents"
        case .commands: sidebarSelection = "commands"
        case .projects: sidebarSelection = "projects"
        case .documentation: sidebarSelection = "documentation"
        case .search: sidebarSelection = "search"
        case .knowledge: sidebarSelection = "knowledge"
        case .learn: sidebarSelection = "learn"
        case .settings: sidebarSelection = "settings"
        case .chat: sidebarSelection = "chat"
        case .files: sidebarSelection = "files"
        default: break
        }
    }
    
    public func goBack() {
        guard !history.isEmpty else { return }
        let previous = history.removeLast()
        currentDestination = previous
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    public func goToRoot() {
        navigationPath.removeAll()
        currentDestination = .dashboard()
        sidebarSelection = "dashboard"
    }
    
    // MARK: - Sheets
    
    public func present(_ sheet: SheetDestination) {
        presentedSheet = sheet
        isShowingSheet = true
    }
    
    public func dismissSheet() {
        isShowingSheet = false
        presentedSheet = nil
        showingSheet = nil
    }
    
    // MARK: - Quick Actions
    
    public func showTerminal() {
        NotificationCenter.default.post(name: .showTerminalPanel, object: nil)
    }
    
    public func runRecommendedAgent() {
        NotificationCenter.default.post(name: .runRecommendedAgent, object: nil)
    }
    
    public func runSystemScan() {
        NotificationCenter.default.post(name: .runSystemScan, object: nil)
    }
    
    public func syncMarketplaces() {
        NotificationCenter.default.post(name: .syncMarketplaces, object: nil)
    }
    
    // MARK: - Deep Linking
    
    public func handleDeepLink(_ url: URL) -> Bool {
        guard let host = url.host else { return false }
        
        switch host.lowercased() {
        case "dashboard": navigate(to: .dashboard()); return true
        case "workflows": navigate(to: .workflows()); return true
        case "agents": navigate(to: .agents()); return true
        case "commands": navigate(to: .commands()); return true
        case "projects": navigate(to: .projects()); return true
        case "documentation": navigate(to: .documentation()); return true
        case "search": navigate(to: .search()); return true
        default: return false
        }
    }
    
    // MARK: - State
    
    public var canGoBack: Bool { !history.isEmpty }
    
    public var breadcrumbs: [NavigationDestination] {
        var crumbs = history.suffix(3).map { $0 }
        crumbs.append(currentDestination)
        return crumbs
    }
    
    public func getHistory() -> [NavigationDestination] {
        history
    }
}

// MARK: - Notification Names

public extension Notification.Name {
    // Panel notifications
    static let showTerminalPanel = Notification.Name("showTerminalPanel")
    static let showOutputPanel = Notification.Name("showOutputPanel")
    static let showProblemsPanel = Notification.Name("showProblemsPanel")
    static let toggleBottomPanel = Notification.Name("toggleBottomPanel")
    
    // Navigation notifications
    static let showWorkflows = Notification.Name("showWorkflows")
    static let showProjects = Notification.Name("showProjects")
    static let showDashboard = Notification.Name("showDashboard")
    static let showChat = Notification.Name("showChat")
    static let showAIAssistant = Notification.Name("showAIAssistant")
    static let showHistory = Notification.Name("showHistory")
    static let toggleSidebar = Notification.Name("toggleSidebar")
    
    // Action notifications
    static let runRecommendedAgent = Notification.Name("runRecommendedAgent")
    static let runSystemScan = Notification.Name("runSystemScan")
    static let syncMarketplaces = Notification.Name("syncMarketplaces")
    static let searchDocumentation = Notification.Name("searchDocumentation")
    static let newWorkflow = Notification.Name("newWorkflow")
    static let openWorkflow = Notification.Name("openWorkflow")
    
    // Completion notifications
    static let workflowCompleted = Notification.Name("workflowCompleted")
}
