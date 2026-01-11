//
//  AgentViewModel.swift
//  AgentKit
//

import Foundation
import Combine

@MainActor
public class AgentViewModel: ObservableObject {
    @Published public var agents: [Agent] = []
    @Published public var selectedAgent: Agent?
    @Published public var searchText = ""
    @Published public var selectedCategory: AgentCategory?
    @Published public var selectedSection: AgentSection = .all
    @Published public var isLoading = false
    @Published public var error: AgentError?
    
    private let manager: AgentManager
    
    public init(manager: AgentManager = .shared) {
        self.manager = manager
        Task { await loadAgents() }
    }
    
    // MARK: - CRUD Operations
    
    public func loadAgents() async {
        isLoading = true
        agents = manager.agents
        isLoading = false
    }
    
    public func create(name: String, description: String, type: AgentType, capabilities: [AgentCapability] = []) async {
        let _ = manager.createAgent(name: name, description: description, type: type, capabilities: capabilities)
        await loadAgents()
    }
    
    public func update(_ agent: Agent) async {
        manager.updateAgent(agent)
        await loadAgents()
    }
    
    public func delete(_ agent: Agent) async {
        manager.deleteAgent(agent)
        await loadAgents()
    }
    
    public func start(_ agent: Agent) async -> AgentRunResult {
        await manager.runAgent(agent)
    }
    
    public func stop(_ agent: Agent) async {
        // Stop agent logic
        await loadAgents()
    }
    
    // MARK: - Filtering
    
    public var filteredAgents: [Agent] {
        var result = agents
        
        if let category = selectedCategory, category != .all {
            result = result.filter { $0.type.rawValue.lowercased().contains(category.rawValue.lowercased()) }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch selectedSection {
        case .all: break
        case .running: result = result.filter { $0.status == .running }
        case .templates: break
        case .history: break
        }
        
        return result
    }
}
