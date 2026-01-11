//
//  WorkflowMatchingPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for natural language workflow matching
//  Validates requirements 1.1, 1.2, 1.3, 1.4, 1.5
//

import XCTest
import SwiftCheck
@testable import Project

final class WorkflowMatchingPropertyTests: XCTestCase {
    var nluEngine: NLUEngine!
    var workflowOrchestrator: WorkflowOrchestrator!
    var workflowMatcher: WorkflowMatcher!
    
    override func setUp() async throws {
        try await super.setUp()
        nluEngine = NLUEngine()
        try await nluEngine.initialize()
        
        let commandExecutor = CommandExecutor()
        let errorRecoveryEngine = ErrorRecoveryEngine()
        workflowOrchestrator = WorkflowOrchestrator(
            commandExecutor: commandExecutor,
            errorRecoveryEngine: errorRecoveryEngine
        )
        
        workflowMatcher = await WorkflowMatcher(
            nluEngine: nluEngine,
            workflowOrchestrator: workflowOrchestrator
        )
    }
    
    // MARK: - Property 1: Workflow Matching Completeness
    // Requirements 1.1, 1.3
    
    func testProperty1_WorkflowMatchingCompleteness() {
        property("All workflow-related intents should produce a match or suggestion") <- forAll { (text: String) in
            let workflowKeywords = ["create", "build", "setup", "generate", "workflow", "ios", "macos", "swiftui", "test", "package"]
            
            // Only test strings that contain workflow-related keywords
            guard workflowKeywords.contains(where: { text.lowercased().contains($0) }) else {
                return true  // Skip non-workflow queries
            }
            
            let expectation = self.expectation(description: "Match workflows")
            var result: WorkflowMatchResult?
            
            Task {
                do {
                    result = try await self.workflowMatcher.matchWorkflows(for: text)
                    expectation.fulfill()
                } catch {
                    XCTFail("Matching failed: \(error)")
                    expectation.fulfill()
                }
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Property: Should always return a result (match or suggestion)
            guard let matchResult = result else {
                return false
            }
            
            switch matchResult {
            case .singleMatch(let match):
                // Should have reasonable confidence
                return match.confidence > 0.3
            case .ambiguous(let matches):
                // Should have multiple matches
                return matches.count > 1
            case .noMatch(let suggestion):
                // Should provide a helpful suggestion
                return !suggestion.isEmpty
            }
        }
    }
    
    // MARK: - Property 2: Ambiguity Resolution
    // Requirement 1.2
    
    func testProperty2_AmbiguityResolution() {
        property("Ambiguous matches should be resolvable by selection") <- forAll { (seed: Int) in
            // Create ambiguous query
            let ambiguousQueries = [
                "create a new app",
                "build an application",
                "setup a project",
                "generate code"
            ]
            let query = ambiguousQueries[abs(seed) % ambiguousQueries.count]
            
            let expectation = self.expectation(description: "Resolve ambiguity")
            var matchResult: WorkflowMatchResult?
            var resolved: WorkflowMatch?
            
            Task {
                do {
                    matchResult = try await self.workflowMatcher.matchWorkflows(for: query)
                    
                    if case .ambiguous(let matches) = matchResult {
                        // Resolve by selecting first match
                        resolved = await self.workflowMatcher.resolveAmbiguity(
                            selectedWorkflow: matches[0].workflow,
                            from: matches
                        )
                    }
                    
                    expectation.fulfill()
                } catch {
                    XCTFail("Resolution failed: \(error)")
                    expectation.fulfill()
                }
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Property: If ambiguous, resolution should return a valid match
            if case .ambiguous(let matches) = matchResult {
                return resolved != nil && matches.contains { $0.workflow.id == resolved?.workflow.id }
            }
            
            return true  // Not ambiguous, property doesn't apply
        }
    }
    
    // MARK: - Property 3: Execution Confirmation
    // Requirement 1.4
    
    func testProperty3_ExecutionConfirmation() {
        property("Low confidence matches should require confirmation") <- forAll { (text: String) in
            let workflowKeywords = ["create", "build", "setup"]
            guard workflowKeywords.contains(where: { text.lowercased().contains($0) }) else {
                return true
            }
            
            let expectation = self.expectation(description: "Check confirmation")
            var requiresConfirmation = false
            
            Task {
                do {
                    let matchResult = try await self.workflowMatcher.matchWorkflows(for: text)
                    
                    if case .singleMatch(let match) = matchResult {
                        let executionResult = try await self.workflowMatcher.executeWorkflow(
                            match,
                            withConfirmation: true
                        )
                        
                        // Property: Low confidence should require confirmation
                        if match.confidence < 0.8 {
                            if case .pendingConfirmation = executionResult {
                                requiresConfirmation = true
                            }
                        } else {
                            // High confidence should execute directly
                            if case .executing = executionResult {
                                requiresConfirmation = true
                            }
                        }
                    } else {
                        requiresConfirmation = true  // No match, property doesn't apply
                    }
                    
                    expectation.fulfill()
                } catch {
                    expectation.fulfill()
                }
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            return requiresConfirmation
        }
    }
    
    // MARK: - Property 4: Natural Language Acceptance
    // Requirement 1.5
    
    func testProperty4_NaturalLanguageAcceptance() {
        property("System should accept various natural language phrasings") <- forAll { (seed: Int) in
            // Test various natural language phrasings for the same intent
            let phrasings = [
                "I want to create an iOS app",
                "Can you help me build an iPhone application?",
                "Let's make a new iOS project",
                "Start a fresh iOS app for me",
                "Create iOS application"
            ]
            
            let phrasing = phrasings[abs(seed) % phrasings.count]
            
            let expectation = self.expectation(description: "Accept natural language")
            var accepted = false
            
            Task {
                do {
                    let matchResult = try await self.workflowMatcher.matchWorkflows(for: phrasing)
                    
                    // Property: Should find a match or provide suggestion
                    switch matchResult {
                    case .singleMatch(let match):
                        // Should match iOS-related workflow
                        accepted = match.workflow.keywords.contains { $0.lowercased().contains("ios") }
                    case .ambiguous(let matches):
                        // At least one should be iOS-related
                        accepted = matches.contains { match in
                            match.workflow.keywords.contains { $0.lowercased().contains("ios") }
                        }
                    case .noMatch(let suggestion):
                        // Should provide helpful suggestion
                        accepted = !suggestion.isEmpty
                    }
                    
                    expectation.fulfill()
                } catch {
                    expectation.fulfill()
                }
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            return accepted
        }
    }
    
    // MARK: - Additional Tests
    
    func testWorkflowMatchingWithSpecificKeywords() async throws {
        // Test specific workflow matching scenarios
        let testCases: [(String, String)] = [
            ("create an iOS app", "iOS App Setup"),
            ("build a macOS application", "macOS App Setup"),
            ("generate a SwiftUI view", "SwiftUI View Generator"),
            ("setup testing framework", "Test Suite Setup"),
            ("create a Swift package", "Swift Package Creator")
        ]
        
        for (query, expectedWorkflow) in testCases {
            let result = try await workflowMatcher.matchWorkflows(for: query)
            
            switch result {
            case .singleMatch(let match):
                XCTAssertTrue(
                    match.workflow.name.contains(expectedWorkflow.split(separator: " ")[0]),
                    "Expected workflow containing '\(expectedWorkflow)' for query '\(query)'"
                )
            case .ambiguous(let matches):
                XCTAssertTrue(
                    matches.contains { $0.workflow.name.contains(expectedWorkflow.split(separator: " ")[0]) },
                    "Expected one of ambiguous matches to contain '\(expectedWorkflow)' for query '\(query)'"
                )
            case .noMatch(let suggestion):
                XCTFail("Expected match for '\(query)', got suggestion: \(suggestion)")
            }
        }
    }
    
    func testNoMatchProvidesSuggestion() async throws {
        let result = try await workflowMatcher.matchWorkflows(for: "completely unrelated random text xyz123")
        
        if case .noMatch(let suggestion) = result {
            XCTAssertFalse(suggestion.isEmpty, "Should provide a suggestion for no match")
        }
    }
    
    func testAmbiguousMatchesHaveSimilarConfidence() async throws {
        let result = try await workflowMatcher.matchWorkflows(for: "create a new app")
        
        if case .ambiguous(let matches) = result {
            XCTAssertGreaterThan(matches.count, 1, "Ambiguous result should have multiple matches")
            
            // Check that matches have similar confidence (within 0.15)
            let topConfidence = matches[0].confidence
            for match in matches {
                XCTAssertLessThan(
                    topConfidence - match.confidence,
                    0.15,
                    "Ambiguous matches should have similar confidence"
                )
            }
        }
    }
}
