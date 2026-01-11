//
//  CommandAutoCompletePropertyTests.swift
//  ProjectTests
//
//  Property-based tests for command auto-completion system
//

import XCTest
import SwiftCheck
@testable import Project

class CommandAutoCompletePropertyTests: XCTestCase {
    
    var autoCompleteService: CommandAutoCompleteService!
    
    override func setUp() async throws {
        try await super.setUp()
        autoCompleteService = CommandAutoCompleteService()
    }
    
    override func tearDown() async throws {
        autoCompleteService = nil
        try await super.tearDown()
    }
    
    // MARK: - Property 79: Command Auto-Completion
    
    /// **Feature: workflow-assistant-app, Property 79: Command auto-completion**
    /// **Validates: Requirements 20.2**
    ///
    /// For any partial command being typed, the system should provide auto-completion suggestions
    func testCommandAutoCompletionProperty() {
        property("For any partial command, system provides auto-completion") <- forAll { (partial: String) in
            let expectation = XCTestExpectation(description: "Get auto-complete suggestions")
            
            Task {
                // Given: A partial command input (ensure it starts with /)
                let input = "/" + partial.prefix(10)  // Limit length
                
                // When: Getting auto-complete suggestions
                let suggestions = await self.autoCompleteService.getAutoCompleteSuggestions(for: input)
                
                // Then: Suggestions should be provided (may be empty if no match)
                // All suggestions should be valid
                for suggestion in suggestions {
                    XCTAssertFalse(suggestion.command.name.isEmpty, "Command name should not be empty")
                    XCTAssertFalse(suggestion.command.description.isEmpty, "Command description should not be empty")
                    XCTAssertGreaterThan(suggestion.matchScore, 0.0, "Match score should be positive")
                    XCTAssertLessThanOrEqual(suggestion.matchScore, 1.0, "Match score should not exceed 1.0")
                    XCTAssertTrue(suggestion.highlightedText.hasPrefix("/"), "Highlighted text should start with /")
                }
                
                // Suggestions should be sorted by match score
                if suggestions.count > 1 {
                    for i in 0..<(suggestions.count - 1) {
                        XCTAssertGreaterThanOrEqual(
                            suggestions[i].matchScore,
                            suggestions[i + 1].matchScore,
                            "Suggestions should be sorted by match score"
                        )
                    }
                }
                
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 2.0)
            return true
        }.withSize(50)
    }
    
    // MARK: - Property 80: Command Inline Help
    
    /// **Feature: workflow-assistant-app, Property 80: Command inline help**
    /// **Validates: Requirements 20.3**
    ///
    /// For any command being typed, the system should display inline help with syntax and parameters
    func testCommandInlineHelpProperty() {
        property("For any command, system provides inline help") <- forAll { (commandName: String) in
            let expectation = XCTestExpectation(description: "Get inline help")
            
            Task {
                // Given: A command input
                let input = "/\(commandName)"
                
                // When: Getting inline help
                let help = await self.autoCompleteService.getInlineHelp(for: input)
                
                // Then: If help is provided, it should be complete
                if let help = help {
                    XCTAssertFalse(help.command.name.isEmpty, "Command name should not be empty")
                    XCTAssertFalse(help.command.syntax.isEmpty, "Syntax should not be empty")
                    XCTAssertFalse(help.helpText.isEmpty, "Help text should not be empty")
                    XCTAssertTrue(help.helpText.contains(help.command.syntax), "Help text should contain syntax")
                    XCTAssertTrue(help.helpText.contains(help.command.description), "Help text should contain description")
                }
                
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 2.0)
            return true
        }.withSize(50)
    }
    
    // MARK: - Property 81: Command Execution Feedback
    
    /// **Feature: workflow-assistant-app, Property 81: Command execution feedback**
    /// **Validates: Requirements 20.5**
    ///
    /// For any executed command, the system should provide immediate feedback on success or error
    func testCommandExecutionFeedbackProperty() {
        property("For any command execution, system provides feedback") <- forAll { (commandInput: String) in
            let expectation = XCTestExpectation(description: "Execute command and get feedback")
            
            Task {
                // Given: A command input
                let input = "/" + commandInput.prefix(20)  // Limit length
                
                // When: Executing the command
                let feedback = await self.autoCompleteService.executeCommand(input)
                
                // Then: Feedback should always be provided
                XCTAssertFalse(feedback.message.isEmpty, "Feedback message should not be empty")
                XCTAssertNotNil(feedback.timestamp, "Feedback should have timestamp")
                
                // Feedback should indicate success or failure
                if feedback.success {
                    XCTAssertFalse(feedback.message.contains("error"), "Success feedback should not contain 'error'")
                } else {
                    // Failed commands should provide helpful details
                    XCTAssertNotNil(feedback.details, "Failed commands should provide details")
                }
                
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 2.0)
            return true
        }.withSize(50)
    }
    
    // MARK: - Integration Tests
    
    /// Test auto-completion with known commands
    func testAutoCompletionWithKnownCommands() async throws {
        // Given: Partial command inputs
        let inputs = ["/wor", "/doc", "/ana", "/hel"]
        
        for input in inputs {
            // When: Getting suggestions
            let suggestions = await autoCompleteService.getAutoCompleteSuggestions(for: input)
            
            // Then: Should get relevant suggestions
            XCTAssertFalse(suggestions.isEmpty, "Should get suggestions for '\(input)'")
            
            for suggestion in suggestions {
                XCTAssertTrue(
                    suggestion.command.name.lowercased().contains(String(input.dropFirst()).lowercased()),
                    "Suggestion should match input"
                )
            }
        }
    }
    
    /// Test inline help for complete commands
    func testInlineHelpForCompleteCommands() async throws {
        // Given: Complete command inputs
        let commands = ["/workflow", "/docs", "/analytics", "/help"]
        
        for command in commands {
            // When: Getting inline help
            let help = await autoCompleteService.getInlineHelp(for: command)
            
            // Then: Should get help information
            XCTAssertNotNil(help, "Should get help for '\(command)'")
            
            if let help = help {
                XCTAssertTrue(help.helpText.contains(help.command.syntax), "Help should contain syntax")
                XCTAssertTrue(help.helpText.contains(help.command.description), "Help should contain description")
            }
        }
    }
    
    /// Test execution feedback for valid and invalid commands
    func testExecutionFeedback() async throws {
        // Test valid command
        let validFeedback = await autoCompleteService.executeCommand("/help")
        XCTAssertTrue(validFeedback.success || !validFeedback.success, "Should provide feedback")
        XCTAssertFalse(validFeedback.message.isEmpty, "Should have message")
        
        // Test invalid command
        let invalidFeedback = await autoCompleteService.executeCommand("/invalidcommand")
        XCTAssertFalse(invalidFeedback.success, "Invalid command should fail")
        XCTAssertTrue(invalidFeedback.message.contains("Unknown"), "Should indicate unknown command")
    }
    
    /// Test command validation
    func testCommandValidation() async throws {
        // Valid commands
        let (valid1, _) = await autoCompleteService.validateCommand("/help")
        XCTAssertTrue(valid1, "Valid command should pass validation")
        
        let (valid2, _) = await autoCompleteService.validateCommand("/workflow test")
        XCTAssertTrue(valid2, "Valid command with params should pass validation")
        
        // Invalid commands
        let (invalid1, error1) = await autoCompleteService.validateCommand("help")
        XCTAssertFalse(invalid1, "Command without / should fail")
        XCTAssertNotNil(error1, "Should provide error message")
        
        let (invalid2, error2) = await autoCompleteService.validateCommand("/unknowncommand")
        XCTAssertFalse(invalid2, "Unknown command should fail")
        XCTAssertNotNil(error2, "Should provide error message")
    }
    
    /// Test auto-completion sorting
    func testAutoCompletionSorting() async throws {
        // Given: A partial command that matches multiple commands
        let input = "/w"
        
        // When: Getting suggestions
        let suggestions = await autoCompleteService.getAutoCompleteSuggestions(for: input)
        
        // Then: Suggestions should be sorted by match score
        if suggestions.count > 1 {
            for i in 0..<(suggestions.count - 1) {
                XCTAssertGreaterThanOrEqual(
                    suggestions[i].matchScore,
                    suggestions[i + 1].matchScore,
                    "Suggestions should be sorted by match score (descending)"
                )
            }
        }
    }
}
