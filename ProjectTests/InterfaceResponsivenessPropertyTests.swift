//
//  InterfaceResponsivenessPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for interface responsiveness
//

import XCTest
import SwiftUI
@testable import Project

class InterfaceResponsivenessPropertyTests: XCTestCase {
    
    // MARK: - Property 39: Interface responsiveness
    // **Feature: workflow-assistant-app, Property 39: Interface responsiveness**
    // **Validates: Requirements 9.5**
    
    /// For any user input, the interface should provide feedback within 500 milliseconds
    func testInterfaceResponsivenessWithinLimit() {
        // Run 100 iterations as specified in the design document
        for iteration in 0..<100 {
            let viewController = ChatViewController()
            
            // Generate random input of varying lengths
            let inputLength = Int.random(in: 1...500)
            let randomInput = String(repeating: "a", count: inputLength)
            
            // Measure response time for setting input
            let startTime = Date()
            viewController.inputText = randomInput
            let inputSetTime = Date().timeIntervalSince(startTime)
            
            // Property: Setting input should be nearly instantaneous (< 50ms)
            XCTAssertLessThan(
                inputSetTime,
                0.05,
                "Setting input text should be instantaneous (< 50ms), got \(inputSetTime * 1000)ms"
            )
            
            // Measure response time for sending message
            let sendStartTime = Date()
            viewController.sendMessage()
            let sendResponseTime = Date().timeIntervalSince(sendStartTime)
            
            // Property: Sending message should provide immediate feedback (< 500ms)
            // This includes adding the message to the display
            XCTAssertLessThan(
                sendResponseTime,
                0.5,
                "Send message should respond within 500ms, got \(sendResponseTime * 1000)ms"
            )
            
            // Verify the message was added immediately
            XCTAssertGreaterThan(
                viewController.messages.count,
                0,
                "Message should be added to display immediately"
            )
            
            // Verify the last response time is tracked
            XCTAssertGreaterThan(
                viewController.lastResponseTime,
                0,
                "Response time should be tracked"
            )
            
            XCTAssertLessThan(
                viewController.lastResponseTime,
                0.5,
                "Tracked response time should be within 500ms limit"
            )
        }
    }
    
    /// Test that typing indicator appears promptly
    func testTypingIndicatorResponsiveness() {
        for _ in 0..<100 {
            let viewController = ChatViewController()
            
            // Measure time to show typing indicator
            let startTime = Date()
            viewController.showTypingIndicator()
            let showTime = Date().timeIntervalSince(startTime)
            
            // Property: Showing typing indicator should be immediate (< 50ms)
            XCTAssertLessThan(
                showTime,
                0.05,
                "Showing typing indicator should be immediate, got \(showTime * 1000)ms"
            )
            
            XCTAssertTrue(
                viewController.isTyping,
                "Typing indicator should be visible"
            )
            
            // Measure time to hide typing indicator
            let hideStartTime = Date()
            viewController.hideTypingIndicator()
            let hideTime = Date().timeIntervalSince(hideStartTime)
            
            // Property: Hiding typing indicator should be immediate (< 50ms)
            XCTAssertLessThan(
                hideTime,
                0.05,
                "Hiding typing indicator should be immediate, got \(hideTime * 1000)ms"
            )
            
            XCTAssertFalse(
                viewController.isTyping,
                "Typing indicator should be hidden"
            )
        }
    }
    
    /// Test that message display operations are responsive
    func testMessageDisplayResponsiveness() {
        for _ in 0..<100 {
            let viewController = ChatViewController()
            let messageCount = Int.random(in: 1...50)
            
            // Measure time to display multiple messages
            let startTime = Date()
            
            for i in 0..<messageCount {
                let message = ChatMessage(
                    id: UUID(),
                    content: "Test message \(i)",
                    sender: i % 2 == 0 ? .user : .system,
                    timestamp: Date()
                )
                viewController.displayMessage(message)
            }
            
            let totalTime = Date().timeIntervalSince(startTime)
            let averageTimePerMessage = totalTime / Double(messageCount)
            
            // Property: Each message display should average well under 500ms
            // We expect much faster performance, but test against the requirement
            XCTAssertLessThan(
                averageTimePerMessage,
                0.1,
                "Average message display time should be < 100ms, got \(averageTimePerMessage * 1000)ms"
            )
            
            // Verify all messages were added
            XCTAssertEqual(
                viewController.messages.count,
                messageCount,
                "All messages should be displayed"
            )
        }
    }
    
    /// Test that command suggestion updates are responsive
    func testCommandSuggestionResponsiveness() {
        for _ in 0..<100 {
            let viewController = ChatViewController()
            
            // Test various command prefixes
            let commandPrefixes = ["/", "/w", "/wo", "/wor", "/work", "/workf", "/workfl", "/workflo", "/workflow"]
            
            for prefix in commandPrefixes {
                let startTime = Date()
                viewController.displayCommandSuggestions(["/workflow", "/work"])
                let displayTime = Date().timeIntervalSince(startTime)
                
                // Property: Command suggestions should appear immediately (< 100ms)
                XCTAssertLessThan(
                    displayTime,
                    0.1,
                    "Command suggestions should appear within 100ms, got \(displayTime * 1000)ms"
                )
            }
        }
    }
    
    /// Test that clearing messages is responsive
    func testClearMessagesResponsiveness() {
        for _ in 0..<100 {
            let viewController = ChatViewController()
            
            // Add random number of messages
            let messageCount = Int.random(in: 10...100)
            for i in 0..<messageCount {
                let message = ChatMessage(
                    id: UUID(),
                    content: "Message \(i)",
                    sender: .user,
                    timestamp: Date()
                )
                viewController.messages.append(message)
            }
            
            // Measure time to clear all messages
            let startTime = Date()
            viewController.clearMessages()
            let clearTime = Date().timeIntervalSince(startTime)
            
            // Property: Clearing messages should be fast regardless of count (< 100ms)
            XCTAssertLessThan(
                clearTime,
                0.1,
                "Clearing \(messageCount) messages should be < 100ms, got \(clearTime * 1000)ms"
            )
            
            XCTAssertEqual(
                viewController.messages.count,
                0,
                "All messages should be cleared"
            )
        }
    }
    
    /// Test that delete operations are responsive
    func testDeleteMessageResponsiveness() {
        for _ in 0..<100 {
            let viewController = ChatViewController()
            
            // Add messages
            let messageCount = Int.random(in: 5...30)
            var messagesToDelete: [ChatMessage] = []
            
            for i in 0..<messageCount {
                let message = ChatMessage(
                    id: UUID(),
                    content: "Message \(i)",
                    sender: i % 2 == 0 ? .user : .system,
                    timestamp: Date()
                )
                viewController.messages.append(message)
                messagesToDelete.append(message)
            }
            
            // Delete random messages and measure time
            let deleteCount = Int.random(in: 1...min(5, messageCount))
            let messagesToRemove = messagesToDelete.shuffled().prefix(deleteCount)
            
            let startTime = Date()
            for message in messagesToRemove {
                viewController.deleteMessage(message)
            }
            let deleteTime = Date().timeIntervalSince(startTime)
            
            // Property: Deleting messages should be fast (< 100ms total)
            XCTAssertLessThan(
                deleteTime,
                0.1,
                "Deleting \(deleteCount) messages should be < 100ms, got \(deleteTime * 1000)ms"
            )
            
            // Verify correct number of messages remain
            XCTAssertEqual(
                viewController.messages.count,
                messageCount - deleteCount,
                "Correct number of messages should remain after deletion"
            )
        }
    }
    
    /// Test responsiveness under rapid input changes
    func testRapidInputChangeResponsiveness() {
        for _ in 0..<100 {
            let viewController = ChatViewController()
            
            // Simulate rapid typing
            let inputChanges = Int.random(in: 10...50)
            let startTime = Date()
            
            for i in 0..<inputChanges {
                viewController.inputText = String(repeating: "a", count: i)
            }
            
            let totalTime = Date().timeIntervalSince(startTime)
            let averageTimePerChange = totalTime / Double(inputChanges)
            
            // Property: Each input change should be handled quickly (< 50ms average)
            XCTAssertLessThan(
                averageTimePerChange,
                0.05,
                "Average input change handling should be < 50ms, got \(averageTimePerChange * 1000)ms"
            )
        }
    }
    
    /// Test that the interface remains responsive with large message history
    func testResponsivenessWithLargeHistory() {
        for _ in 0..<100 {
            let viewController = ChatViewController()
            
            // Create a large message history
            let largeHistorySize = Int.random(in: 100...500)
            for i in 0..<largeHistorySize {
                let message = ChatMessage(
                    id: UUID(),
                    content: "Historical message \(i)",
                    sender: i % 2 == 0 ? .user : .system,
                    timestamp: Date().addingTimeInterval(TimeInterval(-largeHistorySize + i))
                )
                viewController.messages.append(message)
            }
            
            // Test that adding a new message is still responsive
            let startTime = Date()
            let newMessage = ChatMessage(
                id: UUID(),
                content: "New message",
                sender: .user,
                timestamp: Date()
            )
            viewController.displayMessage(newMessage)
            let addTime = Date().timeIntervalSince(startTime)
            
            // Property: Adding message should remain fast even with large history (< 100ms)
            XCTAssertLessThan(
                addTime,
                0.1,
                "Adding message with \(largeHistorySize) history should be < 100ms, got \(addTime * 1000)ms"
            )
            
            // Test that clearing is still responsive
            let clearStartTime = Date()
            viewController.clearMessages()
            let clearTime = Date().timeIntervalSince(clearStartTime)
            
            // Property: Clearing large history should still be reasonably fast (< 200ms)
            XCTAssertLessThan(
                clearTime,
                0.2,
                "Clearing \(largeHistorySize) messages should be < 200ms, got \(clearTime * 1000)ms"
            )
        }
    }
    
    /// Test that concurrent operations maintain responsiveness
    func testConcurrentOperationResponsiveness() {
        for _ in 0..<100 {
            let viewController = ChatViewController()
            let expectation = XCTestExpectation(description: "Concurrent operations complete")
            
            let startTime = Date()
            
            // Simulate concurrent operations
            DispatchQueue.global().async {
                for i in 0..<10 {
                    DispatchQueue.main.async {
                        let message = ChatMessage(
                            id: UUID(),
                            content: "Concurrent message \(i)",
                            sender: .system,
                            timestamp: Date()
                        )
                        viewController.displayMessage(message)
                    }
                }
                
                DispatchQueue.main.async {
                    expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: 1.0)
            let totalTime = Date().timeIntervalSince(startTime)
            
            // Property: Concurrent operations should complete within reasonable time (< 1s)
            XCTAssertLessThan(
                totalTime,
                1.0,
                "Concurrent operations should complete within 1s, got \(totalTime)s"
            )
            
            // Verify all messages were added
            XCTAssertEqual(
                viewController.messages.count,
                10,
                "All concurrent messages should be added"
            )
        }
    }
}
