//
//  FeedbackCollectionPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for feedback collection system
//

import XCTest
import SwiftCheck
@testable import Project

class FeedbackCollectionPropertyTests: XCTestCase {
    
    var feedbackService: FeedbackCollectionService!
    var learningSystem: LearningSystem!
    
    override func setUp() async throws {
        try await super.setUp()
        learningSystem = LearningSystem()
        feedbackService = FeedbackCollectionService(learningSystem: learningSystem)
    }
    
    override func tearDown() async throws {
        feedbackService = nil
        learningSystem = nil
        try await super.tearDown()
    }
    
    // MARK: - Property 19: Feedback Prompting
    
    /// **Feature: workflow-assistant-app, Property 19: Feedback prompting**
    /// **Validates: Requirements 5.1**
    ///
    /// For any completed workflow, the system should prompt the user for feedback
    func testFeedbackPromptingProperty() {
        property("For any completed workflow, system prompts for feedback") <- forAll { (workflowId: UUID, executionId: UUID, workflowName: String, success: Bool) in
            // Given: A completed workflow
            let expectation = XCTestExpectation(description: "Prompt for feedback")
            
            Task {
                // When: Requesting feedback prompt
                let prompt = await self.feedbackService.promptForFeedback(
                    workflowId: workflowId,
                    executionId: executionId,
                    workflowName: workflowName,
                    success: success
                )
                
                // Then: A feedback prompt should be returned
                XCTAssertFalse(prompt.message.isEmpty, "Feedback prompt message should not be empty")
                XCTAssertTrue(prompt.showRating, "Feedback prompt should show rating")
                XCTAssertTrue(prompt.showComment, "Feedback prompt should show comment field")
                
                // For failed workflows, should request details
                if !success {
                    XCTAssertTrue(prompt.requestDetails, "Failed workflows should request details")
                }
                
                expectation.fulfill()
            }
            
            self.self.wait(for: [expectation], timeout: 1.0)
            return true
        }.withSize(100)
    }
    
    // MARK: - Property 20: Negative Feedback Detail Request
    
    /// **Feature: workflow-assistant-app, Property 20: Negative feedback detail request**
    /// **Validates: Requirements 5.2**
    ///
    /// For any negative feedback provided, the system should request specific details about the issue
    func testNegativeFeedbackDetailRequestProperty() {
        property("For any negative feedback, system requests specific details") <- forAll { (rating: Int, workflowName: String) in
            // Constrain rating to valid range (1-5)
            let validRating = max(1, min(5, abs(rating % 6)))
            
            let expectation = XCTestExpectation(description: "Request negative feedback details")
            
            Task {
                // When: Requesting details for feedback
                let detailRequest = await self.feedbackService.requestNegativeFeedbackDetails(
                    rating: validRating,
                    workflowName: workflowName
                )
                
                // Then: For negative feedback (rating < 4), details should be requested
                if validRating < 4 {
                    XCTAssertNotNil(detailRequest, "Negative feedback should request details")
                    XCTAssertFalse(detailRequest!.questions.isEmpty, "Should have questions")
                    XCTAssertFalse(detailRequest!.suggestedIssues.isEmpty, "Should have suggested issues")
                } else {
                    // For positive feedback, no detail request needed
                    XCTAssertNil(detailRequest, "Positive feedback should not request details")
                }
                
                expectation.fulfill()
            }
            
            self.self.wait(for: [expectation], timeout: 1.0)
            return true
        }.withSize(100)
    }
    
    // MARK: - Property 21: Feedback Incorporation
    
    /// **Feature: workflow-assistant-app, Property 21: Feedback incorporation**
    /// **Validates: Requirements 5.3**
    ///
    /// For any received feedback, the learning system should incorporate it into future workflow recommendations
    func testFeedbackIncorporationProperty() {
        property("For any received feedback, learning system incorporates it") <- forAll { (workflowId: UUID, executionId: UUID, rating: Int) in
            // Constrain rating to valid range (1-5)
            let validRating = max(1, min(5, abs(rating % 6)))
            
            let expectation = XCTestExpectation(description: "Incorporate feedback")
            
            Task {
                // Given: Feedback for a workflow
                let feedback = WorkflowFeedback(
                    workflowId: workflowId,
                    executionId: executionId,
                    overallRating: validRating,
                    comment: "Test feedback",
                    specificIssues: []
                )
                
                // When: Submitting feedback
                await self.feedbackService.submitFeedback(feedback)
                
                // Then: Learning system should have recorded the interaction
                // We verify this by checking that the learning system's interaction count increased
                let stats = await self.learningSystem.getStatistics()
                XCTAssertGreaterThan(stats.totalInteractions, 0, "Learning system should have recorded interaction")
                
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 2.0)
            return true
        }.withSize(100)
    }
    
    // MARK: - Property 22: Step-Level Rating Availability
    
    /// **Feature: workflow-assistant-app, Property 22: Step-level rating availability**
    /// **Validates: Requirements 5.4**
    ///
    /// For any workflow step, the system should allow users to provide a rating
    func testStepLevelRatingAvailabilityProperty() {
        property("For any workflow step, system allows rating") <- forAll { (stepIndex: Int, rating: Int) in
            // Constrain to valid values
            let validStepIndex = abs(stepIndex % 100)
            let validRating = max(1, min(5, abs(rating % 6)))
            
            let expectation = XCTestExpectation(description: "Create step rating")
            
            Task {
                // When: Creating a step rating
                let stepRating = await self.feedbackService.createStepRating(
                    stepIndex: validStepIndex,
                    rating: validRating,
                    comment: "Test comment"
                )
                
                // Then: Step rating should be created successfully
                XCTAssertEqual(stepRating.stepIndex, validStepIndex, "Step index should match")
                XCTAssertEqual(stepRating.rating, validRating, "Rating should match")
                XCTAssertNotNil(stepRating.id, "Step rating should have an ID")
                
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 1.0)
            return true
        }.withSize(100)
    }
    
    // MARK: - Property 23: Failure Context Capture
    
    /// **Feature: workflow-assistant-app, Property 23: Failure context capture**
    /// **Validates: Requirements 5.5**
    ///
    /// For any workflow failure, the system should automatically capture the failure context for analysis
    func testFailureContextCaptureProperty() {
        property("For any workflow failure, system captures failure context") <- forAll { (workflowName: String, stepCount: Int) in
            // Constrain step count to reasonable range
            let validStepCount = max(1, min(10, abs(stepCount % 11)))
            
            let expectation = XCTestExpectation(description: "Capture failure context")
            
            Task {
                // Given: A workflow execution that failed
                let workflow = Workflow(
                    name: workflowName,
                    description: "Test workflow",
                    steps: Array(repeating: .command(Command(
                        script: "echo test",
                        description: "Test step",
                        requiresPermission: false,
                        timeout: 30.0
                    )), count: validStepCount)
                )
                
                var execution = WorkflowExecution(workflow: workflow)
                execution.currentStepIndex = validStepCount / 2  // Failed midway
                
                // Add some results
                for i in 0..<execution.currentStepIndex {
                    execution.results.append(StepResult(
                        stepIndex: i,
                        success: true,
                        output: "Step \(i) output",
                        duration: 1.0
                    ))
                }
                
                let error = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test failure"])
                
                // When: Capturing failure context
                let failureContext = await self.feedbackService.captureFailureContext(
                    execution: execution,
                    error: error
                )
                
                // Then: Failure context should be captured
                XCTAssertEqual(failureContext.failedStepIndex, execution.currentStepIndex, "Failed step index should match")
                XCTAssertFalse(failureContext.errorMessage.isEmpty, "Error message should not be empty")
                XCTAssertNotNil(failureContext.systemState, "System state should be captured")
                XCTAssertFalse(failureContext.executionLog.isEmpty, "Execution log should not be empty")
                XCTAssertEqual(failureContext.executionLog.count, execution.results.count, "Execution log should match results")
                
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 2.0)
            return true
        }.withSize(100)
    }
    
    // MARK: - Additional Integration Tests
    
    /// Test complete feedback flow
    func testCompleteFeedbackFlow() async throws {
        // Given: A completed workflow
        let workflowId = UUID()
        let executionId = UUID()
        let workflowName = "Test Workflow"
        
        // When: Prompting for feedback
        let prompt = await feedbackService.promptForFeedback(
            workflowId: workflowId,
            executionId: executionId,
            workflowName: workflowName,
            success: false
        )
        
        // Then: Prompt should be appropriate for failed workflow
        XCTAssertTrue(prompt.requestDetails)
        
        // When: Submitting negative feedback
        let feedback = WorkflowFeedback(
            workflowId: workflowId,
            executionId: executionId,
            overallRating: 2,
            comment: "Workflow failed at step 3",
            specificIssues: ["Command failed to execute", "Unexpected result"]
        )
        
        await feedbackService.submitFeedback(feedback)
        
        // Then: Feedback should be incorporated into learning system
        let stats = await learningSystem.getStatistics()
        XCTAssertGreaterThan(stats.totalInteractions, 0)
    }
    
    /// Test step rating creation
    func testStepRatingCreation() async throws {
        // When: Creating multiple step ratings
        let rating1 = await feedbackService.createStepRating(stepIndex: 0, rating: 5)
        let rating2 = await feedbackService.createStepRating(stepIndex: 1, rating: 3, comment: "Slow step")
        let rating3 = await feedbackService.createStepRating(stepIndex: 2, rating: 4)
        
        // Then: All ratings should be created with correct properties
        XCTAssertEqual(rating1.stepIndex, 0)
        XCTAssertEqual(rating1.rating, 5)
        XCTAssertNil(rating1.comment)
        
        XCTAssertEqual(rating2.stepIndex, 1)
        XCTAssertEqual(rating2.rating, 3)
        XCTAssertEqual(rating2.comment, "Slow step")
        
        XCTAssertEqual(rating3.stepIndex, 2)
        XCTAssertEqual(rating3.rating, 4)
    }
    
    /// Test failure context capture with real execution
    func testFailureContextCaptureWithRealExecution() async throws {
        // Given: A workflow execution
        let workflow = Workflow(
            name: "Test Workflow",
            description: "Test",
            steps: [
                .command(Command(script: "echo step1", description: "Step 1", requiresPermission: false, timeout: 30.0)),
                .command(Command(script: "echo step2", description: "Step 2", requiresPermission: false, timeout: 30.0)),
                .command(Command(script: "false", description: "Failing step", requiresPermission: false, timeout: 30.0))
            ]
        )
        
        var execution = WorkflowExecution(workflow: workflow)
        execution.currentStepIndex = 2
        execution.results = [
            StepResult(stepIndex: 0, success: true, output: "step1", duration: 0.1),
            StepResult(stepIndex: 1, success: true, output: "step2", duration: 0.1)
        ]
        
        let error = NSError(domain: "WorkflowError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Command failed"])
        
        // When: Capturing failure context
        let context = await feedbackService.captureFailureContext(execution: execution, error: error)
        
        // Then: Context should contain all relevant information
        XCTAssertEqual(context.failedStepIndex, 2)
        XCTAssertEqual(context.errorMessage, "Command failed")
        XCTAssertEqual(context.executionLog.count, 2)
        XCTAssertNotNil(context.systemState)
    }
}
