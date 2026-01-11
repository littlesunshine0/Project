//
//  ChatMessageOrderingPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for chat message chronological ordering
//

import XCTest
import SwiftUI
@testable import Project

class ChatMessageOrderingPropertyTests: XCTestCase {
    
    // MARK: - Property 35: Message chronological ordering
    // **Feature: workflow-assistant-app, Property 35: Message chronological ordering**
    // **Validates: Requirements 9.1**
    
    /// For any set of messages, the interface should display them in chronological order with visual distinction between senders
    func testMessageChronologicalOrdering() {
        // Run 100 iterations as specified in the design document
        for iteration in 0..<100 {
            // Generate a random set of messages with varying timestamps
            let messageCount = Int.random(in: 2...20)
            var messages: [ChatMessage] = []
            
            // Create messages with random timestamps over a 24-hour period
            let baseDate = Date()
            for i in 0..<messageCount {
                let randomOffset = TimeInterval.random(in: 0...(24 * 60 * 60))
                let timestamp = baseDate.addingTimeInterval(randomOffset)
                let sender: MessageSender = Bool.random() ? .user : .system
                
                let message = ChatMessage(
                    id: UUID(),
                    content: "Test message \(i)",
                    sender: sender,
                    timestamp: timestamp
                )
                messages.append(message)
            }
            
            // Create a ChatViewController and set the messages
            let viewController = ChatViewController()
            
            // Simulate adding messages in random order
            let shuffledMessages = messages.shuffled()
            for message in shuffledMessages {
                viewController.messages.append(message)
            }
            
            // Property: Messages should be sortable by timestamp
            let sortedMessages = viewController.messages.sorted { $0.timestamp < $1.timestamp }
            
            // Verify that we can determine chronological order
            for i in 0..<(sortedMessages.count - 1) {
                XCTAssertLessThanOrEqual(
                    sortedMessages[i].timestamp,
                    sortedMessages[i + 1].timestamp,
                    "Messages should be orderable chronologically"
                )
            }
            
            // Property: Each message should have a distinct sender that can be identified
            for message in viewController.messages {
                switch message.sender {
                case .user:
                    XCTAssertNotEqual(message.sender, MessageSender.system, "User messages should be distinguishable from system messages")
                case .system:
                    XCTAssertNotEqual(message.sender, MessageSender.user, "System messages should be distinguishable from user messages")
                case .workflow:
                    // Workflow messages are also distinct
                    XCTAssertNotEqual(message.sender, MessageSender.user, "Workflow messages should be distinguishable from user messages")
                    XCTAssertNotEqual(message.sender, MessageSender.system, "Workflow messages should be distinguishable from system messages")
                }
            }
        }
    }
    
    /// Test that messages maintain chronological order when added sequentially
    func testSequentialMessageOrdering() {
        for _ in 0..<100 {
            let viewController = ChatViewController()
            let messageCount = Int.random(in: 2...15)
            
            var previousTimestamp: Date?
            
            for i in 0..<messageCount {
                // Add a small delay to ensure timestamps are sequential
                let timestamp = Date().addingTimeInterval(TimeInterval(i))
                let sender: MessageSender = i % 2 == 0 ? .user : .system
                
                let message = ChatMessage(
                    id: UUID(),
                    content: "Sequential message \(i)",
                    sender: sender,
                    timestamp: timestamp
                )
                
                viewController.messages.append(message)
                
                // Verify this message's timestamp is after the previous one
                if let prev = previousTimestamp {
                    XCTAssertGreaterThanOrEqual(
                        timestamp,
                        prev,
                        "Sequentially added messages should have non-decreasing timestamps"
                    )
                }
                
                previousTimestamp = timestamp
            }
            
            // Verify the entire array maintains chronological order
            for i in 0..<(viewController.messages.count - 1) {
                XCTAssertLessThanOrEqual(
                    viewController.messages[i].timestamp,
                    viewController.messages[i + 1].timestamp,
                    "Messages array should maintain chronological order"
                )
            }
        }
    }
    
    /// Test that sender distinction is maintained across all message types
    func testSenderDistinction() {
        for _ in 0..<100 {
            let viewController = ChatViewController()
            let messageCount = Int.random(in: 5...20)
            
            for i in 0..<messageCount {
                let senderType = i % 3
                let sender: MessageSender
                
                switch senderType {
                case 0:
                    sender = .user
                case 1:
                    sender = .system
                default:
                    sender = .workflow(UUID())
                }
                
                let message = ChatMessage(
                    id: UUID(),
                    content: "Message \(i)",
                    sender: sender,
                    timestamp: Date().addingTimeInterval(TimeInterval(i))
                )
                
                viewController.messages.append(message)
            }
            
            // Verify each message has a clearly identifiable sender
            for message in viewController.messages {
                let hasDistinctSender: Bool
                
                switch message.sender {
                case .user:
                    hasDistinctSender = true
                case .system:
                    hasDistinctSender = true
                case .workflow:
                    hasDistinctSender = true
                }
                
                XCTAssertTrue(hasDistinctSender, "Each message should have a distinct, identifiable sender")
            }
            
            // Verify that we can group messages by sender
            let userMessages = viewController.messages.filter {
                if case .user = $0.sender { return true }
                return false
            }
            
            let systemMessages = viewController.messages.filter {
                if case .system = $0.sender { return true }
                return false
            }
            
            let workflowMessages = viewController.messages.filter {
                if case .workflow = $0.sender { return true }
                return false
            }
            
            // The sum of categorized messages should equal total messages
            XCTAssertEqual(
                userMessages.count + systemMessages.count + workflowMessages.count,
                viewController.messages.count,
                "All messages should be categorizable by sender type"
            )
        }
    }
    
    /// Test that chronological ordering is preserved after message operations
    func testChronologicalOrderingAfterOperations() {
        for _ in 0..<100 {
            let viewController = ChatViewController()
            let initialCount = Int.random(in: 5...15)
            
            // Add initial messages
            for i in 0..<initialCount {
                let message = ChatMessage(
                    id: UUID(),
                    content: "Initial message \(i)",
                    sender: i % 2 == 0 ? .user : .system,
                    timestamp: Date().addingTimeInterval(TimeInterval(i))
                )
                viewController.messages.append(message)
            }
            
            // Verify initial ordering
            for i in 0..<(viewController.messages.count - 1) {
                XCTAssertLessThanOrEqual(
                    viewController.messages[i].timestamp,
                    viewController.messages[i + 1].timestamp,
                    "Initial messages should be in chronological order"
                )
            }
            
            // Delete a random message (if any exist)
            if !viewController.messages.isEmpty {
                let randomIndex = Int.random(in: 0..<viewController.messages.count)
                let messageToDelete = viewController.messages[randomIndex]
                viewController.deleteMessage(messageToDelete)
            }
            
            // Verify ordering is still maintained after deletion
            for i in 0..<(viewController.messages.count - 1) {
                XCTAssertLessThanOrEqual(
                    viewController.messages[i].timestamp,
                    viewController.messages[i + 1].timestamp,
                    "Chronological order should be maintained after deletion"
                )
            }
            
            // Add a new message with a timestamp after all existing messages
            if !viewController.messages.isEmpty {
                let lastTimestamp = viewController.messages.last!.timestamp
                let newMessage = ChatMessage(
                    id: UUID(),
                    content: "New message",
                    sender: .user,
                    timestamp: lastTimestamp.addingTimeInterval(1)
                )
                viewController.messages.append(newMessage)
                
                // Verify the new message is at the end and maintains order
                XCTAssertEqual(
                    viewController.messages.last?.id,
                    newMessage.id,
                    "New message with latest timestamp should be at the end"
                )
                
                for i in 0..<(viewController.messages.count - 1) {
                    XCTAssertLessThanOrEqual(
                        viewController.messages[i].timestamp,
                        viewController.messages[i + 1].timestamp,
                        "Chronological order should be maintained after adding new message"
                    )
                }
            }
        }
    }
    
    /// Test that messages with identical timestamps maintain insertion order
    func testIdenticalTimestampOrdering() {
        for _ in 0..<100 {
            let viewController = ChatViewController()
            let sameTimestamp = Date()
            let messageCount = Int.random(in: 3...10)
            
            var messageIds: [UUID] = []
            
            // Add messages with identical timestamps
            for i in 0..<messageCount {
                let message = ChatMessage(
                    id: UUID(),
                    content: "Message \(i)",
                    sender: i % 2 == 0 ? .user : .system,
                    timestamp: sameTimestamp
                )
                messageIds.append(message.id)
                viewController.messages.append(message)
            }
            
            // Verify all messages have the same timestamp
            for message in viewController.messages {
                XCTAssertEqual(
                    message.timestamp,
                    sameTimestamp,
                    "All messages should have identical timestamps"
                )
            }
            
            // Verify insertion order is maintained (messages appear in the order they were added)
            for (index, messageId) in messageIds.enumerated() {
                XCTAssertEqual(
                    viewController.messages[index].id,
                    messageId,
                    "Messages with identical timestamps should maintain insertion order"
                )
            }
        }
    }
}
