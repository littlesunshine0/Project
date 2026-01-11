//
//  PackageOrchestrator.swift
//  DataKit
//
//  Central orchestrator that auto-loads packages and wires everything together
//  Attach Package → Run → Everything Happens
//

import Foundation

// MARK: - Package Orchestrator

public actor PackageOrchestrator {
    public static let shared = PackageOrchestrator()
    
    // Registries
    private var packages: [String: PackageContract] = [:]
    private var loadOrder: [String] = []
    private var status: OrchestratorStatus = .idle
    
    // Sub-systems
    private let commandRegistry = CommandRegistry()
    private let actionRegistry = ActionRegistry()
    private let agentRegistry = AgentRegistry()
    private let workflowRegistry = WorkflowRegistry()
    private let menuRegistry = MenuRegistry()
    private let stateManager = PackageStateManager()
    
    private init() {}
    
    // MARK: - Package Loading Pipeline
    
    /// Main entry point: Attach package → everything auto-wires
    public func attachPackage(_ contract: PackageContract) async throws {
        let id = contract.manifest.id
        
        // 1. Validate dependencies
        try validateDependencies(contract)
        
        // 2. Register package
        packages[id] = contract
        loadOrder.append(id)
        
        // 3. Auto-wire all systems
        await wireCommands(contract)
        await wireActions(contract)
        await wireAgents(contract)
        await wireWorkflows(contract)
        await wireMenus(contract)
        await wireState(contract)
        
        // 4. Emit event
        await EventBus.shared.publish(DataEvent(
            type: "package.attached",
            entityType: "Package",
            entityId: UUID(),
            payload: ["packageId": id],
            source: "PackageOrchestrator"
        ))
    }
    
    /// Load all packages and run the automation pipeline
    public func run() async throws {
        status = .loading
        
        // Sort by dependencies
        let sorted = try topologicalSort(loadOrder)
        
        // Initialize each package in order
        for packageId in sorted {
            guard let contract = packages[packageId] else { continue }
            try await initializePackage(contract)
        }
        
        // Generate auto-content
        await generateDocumentation()
        await generateDefaultWorkflows()
        await indexForML()
        
        status = .running
        await EventBus.shared.publish(DataEvent(
            type: "orchestrator.ready",
            entityType: "Orchestrator",
            entityId: UUID(),
            payload: [:],
            source: "PackageOrchestrator"
        ))
    }
    
    // MARK: - Auto-Wiring
    
    private func wireCommands(_ contract: PackageContract) async {
        for action in contract.actions.actions {
            let command = CommandEntry(
                id: action.id,
                name: action.name,
                description: action.description,
                syntax: "/\(action.id.replacingOccurrences(of: ".", with: " "))",
                packageId: contract.manifest.id,
                handler: action.id
            )
            await commandRegistry.register(command)
        }
    }
    
    private func wireActions(_ contract: PackageContract) async {
        for action in contract.actions.actions {
            let entry = ActionEntry(
                id: action.id,
                name: action.name,
                description: action.description,
                icon: action.icon,
                packageId: contract.manifest.id,
                input: action.input.map { InputParam(name: $0.name, type: $0.type.rawValue, required: $0.required) },
                output: action.output,
                shortcut: action.shortcut
            )
            await actionRegistry.register(entry)
        }
    }
    
    private func wireAgents(_ contract: PackageContract) async {
        for agent in contract.agents.agents {
            let entry = AgentEntry(
                id: agent.id,
                name: agent.name,
                description: agent.description,
                packageId: contract.manifest.id,
                triggers: agent.triggers.map { $0.type.rawValue },
                actions: agent.actions,
                autoStart: agent.config.autoStart
            )
            await agentRegistry.register(entry)
        }
    }
    
    private func wireWorkflows(_ contract: PackageContract) async {
        for workflow in contract.workflows.workflows {
            let entry = WorkflowEntry(
                id: workflow.id,
                name: workflow.name,
                description: workflow.description,
                packageId: contract.manifest.id,
                steps: workflow.steps.map { $0.action },
                triggers: workflow.triggers
            )
            await workflowRegistry.register(entry)
        }
    }
    
    private func wireMenus(_ contract: PackageContract) async {
        for menu in contract.ui.menus {
            let entry = MenuEntry(
                id: menu.id,
                type: menu.type,
                packageId: contract.manifest.id,
                items: menu.items.map { MenuItemEntry(id: $0.id, title: $0.title, icon: $0.icon, action: $0.action, shortcut: $0.shortcut) }
            )
            await menuRegistry.register(entry)
        }
    }
    
    private func wireState(_ contract: PackageContract) async {
        await stateManager.registerPackage(
            id: contract.manifest.id,
            states: contract.state.states.map { $0.id },
            events: contract.state.events.map { $0.id }
        )
    }
    
    // MARK: - Auto-Generation
    
    private func generateDocumentation() async {
        // DocKit will auto-generate docs for each package
        for (id, _) in packages {
            await EventBus.shared.publish(DataEvent(
                type: "doc.generation.request",
                entityType: "DocGeneration",
                entityId: UUID(),
                payload: ["packageId": id],
                source: "PackageOrchestrator"
            ))
        }
    }
    
    private func generateDefaultWorkflows() async {
        // WorkflowKit creates default workflows based on actions
        for (id, contract) in packages {
            if contract.workflows.workflows.isEmpty {
                await EventBus.shared.publish(DataEvent(
                    type: "workflow.generation.request",
                    entityType: "WorkflowGeneration",
                    entityId: UUID(),
                    payload: ["packageId": id, "actionCount": String(contract.actions.actions.count)],
                    source: "PackageOrchestrator"
                ))
            }
        }
    }
    
    private func indexForML() async {
        // AIKit indexes everything for ML
        for (id, _) in packages {
            await EventBus.shared.publish(DataEvent(
                type: "ml.index.request",
                entityType: "MLIndex",
                entityId: UUID(),
                payload: ["packageId": id],
                source: "PackageOrchestrator"
            ))
        }
    }
    
    // MARK: - Initialization
    
    private func initializePackage(_ contract: PackageContract) async throws {
        let id = contract.manifest.id
        await stateManager.setState(packageId: id, state: "loading")
        
        // Start auto-start agents
        for agent in contract.agents.agents where agent.config.autoStart {
            await agentRegistry.start(agentId: agent.id)
        }
        
        await stateManager.setState(packageId: id, state: "idle")
        await EventBus.shared.publish(DataEvent(
            type: "package.initialized",
            entityType: "Package",
            entityId: UUID(),
            payload: ["packageId": id],
            source: "PackageOrchestrator"
        ))
    }
    
    // MARK: - Dependency Resolution
    
    private func validateDependencies(_ contract: PackageContract) throws {
        for dep in contract.manifest.dependencies {
            guard packages[dep] != nil || isCoreDependency(dep) else {
                throw PackageOrchestratorError.missingDependency(dep, for: contract.manifest.id)
            }
        }
    }
    
    private func isCoreDependency(_ dep: String) -> Bool {
        ["CoreKit", "DataKit"].contains(dep)
    }
    
    private func topologicalSort(_ ids: [String]) throws -> [String] {
        var result: [String] = []
        var visited: Set<String> = []
        var visiting: Set<String> = []
        
        func visit(_ id: String) throws {
            if visited.contains(id) { return }
            if visiting.contains(id) { throw PackageOrchestratorError.circularDependency(id) }
            
            visiting.insert(id)
            if let contract = packages[id] {
                for dep in contract.manifest.dependencies {
                    if packages[dep] != nil {
                        try visit(dep)
                    }
                }
            }
            visiting.remove(id)
            visited.insert(id)
            result.append(id)
        }
        
        for id in ids {
            try visit(id)
        }
        
        return result
    }
    
    // MARK: - Queries
    
    public func getPackage(_ id: String) -> PackageContract? {
        packages[id]
    }
    
    public func getAllPackages() -> [PackageContract] {
        Array(packages.values)
    }
    
    public func getCommands() async -> [CommandEntry] {
        await commandRegistry.getAll()
    }
    
    public func getActions() async -> [ActionEntry] {
        await actionRegistry.getAll()
    }
    
    public func getAgents() async -> [AgentEntry] {
        await agentRegistry.getAll()
    }
    
    public func getWorkflows() async -> [WorkflowEntry] {
        await workflowRegistry.getAll()
    }
    
    public func getMenus(type: PackageUI.MenuDefinition.MenuType) async -> [MenuEntry] {
        await menuRegistry.getByType(type)
    }
    
    public func getStatus() -> OrchestratorStatus {
        status
    }
}

// MARK: - Registry Types

public struct CommandEntry: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let syntax: String
    public let packageId: String
    public let handler: String
}

public struct ActionEntry: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let icon: String
    public let packageId: String
    public let input: [InputParam]
    public let output: String
    public let shortcut: String?
}

public struct InputParam: Sendable {
    public let name: String
    public let type: String
    public let required: Bool
}

public struct AgentEntry: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let packageId: String
    public let triggers: [String]
    public let actions: [String]
    public let autoStart: Bool
}

public struct WorkflowEntry: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let packageId: String
    public let steps: [String]
    public let triggers: [String]
}

public struct MenuEntry: Identifiable, Sendable {
    public let id: String
    public let type: PackageUI.MenuDefinition.MenuType
    public let packageId: String
    public let items: [MenuItemEntry]
}

public struct MenuItemEntry: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let icon: String?
    public let action: String
    public let shortcut: String?
}

// MARK: - Sub-Registries

actor CommandRegistry {
    private var commands: [String: CommandEntry] = [:]
    
    func register(_ entry: CommandEntry) {
        commands[entry.id] = entry
    }
    
    func getAll() -> [CommandEntry] {
        Array(commands.values)
    }
    
    func get(_ id: String) -> CommandEntry? {
        commands[id]
    }
}

actor ActionRegistry {
    private var actions: [String: ActionEntry] = [:]
    
    func register(_ entry: ActionEntry) {
        actions[entry.id] = entry
    }
    
    func getAll() -> [ActionEntry] {
        Array(actions.values)
    }
    
    func get(_ id: String) -> ActionEntry? {
        actions[id]
    }
}

actor AgentRegistry {
    private var agents: [String: AgentEntry] = [:]
    private var running: Set<String> = []
    
    func register(_ entry: AgentEntry) {
        agents[entry.id] = entry
    }
    
    func start(agentId: String) {
        running.insert(agentId)
    }
    
    func stop(agentId: String) {
        running.remove(agentId)
    }
    
    func getAll() -> [AgentEntry] {
        Array(agents.values)
    }
    
    func isRunning(_ id: String) -> Bool {
        running.contains(id)
    }
}

actor WorkflowRegistry {
    private var workflows: [String: WorkflowEntry] = [:]
    
    func register(_ entry: WorkflowEntry) {
        workflows[entry.id] = entry
    }
    
    func getAll() -> [WorkflowEntry] {
        Array(workflows.values)
    }
    
    func get(_ id: String) -> WorkflowEntry? {
        workflows[id]
    }
}

actor MenuRegistry {
    private var menus: [String: MenuEntry] = [:]
    
    func register(_ entry: MenuEntry) {
        menus[entry.id] = entry
    }
    
    func getAll() -> [MenuEntry] {
        Array(menus.values)
    }
    
    func getByType(_ type: PackageUI.MenuDefinition.MenuType) -> [MenuEntry] {
        menus.values.filter { $0.type == type }
    }
}

actor PackageStateManager {
    private var states: [String: String] = [:]
    private var registeredStates: [String: [String]] = [:]
    private var registeredEvents: [String: [String]] = [:]
    
    func registerPackage(id: String, states: [String], events: [String]) {
        registeredStates[id] = states
        registeredEvents[id] = events
        self.states[id] = "idle"
    }
    
    func setState(packageId: String, state: String) {
        states[packageId] = state
    }
    
    func getState(packageId: String) -> String? {
        states[packageId]
    }
}

// MARK: - Events

public enum PackageEvent: Sendable {
    case attached(String)
    case initialized(String)
    case stateChanged(String, String)
}

public enum OrchestratorEvent: Sendable {
    case ready
    case error(String)
}

public struct DocGenerationRequest: Sendable {
    public let packageId: String
    public let contract: PackageContract
}

public struct WorkflowGenerationRequest: Sendable {
    public let packageId: String
    public let actions: [String]
}

public struct MLIndexRequest: Sendable {
    public let packageId: String
    public let contract: PackageContract
}

// MARK: - Status & Errors

public enum OrchestratorStatus: Sendable {
    case idle, loading, running, error
}

public enum PackageOrchestratorError: LocalizedError {
    case missingDependency(String, for: String)
    case circularDependency(String)
    case invalidContract(String)
    
    public var errorDescription: String? {
        switch self {
        case .missingDependency(let dep, let pkg):
            return "Missing dependency '\(dep)' for package '\(pkg)'"
        case .circularDependency(let pkg):
            return "Circular dependency detected involving '\(pkg)'"
        case .invalidContract(let msg):
            return "Invalid contract: \(msg)"
        }
    }
}
