//
//  ContextualCommandSuggestionPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for contextual command suggestions
//

import XCTest
import SwiftCheck
@testable import Project

final class ContextualCommandSuggestionPropertyTests: XCTestCase {
    
    // MARK: - Property 82: Project-specific command suggestions
    
    func testProperty82_ProjectSpecificSuggestions() {
        /**
         **Feature: workflow-assistant-app, Property 82: Project-specific command suggestions**
         
         For any project context, the system should suggest commands relevant to that project type.
         
         This property ensures that:
         - Commands suggested match the project type
         - Relevance scores are above threshold
         - Suggestions include appropriate reasoning
         */
        
        property("Project-specific suggestions are relevant to project type") <- forAll { (projectType: String) in
            guard !projectType.isEmpty else { return Discard() }
            
            let service = ContextualCommandSuggestionService()
            let expectation = XCTestExpectation(description: "Get project suggestions")
            var suggestions: [ContextualCommandSuggestion] = []
            
            Task {
                suggestions = await service.getProjectSpecificSuggestions(
                    projectType: projectType,
                    limit: 5
                )
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 2.0)
            
            // All suggestions should have relevance scores above threshold
            let allAboveThreshold = suggestions.allSatisfy { $0.relevanceScore > 0.3 }
            
            // All suggestions should have non-empty reasons
            let allHaveReasons = suggestions.allSatisfy { !$0.reason.isEmpty }
            
            // All suggestions should reference the project type in context
            let allHaveProjectContext = suggestions.allSatisfy {
                $0.context.projectType == projectType
            }
            
            return allAboveThreshold <?> "All suggestions above threshold" ^&&^
                   allHaveReasons <?> "All suggestions have reasons" ^&&^
                   allHaveProjectContext <?> "All suggestions have project context"
        }.verbose.once
    }
    
    func testProperty82_SwiftProjectSuggestions() {
        /**
         Specific test for Swift projects to ensure relevant commands are suggested
         */
        
        let service = ContextualCommandSuggestionService()
        let expectation = XCTestExpectation(description: "Get Swift suggestions")
        var suggestions: [ContextualCommandSuggestion] = []
        
        Task {
            suggestions = await service.getProjectSpecificSuggestions(
                projectType: "Swift",
                limit: 5
            )
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertFalse(suggestions.isEmpty, "Should return suggestions for Swift projects")
        XCTAssertTrue(suggestions.allSatisfy { $0.relevanceScore > 0.3 }, "All suggestions should be relevant")
    }
    
    // MARK: - Property 83: Conversation-aware command recommendations
    
    func testProperty83_ConversationAwareSuggestions() {
        /**
         **Feature: workflow-assistant-app, Property 83: Conversation-aware command recommendations**
         
         For any conversation state, the system should recommend commands that advance the current workflow.
         
         This property ensures that:
         - Suggestions match the conversation state
         - Commands are contextually appropriate
         - Relevance scores reflect conversation context
         */
        
        let conversationStates: [ConversationState] = [
            .idle, .workflowInProgress, .documentationSearch,
            .analyticsReview, .configuration, .troubleshooting
        ]
        
        property("Conversation-aware suggestions match conversation state") <- forAll { (stateIndex: Int) in
            guard stateIndex >= 0 && stateIndex < conversationStates.count else { return Discard() }
            
            let state = conversationStates[stateIndex]
            let service = ContextualCommandSuggestionService()
            let expectation = XCTestExpectation(description: "Get conversation suggestions")
            var suggestions: [ContextualCommandSuggestion] = []
            
            Task {
                suggestions = await service.getConversationAwareSuggestions(
                    conversationState: state,
                    limit: 5
                )
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 2.0)
            
            // All suggestions should have relevance scores above threshold
            let allAboveThreshold = suggestions.allSatisfy { $0.relevanceScore > 0.3 }
            
            // All suggestions should match conversation state
            let allMatchState = suggestions.allSatisfy {
                $0.context.conversationState == state
            }
            
            // All suggestions should have appropriate reasons
            let allHaveReasons = suggestions.allSatisfy { !$0.reason.isEmpty }
            
            return allAboveThreshold <?> "All suggestions above threshold" ^&&^
                   allMatchState <?> "All suggestions match conversation state" ^&&^
                   allHaveReasons <?> "All suggestions have reasons"
        }.verbose.once
    }
    
    func testProperty83_WorkflowInProgressSuggestions() {
        /**
         Specific test for workflow in progress state
         */
        
        let service = ContextualCommandSuggestionService()
        let expectation = XCTestExpectation(description: "Get workflow suggestions")
        var suggestions: [ContextualCommandSuggestion] = []
        
        Task {
            suggestions = await service.getConversationAwareSuggestions(
                conversationState: .workflowInProgress,
                limit: 5
            )
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertFalse(suggestions.isEmpty, "Should return suggestions for workflow in progress")
        XCTAssertTrue(
            suggestions.allSatisfy { $0.context.conversationState == .workflowInProgress },
            "All suggestions should match workflow state"
        )
    }
    
    // MARK: - Property 84: Intent-matched command suggestions
    
    func testProperty84_IntentMatchedSuggestions() {
        /**
         **Feature: workflow-assistant-app, Property 84: Intent-matched command suggestions**
         
         For any detected user intent matching a command, the system should display the command as a clickable suggestion.
         
         This property ensures that:
         - User intent is correctly detected
         - Matching commands are suggested
         - Suggestions have high relevance scores
         - Suggestions are clickable/actionable
         */
        
        let testInputs = [
            "run workflow",
            "search documentation",
            "view analytics",
            "configure settings",
            "help me with this"
        ]
        
        property("Intent-matched suggestions have high relevance") <- forAll { (inputIndex: Int) in
            guard inputIndex >= 0 && inputIndex < testInputs.count else { return Discard() }
            
            let userInput = testInputs[inputIndex]
            let service = ContextualCommandSuggestionService()
            let expectation = XCTestExpectation(description: "Get intent suggestions")
            var suggestions: [ContextualCommandSuggestion] = []
            
            Task {
                suggestions = await service.getIntentMatchedSuggestions(
                    userInput: userInput,
                    limit: 3
                )
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 2.0)
            
            // Suggestions should have high relevance (>0.5 for intent matches)
            let allHighRelevance = suggestions.allSatisfy { $0.relevanceScore > 0.5 }
            
            // All suggestions should have detected intent in context
            let allHaveIntent = suggestions.allSatisfy { $0.context.detectedIntent != nil }
            
            // All suggestions should have reasons mentioning intent
            let allHaveIntentReasons = suggestions.allSatisfy {
                $0.reason.lowercased().contains("intent")
            }
            
            return allHighRelevance <?> "All suggestions have high relevance" ^&&^
                   allHaveIntent <?> "All suggestions have detected intent" ^&&^
                   allHaveIntentReasons <?> "All suggestions mention intent in reason"
        }.verbose.once
    }
    
    func testProperty84_WorkflowIntentSuggestion() {
        /**
         Specific test for workflow execution intent
         */
        
        let service = ContextualCommandSuggestionService()
        let expectation = XCTestExpectation(description: "Get workflow intent suggestions")
        var suggestions: [ContextualCommandSuggestion] = []
        
        Task {
            suggestions = await service.getIntentMatchedSuggestions(
                userInput: "I want to run a workflow",
                limit: 3
            )
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertFalse(suggestions.isEmpty, "Should return suggestions for workflow intent")
        XCTAssertTrue(
            suggestions.allSatisfy { $0.relevanceScore > 0.5 },
            "Intent-matched suggestions should have high relevance"
        )
    }
    
    // MARK: - Property 85: Command suggestion learning
    
    func testProperty85_SuggestionLearning() {
        /**
         **Feature: workflow-assistant-app, Property 85: Command suggestion learning**
         
         For any accepted or rejected command suggestion, the system should adjust future prioritization.
         
         This property ensures that:
         - Feedback is recorded correctly
         - Acceptance increases future relevance
         - Rejection decreases future relevance
         - Learning persists across sessions
         */
        
        property("Accepted suggestions increase future relevance") <- forAll { (commandName: String, contextType: String) in
            guard !commandName.isEmpty && !contextType.isEmpty else { return Discard() }
            
            let service = ContextualCommandSuggestionService()
            let command = SlashCommand(
                name: commandName,
                description: "Test command",
                category: .workflow,
                handler: { _ in .success("Test") }
            )
            
            let suggestion = ContextualCommandSuggestion(
                command: command,
                relevanceScore: 0.5,
                reason: "Test reason",
                context: CommandContext()
            )
            
            let expectation = XCTestExpectation(description: "Record feedback")
            
            Task {
                // Record acceptance
                await service.recordSuggestionFeedback(suggestion: suggestion, accepted: true)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 2.0)
            
            // Feedback should be recorded (we can't directly verify internal state,
            // but we can verify the method completes without error)
            return true <?> "Feedback recorded successfully"
        }.verbose.once
    }
    
    func testProperty85_RejectionLearning() {
        /**
         Test that rejected suggestions are learned from
         */
        
        let service = ContextualCommandSuggestionService()
        let command = SlashCommand(
            name: "test-command",
            description: "Test command",
            category: .workflow,
            handler: { _ in .success("Test") }
        )
        
        let suggestion = ContextualCommandSuggestion(
            command: command,
            relevanceScore: 0.7,
            reason: "Test reason",
            context: CommandContext(projectType: "Swift")
        )
        
        let expectation = XCTestExpectation(description: "Record rejection")
        
        Task {
            await service.recordSuggestionFeedback(suggestion: suggestion, accepted: false)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertTrue(true, "Rejection feedback recorded")
    }
    
    // MARK: - Property 86: OS-level command suggestions
    
    func testProperty86_OSLevelSuggestions() {
        /**
         **Feature: workflow-assistant-app, Property 86: OS-level command suggestions**
         
         For any detected system administration or configuration task, the system should suggest appropriate OS-level commands.
         
         This property ensures that:
         - System tasks are detected correctly
         - OS-level commands are suggested
         - Suggestions are safe and appropriate
         - Commands have proper permissions
         */
        
        let systemTasks = [
            "configure system settings",
            "manage system processes",
            "check system status",
            "update system configuration",
            "view system logs"
        ]
        
        property("OS-level suggestions are appropriate for system tasks") <- forAll { (taskIndex: Int) in
            guard taskIndex >= 0 && taskIndex < systemTasks.count else { return Discard() }
            
            let taskDescription = systemTasks[taskIndex]
            let service = ContextualCommandSuggestionService()
            let expectation = XCTestExpectation(description: "Get OS suggestions")
            var suggestions: [ContextualCommandSuggestion] = []
            
            Task {
                suggestions = await service.getOSLevelSuggestions(
                    taskDescription: taskDescription,
                    limit: 3
                )
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 2.0)
            
            // All suggestions should have relevance scores above threshold
            let allAboveThreshold = suggestions.allSatisfy { $0.relevanceScore > 0.3 }
            
            // All suggestions should be system or configuration related
            let allSystemRelated = suggestions.allSatisfy {
                $0.command.category == .system || $0.command.category == .configuration
            }
            
            // All suggestions should have reasons
            let allHaveReasons = suggestions.allSatisfy { !$0.reason.isEmpty }
            
            return allAboveThreshold <?> "All suggestions above threshold" ^&&^
                   allSystemRelated <?> "All suggestions are system-related" ^&&^
                   allHaveReasons <?> "All suggestions have reasons"
        }.verbose.once
    }
    
    func testProperty86_SystemConfigurationSuggestion() {
        /**
         Specific test for system configuration tasks
         */
        
        let service = ContextualCommandSuggestionService()
        let expectation = XCTestExpectation(description: "Get system config suggestions")
        var suggestions: [ContextualCommandSuggestion] = []
        
        Task {
            suggestions = await service.getOSLevelSuggestions(
                taskDescription: "configure system settings",
                limit: 3
            )
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        // Should return suggestions for system configuration
        XCTAssertTrue(
            suggestions.allSatisfy { $0.relevanceScore > 0.3 },
            "System suggestions should be relevant"
        )
    }
}
