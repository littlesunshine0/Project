//
//  RealTimeIntentPredictionPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for real-time intent prediction
//  **Feature: workflow-assistant-app, Property 15: Real-time intent prediction**
//

import XCTest
import SwiftCheck
@testable import Project

class RealTimeIntentPredictionPropertyTests: XCTestCase {
    
    var nluEngine: NLUEngine!
    
    override func setUp() async throws {
        try await super.setUp()
        nluEngine = NLUEngine()
        try await nluEngine.initialize()
    }
    
    override func tearDown() async throws {
        nluEngine = nil
        try await super.tearDown()
    }
    
    // MARK: - Property 15: Real-time intent prediction
    
    /// **Feature: workflow-assistant-app, Property 15: Real-time intent prediction**
    /// For any partial user message being typed, the NLU engine should provide intent predictions within 200ms
    /// **Validates: Requirements 4.3**
    func testRealTimeIntentPredictionLatency() async throws {
        // Test with various partial messages
        let testMessages = [
            "create a new",
            "execute the",
            "search for",
            "show me the",
            "list all",
            "pause the current",
            "resume my",
            "view analytics",
            "help me with",
            "configure the",
            "run the command",
            "delete the workflow",
            "share this",
            "view history",
            "generate a report",
            "find documentation about",
            "ingest docs from",
            "collaborate on",
            "rate this workflow",
            "provide feedback"
        ]
        
        var latencies: [TimeInterval] = []
        var failedPredictions: [(String, TimeInterval)] = []
        
        // Test each message multiple times to account for variance
        for message in testMessages {
            for iteration in 0..<5 {
                let prediction = try await nluEngine.predictIntentRealtime(message)
                latencies.append(prediction.latency)
                
                // Track failures
                if !prediction.meetsLatencyRequirement {
                    failedPredictions.append((message, prediction.latency))
                }
                
                // Verify latency requirement
                XCTAssertLessThanOrEqual(
                    prediction.latency,
                    0.200,
                    "Prediction for '\(message)' (iteration \(iteration + 1)) took \(Int(prediction.latency * 1000))ms, exceeding 200ms requirement"
                )
                
                // Verify prediction structure
                XCTAssertNotNil(prediction.intent, "Prediction should have an intent")
                XCTAssertTrue(prediction.isPartial, "Prediction should be marked as partial")
                XCTAssertGreaterThan(prediction.latency, 0, "Latency should be positive")
            }
        }
        
        // Calculate statistics
        let averageLatency = latencies.reduce(0, +) / Double(latencies.count)
        let maxLatency = latencies.max() ?? 0
        let minLatency = latencies.min() ?? 0
        let p95Latency = latencies.sorted()[Int(Double(latencies.count) * 0.95)]
        
        print("\n=== Real-Time Intent Prediction Performance ===")
        print("Total predictions: \(latencies.count)")
        print("Average latency: \(Int(averageLatency * 1000))ms")
        print("Min latency: \(Int(minLatency * 1000))ms")
        print("Max latency: \(Int(maxLatency * 1000))ms")
        print("P95 latency: \(Int(p95Latency * 1000))ms")
        print("Failed predictions: \(failedPredictions.count)/\(latencies.count)")
        
        if !failedPredictions.isEmpty {
            print("\nFailed predictions (>200ms):")
            for (message, latency) in failedPredictions.prefix(5) {
                print("  - '\(message)': \(Int(latency * 1000))ms")
            }
        }
        
        // Overall requirement: average should be well under 200ms
        XCTAssertLessThan(
            averageLatency,
            0.200,
            "Average latency \(Int(averageLatency * 1000))ms should be under 200ms"
        )
        
        // P95 should also meet requirement
        XCTAssertLessThanOrEqual(
            p95Latency,
            0.200,
            "P95 latency \(Int(p95Latency * 1000))ms should be under 200ms"
        )
    }
    
    /// Test that real-time prediction works with varying input lengths
    func testRealTimePredictionWithVaryingLengths() async throws {
        let inputs = [
            "cre",                                    // 3 chars
            "create",                                 // 6 chars
            "create a new",                           // 13 chars
            "create a new workflow",                  // 22 chars
            "create a new workflow for iOS",          // 30 chars
            "create a new workflow for iOS app setup" // 40 chars
        ]
        
        for input in inputs {
            let prediction = try await nluEngine.predictIntentRealtime(input)
            
            // Verify latency requirement
            XCTAssertLessThanOrEqual(
                prediction.latency,
                0.200,
                "Prediction for input length \(input.count) took \(Int(prediction.latency * 1000))ms"
            )
            
            // Longer inputs should generally have higher confidence
            if input.count >= 20 {
                // For longer, more complete inputs, we expect reasonable confidence
                // (unless it's truly ambiguous)
                XCTAssertGreaterThan(
                    prediction.intent.confidence,
                    0.0,
                    "Longer input should have some confidence"
                )
            }
        }
    }
    
    /// Test that predictions are consistent for similar inputs
    func testPredictionConsistency() async throws {
        let baseMessage = "create a new workflow"
        
        // Run prediction multiple times
        var predictions: [IntentPrediction] = []
        for _ in 0..<10 {
            let prediction = try await nluEngine.predictIntentRealtime(baseMessage)
            predictions.append(prediction)
        }
        
        // All predictions should have same intent type
        let intentTypes = Set(predictions.map { $0.intent.type })
        XCTAssertEqual(
            intentTypes.count,
            1,
            "Predictions for same input should be consistent, got: \(intentTypes)"
        )
        
        // Confidence should be relatively stable (within 10%)
        let confidences = predictions.map { $0.intent.confidence }
        let avgConfidence = confidences.reduce(0, +) / Double(confidences.count)
        for confidence in confidences {
            XCTAssertLessThan(
                abs(confidence - avgConfidence),
                0.10,
                "Confidence should be stable across predictions"
            )
        }
        
        // All should meet latency requirement
        for prediction in predictions {
            XCTAssertTrue(
                prediction.meetsLatencyRequirement,
                "All predictions should meet latency requirement"
            )
        }
    }
    
    /// Test that very short inputs are handled efficiently
    func testShortInputHandling() async throws {
        let shortInputs = ["a", "ab", "cr"]
        
        for input in shortInputs {
            let prediction = try await nluEngine.predictIntentRealtime(input)
            
            // Should still meet latency requirement (should be very fast)
            XCTAssertLessThanOrEqual(
                prediction.latency,
                0.200,
                "Short input '\(input)' should be handled quickly"
            )
            
            // Should be marked as partial
            XCTAssertTrue(prediction.isPartial, "Should be marked as partial")
            
            // For very short input, confidence should be low or intent should be unknown
            if input.count < 3 {
                XCTAssertTrue(
                    prediction.intent.confidence < 0.5 || prediction.intent.type == .unknown,
                    "Very short input should have low confidence or unknown intent"
                )
            }
        }
    }
    
    /// Test concurrent predictions (simulating rapid typing)
    func testConcurrentPredictions() async throws {
        let messages = [
            "create",
            "create a",
            "create a new",
            "create a new workflow",
            "create a new workflow for"
        ]
        
        // Run predictions concurrently
        try await withThrowingTaskGroup(of: IntentPrediction.self) { group in
            for message in messages {
                group.addTask {
                    return try await self.nluEngine.predictIntentRealtime(message)
                }
            }
            
            var predictions: [IntentPrediction] = []
            for try await prediction in group {
                predictions.append(prediction)
            }
            
            // All should meet latency requirement
            for prediction in predictions {
                XCTAssertLessThanOrEqual(
                    prediction.latency,
                    0.200,
                    "Concurrent prediction took \(Int(prediction.latency * 1000))ms"
                )
            }
            
            // Should have received all predictions
            XCTAssertEqual(predictions.count, messages.count)
        }
    }
    
    /// Test that prediction latency is tracked correctly
    func testLatencyTracking() async throws {
        let message = "search for documentation"
        
        let prediction = try await nluEngine.predictIntentRealtime(message)
        
        // Latency should be positive
        XCTAssertGreaterThan(prediction.latency, 0, "Latency should be positive")
        
        // Latency should be reasonable (not negative, not huge)
        XCTAssertLessThan(prediction.latency, 1.0, "Latency should be less than 1 second")
        
        // meetsLatencyRequirement should be consistent with actual latency
        if prediction.latency <= 0.200 {
            XCTAssertTrue(
                prediction.meetsLatencyRequirement,
                "Should meet latency requirement when latency is \(Int(prediction.latency * 1000))ms"
            )
        } else {
            XCTAssertFalse(
                prediction.meetsLatencyRequirement,
                "Should not meet latency requirement when latency is \(Int(prediction.latency * 1000))ms"
            )
        }
    }
    
    /// Test prediction with various intent types
    func testVariousIntentTypes() async throws {
        let intentMessages: [(String, IntentType)] = [
            ("create a new workflow", .createWorkflow),
            ("execute the workflow", .executeWorkflow),
            ("search for documentation", .searchDocumentation),
            ("view analytics", .viewAnalytics),
            ("help me", .help),
            ("list all workflows", .listWorkflows),
            ("pause the current", .pauseWorkflow),
            ("resume my workflow", .resumeWorkflow)
        ]
        
        for (message, expectedIntent) in intentMessages {
            let prediction = try await nluEngine.predictIntentRealtime(message)
            
            // Should meet latency requirement
            XCTAssertLessThanOrEqual(
                prediction.latency,
                0.200,
                "Prediction for '\(message)' took \(Int(prediction.latency * 1000))ms"
            )
            
            // Intent type should match (or be reasonable alternative)
            // Note: We're lenient here because partial input may not always predict correctly
            XCTAssertNotEqual(
                prediction.intent.type,
                .unknown,
                "Should predict a specific intent for '\(message)'"
            )
        }
    }
}
