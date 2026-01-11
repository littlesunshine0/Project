//
//  AnalyticsEnginePropertyTests.swift
//  ProjectTests
//
//  Property-based tests for analytics engine
//

import XCTest
import SwiftCheck
@testable import Project

class AnalyticsEnginePropertyTests: XCTestCase {
    
    // MARK: - Property 54: Comprehensive metric tracking
    // **Feature: workflow-assistant-app, Property 54: Comprehensive metric tracking**
    // **Validates: Requirements 13.1**
    
    func testComprehensiveMetricTracking() {
        property("For any workflow execution, analytics engine tracks execution time, success rate, and frequency") <- forAll { (seed: Int) in
            let expectation = XCTestExpectation(description: "Track metrics")
            var result = false
            
            Task {
                // Create test workflow
                let workflow = self.createTestWorkflow(seed: seed)
                
                // Create execution
                var execution = WorkflowExecution(workflow: workflow)
                execution.state = .completed
                execution.completedAt = Date()
                
                // Add some step results
                let stepResult = StepResult(
                    stepIndex: 0,
                    success: seed % 2 == 0,
                    output: "Test output",
                    duration: Double(seed % 10 + 1)
                )
                execution.results = [stepResult]
                
                // Track execution
                let engine = AnalyticsEngine()
                await engine.trackWorkflowExecution(execution)
                
                // Generate report to verify tracking
                let now = Date()
                let hourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: now)!
                let period = DateInterval(start: hourAgo, end: now)
                let report = await engine.generateReport(for: period)
                
                // Verify metrics are tracked
                result = report.totalExecutions > 0 &&
                         report.successRate >= 0.0 && report.successRate <= 1.0 &&
                         report.timeSaved >= 0.0
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
            return result
        }.withSize(100)
    }
    
    // MARK: - Property 55: Analytics visualization generation
    // **Feature: workflow-assistant-app, Property 55: Analytics visualization generation**
    // **Validates: Requirements 13.2**
    
    func testAnalyticsVisualizationGeneration() {
        property("For any analytics request, system generates visualizations of performance trends") <- forAll { (seed: Int) in
            let expectation = XCTestExpectation(description: "Generate visualizations")
            var result = false
            
            Task {
                // Create multiple test executions
                let engine = AnalyticsEngine()
                
                for i in 0..<5 {
                    let workflow = self.createTestWorkflow(seed: seed + i)
                    var execution = WorkflowExecution(workflow: workflow)
                    execution.state = .completed
                    execution.completedAt = Date()
                    
                    let stepResult = StepResult(
                        stepIndex: 0,
                        success: true,
                        output: "Output \(i)",
                        duration: Double(i + 1)
                    )
                    execution.results = [stepResult]
                    
                    await engine.trackWorkflowExecution(execution)
                }
                
                // Generate report
                let now = Date()
                let hourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: now)!
                let period = DateInterval(start: hourAgo, end: now)
                let report = await engine.generateReport(for: period)
                
                // Verify visualizations are generated
                result = !report.visualizations.isEmpty &&
                         report.visualizations.allSatisfy { !$0.data.isEmpty }
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
            return result
        }.withSize(100)
    }
    
    // MARK: - Property 56: Bottleneck identification
    // **Feature: workflow-assistant-app, Property 56: Bottleneck identification**
    // **Validates: Requirements 13.3**
    
    func testBottleneckIdentification() {
        property("For any workflow with execution history, analytics engine identifies bottlenecks") <- forAll { (seed: Int) in
            let expectation = XCTestExpectation(description: "Identify bottlenecks")
            var result = false
            
            Task {
                let engine = AnalyticsEngine()
                let workflow = self.createTestWorkflow(seed: seed)
                
                // Create executions with varying step durations
                for i in 0..<10 {
                    var execution = WorkflowExecution(workflow: workflow)
                    execution.state = .completed
                    execution.completedAt = Date()
                    
                    // Create a slow step (bottleneck)
                    let slowStepResult = StepResult(
                        stepIndex: 0,
                        success: true,
                        output: "Slow step",
                        duration: 100.0 // Much slower than average
                    )
                    
                    // Create normal steps
                    let normalStepResult = StepResult(
                        stepIndex: 1,
                        success: true,
                        output: "Normal step",
                        duration: 5.0
                    )
                    
                    execution.results = [slowStepResult, normalStepResult]
                    await engine.trackWorkflowExecution(execution)
                }
                
                // Identify bottlenecks
                let bottlenecks = await engine.identifyBottlenecks()
                
                // Verify bottlenecks are identified
                // Should identify the slow step as a bottleneck
                result = bottlenecks.contains { bottleneck in
                    bottleneck.averageDuration > 50.0 // The slow step
                }
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
            return result
        }.withSize(100)
    }
    
    // MARK: - Property 57: Consolidation suggestion
    // **Feature: workflow-assistant-app, Property 57: Consolidation suggestion**
    // **Validates: Requirements 13.4**
    
    func testConsolidationSuggestion() {
        property("For any set of similar workflows, analytics engine suggests consolidation") <- forAll { (seed: Int) in
            let expectation = XCTestExpectation(description: "Suggest consolidation")
            var result = false
            
            Task {
                let engine = AnalyticsEngine()
                
                // Create two similar workflows
                let workflow1 = self.createTestWorkflow(seed: seed, name: "Workflow A")
                let workflow2 = self.createTestWorkflow(seed: seed + 1, name: "Workflow B")
                
                // Execute both workflows multiple times
                for i in 0..<5 {
                    // Execute workflow 1
                    var execution1 = WorkflowExecution(workflow: workflow1)
                    execution1.state = .completed
                    execution1.completedAt = Date()
                    execution1.results = [
                        StepResult(stepIndex: 0, success: true, output: "Step 1", duration: 10.0),
                        StepResult(stepIndex: 1, success: true, output: "Step 2", duration: 10.0)
                    ]
                    await engine.trackWorkflowExecution(execution1)
                    
                    // Execute workflow 2 (similar pattern)
                    var execution2 = WorkflowExecution(workflow: workflow2)
                    execution2.state = .completed
                    execution2.completedAt = Date()
                    execution2.results = [
                        StepResult(stepIndex: 0, success: true, output: "Step 1", duration: 11.0),
                        StepResult(stepIndex: 1, success: true, output: "Step 2", duration: 11.0)
                    ]
                    await engine.trackWorkflowExecution(execution2)
                }
                
                // Get consolidation suggestions
                let consolidations = await engine.suggestConsolidations()
                
                // Verify consolidation suggestions are made for similar workflows
                result = consolidations.contains { consolidation in
                    consolidation.workflows.contains(workflow1.id) &&
                    consolidation.workflows.contains(workflow2.id) &&
                    consolidation.similarity > 0.5
                }
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
            return result
        }.withSize(100)
    }
    
    // MARK: - Helper Methods
    
    private func createTestWorkflow(seed: Int, name: String? = nil) -> Workflow {
        let workflowName = name ?? "Test Workflow \(seed)"
        
        let command1 = Command(
            script: "echo 'test'",
            description: "Test command",
            requiresPermission: false,
            timeout: 30.0
        )
        
        let command2 = Command(
            script: "echo 'test2'",
            description: "Test command 2",
            requiresPermission: false,
            timeout: 30.0
        )
        
        return Workflow(
            id: UUID(),
            name: workflowName,
            description: "Test workflow for analytics",
            steps: [.command(command1), .command(command2)],
            category: .testing,
            tags: ["test"],
            isBuiltIn: false,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}
