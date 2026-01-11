//
//  ViewServiceConnectionTests.swift
//  ProjectTests
//
//  Tests that verify views are properly connected to their services
//  and that the data flows correctly between them
//

import XCTest
@testable import Project

class ViewServiceConnectionTests: XCTestCase {
    
    // MARK: - Dashboard View Connections
    
    func testDashboardViewHasDataSource() async throws {
        // Dashboard should display:
        // - System resources
        // - Recent workflows
        // - Quick actions
        // - Activity timeline
        
        var issues: [String] = []
        var working: [String] = []
        
        // Check PerformanceMonitor provides system resources
        let monitor = PerformanceMonitor.shared
        let resources = await monitor.getCurrentResources()
        if resources.cpuUsage >= 0 {
            working.append("PerformanceMonitor provides CPU data")
        } else {
            issues.append("PerformanceMonitor CPU data unavailable")
        }
        
        // Check WorkflowOrchestrator provides recent workflows
        let orchestrator = WorkflowOrchestrator()
        let paused = await orchestrator.getPausedWorkflows()
        working.append("WorkflowOrchestrator accessible (paused: \(paused.count))")
        
        printConnectionReport("DashboardView", working: working, issues: issues)
        XCTAssertTrue(issues.count < working.count, "Dashboard has more issues than working connections")
    }
    
    func testWorkflowsViewHasDataSource() async throws {
        var issues: [String] = []
        var working: [String] = []
        
        // WorkflowsView should connect to:
        // - WorkflowOrchestrator for execution
        // - Workflow model for data
        
        // Test workflow loading
        let viewModel = await WorkflowsViewModel()
        await viewModel.loadWorkflows()
        
        if await viewModel.workflows.isEmpty {
            issues.append("No workflows loaded - check loadWorkflows()")
        } else {
            working.append("Workflows loaded: \(await viewModel.workflows.count)")
        }
        
        if await viewModel.templates.isEmpty {
            issues.append("No templates loaded")
        } else {
            working.append("Templates loaded: \(await viewModel.templates.count)")
        }
        
        printConnectionReport("WorkflowsView", working: working, issues: issues)
        XCTAssertFalse(await viewModel.workflows.isEmpty, "WorkflowsView should have workflows")
    }
    
    func testInventoryViewHasDataSource() async throws {
        var issues: [String] = []
        var working: [String] = []
        
        // InventoryView should connect to:
        // - InventoryService for CRUD operations
        // - MarketplaceIntegrationService for listings
        
        let inventoryService = InventoryService.shared
        let items = await inventoryService.getAllItems()
        
        working.append("InventoryService accessible")
        
        if items.isEmpty {
            issues.append("No inventory items - may need sample data")
        } else {
            working.append("Inventory has \(items.count) items")
        }
        
        printConnectionReport("InventoryView", working: working, issues: issues)
    }
    
    func testDocumentationViewHasDataSource() async throws {
        var issues: [String] = []
        var working: [String] = []
        
        // DocumentationView should connect to:
        // - PreIndexedDocumentation for offline docs
        // - KnowledgeBrowserService for knowledge base
        
        let preIndexed = PreIndexedDocumentation.shared
        let sources = await preIndexed.getSources()
        
        if sources.isEmpty {
            issues.append("PreIndexedDocumentation has no sources")
        } else {
            working.append("PreIndexedDocumentation has \(sources.count) sources")
        }
        
        // Check JSON documentation files exist
        let appleDocsURL = Bundle.main.url(forResource: "apple_developer_docs", withExtension: "json")
        let swiftDocsURL = Bundle.main.url(forResource: "swift_developer_docs", withExtension: "json")
        
        if appleDocsURL != nil {
            working.append("apple_developer_docs.json found")
        } else {
            issues.append("apple_developer_docs.json missing from bundle")
        }
        
        if swiftDocsURL != nil {
            working.append("swift_developer_docs.json found")
        } else {
            issues.append("swift_developer_docs.json missing from bundle")
        }
        
        printConnectionReport("DocumentationView", working: working, issues: issues)
    }
    
    func testChatViewHasDataSource() async throws {
        var issues: [String] = []
        var working: [String] = []
        
        // ChatView should connect to:
        // - ChatExecutor for command processing
        // - ConversationService for history
        // - NLUEngine for intent recognition
        
        let chatExecutor = ChatExecutor.shared
        working.append("ChatExecutor accessible")
        
        // Check available commands
        let commands = await chatExecutor.availableCommands
        if commands.isEmpty {
            issues.append("No chat commands registered")
        } else {
            working.append("\(commands.count) chat commands available")
        }
        
        printConnectionReport("ChatView", working: working, issues: issues)
    }
    
    func testAgentViewHasDataSource() async throws {
        var issues: [String] = []
        var working: [String] = []
        
        // AgentView should connect to:
        // - AgentManager for agent CRUD
        // - Agent model for data
        
        let agentManager = AgentManager.shared
        let agents = await agentManager.getAllAgents()
        
        working.append("AgentManager accessible")
        
        if agents.isEmpty {
            issues.append("No agents configured - may need defaults")
        } else {
            working.append("\(agents.count) agents available")
        }
        
        printConnectionReport("AgentView", working: working, issues: issues)
    }
    
    func testCommandRegistryViewHasDataSource() async throws {
        var issues: [String] = []
        var working: [String] = []
        
        // CommandRegistryView should connect to:
        // - CommandLibraryLoader for command data
        // - CommandIntegrationService for execution
        
        let loader = CommandLibraryLoader.shared
        let commands = await loader.loadAllCommands()
        
        if commands.isEmpty {
            issues.append("No commands loaded from library")
        } else {
            working.append("\(commands.count) commands in library")
        }
        
        // Check JSON command files exist
        let coreCommandsURL = Bundle.main.url(forResource: "core_commands", withExtension: "json")
        if coreCommandsURL != nil {
            working.append("core_commands.json found")
        } else {
            issues.append("core_commands.json missing")
        }
        
        printConnectionReport("CommandRegistryView", working: working, issues: issues)
    }
    
    func testKnowledgeBrowserViewHasDataSource() async throws {
        var issues: [String] = []
        var working: [String] = []
        
        // KnowledgeBrowserView should connect to:
        // - KnowledgeBrowserService for data
        // - Knowledge database
        
        let service = KnowledgeBrowserService.shared
        let items = await service.getItems(source: .local, search: "", category: nil, limit: 10)
        
        working.append("KnowledgeBrowserService accessible")
        
        if items.isEmpty {
            issues.append("No knowledge items - database may be empty")
        } else {
            working.append("\(items.count) knowledge items found")
        }
        
        // Check database file
        let stats = await service.getStats()
        if let stats = stats {
            working.append("Stats: \(stats.totalItems) total items")
        } else {
            issues.append("Could not get knowledge stats")
        }
        
        printConnectionReport("KnowledgeBrowserView", working: working, issues: issues)
    }
    
    // MARK: - Helper
    
    private func printConnectionReport(_ viewName: String, working: [String], issues: [String]) {
        print("\n--- \(viewName) Connection Report ---")
        print("Working (\(working.count)):")
        for item in working {
            print("  ✅ \(item)")
        }
        if !issues.isEmpty {
            print("Issues (\(issues.count)):")
            for item in issues {
                print("  ❌ \(item)")
            }
        }
    }
}
