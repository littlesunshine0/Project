//
//  FlowKitOrchestrator.swift
//  DataKit
//
//  Central orchestrator that brings all Kits together
//

import Foundation

// MARK: - FlowKit Orchestrator

@MainActor
public class FlowKitOrchestrator: ObservableObject {
    public static let shared = FlowKitOrchestrator()
    
    @Published public var isInitialized = false
    @Published public var registeredKits: [String] = []
    @Published public var activeAgents: [String] = []
    @Published public var runningWorkflows: [String] = []
    
    private init() {}
    
    // MARK: - Initialization
    
    public func initialize() async {
        // Register all Kit manifests
        await registerAllKits()
        
        // Subscribe to cross-kit events
        await setupEventSubscriptions()
        
        // Start background agents
        await startBackgroundAgents()
        
        isInitialized = true
    }
    
    private func registerAllKits() async {
        // Each Kit registers its manifest
        // This would be called by each Kit's initialization
        registeredKits = await KitRegistry.shared.getAllKits().map { $0.name }
    }
    
    private func setupEventSubscriptions() async {
        // Subscribe to all events for cross-kit coordination
        await EventBus.shared.subscribeAll { [weak self] event in
            await self?.handleEvent(event)
        }
    }
    
    private func handleEvent(_ event: DataEvent) async {
        // Route events to appropriate handlers
        switch event.type {
        case let type where type.contains(".created"):
            await handleEntityCreated(event)
        case let type where type.contains(".updated"):
            await handleEntityUpdated(event)
        case let type where type.contains(".deleted"):
            await handleEntityDeleted(event)
        default:
            break
        }
    }
    
    private func handleEntityCreated(_ event: DataEvent) async {
        // Notify interested Kits about new entities
    }
    
    private func handleEntityUpdated(_ event: DataEvent) async {
        // Sync updates across Kits
    }
    
    private func handleEntityDeleted(_ event: DataEvent) async {
        // Clean up references in other Kits
    }
    
    private func startBackgroundAgents() async {
        // Start essential background agents
    }
    
    // MARK: - Command Execution
    
    public func executeCommand(_ input: String) async throws -> CommandExecutionResult {
        guard input.hasPrefix("/") else {
            throw OrchestratorError.invalidCommand("Commands must start with /")
        }
        
        let components = input.dropFirst().split(separator: " ").map(String.init)
        guard let commandName = components.first else {
            throw OrchestratorError.invalidCommand("Empty command")
        }
        
        // Find command in registry
        if let command = await KitRegistry.shared.getCommand(commandName) {
            return CommandExecutionResult(
                success: true,
                output: "Executed: \(command.name)",
                command: commandName
            )
        }
        
        throw OrchestratorError.commandNotFound(commandName)
    }
    
    // MARK: - Action Execution
    
    public func executeAction(_ actionId: String, context: [String: Any] = [:]) async throws {
        guard let action = await KitRegistry.shared.getAction(actionId) else {
            throw OrchestratorError.actionNotFound(actionId)
        }
        
        // Execute action handler
        await EventBus.shared.publish(DataEvent(
            type: "action.executed",
            entityType: "Action",
            entityId: UUID(),
            payload: ["action": action.id, "kit": action.kit],
            source: "Orchestrator"
        ))
    }
    
    // MARK: - Shortcut Handling
    
    public func handleShortcut(key: String, modifiers: [String]) async -> Bool {
        let shortcutKey = modifiers.sorted().joined() + key
        
        if let shortcut = await KitRegistry.shared.getShortcut(for: shortcutKey) {
            try? await executeAction(shortcut.action)
            return true
        }
        
        return false
    }
    
    // MARK: - Menu Building
    
    public func buildMainMenu() async -> [MenuSection] {
        let allMenuItems = await KitRegistry.shared.getAllMenuItems()
        
        // Group by Kit
        let grouped = Dictionary(grouping: allMenuItems) { $0.kit }
        
        return grouped.map { kit, items in
            MenuSection(title: kit, items: items)
        }
    }
    
    public func buildContextMenu(for targetType: String) async -> [KitMenuItem] {
        var items: [KitMenuItem] = []
        
        for kit in await KitRegistry.shared.getAllKits() {
            let contextMenus = await KitRegistry.shared.getContextMenus(for: kit.identifier)
            for menu in contextMenus where menu.targetType == targetType {
                items.append(contentsOf: menu.items)
            }
        }
        
        return items
    }
    
    // MARK: - Help System
    
    public func getHelp(for topic: String? = nil) async -> HelpContent {
        if let topic = topic {
            // Get specific help
            if let command = await KitRegistry.shared.getCommand(topic) {
                return HelpContent(
                    title: command.name,
                    description: command.description,
                    syntax: command.syntax,
                    examples: []
                )
            }
        }
        
        // Get general help
        let commands = await KitRegistry.shared.getAllCommands()
        return HelpContent(
            title: "FlowKit Help",
            description: "Available commands: \(commands.count)",
            syntax: "/help <command>",
            examples: commands.prefix(5).map { "/\($0.name)" }
        )
    }
    
    // MARK: - Statistics
    
    public func getStats() async -> OrchestratorStats {
        let kits = await KitRegistry.shared.getAllKits()
        let commands = await KitRegistry.shared.getAllCommands()
        let actions = await KitRegistry.shared.getAllActions()
        let shortcuts = await KitRegistry.shared.getAllShortcuts()
        
        return OrchestratorStats(
            kitCount: kits.count,
            commandCount: commands.count,
            actionCount: actions.count,
            shortcutCount: shortcuts.count,
            activeAgentCount: activeAgents.count,
            runningWorkflowCount: runningWorkflows.count
        )
    }
}

// MARK: - Supporting Types

public struct CommandExecutionResult: Sendable {
    public let success: Bool
    public let output: String
    public let command: String
}

public struct MenuSection: Identifiable, Sendable {
    public let id = UUID()
    public let title: String
    public let items: [KitMenuItem]
}

public struct HelpContent: Sendable {
    public let title: String
    public let description: String
    public let syntax: String
    public let examples: [String]
}

public struct OrchestratorStats: Sendable {
    public let kitCount: Int
    public let commandCount: Int
    public let actionCount: Int
    public let shortcutCount: Int
    public let activeAgentCount: Int
    public let runningWorkflowCount: Int
}

public enum OrchestratorError: LocalizedError {
    case invalidCommand(String)
    case commandNotFound(String)
    case actionNotFound(String)
    case kitNotFound(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidCommand(let msg): return "Invalid command: \(msg)"
        case .commandNotFound(let name): return "Command not found: \(name)"
        case .actionNotFound(let id): return "Action not found: \(id)"
        case .kitNotFound(let name): return "Kit not found: \(name)"
        }
    }
}
