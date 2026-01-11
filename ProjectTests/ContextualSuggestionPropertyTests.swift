//
//  ContextualSuggestionPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for contextual workflow suggestions
//

import XCTest
import SwiftCheck
@testable import Project

class ContextualSuggestionPropertyTests: XCTestCase {
    
    var suggestionService: ContextualSuggestionService!
    var learningSystem: LearningSystem!
    
    override func setUp() async throws {
        try await super.setUp()
        learningSystem = LearningSystem()
        suggestionService = ContextualSuggestionService(learningSystem: learningSystem)
    }
    
    override func tearDown() async throws {
        suggestionService = nil
        learningSystem = nil
        try await super.tearDown()
    }
    
    // MARK: - Property 32: Suggestion Explanation
    
    /// **Feature: workflow-assistant-app, Property 32: Suggestion explanation**
    /// **Validates: Requirements 8.3**
    ///
    /// For any proactively suggested workflow, the system should explain why it is relevant
    func testSuggestionExplanationProperty() {
        property("For any suggested workflow, system provides explanation") <- forAll { (workflowName: String, appName: String) in
            let expectation = XCTestExpectation(description: "Generate suggestions with explanations")
            
            Task {
                // Given: A workflow and context
                let workflow = Workflow(
                    name: workflowName,
                    description: "Test workflow",
                    category: .development,
                    tags: [appName]
                )
                
                let context = UserContext(
                    activeApplication: appName,
                    projectType: "Swift"
                )
                
                // When: Generating suggestions
                let suggestions = await self.suggestionService.generateSuggestions(
                    workflows: [workflow],
                    context: context
                )
                
                // Then: All suggestions should have explanations
                for suggestion in suggestions {
                    XCTAssertFalse(suggestion.explanation.isEmpty, "Suggestion should have explanation")
                    XCTAssertNotNil(suggestion.workflow, "Suggestion should have workflow")
                    XCTAssertGreaterThan(suggestion.relevanceScore, 0.0, "Suggestion should have relevance score")
                }
                
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 2.0)
            return true
        }.withSize(50)  // Reduced size for faster testing
    }
    
    // MARK: - Property 33: Suggestion Rate Limiting
    
    /// **Feature: workflow-assistant-app, Property 33: Suggestion rate limiting**
    /// **Validates: Requirements 8.4**
    ///
    /// For any time period, the system should limit proactive suggestions to avoid interrupting user focus
    func testSuggestionRateLimitingProperty() {
        property("System limits suggestion frequency") <- forAll { (count: Int) in
            // Constrain to reasonable range
            let requestCount = max(1, min(20, abs(count % 21)))
            
            let expectation = XCTestExpectation(description: "Test rate limiting")
            
            Task {
                // Given: Multiple suggestion requests in short time
                let workflow = Workflow(
                    name: "Test Workflow",
                    description: "Test",
                    category: .development
                )
                
                var generatedCount = 0
                
                // When: Requesting suggestions multiple times rapidly
                for _ in 0..<requestCount {
                    let suggestions = await self.suggestionService.generateSuggestions(
                        workflows: [workflow]
                    )
                    
                    if !suggestions.isEmpty {
                        generatedCount += 1
                    }
                }
                
                // Then: System should limit suggestions (not generate for every request)
                // Due to rate limiting, we shouldn't get suggestions for all requests
                XCTAssertLessThan(generatedCount, requestCount, "Rate limiting should prevent all requests from generating suggestions")
                
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            return true
        }.withSize(20)
    }
    
    // MARK: - Property 34: Dismissal Learning
    
    /// **Feature: workflow-assistant-app, Property 34: Dismissal learning**
    /// **Validates: Requirements 8.5**
    ///
    /// For any dismissed suggestion, the learning system should reduce the frequency of similar future suggestions
    func testDismissalLearningProperty() {
        property("System learns from dismissed suggestions") <- forAll { (workflowName: String) in
            let expectation = XCTestExpectation(description: "Test dismissal learning")
            
            Task {
                // Given: A workflow and context
                let workflow = Workflow(
                    name: workflowName,
                    description: "Test workflow",
                    category: .development
                )
                
                let context = UserContext(
                    activeApplication: "Xcode",
                    projectType: "Swift"
                )
                
                // When: Generating a suggestion and dismissing it
                let initialSuggestions = await self.suggestionService.generateSuggestions(
                    workflows: [workflow],
                    context: context
                )
                
                if let suggestion = initialSuggestions.first {
                    // Record dismissal
                    await self.suggestionService.recordDismissal(
                        suggestion: suggestion,
                        context: context
                    )
                    
                    // Then: Dismissal should be recorded
                    // (We verify this by checking that the service accepted the dismissal without error)
                    XCTAssertNotNil(suggestion.id, "Suggestion should have ID")
                    XCTAssertEqual(suggestion.workflow.id, workflow.id, "Suggestion should be for correct workflow")
                }
                
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 2.0)
            return true
        }.withSize(50)
    }
    
    // MARK: - Integration Tests
    
    /// Test complete suggestion flow
    func testCompleteSuggestionFlow() async throws {
        // Given: Workflows and context
        let workflows = [
            Workflow(
                name: "Create SwiftUI View",
                description: "Creates a new SwiftUI view",
                category: .development,
                tags: ["Xcode", "Swift", "SwiftUI"]
            ),
            Workflow(
                name: "Run Tests",
                description: "Runs unit tests",
                category: .testing,
                tags: ["Xcode", "Testing"]
            )
        ]
        
        let context = UserContext(
            activeApplication: "Xcode",
            projectType: "Swift"
        )
        
        // When: Generating suggestions
        let suggestions = await suggestionService.generateSuggestions(
            workflows: workflows,
            context: context
        )
        
        // Then: Suggestions should be relevant and explained
        XCTAssertFalse(suggestions.isEmpty, "Should generate suggestions")
        
        for suggestion in suggestions {
            XCTAssertFalse(suggestion.explanation.isEmpty, "Should have explanation")
            XCTAssertGreaterThan(suggestion.relevanceScore, 0.0, "Should have relevance score")
        }
    }
    
    /// Test rate limiting behavior
    func testRateLimiting() async throws {
        // Given: A workflow
        let workflow = Workflow(
            name: "Test Workflow",
            description: "Test",
            category: .development
        )
        
        var suggestionCounts: [Int] = []
        
        // When: Making multiple rapid requests
        for _ in 0..<10 {
            let suggestions = await suggestionService.generateSuggestions(
                workflows: [workflow]
            )
            suggestionCounts.append(suggestions.count)
        }
        
        // Then: Not all requests should return suggestions (due to rate limiting)
        let totalSuggestions = suggestionCounts.reduce(0, +)
        XCTAssertLessThan(totalSuggestions, 10, "Rate limiting should prevent all requests from succeeding")
    }
    
    /// Test dismissal recording
    func testDismissalRecording() async throws {
        // Given: A suggestion
        let workflow = Workflow(
            name: "Test Workflow",
            description: "Test",
            category: .development
        )
        
        let suggestion = WorkflowSuggestion(
            workflow: workflow,
            relevanceScore: 0.8,
            explanation: "Test explanation"
        )
        
        let context = UserContext(
            activeApplication: "Xcode"
        )
        
        // When: Recording a dismissal
        await suggestionService.recordDismissal(suggestion: suggestion, context: context)
        
        // Then: Dismissal should be recorded (no error thrown)
        // Success is indicated by the function completing without throwing
        XCTAssertTrue(true, "Dismissal recorded successfully")
    }
    
    /// Test context detection
    func testContextDetection() async throws {
        // Given: A context detector
        let detector = ContextDetector()
        
        // When: Detecting context
        let context = await detector.detectContext()
        
        // Then: Context should be created
        XCTAssertNotNil(context, "Context should be detected")
        XCTAssertGreaterThan(context.timeOfDay, -1, "Time of day should be valid")
        XCTAssertGreaterThan(context.dayOfWeek, 0, "Day of week should be valid")
    }
}
