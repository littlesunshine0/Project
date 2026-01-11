//
//  TestStrategyGenerator.swift
//  IdeaKit - Project Operating System
//
//  Tool: TestStrategyGenerator
//  Phase: Quality
//  Purpose: Define testing approach early - unit vs integration vs e2e
//  Outputs: test_strategy.md
//

import Foundation

/// Generates testing strategy recommendations
public final class TestStrategyGenerator: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "test_strategy_generator"
    public static let name = "Test Strategy Generator"
    public static let description = "Define testing approach with coverage targets and tooling suggestions"
    public static let phase = ProjectPhase.quality
    public static let outputs = ["test_strategy.md"]
    public static let inputs = ["architecture.md", "requirements.md"]
    public static let isDefault = false
    
    // MARK: - Singleton
    
    public static let shared = TestStrategyGenerator()
    private init() {}
    
    // MARK: - Generation
    
    /// Generate test strategy
    public func generate(for architecture: ArchitectureRecommendation) -> TestStrategy {
        TestStrategy(
            unitTestCoverage: 80,
            integrationTestCoverage: 60,
            e2eTestCoverage: 40,
            testPyramid: generateTestPyramid(for: architecture),
            tooling: recommendTooling(),
            priorities: generatePriorities(for: architecture)
        )
    }
    
    /// Generate test strategy markdown
    public func generateMarkdown(from strategy: TestStrategy) -> String {
        """
        # Test Strategy
        
        ## Coverage Targets
        
        | Test Type | Target Coverage | Priority |
        |-----------|-----------------|----------|
        | Unit Tests | \(strategy.unitTestCoverage)% | High |
        | Integration Tests | \(strategy.integrationTestCoverage)% | Medium |
        | E2E Tests | \(strategy.e2eTestCoverage)% | Low |
        
        ## Test Pyramid
        
        ```
                    /\\
                   /  \\
                  / E2E\\     <- Few, slow, expensive
                 /______\\
                /        \\
               /Integration\\  <- Some, medium speed
              /______________\\
             /                \\
            /    Unit Tests    \\  <- Many, fast, cheap
           /____________________\\
        ```
        
        ### Distribution
        
        \(strategy.testPyramid.map { "- **\($0.type.rawValue.capitalized)**: \($0.percentage)% (\($0.description))" }.joined(separator: "\n"))
        
        ## Testing Priorities
        
        \(strategy.priorities.enumerated().map { "\\($0.offset + 1). \($0.element)" }.joined(separator: "\n"))
        
        ## Recommended Tooling
        
        | Purpose | Tool | Notes |
        |---------|------|-------|
        \(strategy.tooling.map { "| \($0.purpose) | \($0.tool) | \($0.notes) |" }.joined(separator: "\n"))
        
        ## Test Categories
        
        ### Unit Tests
        
        - Test individual functions and methods
        - Mock external dependencies
        - Fast execution (< 1 second per test)
        - Run on every commit
        
        ### Integration Tests
        
        - Test component interactions
        - Use real dependencies where practical
        - Medium execution time
        - Run on PR/merge
        
        ### E2E Tests
        
        - Test complete user workflows
        - Use production-like environment
        - Slower execution
        - Run before release
        
        ## Best Practices
        
        1. Write tests before or alongside code (TDD/BDD)
        2. Keep tests independent and isolated
        3. Use descriptive test names
        4. Follow Arrange-Act-Assert pattern
        5. Don't test implementation details
        6. Maintain test code quality
        
        ## CI/CD Integration
        
        ```yaml
        # Example CI pipeline
        test:
          - run: swift test --parallel
          - coverage: --minimum-coverage \(strategy.unitTestCoverage)
          - report: generate coverage report
        ```
        """
    }
    
    // MARK: - Private Methods
    
    private func generateTestPyramid(for architecture: ArchitectureRecommendation) -> [TestLayer] {
        [
            TestLayer(type: .unit, percentage: 70, description: "Models, ViewModels, Services"),
            TestLayer(type: .integration, percentage: 20, description: "Service interactions, Data flow"),
            TestLayer(type: .e2e, percentage: 10, description: "Critical user journeys")
        ]
    }
    
    private func recommendTooling() -> [TestTool] {
        [
            TestTool(purpose: "Unit Testing", tool: "XCTest", notes: "Built-in, fast"),
            TestTool(purpose: "Mocking", tool: "Swift Macros / Protocols", notes: "Type-safe mocking"),
            TestTool(purpose: "UI Testing", tool: "XCUITest", notes: "Native UI automation"),
            TestTool(purpose: "Snapshot Testing", tool: "swift-snapshot-testing", notes: "Visual regression"),
            TestTool(purpose: "Coverage", tool: "Xcode Coverage", notes: "Built-in coverage reports")
        ]
    }
    
    private func generatePriorities(for architecture: ArchitectureRecommendation) -> [String] {
        [
            "Core business logic (Models, Services)",
            "Data persistence and retrieval",
            "Critical user workflows",
            "Error handling paths",
            "Edge cases and boundary conditions"
        ]
    }
}

// MARK: - Supporting Types

public struct TestStrategy: Sendable {
    public let unitTestCoverage: Int
    public let integrationTestCoverage: Int
    public let e2eTestCoverage: Int
    public let testPyramid: [TestLayer]
    public let tooling: [TestTool]
    public let priorities: [String]
}

public struct TestLayer: Sendable {
    public let type: TestType
    public let percentage: Int
    public let description: String
}

public enum TestType: String, Sendable {
    case unit, integration, e2e
}

public struct TestTool: Sendable {
    public let purpose: String
    public let tool: String
    public let notes: String
}
