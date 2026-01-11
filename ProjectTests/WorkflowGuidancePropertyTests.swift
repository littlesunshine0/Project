//
//  WorkflowGuidancePropertyTests.swift
//  ProjectTests
//
//  Property-based tests for workflow guidance system
//  Validates requirements 2.1, 2.2, 2.3, 2.4, 2.5
//

import XCTest
import SwiftCheck
@testable import Project

final class WorkflowGuidancePropertyTests: XCTestCase {
    var guidanceEngine: WorkflowGuidanceEngine!
    var workflowOrchestrator: WorkflowOrchestrator!
    var errorRecoveryEngine: ErrorRecoveryEngine!
    
    override func setUp() async throws {
        try await super.setUp()
        
        let commandExecutor = CommandExecutor()
        let errorLogger = ErrorLogger()
        errorRecoveryEngine = ErrorRecoveryEngine(errorLogger: errorLogger)
        workflowOrchestrator = WorkflowOrchestrator(
            commandExecutor: commandExecutor,
            errorRecovery: errorRecoveryEngine
        )
        
        guidanceEngine = await WorkflowGuidanceEngine(
            workflowOrchestrator: workflowOrchestrator,
            errorRecoveryEngine: errorRecoveryEngine
        )
    }
    
    // MARK: - Property 5: Initial Step Presentation
    // Requirement 2.1
    
    func testProperty5_InitialStepPresentation() {
        property("Starting a workflow should present the first step") <- forAll { (seed: Int) in
            let workflow = self.createTestWorkflow(stepCount: max(1, abs(seed) % 5 + 1))
            
            let expectation = self.expectation(description: "Present initial step")
            var session: GuidanceSession?
            
            Task {
                do {
                    session = try await self.guidanceEngine.startGuidedWorkflow(workflow)
                    expectation.fulfill()
                } catch {
                    XCTFail("Failed to start workflow: \(error)")
                    expectation.fulfill()
                }
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Property: Session should have initial step presentation
            guard let session = session else { return false }
            
            return session.currentStepIndex == 0 &&
                   session.currentPresentation != nil &&
                   session.currentPresentation?.stepNumber == 1 &&
                   session.status == .inProgress
        }
    }
    
    // MARK: - Property 6: Input Prompting
    // Requirement 2.2
    
    func testProperty6_InputPrompting() {
        property("Steps requiring input should prompt the user") <- forAll { (seed: Int) in
            let workflow = self.createTestWorkflowWithInput()
            
            let expectation = self.expectation(description: "Prompt for input")
            var session: GuidanceSession?
            var inputPrompt: InputPrompt?
            
            Task {
                do {
                    session = try await self.guidanceEngine.startGuidedWorkflow(workflow)
                    
                    if let sessionId = session?.id {
                        inputPrompt = try await self.guidanceEngine.promptForInput(sessionId: sessionId)
                    }
                    
                    expectation.fulfill()
                } catch {
                    expectation.fulfill()
                }
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Property: Should provide input prompt for steps requiring input
            if let session = session, let firstStep = workflow.steps.first, firstStep.requiresInput {
                return inputPrompt != nil &&
                       !inputPrompt!.prompt.isEmpty &&
                       inputPrompt!.stepName == firstStep.name
            }
            
            return true  // No input required, property doesn't apply
        }
    }
    
    // MARK: - Property 7: Step Completion Feedback
    // Requirement 2.3
    
    func testProperty7_StepCompletionFeedback() {
        property("Completed steps should provide feedback") <- forAll { (seed: Int) in
            let workflow = self.createTestWorkflow(stepCount: 3)
            
            let expectation = self.expectation(description: "Complete step")
            var feedback: StepCompletionFeedback?
            
            Task {
                do {
                    let session = try await self.guidanceEngine.startGuidedWorkflow(workflow)
                    let result = try await self.guidanceEngine.executeStep(
                        sessionId: session.id,
                        userInput: nil
                    )
                    
                    if case .success(let stepFeedback) = result {
                        feedback = stepFeedback
                    }
                    
                    expectation.fulfill()
                } catch {
                    expectation.fulfill()
                }
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Property: Should provide completion feedback
            guard let feedback = feedback else { return false }
            
            return !feedback.message.isEmpty &&
                   feedback.status == .completed &&
                   feedback.progress >= 0.0 && feedback.progress <= 1.0
        }
    }
    
    // MARK: - Property 8: Error Recovery Offering
    // Requirement 2.4
    
    func testProperty8_ErrorRecoveryOffering() {
        property("Failed steps should offer recovery options") <- forAll { (seed: Int) in
            let error = NSError(domain: "TestError", code: abs(seed), userInfo: nil)
            
            let expectation = self.expectation(description: "Offer recovery")
            var recoveryOptions: [RecoveryOption] = []
            
            Task {
                let workflow = self.createTestWorkflow(stepCount: 1)
                let session = try await self.guidanceEngine.startGuidedWorkflow(workflow)
                
                recoveryOptions = await self.guidanceEngine.offerErrorRecovery(
                    sessionId: session.id,
                    error: error
                )
                
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Property: Should offer at least one recovery option
            return !recoveryOptions.isEmpty &&
                   recoveryOptions.allSatisfy { !$0.title.isEmpty && !$0.description.isEmpty }
        }
    }
    
    // MARK: - Property 9: Progress Visibility
    // Requirement 2.5
    
    func testProperty9_ProgressVisibility() {
        property("Workflow progress should be visible at any time") <- forAll { (stepCount: Int) in
            let count = max(1, abs(stepCount) % 10 + 1)
            let workflow = self.createTestWorkflow(stepCount: count)
            
            let expectation = self.expectation(description: "Get progress")
            var progress: WorkflowProgress?
            
            Task {
                do {
                    let session = try await self.guidanceEngine.startGuidedWorkflow(workflow)
                    progress = await self.guidanceEngine.getProgress(sessionId: session.id)
                    expectation.fulfill()
                } catch {
                    expectation.fulfill()
                }
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Property: Progress should be available and valid
            guard let progress = progress else { return false }
            
            return progress.totalSteps == count &&
                   progress.currentStep >= 1 &&
                   progress.currentStep <= count &&
                   progress.progress >= 0.0 && progress.progress <= 1.0 &&
                   progress.completedSteps >= 0 &&
                   progress.completedSteps <= count
        }
    }
    
    // MARK: - Additional Tests
    
    func testStepPresentationContainsRequiredInformation() async throws {
        let workflow = createTestWorkflow(stepCount: 3)
        let session = try await guidanceEngine.startGuidedWorkflow(workflow)
        
        XCTAssertNotNil(session.currentPresentation)
        
        if let presentation = session.currentPresentation {
            XCTAssertEqual(presentation.stepNumber, 1)
            XCTAssertEqual(presentation.totalSteps, 3)
            XCTAssertFalse(presentation.title.isEmpty)
            XCTAssertFalse(presentation.instructions.isEmpty)
        }
    }
    
    func testInputValidation() async throws {
        let workflow = createTestWorkflowWithInput()
        let session = try await guidanceEngine.startGuidedWorkflow(workflow)
        
        // Test with empty input (should fail validation)
        let result = try await guidanceEngine.executeStep(
            sessionId: session.id,
            userInput: ""
        )
        
        if case .validationFailed(let error) = result {
            XCTAssertFalse(error.isEmpty)
        } else {
            XCTFail("Expected validation failure for empty input")
        }
    }
    
    func testProgressIncrementsAfterStepCompletion() async throws {
        let workflow = createTestWorkflow(stepCount: 3)
        let session = try await guidanceEngine.startGuidedWorkflow(workflow)
        
        // Get initial progress
        let initialProgress = await guidanceEngine.getProgress(sessionId: session.id)
        XCTAssertEqual(initialProgress?.completedSteps, 0)
        
        // Execute first step
        _ = try await guidanceEngine.executeStep(sessionId: session.id, userInput: nil)
        
        // Check progress increased
        let updatedProgress = await guidanceEngine.getProgress(sessionId: session.id)
        XCTAssertEqual(updatedProgress?.completedSteps, 1)
        XCTAssertGreaterThan(updatedProgress?.progress ?? 0, initialProgress?.progress ?? 0)
    }
    
    func testRecoveryOptionsIncludeRetry() async throws {
        let workflow = createTestWorkflow(stepCount: 1)
        let session = try await guidanceEngine.startGuidedWorkflow(workflow)
        
        let error = NSError(domain: "TestError", code: 1, userInfo: nil)
        let options = await guidanceEngine.offerErrorRecovery(sessionId: session.id, error: error)
        
        XCTAssertTrue(options.contains { $0.action == .retry })
    }
    
    // MARK: - Helper Methods
    
    private func createTestWorkflow(stepCount: Int) -> Workflow {
        var steps: [WorkflowStep] = []
        
        for i in 1...stepCount {
            steps.append(WorkflowStep(
                id: UUID(),
                name: "Step \(i)",
                description: "Test step \(i)",
                command: "echo 'Step \(i)'",
                requiresInput: false,
                estimatedDuration: 10.0
            ))
        }
        
        return Workflow(
            id: UUID(),
            name: "Test Workflow",
            description: "A test workflow",
            category: .development,
            steps: steps,
            keywords: ["test"],
            intents: [.executeWorkflow]
        )
    }
    
    private func createTestWorkflowWithInput() -> Workflow {
        let step = WorkflowStep(
            id: UUID(),
            name: "Input Step",
            description: "Step requiring input",
            command: "echo '{input}'",
            requiresInput: true,
            inputPrompt: "Please enter a value:",
            inputType: .text,
            validationRules: [.notEmpty, .minLength(3)],
            inputPlaceholder: "Enter value",
            defaultValue: nil,
            estimatedDuration: 10.0
        )
        
        return Workflow(
            id: UUID(),
            name: "Input Workflow",
            description: "Workflow with input",
            category: .development,
            steps: [step],
            keywords: ["input"],
            intents: [.executeWorkflow]
        )
    }
}
