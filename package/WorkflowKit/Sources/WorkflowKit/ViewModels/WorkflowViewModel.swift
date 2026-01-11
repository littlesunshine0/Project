//
//  WorkflowViewModel.swift
//  WorkflowKit
//

import Foundation
import Combine

@MainActor
public class WorkflowViewModel: ObservableObject {
    @Published public var workflows: [Workflow] = []
    @Published public var selectedWorkflow: Workflow?
    @Published public var searchText = ""
    @Published public var selectedCategory: WorkflowCategory?
    @Published public var selectedSection: WorkflowSection = .all
    @Published public var isLoading = false
    @Published public var error: WorkflowError?
    
    private let manager: WorkflowManager
    
    public init(manager: WorkflowManager = .shared) {
        self.manager = manager
        Task { await loadWorkflows() }
    }
    
    // MARK: - CRUD Operations
    
    public func loadWorkflows() async {
        isLoading = true
        workflows = manager.workflows
        isLoading = false
    }
    
    public func create(name: String, description: String, steps: [WorkflowStep] = [], category: WorkflowCategory = .general) async {
        let _ = manager.createWorkflow(name: name, description: description, steps: steps, category: category)
        await loadWorkflows()
    }
    
    public func update(_ workflow: Workflow) async {
        manager.updateWorkflow(workflow)
        await loadWorkflows()
    }
    
    public func delete(_ workflow: Workflow) async {
        manager.deleteWorkflow(workflow)
        await loadWorkflows()
    }
    
    public func execute(_ workflow: Workflow) async -> WorkflowRunResult {
        await manager.runWorkflow(workflow)
    }
    
    // MARK: - Filtering
    
    public var filteredWorkflows: [Workflow] {
        var result = workflows
        
        if let category = selectedCategory, category != .all {
            result = result.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch selectedSection {
        case .all: break
        case .recent: result = Array(result.sorted { $0.updatedAt > $1.updatedAt }.prefix(10))
        case .templates: result = result.filter { $0.isBuiltIn }
        case .running: result = [] // Would filter by running status
        case .history: break
        case .favorites: break // Would filter by favorites
        }
        
        return result
    }
}
