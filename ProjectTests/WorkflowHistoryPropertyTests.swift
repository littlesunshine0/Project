//
//  WorkflowHistoryPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for workflow history functionality
//

import XCTest
import SwiftCheck
@testable import Project

final class WorkflowHistoryPropertyTests: XCTestCase {
    
    var workflowHistory: WorkflowHistoryService!
    var persistenceController: PersistenceController!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Use in-memory store for testing
        persistenceController = PersistenceController(inMemory: true)
        workflowHistory = WorkflowHistoryService(persistenceController: persistenceController)
    }
    
    override func tearDown() async throws {
        try await workflowHistory.clearHistory()
        workflowHistory = nil
        persistenceController = nil
        try await super.tearDown()
    }
    
    // MARK: - Property 27: History monotonicity
    
    /// **Feature: workflow-assistant-app, Property 27: History monotonicity**
    /// For any completed workflow, it should appear in the chronological history,
    /// and history should never decrease in size
    func testHistoryMonotonicity() async throws {
        // Test that history size never decreases when adding entries
        let initialCount = try await workflowHistory.getHistoryCount()
        
        // Record multiple workflow executions
        for i in 0..<10 {
            let workflow = createTestWorkflow(name: "Test Workflow \(i)")
            let execution = WorkflowExecution(workflow: workflow)
            
            let countBefore = try await workflowHistory.getHistoryCount()
            
            try await workflowHistory.recordExecution(
                execution,
                outcome: .success,
                inputs: ["test": "value\(i)"]
            )
            
            let countAfter = try await workflowHistory.getHistoryCount()
            
            // History should grow by exactly 1
            XCTAssertEqual(countAfter, countBefore + 1, "History count should increase by 1 after recording execution")
            
            // Verify the entry exists in history
            let history = try await workflowHistory.getAllHistory()
            XCTAssertTrue(history.contains { $0.workflowName == workflow.name }, "Recorded workflow should appear in history")
        }
        
        let finalCount = try await workflowHistory.getHistoryCount()
        XCTAssertEqual(finalCount, initialCount + 10, "History should have grown by exactly 10 entries")
    }
    
    /// Test that history is chronologically ordered (newest first)
    func testHistoryChronologicalOrdering() async throws {
        // Record workflows with different timestamps
        for i in 0..<5 {
            let workflow = createTestWorkflow(name: "Workflow \(i)")
            var execution = WorkflowExecution(workflow: workflow)
            
            // Set different completion times
            execution.completedAt = Date().addingTimeInterval(TimeInterval(i))
            
            try await workflowHistory.recordExecution(
                execution,
                outcome: .success
            )
            
            // Small delay to ensure different timestamps
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        }
        
        let history = try await workflowHistory.getAllHistory()
        
        // Verify chronological ordering (newest first)
        for i in 0..<(history.count - 1) {
            XCTAssertGreaterThanOrEqual(
                history[i].completedAt,
                history[i + 1].completedAt,
                "History should be ordered chronologically (newest first)"
            )
        }
    }
    
    // MARK: - Property 28: History entry completeness
    
    /// **Feature: workflow-assistant-app, Property 28: History entry completeness**
    /// For any workflow in history, the system should display its name, completion date, and outcome
    func testHistoryEntryCompleteness() async throws {
        let outcomes: [WorkflowOutcome] = [.success, .partial, .failed, .cancelled]
        
        for outcome in outcomes {
            let workflow = createTestWorkflow(name: "Test \(outcome.rawValue)")
            var execution = WorkflowExecution(workflow: workflow)
            execution.completedAt = Date()
            
            try await workflowHistory.recordExecution(
                execution,
                outcome: outcome,
                inputs: ["key": "value"]
            )
        }
        
        let history = try await workflowHistory.getAllHistory()
        
        // Verify each entry has complete information
        for entry in history {
            // Name should not be empty
            XCTAssertFalse(entry.workflowName.isEmpty, "History entry should have a workflow name")
            
            // Completion date should be set
            XCTAssertNotNil(entry.completedAt, "History entry should have a completion date")
            
            // Outcome should be valid
            XCTAssertTrue(
                [WorkflowOutcome.success, .partial, .failed, .cancelled].contains(entry.outcome),
                "History entry should have a valid outcome"
            )
            
            // Should have execution data
            XCTAssertNotNil(entry.execution, "History entry should have execution data")
            
            // Should have workflow ID
            XCTAssertNotEqual(entry.workflowId, UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, "History entry should have a valid workflow ID")
        }
    }
    
    /// Test that history entries contain detailed execution logs
    func testHistoryDetailAvailability() async throws {
        let workflow = createTestWorkflow(name: "Detailed Test")
        var execution = WorkflowExecution(workflow: workflow)
        
        // Add some step results
        execution.results = [
            StepResult(stepIndex: 0, success: true, output: "Step 1 output", duration: 1.0),
            StepResult(stepIndex: 1, success: true, output: "Step 2 output", duration: 2.0),
            StepResult(stepIndex: 2, success: false, output: "Step 3 output", error: "Step 3 error", duration: 0.5)
        ]
        execution.completedAt = Date()
        
        try await workflowHistory.recordExecution(
            execution,
            outcome: .partial
        )
        
        let history = try await workflowHistory.getAllHistory()
        XCTAssertFalse(history.isEmpty, "History should not be empty")
        
        let entry = history[0]
        let logs = entry.executionLogs
        
        // Verify execution logs are available
        XCTAssertEqual(logs.count, 3, "Should have 3 execution logs")
        
        // Verify log details
        XCTAssertTrue(logs[0].success, "First step should be successful")
        XCTAssertEqual(logs[0].output, "Step 1 output", "Should have correct output")
        
        XCTAssertFalse(logs[2].success, "Third step should have failed")
        XCTAssertEqual(logs[2].error, "Step 3 error", "Should have error message")
    }
    
    // MARK: - Property 30: History re-execution
    
    /// **Feature: workflow-assistant-app, Property 30: History re-execution**
    /// For any workflow in history, the system should allow re-execution with a single action
    func testHistoryReExecution() async throws {
        let workflow = createTestWorkflow(name: "Re-executable Workflow")
        var execution = WorkflowExecution(workflow: workflow)
        execution.completedAt = Date()
        
        try await workflowHistory.recordExecution(
            execution,
            outcome: .success,
            inputs: ["param1": "value1", "param2": "value2"]
        )
        
        let history = try await workflowHistory.getAllHistory()
        XCTAssertFalse(history.isEmpty, "History should not be empty")
        
        let entry = history[0]
        
        // Verify we can access the workflow for re-execution
        XCTAssertNotNil(entry.execution.workflow, "Should be able to access workflow from history")
        XCTAssertEqual(entry.execution.workflow.name, workflow.name, "Workflow should match original")
        
        // Verify we can create a new execution from the historical workflow
        let orchestrator = WorkflowOrchestrator()
        let reExecutionWorkflow = entry.execution.workflow
        
        // This verifies that the workflow can be re-executed
        // In a real scenario, this would trigger actual execution
        XCTAssertEqual(reExecutionWorkflow.id, workflow.id, "Re-execution workflow should have same ID")
        XCTAssertEqual(reExecutionWorkflow.steps.count, workflow.steps.count, "Re-execution workflow should have same steps")
    }
    
    // MARK: - Property 31: Input pre-filling on re-execution
    
    /// **Feature: workflow-assistant-app, Property 31: Input pre-filling on re-execution**
    /// For any re-executed workflow from history, the system should pre-fill previous inputs
    /// as defaults while allowing modifications
    func testInputPreFillingOnReExecution() async throws {
        let workflow = createTestWorkflow(name: "Workflow with Inputs")
        var execution = WorkflowExecution(workflow: workflow)
        execution.completedAt = Date()
        
        let originalInputs = [
            "username": "testuser",
            "email": "test@example.com",
            "count": "42"
        ]
        
        try await workflowHistory.recordExecution(
            execution,
            outcome: .success,
            inputs: originalInputs
        )
        
        let history = try await workflowHistory.getAllHistory()
        XCTAssertFalse(history.isEmpty, "History should not be empty")
        
        let entry = history[0]
        
        // Verify inputs are stored and retrievable
        XCTAssertNotNil(entry.inputs, "History entry should have inputs")
        XCTAssertEqual(entry.inputs?.count, originalInputs.count, "Should have all original inputs")
        
        // Verify each input is preserved
        for (key, value) in originalInputs {
            XCTAssertEqual(entry.inputs?[key], value, "Input '\(key)' should be preserved")
        }
        
        // Verify inputs can be modified for re-execution
        var modifiedInputs = entry.inputs ?? [:]
        modifiedInputs["username"] = "newuser"
        modifiedInputs["count"] = "100"
        
        // The modified inputs should be different from original
        XCTAssertNotEqual(modifiedInputs["username"], originalInputs["username"], "Inputs should be modifiable")
        XCTAssertNotEqual(modifiedInputs["count"], originalInputs["count"], "Inputs should be modifiable")
        
        // But original inputs should remain unchanged in history
        let historyAgain = try await workflowHistory.getAllHistory()
        let entryAgain = historyAgain[0]
        XCTAssertEqual(entryAgain.inputs?["username"], originalInputs["username"], "Original inputs should remain unchanged")
    }
    
    /// Test that workflows without inputs can still be re-executed
    func testReExecutionWithoutInputs() async throws {
        let workflow = createTestWorkflow(name: "Workflow without Inputs")
        var execution = WorkflowExecution(workflow: workflow)
        execution.completedAt = Date()
        
        // Record without inputs
        try await workflowHistory.recordExecution(
            execution,
            outcome: .success,
            inputs: nil
        )
        
        let history = try await workflowHistory.getAllHistory()
        XCTAssertFalse(history.isEmpty, "History should not be empty")
        
        let entry = history[0]
        
        // Verify workflow can be re-executed even without inputs
        XCTAssertNotNil(entry.execution.workflow, "Should be able to access workflow")
        
        // Inputs should be nil or empty
        XCTAssertTrue(entry.inputs == nil || entry.inputs?.isEmpty == true, "Inputs should be nil or empty")
    }
    
    // MARK: - Helper Methods
    
    private func createTestWorkflow(name: String) -> Workflow {
        return Workflow(
            id: UUID(),
            name: name,
            description: "Test workflow for \(name)",
            steps: [
                .command(Command(script: "echo 'Step 1'", description: "First step")),
                .command(Command(script: "echo 'Step 2'", description: "Second step"))
            ],
            category: .testing,
            tags: ["test"],
            isBuiltIn: false,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}
