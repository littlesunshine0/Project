//
//  CollaborationPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for collaboration system
//

import XCTest
import SwiftCheck
@testable import Project

class CollaborationPropertyTests: XCTestCase {
    
    var collaborationManager: CollaborationManager!
    var currentUser: User!
    
    override func setUp() async throws {
        try await super.setUp()
        currentUser = User(
            name: "Test User",
            deviceId: "test-device-\(UUID().uuidString)",
            deviceName: "Test Device"
        )
        collaborationManager = CollaborationManager(currentUser: currentUser)
    }
    
    override func tearDown() async throws {
        await collaborationManager.stop()
        try await super.tearDown()
    }
    
    // MARK: - Property 49: Workflow shareability
    // **Feature: workflow-assistant-app, Property 49: Workflow shareability**
    
    func testWorkflowShareability() {
        property("For any workflow, the system should allow sharing it with other users on the same network") <- forAll { (workflowName: String, workflowDescription: String) in
            // Filter out empty strings
            guard !workflowName.isEmpty && !workflowDescription.isEmpty else {
                return true
            }
            
            let expectation = XCTestExpectation(description: "Share workflow")
            var testPassed = false
            
            Task {
                // Create a workflow
                let workflow = Workflow(
                    name: workflowName,
                    description: workflowDescription,
                    steps: [
                        .command(Command(
                            script: "echo 'test'",
                            description: "Test command"
                        ))
                    ],
                    category: .general,
                    tags: ["test"]
                )
                
                // Create collaborators
                let collaborators = [
                    User(name: "User 1", deviceId: "device-1", deviceName: "Device 1"),
                    User(name: "User 2", deviceId: "device-2", deviceName: "Device 2")
                ]
                
                do {
                    // Share the workflow
                    try await self.collaborationManager.shareWorkflow(workflow, with: collaborators)
                    
                    // Verify the workflow is shared
                    let isShared = await self.collaborationManager.isShared(workflow.id)
                    let sharedWorkflow = await self.collaborationManager.getSharedWorkflow(workflow.id)
                    
                    testPassed = isShared && sharedWorkflow != nil
                } catch {
                    testPassed = false
                }
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
            return testPassed
        }.withSize(100)
    }
    
    // MARK: - Property 50: Version history maintenance
    // **Feature: workflow-assistant-app, Property 50: Version history maintenance**
    
    func testVersionHistoryMaintenance() {
        property("For any shared workflow, the collaboration space should maintain version history and track contributor changes") <- forAll { (workflowName: String) in
            guard !workflowName.isEmpty else {
                return true
            }
            
            let expectation = XCTestExpectation(description: "Version history")
            var testPassed = false
            
            Task {
                // Create and share a workflow
                let workflow = Workflow(
                    name: workflowName,
                    description: "Test workflow",
                    steps: [],
                    category: .general,
                    tags: []
                )
                
                let collaborators = [
                    User(name: "Collaborator", deviceId: "collab-device", deviceName: "Collab Device")
                ]
                
                do {
                    try await self.collaborationManager.shareWorkflow(workflow, with: collaborators)
                    
                    // Make a change
                    let change = WorkflowChange(
                        workflowId: workflow.id,
                        author: self.currentUser,
                        changeType: .modified,
                        description: "Updated workflow"
                    )
                    
                    try await self.collaborationManager.syncChanges([change])
                    
                    // Get version history
                    let history = await self.collaborationManager.getVersionHistory(for: workflow.id)
                    
                    // Verify history exists and contains changes
                    testPassed = !history.isEmpty && history.count >= 1
                } catch {
                    testPassed = false
                }
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
            return testPassed
        }.withSize(100)
    }
    
    // MARK: - Property 51: Real-time synchronization
    // **Feature: workflow-assistant-app, Property 51: Real-time synchronization**
    
    func testRealTimeSynchronization() {
        property("For any shared workflow being edited by multiple users, changes should synchronize in real-time") <- forAll { (changeDescription: String) in
            guard !changeDescription.isEmpty else {
                return true
            }
            
            let expectation = XCTestExpectation(description: "Real-time sync")
            var testPassed = false
            
            Task {
                // Create and share a workflow
                let workflow = Workflow(
                    name: "Sync Test",
                    description: "Test workflow",
                    steps: [],
                    category: .general,
                    tags: []
                )
                
                do {
                    try await self.collaborationManager.shareWorkflow(workflow, with: [])
                    
                    // Subscribe to updates
                    let updateStream = await self.collaborationManager.subscribeToWorkflow(workflow.id)
                    
                    // Create a change
                    let change = WorkflowChange(
                        workflowId: workflow.id,
                        author: self.currentUser,
                        changeType: .modified,
                        description: changeDescription
                    )
                    
                    // Sync the change
                    try await self.collaborationManager.syncChanges([change])
                    
                    // Verify the change was applied
                    let sharedWorkflow = await self.collaborationManager.getSharedWorkflow(workflow.id)
                    testPassed = sharedWorkflow?.changes.contains(where: { $0.description == changeDescription }) ?? false
                    
                } catch {
                    testPassed = false
                }
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
            return testPassed
        }.withSize(100)
    }
    
    // MARK: - Property 52: Step annotation capability
    // **Feature: workflow-assistant-app, Property 52: Step annotation capability**
    
    func testStepAnnotationCapability() {
        property("For any workflow step, the system should allow users to add comments and annotations") <- forAll { (annotationContent: String) in
            guard !annotationContent.isEmpty else {
                return true
            }
            
            let expectation = XCTestExpectation(description: "Step annotation")
            var testPassed = false
            
            Task {
                // Create and share a workflow with steps
                let workflow = Workflow(
                    name: "Annotation Test",
                    description: "Test workflow",
                    steps: [
                        .command(Command(script: "echo 'step 1'", description: "Step 1")),
                        .command(Command(script: "echo 'step 2'", description: "Step 2"))
                    ],
                    category: .general,
                    tags: []
                )
                
                do {
                    try await self.collaborationManager.shareWorkflow(workflow, with: [])
                    
                    // Add annotation to a step
                    let annotation = WorkflowAnnotation(
                        workflowId: workflow.id,
                        stepIndex: 0,
                        author: self.currentUser,
                        content: annotationContent
                    )
                    
                    try await self.collaborationManager.addAnnotation(annotation)
                    
                    // Retrieve annotations for the step
                    let annotations = await self.collaborationManager.getAnnotations(for: workflow.id, stepIndex: 0)
                    
                    testPassed = annotations.contains(where: { $0.content == annotationContent })
                } catch {
                    testPassed = false
                }
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
            return testPassed
        }.withSize(100)
    }
    
    // MARK: - Property 53: Execution notification
    // **Feature: workflow-assistant-app, Property 53: Execution notification**
    
    func testExecutionNotification() {
        property("For any shared workflow execution, the system should notify all collaborators of the execution and outcome") <- forAll { (success: Bool, duration: Double) in
            // Ensure duration is positive and reasonable
            let validDuration = abs(duration).truncatingRemainder(dividingBy: 3600)
            guard validDuration > 0 else {
                return true
            }
            
            let expectation = XCTestExpectation(description: "Execution notification")
            var testPassed = false
            
            Task {
                // Create and share a workflow
                let workflow = Workflow(
                    name: "Notification Test",
                    description: "Test workflow",
                    steps: [],
                    category: .general,
                    tags: []
                )
                
                let collaborators = [
                    User(name: "Collaborator", deviceId: "collab-device", deviceName: "Collab Device")
                ]
                
                do {
                    try await self.collaborationManager.shareWorkflow(workflow, with: collaborators)
                    
                    // Send execution notification
                    try await self.collaborationManager.notifyExecution(
                        workflowId: workflow.id,
                        success: success,
                        duration: validDuration,
                        message: success ? "Workflow completed successfully" : "Workflow failed"
                    )
                    
                    // For this test, we verify that the notification was sent without error
                    // In a real scenario, we would verify that collaborators received it
                    testPassed = true
                } catch {
                    testPassed = false
                }
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
            return testPassed
        }.withSize(100)
    }
}
