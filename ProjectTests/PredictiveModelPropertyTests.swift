//
//  PredictiveModelPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for the PredictiveModel
//

import XCTest
import SwiftCheck
@testable import Project

class PredictiveModelPropertyTests: XCTestCase {
    
    var predictiveModel: PredictiveModel!
    var interactionStore: InteractionStore!
    var patternAnalyzer: PatternAnalyzer!
    
    override func setUp() async throws {
        try await super.setUp()
        interactionStore = InteractionStore()
        patternAnalyzer = PatternAnalyzer()
        predictiveModel = PredictiveModel(
            interactionStore: interactionStore,
            patternAnalyzer: patternAnalyzer
        )
    }
    
    override func tearDown() async throws {
        predictiveModel = nil
        interactionStore = nil
        patternAnalyzer = nil
        try await super.tearDown()
    }
    
    // MARK: - Property 60: Confidence threshold enforcement
    
    /// **Feature: workflow-assistant-app, Property 60: Confidence threshold enforcement**
    /// For any workflow suggestion made by the predictive model, the confidence score should be above 80 percent
    /// **Validates: Requirements 15.1**
    func testConfidenceThresholdEnforcement() async throws {
        // Create test workflows
        let workflows = createTestWorkflows(count: 10)
        
        // Create historical interactions with varying patterns
        let interactions = createTestInteractions(
            workflows: workflows,
            count: 100,
            withTemporalPatterns: true
        )
        
        // Save interactions to store
        for interaction in interactions {
            await interactionStore.save(interaction)
        }
        
        // Test with multiple contexts
        for _ in 0..<20 {
            let context = createRandomContext(recentWorkflows: workflows.prefix(3).map { $0.id })
            
            // Get predictions
            let predictions = await predictiveModel.predictWorkflows(
                context: context,
                availableWorkflows: workflows
            )
            
            // Verify all predictions meet threshold
            for prediction in predictions {
                XCTAssertGreaterThanOrEqual(
                    prediction.confidence,
                    0.80,
                    "Prediction for '\(prediction.workflowName)' has confidence \(prediction.confidence) which is below 80% threshold"
                )
            }
        }
    }
    
    // MARK: - Property 61: Temporal context awareness
    
    /// **Feature: workflow-assistant-app, Property 61: Temporal context awareness**
    /// For any time-of-day context, the predictive model should analyze patterns and suggest temporally relevant workflows
    /// **Validates: Requirements 15.2**
    func testTemporalContextAwareness() async throws {
        // Create test workflows
        let workflows = createTestWorkflows(count: 5)
        let targetWorkflow = workflows[0]
        
        // Create interactions with strong temporal pattern (workflow at hour 9)
        let targetHour = 9
        var interactions: [UserInteraction] = []
        
        // Create 20 interactions at hour 9 with target workflow
        for i in 0..<20 {
            let context = InteractionContext(
                timeOfDay: targetHour,
                dayOfWeek: 2 + (i % 5),  // Weekdays
                recentWorkflows: []
            )
            
            interactions.append(UserInteraction(
                timestamp: Date().addingTimeInterval(Double(-i * 3600)),
                intent: Intent(type: .executeWorkflow, confidence: 0.9),
                workflowExecuted: targetWorkflow.id,
                success: true,
                duration: 30.0,
                context: context
            ))
        }
        
        // Create some noise at other hours
        for i in 0..<10 {
            let context = InteractionContext(
                timeOfDay: (targetHour + 5) % 24,
                dayOfWeek: 2 + (i % 5),
                recentWorkflows: []
            )
            
            interactions.append(UserInteraction(
                timestamp: Date().addingTimeInterval(Double(-i * 3600)),
                intent: Intent(type: .executeWorkflow, confidence: 0.9),
                workflowExecuted: workflows[1].id,
                success: true,
                duration: 30.0,
                context: context
            ))
        }
        
        // Save interactions
        for interaction in interactions {
            await interactionStore.save(interaction)
        }
        
        // Test prediction at target hour
        let contextAtTargetHour = InteractionContext(
            timeOfDay: targetHour,
            dayOfWeek: 3,
            recentWorkflows: []
        )
        
        let predictions = await predictiveModel.predictWorkflows(
            context: contextAtTargetHour,
            availableWorkflows: workflows
        )
        
        // Should predict the target workflow
        let targetPrediction = predictions.first { $0.workflowId == targetWorkflow.id }
        XCTAssertNotNil(targetPrediction, "Should predict workflow with temporal pattern")
        
        if let prediction = targetPrediction {
            XCTAssertNotNil(prediction.temporalContext, "Prediction should include temporal context")
            XCTAssertEqual(prediction.temporalContext?.hourOfDay, targetHour, "Should match target hour")
            XCTAssertTrue(
                prediction.contextualFactors.contains("temporal_pattern"),
                "Should indicate temporal pattern as a factor"
            )
        }
        
        // Test prediction at different hour - should not predict target workflow
        let contextAtDifferentHour = InteractionContext(
            timeOfDay: (targetHour + 6) % 24,
            dayOfWeek: 3,
            recentWorkflows: []
        )
        
        let predictionsAtDifferentHour = await predictiveModel.predictWorkflows(
            context: contextAtDifferentHour,
            availableWorkflows: workflows
        )
        
        // Target workflow should have lower confidence or not appear
        let targetAtDifferentHour = predictionsAtDifferentHour.first { $0.workflowId == targetWorkflow.id }
        if let prediction = targetAtDifferentHour {
            // If it appears, confidence should be lower
            XCTAssertLessThan(
                prediction.confidence,
                targetPrediction?.confidence ?? 1.0,
                "Confidence should be lower at non-target hour"
            )
        }
    }
    
    // MARK: - Property 62: Automation offering
    
    /// **Feature: workflow-assistant-app, Property 62: Automation offering**
    /// For any sequence of manual actions matching a workflow pattern, the predictive model should offer to automate it
    /// **Validates: Requirements 15.3**
    func testAutomationOffering() async throws {
        // Create a repeated action sequence
        let actionSequence = ["git add .", "git commit -m 'update'", "git push"]
        
        // Repeat the sequence multiple times
        var allActions: [String] = []
        for _ in 0..<5 {
            allActions.append(contentsOf: actionSequence)
            allActions.append("other_action")  // Add noise
        }
        
        // Identify automation opportunities
        let opportunities = await predictiveModel.identifyAutomationOpportunities(
            recentActions: allActions
        )
        
        // Should identify the repeated sequence
        XCTAssertFalse(opportunities.isEmpty, "Should identify automation opportunities")
        
        // Find opportunity matching our sequence
        let matchingOpportunity = opportunities.first { opportunity in
            opportunity.actionSequence == actionSequence
        }
        
        XCTAssertNotNil(matchingOpportunity, "Should identify the repeated action sequence")
        
        if let opportunity = matchingOpportunity {
            XCTAssertGreaterThanOrEqual(
                opportunity.confidence,
                0.80,
                "Automation opportunity should meet confidence threshold"
            )
            XCTAssertGreaterThanOrEqual(
                opportunity.frequency,
                3,
                "Should have occurred at least 3 times"
            )
            XCTAssertFalse(
                opportunity.suggestedWorkflowName.isEmpty,
                "Should suggest a workflow name"
            )
            XCTAssertGreaterThan(
                opportunity.estimatedTimeSaving,
                0,
                "Should estimate time savings"
            )
        }
    }
    
    // MARK: - Property 63: Adaptive threshold adjustment
    
    /// **Feature: workflow-assistant-app, Property 63: Adaptive threshold adjustment**
    /// For any prediction acceptance or rejection, the model should adjust suggestion thresholds accordingly
    /// **Validates: Requirements 15.4**
    func testAdaptiveThresholdAdjustment() async throws {
        // Get initial threshold
        let initialThreshold = await predictiveModel.getConfidenceThreshold()
        XCTAssertEqual(initialThreshold, 0.80, "Initial threshold should be 80%")
        
        // Simulate many rejections (low acceptance rate)
        for i in 0..<50 {
            let feedback = PredictionFeedback(
                predictionId: UUID(),
                accepted: false,  // All rejected
                timestamp: Date().addingTimeInterval(Double(-i))
            )
            await predictiveModel.recordFeedback(feedback)
        }
        
        // Threshold should increase after many rejections
        let thresholdAfterRejections = await predictiveModel.getConfidenceThreshold()
        XCTAssertGreaterThan(
            thresholdAfterRejections,
            initialThreshold,
            "Threshold should increase after many rejections"
        )
        
        // Create new model for acceptance test
        let predictiveModel2 = PredictiveModel(
            interactionStore: InteractionStore(),
            patternAnalyzer: PatternAnalyzer()
        )
        
        let initialThreshold2 = await predictiveModel2.getConfidenceThreshold()
        
        // Simulate many acceptances (high acceptance rate)
        for i in 0..<50 {
            let feedback = PredictionFeedback(
                predictionId: UUID(),
                accepted: true,  // All accepted
                timestamp: Date().addingTimeInterval(Double(-i))
            )
            await predictiveModel2.recordFeedback(feedback)
        }
        
        // Threshold should decrease after many acceptances
        let thresholdAfterAcceptances = await predictiveModel2.getConfidenceThreshold()
        XCTAssertLessThan(
            thresholdAfterAcceptances,
            initialThreshold2,
            "Threshold should decrease after many acceptances"
        )
        
        // Verify statistics reflect the feedback
        let stats = await predictiveModel2.getStatistics()
        XCTAssertEqual(stats.totalFeedback, 50, "Should record all feedback")
        XCTAssertEqual(stats.acceptanceRate, 1.0, "Acceptance rate should be 100%")
    }
    
    // MARK: - Property 64: Prediction explanation
    
    /// **Feature: workflow-assistant-app, Property 64: Prediction explanation**
    /// For any workflow prediction, the system should explain the reasoning behind the suggestion
    /// **Validates: Requirements 15.5**
    func testPredictionExplanation() async throws {
        // Create test workflows
        let workflows = createTestWorkflows(count: 5)
        
        // Create interactions with various patterns
        let interactions = createTestInteractions(
            workflows: workflows,
            count: 50,
            withTemporalPatterns: true
        )
        
        for interaction in interactions {
            await interactionStore.save(interaction)
        }
        
        // Get predictions
        let context = createRandomContext(recentWorkflows: workflows.prefix(2).map { $0.id })
        let predictions = await predictiveModel.predictWorkflows(
            context: context,
            availableWorkflows: workflows
        )
        
        // Verify all predictions have explanations
        for prediction in predictions {
            XCTAssertFalse(
                prediction.reasoning.isEmpty,
                "Prediction for '\(prediction.workflowName)' should have reasoning"
            )
            
            XCTAssertGreaterThan(
                prediction.reasoning.count,
                20,
                "Reasoning should be descriptive (at least 20 characters)"
            )
            
            XCTAssertFalse(
                prediction.contextualFactors.isEmpty,
                "Prediction should include contextual factors"
            )
            
            // Reasoning should mention the workflow name
            XCTAssertTrue(
                prediction.reasoning.contains(prediction.workflowName),
                "Reasoning should mention the workflow name"
            )
            
            // Reasoning should provide specific details (numbers, context, etc.)
            let hasNumbers = prediction.reasoning.range(of: #"\d+"#, options: .regularExpression) != nil
            XCTAssertTrue(
                hasNumbers,
                "Reasoning should include specific details like frequency counts"
            )
        }
    }
    
    // MARK: - Helper Methods
    
    private func createTestWorkflows(count: Int) -> [Workflow] {
        var workflows: [Workflow] = []
        for i in 0..<count {
            workflows.append(Workflow(
                id: UUID(),
                name: "Test Workflow \(i)",
                description: "Test workflow for property testing",
                steps: [],
                category: .development,
                tags: ["test"],
                isBuiltIn: false
            ))
        }
        return workflows
    }
    
    private func createTestInteractions(
        workflows: [Workflow],
        count: Int,
        withTemporalPatterns: Bool
    ) -> [UserInteraction] {
        var interactions: [UserInteraction] = []
        
        for i in 0..<count {
            let workflow = workflows[i % workflows.count]
            let hour = withTemporalPatterns ? (9 + (i % 3)) : Int.random(in: 0...23)
            
            let context = InteractionContext(
                activeApplication: i % 2 == 0 ? "Xcode" : "Terminal",
                projectType: i % 3 == 0 ? "iOS" : "macOS",
                timeOfDay: hour,
                dayOfWeek: 2 + (i % 5),
                recentWorkflows: []
            )
            
            interactions.append(UserInteraction(
                timestamp: Date().addingTimeInterval(Double(-i * 3600)),
                intent: Intent(type: .executeWorkflow, confidence: 0.9),
                workflowExecuted: workflow.id,
                success: true,
                duration: Double.random(in: 10...60),
                feedback: UserFeedback(rating: 4),
                context: context
            ))
        }
        
        return interactions
    }
    
    private func createRandomContext(recentWorkflows: [UUID]) -> InteractionContext {
        return InteractionContext(
            activeApplication: ["Xcode", "Terminal", "Safari"].randomElement(),
            projectType: ["iOS", "macOS", "watchOS"].randomElement(),
            timeOfDay: Int.random(in: 0...23),
            dayOfWeek: Int.random(in: 1...7),
            recentWorkflows: recentWorkflows
        )
    }
}
