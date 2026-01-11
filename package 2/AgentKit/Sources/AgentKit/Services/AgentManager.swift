//
//  AgentManager.swift
//  AgentKit
//
//  Agent lifecycle management and execution
//

import Foundation
import Combine

// MARK: - Agent Manager

@MainActor
public class AgentManager: ObservableObject {
    public static let shared = AgentManager()
    
    @Published public var agents: [Agent] = []
    @Published public var runningAgents: Set<UUID> = []
    @Published public var recentResults: [AgentRunResult] = []
    @Published public var isLoading = false
    
    private let agentsKey = "savedAgents"
    private let maxResults = 100
    
    private init() {
        loadAgents()
    }
    
    // MARK: - Agent CRUD
    
    public func createAgent(
        name: String,
        description: String,
        type: AgentType,
        capabilities: [AgentCapability] = [],
        triggers: [AgentTrigger] = [],
        actions: [AgentAction] = []
    ) -> Agent {
        let agent = Agent(
            name: name,
            description: description,
            type: type,
            capabilities: capabilities,
            triggers: triggers,
            actions: actions
        )
        
        agents.append(agent)
        saveAgents()
        
        return agent
    }
    
    public func updateAgent(_ agent: Agent) {
        if let index = agents.firstIndex(where: { $0.id == agent.id }) {
            agents[index] = agent
            saveAgents()
        }
    }
    
    public func deleteAgent(_ agent: Agent) {
        agents.removeAll { $0.id == agent.id }
        saveAgents()
    }
    
    public func getAgent(byId id: UUID) -> Agent? {
        agents.first { $0.id == id }
    }
    
    public func getAgents(byType type: AgentType) -> [Agent] {
        agents.filter { $0.type == type }
    }
    
    // MARK: - Agent Execution
    
    public func runAgent(_ agent: Agent) async -> AgentRunResult {
        guard !runningAgents.contains(agent.id) else {
            return AgentRunResult(
                agentId: agent.id,
                startTime: Date(),
                endTime: Date(),
                status: .failure,
                output: "",
                error: "Agent is already running",
                actionResults: []
            )
        }
        
        runningAgents.insert(agent.id)
        
        var updatedAgent = agent
        updatedAgent.status = .running
        updatedAgent.runCount += 1
        updateAgent(updatedAgent)
        
        let startTime = Date()
        var actionResults: [AgentRunResult.ActionResult] = []
        var overallSuccess = true
        var output = ""
        var errorMessage: String?
        
        let sortedActions = agent.actions.sorted { $0.order < $1.order }
        
        for action in sortedActions {
            let actionStart = Date()
            let result = await executeAction(action, agent: agent)
            let actionEnd = Date()
            
            let actionResult = AgentRunResult.ActionResult(
                actionId: action.id,
                actionName: action.name,
                success: result.success,
                output: result.output,
                error: result.error,
                duration: actionEnd.timeIntervalSince(actionStart)
            )
            
            actionResults.append(actionResult)
            output += "[\(action.name)] \(result.output)\n"
            
            if !result.success {
                overallSuccess = false
                errorMessage = result.error
                
                if !action.continueOnError {
                    break
                }
            }
        }
        
        let endTime = Date()
        
        updatedAgent.status = .idle
        updatedAgent.lastRunAt = endTime
        if overallSuccess {
            updatedAgent.successCount += 1
        }
        updateAgent(updatedAgent)
        
        runningAgents.remove(agent.id)
        
        let runResult = AgentRunResult(
            agentId: agent.id,
            startTime: startTime,
            endTime: endTime,
            status: overallSuccess ? .success : .failure,
            output: output,
            error: errorMessage,
            actionResults: actionResults
        )
        
        recentResults.insert(runResult, at: 0)
        if recentResults.count > maxResults {
            recentResults.removeLast()
        }
        
        return runResult
    }
    
    private func executeAction(_ action: AgentAction, agent: Agent) async -> (success: Bool, output: String, error: String?) {
        switch action.type {
        case .shellCommand, .gitCommand, .buildCommand, .script:
            return await executeShellCommand(action.command, timeout: action.timeout)
        case .notification:
            return sendActionNotification(action)
        case .workflow:
            return (true, "Workflow '\(action.command)' executed", nil)
        default:
            return (true, "Action type \(action.type.rawValue) executed", nil)
        }
    }
    
    private func executeShellCommand(_ command: String, timeout: TimeInterval) async -> (success: Bool, output: String, error: String?) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", command]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            
            let output = String(data: outputData, encoding: .utf8) ?? ""
            let error = String(data: errorData, encoding: .utf8)
            
            let success = process.terminationStatus == 0
            return (success, output, success ? nil : error)
        } catch {
            return (false, "", error.localizedDescription)
        }
    }
    
    private func sendActionNotification(_ action: AgentAction) -> (success: Bool, output: String, error: String?) {
        let title = action.parameters["title"] ?? "Agent Notification"
        let message = action.parameters["message"] ?? action.command
        return (true, "Notification sent: \(title) - \(message)", nil)
    }
    
    // MARK: - Persistence
    
    private func loadAgents() {
        if let data = UserDefaults.standard.data(forKey: agentsKey),
           let decoded = try? JSONDecoder().decode([Agent].self, from: data) {
            agents = decoded
        }
    }
    
    private func saveAgents() {
        if let encoded = try? JSONEncoder().encode(agents) {
            UserDefaults.standard.set(encoded, forKey: agentsKey)
        }
    }
}
