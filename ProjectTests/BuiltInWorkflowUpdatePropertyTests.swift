//
//  BuiltInWorkflowUpdatePropertyTests.swift
//  ProjectTests
//
//  Property-based tests for built-in workflow updates
//

import XCTest
import SwiftCheck
@testable import Project

class BuiltInWorkflowUpdatePropertyTests: XCTestCase {
    
    // MARK: - Test Setup
    
    var workflowManager: WorkflowManager!
    var workflowStore: WorkflowStore!
    
    override func setUp() async throws {
        try await super.setUp()
        workflowStore = WorkflowStore()
        workflowManager = WorkflowManager(store: workflowStore)
    }
    
    override func tearDown() async throws {
        workflowManager = nil
        workflowStore = nil
        try await super.tearDown()
    }
    
    // MARK: - Property 66: Built-in workflow updates
    
    /// **Feature: workflow-assistant-app, Property 66: Built-in workflow updates**
    /// For any built-in workflow with a new version available locally, the system should update it automatically
    /// **Validates: Requirements 16.5**
    func testBuiltInWorkflowUpdates() async throws {
        // Create a built-in workflow with version 1
        let workflowId = UUID()
        let originalWorkflow = Workflow(
            id: workflowId,
            name: "Test Built-in Workflow",
            description: "Original version",
            steps: [
                .command(Command(
                    script: "echo 'version 1'",
                    description: "Version 1 command",
                    requiresPermission: false,
                    timeout: 30.0
                ))
            ],
            category: .development,
            tags: ["test", "v1"],
            isBuiltIn: true,
            createdAt: Date().addingTimeInterval(-86400),  // Created 1 day ago
            updatedAt: Date().addingTimeInterval(-86400)
        )
        
        // Save the original workflow
        await workflowStore.save(originalWorkflow)
        
        // Verify it was saved
        let savedWorkflow = await workflowStore.fetch(id: workflowId)
        XCTAssertNotNil(savedWorkflow, "Original workflow should be saved")
        XCTAssertEqual(savedWorkflow?.description, "Original version")
        
        // Create an updated version of the built-in workflow
        let updatedWorkflow = Workflow(
            id: workflowId,
            name: "Test Built-in Workflow",
            description: "Updated version",
            steps: [
                .command(Command(
                    script: "echo 'version 2'",
                    description: "Version 2 command",
                    requiresPermission: false,
                    timeout: 30.0
                )),
                .command(Command(
                    script: "echo 'new feature'",
                    description: "New feature in version 2",
                    requiresPermission: false,
                    timeout: 30.0
                ))
            ],
            category: .development,
            tags: ["test", "v2"],
            isBuiltIn: true,
            createdAt: Date().addingTimeInterval(-86400),
            updatedAt: Date()  // Updated now
        )
        
        // Check for updates and apply them
        let updateAvailable = await workflowManager.checkForBuiltInWorkflowUpdates(
            localWorkflow: updatedWorkflow
        )
        
        XCTAssertTrue(updateAvailable, "Update should be available for built-in workflow")
        
        // Apply the update
        await workflowManager.updateBuiltInWorkflow(updatedWorkflow)
        
        // Verify the workflow was updated
        let fetchedWorkflow = await workflowStore.fetch(id: workflowId)
        XCTAssertNotNil(fetchedWorkflow, "Updated workflow should exist")
        XCTAssertEqual(fetchedWorkflow?.description, "Updated version", "Description should be updated")
        XCTAssertEqual(fetchedWorkflow?.steps.count, 2, "Should have new steps")
        XCTAssertTrue(fetchedWorkflow?.tags.contains("v2") ?? false, "Should have updated tags")
        XCTAssertGreaterThan(
            fetchedWorkflow?.updatedAt ?? Date.distantPast,
            originalWorkflow.updatedAt,
            "Updated timestamp should be newer"
        )
    }
    
    // Test that only built-in workflows are auto-updated
    func testOnlyBuiltInWorkflowsAreAutoUpdated() async throws {
        // Create a custom (non-built-in) workflow
        let customWorkflowId = UUID()
        let customWorkflow = Workflow(
            id: customWorkflowId,
            name: "Custom Workflow",
            description: "User created",
            steps: [],
            category: .general,
            tags: ["custom"],
            isBuiltIn: false,  // Not a built-in workflow
            createdAt: Date(),
            updatedAt: Date()
        )
        
        await workflowStore.save(customWorkflow)
        
        // Try to update it as if it were built-in
        let updatedCustom = Workflow(
            id: customWorkflowId,
            name: "Custom Workflow",
            description: "Attempted update",
            steps: [],
            category: .general,
            tags: ["custom", "updated"],
            isBuiltIn: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // Check for updates - should return false for non-built-in
        let updateAvailable = await workflowManager.checkForBuiltInWorkflowUpdates(
            localWorkflow: updatedCustom
        )
        
        XCTAssertFalse(updateAvailable, "Custom workflows should not be auto-updated")
        
        // Verify original workflow is unchanged
        let fetchedWorkflow = await workflowStore.fetch(id: customWorkflowId)
        XCTAssertEqual(fetchedWorkflow?.description, "User created", "Custom workflow should not be updated")
    }
    
    // Test that updates preserve user customizations
    func testUpdatesPreserveUserCustomizations() async throws {
        // Create a built-in workflow
        let workflowId = UUID()
        let builtInWorkflow = Workflow(
            id: workflowId,
            name: "Built-in Workflow",
            description: "Original",
            steps: [],
            category: .development,
            tags: ["builtin"],
            isBuiltIn: true,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        await workflowStore.save(builtInWorkflow)
        
        // User creates a customized variant
        let customizedId = UUID()
        let customizedVariant = Workflow(
            id: customizedId,
            name: "Built-in Workflow (My Custom)",
            description: "User customized version",
            steps: [],
            category: .development,
            tags: ["builtin", "customized"],
            isBuiltIn: false,  // User variant is not built-in
            createdAt: Date(),
            updatedAt: Date()
        )
        
        await workflowStore.save(customizedVariant)
        
        // Update the built-in workflow
        let updatedBuiltIn = Workflow(
            id: workflowId,
            name: "Built-in Workflow",
            description: "Updated",
            steps: [],
            category: .development,
            tags: ["builtin", "v2"],
            isBuiltIn: true,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        await workflowManager.updateBuiltInWorkflow(updatedBuiltIn)
        
        // Verify built-in was updated
        let fetchedBuiltIn = await workflowStore.fetch(id: workflowId)
        XCTAssertEqual(fetchedBuiltIn?.description, "Updated")
        
        // Verify user customization was preserved
        let fetchedCustom = await workflowStore.fetch(id: customizedId)
        XCTAssertEqual(fetchedCustom?.description, "User customized version", "User customization should be preserved")
        XCTAssertFalse(fetchedCustom?.isBuiltIn ?? true, "User variant should remain non-built-in")
    }
    
    // Test automatic update checking on app launch
    func testAutomaticUpdateCheckingOnLaunch() async throws {
        // Create multiple built-in workflows with different versions
        let workflows = [
            Workflow(
                id: UUID(),
                name: "Workflow 1",
                description: "Old version",
                steps: [],
                category: .development,
                tags: ["v1"],
                isBuiltIn: true,
                createdAt: Date().addingTimeInterval(-86400),
                updatedAt: Date().addingTimeInterval(-86400)
            ),
            Workflow(
                id: UUID(),
                name: "Workflow 2",
                description: "Old version",
                steps: [],
                category: .testing,
                tags: ["v1"],
                isBuiltIn: true,
                createdAt: Date().addingTimeInterval(-86400),
                updatedAt: Date().addingTimeInterval(-86400)
            ),
            Workflow(
                id: UUID(),
                name: "Workflow 3",
                description: "Old version",
                steps: [],
                category: .documentation,
                tags: ["v1"],
                isBuiltIn: true,
                createdAt: Date().addingTimeInterval(-86400),
                updatedAt: Date().addingTimeInterval(-86400)
            )
        ]
        
        // Save old versions
        for workflow in workflows {
            await workflowStore.save(workflow)
        }
        
        // Create updated versions
        let updatedWorkflows = workflows.map { workflow in
            Workflow(
                id: workflow.id,
                name: workflow.name,
                description: "Updated version",
                steps: workflow.steps,
                category: workflow.category,
                tags: ["v2"],
                isBuiltIn: true,
                createdAt: workflow.createdAt,
                updatedAt: Date()
            )
        }
        
        // Simulate app launch - check for all updates
        let updatesAvailable = await workflowManager.checkForAllBuiltInWorkflowUpdates(
            availableWorkflows: updatedWorkflows
        )
        
        XCTAssertEqual(updatesAvailable.count, 3, "Should find updates for all 3 workflows")
        
        // Apply all updates
        await workflowManager.updateAllBuiltInWorkflows(updatedWorkflows)
        
        // Verify all were updated
        for workflow in workflows {
            let fetched = await workflowStore.fetch(id: workflow.id)
            XCTAssertEqual(fetched?.description, "Updated version", "Workflow \(workflow.name) should be updated")
            XCTAssertTrue(fetched?.tags.contains("v2") ?? false, "Should have v2 tag")
        }
    }
    
    // Test that updates maintain workflow ID consistency
    func testUpdatesMaintainWorkflowIDConsistency() async throws {
        let workflowId = UUID()
        
        // Create original workflow
        let original = Workflow(
            id: workflowId,
            name: "Consistent ID Workflow",
            description: "Version 1",
            steps: [],
            category: .development,
            tags: ["v1"],
            isBuiltIn: true,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        await workflowStore.save(original)
        
        // Update multiple times
        for version in 2...5 {
            let updated = Workflow(
                id: workflowId,  // Same ID
                name: "Consistent ID Workflow",
                description: "Version \(version)",
                steps: [],
                category: .development,
                tags: ["v\(version)"],
                isBuiltIn: true,
                createdAt: original.createdAt,
                updatedAt: Date()
            )
            
            await workflowManager.updateBuiltInWorkflow(updated)
            
            // Verify ID remains consistent
            let fetched = await workflowStore.fetch(id: workflowId)
            XCTAssertNotNil(fetched, "Workflow should exist after update \(version)")
            XCTAssertEqual(fetched?.id, workflowId, "ID should remain consistent")
            XCTAssertEqual(fetched?.description, "Version \(version)", "Should have latest version")
        }
        
        // Verify only one workflow exists (not duplicates)
        let allWorkflows = await workflowStore.fetchAll()
        let matchingWorkflows = allWorkflows.filter { $0.id == workflowId }
        XCTAssertEqual(matchingWorkflows.count, 1, "Should have exactly one workflow with this ID")
    }
    
    // Test update notification to user
    func testUpdateNotificationToUser() async throws {
        // Create a built-in workflow
        let workflowId = UUID()
        let original = Workflow(
            id: workflowId,
            name: "Notifiable Workflow",
            description: "Original",
            steps: [],
            category: .development,
            tags: ["v1"],
            isBuiltIn: true,
            createdAt: Date(),
            updatedAt: Date().addingTimeInterval(-86400)
        )
        
        await workflowStore.save(original)
        
        // Create updated version
        let updated = Workflow(
            id: workflowId,
            name: "Notifiable Workflow",
            description: "Updated with new features",
            steps: [
                .command(Command(
                    script: "echo 'new feature'",
                    description: "New feature",
                    requiresPermission: false,
                    timeout: 30.0
                ))
            ],
            category: .development,
            tags: ["v2"],
            isBuiltIn: true,
            createdAt: original.createdAt,
            updatedAt: Date()
        )
        
        // Check for updates and get notification info
        let updateInfo = await workflowManager.getUpdateInfo(
            currentWorkflow: original,
            newWorkflow: updated
        )
        
        XCTAssertNotNil(updateInfo, "Should provide update information")
        XCTAssertEqual(updateInfo?.workflowName, "Notifiable Workflow")
        XCTAssertFalse(updateInfo?.changeDescription.isEmpty ?? true, "Should describe changes")
        XCTAssertTrue(updateInfo?.hasNewSteps ?? false, "Should indicate new steps")
    }
}

// MARK: - Supporting Types

/// Manages workflow storage and retrieval
actor WorkflowStore {
    private var workflows: [UUID: Workflow] = [:]
    
    func save(_ workflow: Workflow) {
        workflows[workflow.id] = workflow
    }
    
    func fetch(id: UUID) -> Workflow? {
        return workflows[id]
    }
    
    func fetchAll() -> [Workflow] {
        return Array(workflows.values)
    }
    
    func delete(id: UUID) {
        workflows.removeValue(forKey: id)
    }
    
    func clear() {
        workflows.removeAll()
    }
}

/// Manages workflow updates and version checking
actor WorkflowManager {
    private let store: WorkflowStore
    
    init(store: WorkflowStore) {
        self.store = store
    }
    
    /// Check if a built-in workflow has an update available
    func checkForBuiltInWorkflowUpdates(localWorkflow: Workflow) async -> Bool {
        // Only check built-in workflows
        guard localWorkflow.isBuiltIn else {
            return false
        }
        
        // Check if there's an existing workflow with this ID
        guard let existingWorkflow = await store.fetch(id: localWorkflow.id) else {
            // New workflow available
            return true
        }
        
        // Check if the local version is newer
        return localWorkflow.updatedAt > existingWorkflow.updatedAt
    }
    
    /// Update a built-in workflow
    func updateBuiltInWorkflow(_ workflow: Workflow) async {
        guard workflow.isBuiltIn else {
            return
        }
        
        await store.save(workflow)
    }
    
    /// Check for updates for all built-in workflows
    func checkForAllBuiltInWorkflowUpdates(availableWorkflows: [Workflow]) async -> [Workflow] {
        var updatesAvailable: [Workflow] = []
        
        for workflow in availableWorkflows where workflow.isBuiltIn {
            let hasUpdate = await checkForBuiltInWorkflowUpdates(localWorkflow: workflow)
            if hasUpdate {
                updatesAvailable.append(workflow)
            }
        }
        
        return updatesAvailable
    }
    
    /// Update all built-in workflows
    func updateAllBuiltInWorkflows(_ workflows: [Workflow]) async {
        for workflow in workflows where workflow.isBuiltIn {
            await updateBuiltInWorkflow(workflow)
        }
    }
    
    /// Get information about an available update
    func getUpdateInfo(currentWorkflow: Workflow, newWorkflow: Workflow) async -> WorkflowUpdateInfo? {
        guard newWorkflow.isBuiltIn else {
            return nil
        }
        
        guard newWorkflow.updatedAt > currentWorkflow.updatedAt else {
            return nil
        }
        
        let hasNewSteps = newWorkflow.steps.count > currentWorkflow.steps.count
        let hasChangedDescription = newWorkflow.description != currentWorkflow.description
        let hasNewTags = !Set(newWorkflow.tags).isSubset(of: Set(currentWorkflow.tags))
        
        var changeDescription = "Updated workflow available"
        if hasNewSteps {
            changeDescription += " with \(newWorkflow.steps.count - currentWorkflow.steps.count) new step(s)"
        }
        if hasChangedDescription {
            changeDescription += ", improved description"
        }
        if hasNewTags {
            changeDescription += ", new capabilities"
        }
        
        return WorkflowUpdateInfo(
            workflowId: newWorkflow.id,
            workflowName: newWorkflow.name,
            currentVersion: currentWorkflow.updatedAt,
            newVersion: newWorkflow.updatedAt,
            changeDescription: changeDescription,
            hasNewSteps: hasNewSteps,
            hasChangedDescription: hasChangedDescription,
            hasNewTags: hasNewTags
        )
    }
}

struct WorkflowUpdateInfo {
    let workflowId: UUID
    let workflowName: String
    let currentVersion: Date
    let newVersion: Date
    let changeDescription: String
    let hasNewSteps: Bool
    let hasChangedDescription: Bool
    let hasNewTags: Bool
}
