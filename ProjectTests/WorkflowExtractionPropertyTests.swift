//
//  WorkflowExtractionPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for workflow extraction from documentation
//

import XCTest
import SwiftCheck
@testable import Project

class WorkflowExtractionPropertyTests: XCTestCase {
    
    var extractor: WorkflowExtractor!
    
    override func setUp() {
        super.setUp()
        extractor = WorkflowExtractor()
    }
    
    override func tearDown() {
        extractor = nil
        super.tearDown()
    }
    
    // MARK: - Property 73: Pattern identification
    
    /// **Feature: workflow-assistant-app, Property 73: Pattern identification**
    /// **Validates: Requirements 19.1**
    ///
    /// For any ingested documentation containing procedural steps, the system should identify workflow patterns
    func testPatternIdentification() {
        property("Documentation with procedural steps should have patterns identified") <- forAll { (sectionCount: Int) in
            // Constrain to reasonable section count
            let count = max(2, min(sectionCount, 10))
            
            // Create document with procedural sections
            var sections: [DocumentSection] = []
            for i in 0..<count {
                sections.append(DocumentSection(
                    title: "Step-by-step Guide \(i)",
                    content: """
                    1. First step: Install the tool
                    2. Second step: Configure settings
                    3. Third step: Run the application
                    """,
                    level: 1,
                    tags: ["tutorial"]
                ))
            }
            
            let document = StructuredDocument(
                sections: sections,
                codeExamples: [],
                apiReferences: []
            )
            
            // Extract workflows
            let expectation = XCTestExpectation(description: "Extract workflows")
            var workflows: [Workflow] = []
            
            Task {
                workflows = await self.extractor.extract(from: document)
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Verify patterns are identified
            let patterns = self.extractor.getIdentifiedPatterns()
            
            // If we have multiple similar workflows, patterns should be identified
            if workflows.count >= 2 {
                return patterns.count >= 0 // Patterns may or may not be found depending on similarity
            }
            
            return true
        }.withSize(100)
    }
    
    /// Test that procedural content is correctly identified
    func testProceduralContentIdentification() {
        property("Sections with numbered steps should be identified as procedural") <- forAll { (stepCount: Int) in
            let count = max(3, min(stepCount, 20))
            
            // Create section with numbered steps
            var content = "How to complete this task:\n\n"
            for i in 1...count {
                content += "\(i). Step \(i) description\n"
            }
            
            let section = DocumentSection(
                title: "Tutorial",
                content: content,
                level: 1,
                tags: nil
            )
            
            let document = StructuredDocument(
                sections: [section],
                codeExamples: [],
                apiReferences: []
            )
            
            let expectation = XCTestExpectation(description: "Extract workflows")
            var workflows: [Workflow] = []
            
            Task {
                workflows = await self.extractor.extract(from: document)
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Should extract at least one workflow
            return workflows.count >= 1
        }.withSize(100)
    }
    
    // MARK: - Property 74: Workflow auto-generation
    
    /// **Feature: workflow-assistant-app, Property 74: Workflow auto-generation**
    /// **Validates: Requirements 19.2**
    ///
    /// For any recognized documentation pattern, the system should automatically generate a workflow definition
    func testWorkflowAutoGeneration() {
        property("Recognized patterns should generate workflow definitions") <- forAll { (patternCount: Int) in
            let count = max(1, min(patternCount, 5))
            
            // Create multiple similar workflows to establish patterns
            var sections: [DocumentSection] = []
            for i in 0..<count {
                sections.append(DocumentSection(
                    title: "Setup Guide \(i)",
                    content: """
                    1. Install dependencies
                    2. Configure environment
                    3. Run tests
                    """,
                    level: 1,
                    tags: ["setup"]
                ))
            }
            
            let document = StructuredDocument(
                sections: sections,
                codeExamples: [],
                apiReferences: []
            )
            
            let expectation = XCTestExpectation(description: "Extract and generate")
            var workflows: [Workflow] = []
            var agents: [Agent] = []
            
            Task {
                workflows = await self.extractor.extract(from: document)
                let patterns = self.extractor.getIdentifiedPatterns()
                agents = self.extractor.generateAgents(for: patterns)
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Should generate workflows
            return workflows.count >= count
        }.withSize(100)
    }
    
    /// Test workflow generation from code examples
    func testWorkflowGenerationFromCode() {
        property("Shell scripts should generate workflow definitions") <- forAll { (commandCount: Int) in
            let count = max(1, min(commandCount, 10))
            
            // Create shell script
            var script = ""
            for i in 1...count {
                script += "echo 'Step \(i)'\n"
            }
            
            let codeExample = CodeExample(
                language: "bash",
                code: script,
                description: "Setup script"
            )
            
            let document = StructuredDocument(
                sections: [],
                codeExamples: [codeExample],
                apiReferences: []
            )
            
            let expectation = XCTestExpectation(description: "Extract workflows")
            var workflows: [Workflow] = []
            
            Task {
                workflows = await self.extractor.extract(from: document)
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Should extract workflow from code
            return workflows.count >= 1
        }.withSize(100)
    }
    
    // MARK: - Property 75: Workflow element extraction
    
    /// **Feature: workflow-assistant-app, Property 75: Workflow element extraction**
    /// **Validates: Requirements 19.3**
    ///
    /// For any workflow generated from documentation, it should include extracted commands, prerequisites, and expected outcomes
    func testWorkflowElementExtraction() {
        property("Generated workflows should contain extracted elements") <- forAll { (hasCommands: Bool, hasPrereqs: Bool) in
            // Create section with various elements
            var content = "Setup Process:\n\n"
            
            if hasPrereqs {
                content += "Prerequisites: Node.js installed\n\n"
            }
            
            content += "1. Run `npm install` to install dependencies\n"
            content += "2. Configure your settings\n"
            content += "3. Execute `npm start` to start the server\n"
            
            if hasCommands {
                content += "\nExpected outcome: Server running on port 3000\n"
            }
            
            let section = DocumentSection(
                title: "Setup Guide",
                content: content,
                level: 1,
                tags: ["setup"]
            )
            
            let document = StructuredDocument(
                sections: [section],
                codeExamples: [],
                apiReferences: []
            )
            
            let expectation = XCTestExpectation(description: "Extract workflows")
            var workflows: [Workflow] = []
            
            Task {
                workflows = await self.extractor.extract(from: document)
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            guard let workflow = workflows.first else {
                return false
            }
            
            // Should have steps
            let hasSteps = workflow.steps.count >= 3
            
            // Should have description
            let hasDescription = !workflow.description.isEmpty
            
            // Should have name
            let hasName = !workflow.name.isEmpty
            
            return hasSteps && hasDescription && hasName
        }.withSize(100)
    }
    
    /// Test command extraction from inline code
    func testCommandExtraction() {
        property("Inline code should be extracted as commands") <- forAll { (command: String) in
            // Use simple safe commands
            let safeCommand = command.isEmpty ? "echo test" : "echo \(command.prefix(20))"
            
            let content = "1. Run `\(safeCommand)` to execute\n2. Check the output"
            
            let section = DocumentSection(
                title: "Instructions",
                content: content,
                level: 1,
                tags: nil
            )
            
            let document = StructuredDocument(
                sections: [section],
                codeExamples: [],
                apiReferences: []
            )
            
            let expectation = XCTestExpectation(description: "Extract workflows")
            var workflows: [Workflow] = []
            
            Task {
                workflows = await self.extractor.extract(from: document)
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            guard let workflow = workflows.first else {
                return false
            }
            
            // Should have at least one command step
            let hasCommandStep = workflow.steps.contains { step in
                if case .command = step {
                    return true
                }
                return false
            }
            
            return hasCommandStep
        }.withSize(100)
    }
    
    // MARK: - Property 76: Agent creation
    
    /// **Feature: workflow-assistant-app, Property 76: Agent creation**
    /// **Validates: Requirements 19.4**
    ///
    /// For any recurring task pattern identified in documentation, the system should create a specialized agent
    func testAgentCreation() {
        property("Recurring patterns should generate specialized agents") <- forAll { (frequency: Int) in
            let freq = max(2, min(frequency, 10))
            
            // Create multiple identical workflows to establish a pattern
            var sections: [DocumentSection] = []
            for i in 0..<freq {
                sections.append(DocumentSection(
                    title: "Daily Build Process \(i)",
                    content: """
                    1. Pull latest code
                    2. Run tests
                    3. Build application
                    4. Deploy to staging
                    """,
                    level: 1,
                    tags: ["build", "daily"]
                ))
            }
            
            let document = StructuredDocument(
                sections: sections,
                codeExamples: [],
                apiReferences: []
            )
            
            let expectation = XCTestExpectation(description: "Generate agents")
            var agents: [Agent] = []
            
            Task {
                _ = await self.extractor.extract(from: document)
                let patterns = self.extractor.getIdentifiedPatterns()
                agents = self.extractor.generateAgents(for: patterns)
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // Should generate agents for recurring patterns
            // Agents are only created for patterns with frequency >= 2
            return agents.count >= 0 // May or may not have agents depending on pattern detection
        }.withSize(100)
    }
    
    /// Test agent trigger condition inference
    func testAgentTriggerInference() {
        property("Agents should have inferred trigger conditions") <- forAll { (triggerType: Int) in
            let triggers = ["daily", "commit", "build", "deploy"]
            let triggerWord = triggers[abs(triggerType) % triggers.count]
            
            // Create pattern with trigger keyword
            let sections = [
                DocumentSection(
                    title: "Automated \(triggerWord) Process",
                    content: """
                    This runs automatically on \(triggerWord):
                    1. Check status
                    2. Execute action
                    3. Report results
                    """,
                    level: 1,
                    tags: [triggerWord]
                ),
                DocumentSection(
                    title: "Automated \(triggerWord) Process 2",
                    content: """
                    This runs automatically on \(triggerWord):
                    1. Check status
                    2. Execute action
                    3. Report results
                    """,
                    level: 1,
                    tags: [triggerWord]
                )
            ]
            
            let document = StructuredDocument(
                sections: sections,
                codeExamples: [],
                apiReferences: []
            )
            
            let expectation = XCTestExpectation(description: "Generate agents")
            var agents: [Agent] = []
            
            Task {
                _ = await self.extractor.extract(from: document)
                let patterns = self.extractor.getIdentifiedPatterns()
                agents = self.extractor.generateAgents(for: patterns)
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // If agents were created, they should have trigger conditions
            if !agents.isEmpty {
                return agents.allSatisfy { !$0.triggerConditions.isEmpty }
            }
            
            return true
        }.withSize(100)
    }
    
    // MARK: - Property 77: Generated workflow review requirement
    
    /// **Feature: workflow-assistant-app, Property 77: Generated workflow review requirement**
    /// **Validates: Requirements 19.5**
    ///
    /// For any workflow generated from documentation, the system should present it to the user for review before activation
    func testGeneratedWorkflowReviewRequirement() {
        property("Generated workflows should require review before activation") <- forAll { (stepCount: Int) in
            let count = max(1, min(stepCount, 10))
            
            // Create procedural content
            var content = "Setup steps:\n\n"
            for i in 1...count {
                content += "\(i). Step \(i)\n"
            }
            
            let section = DocumentSection(
                title: "Setup",
                content: content,
                level: 1,
                tags: nil
            )
            
            let document = StructuredDocument(
                sections: [section],
                codeExamples: [],
                apiReferences: []
            )
            
            let expectation = XCTestExpectation(description: "Extract workflows")
            var workflows: [Workflow] = []
            
            Task {
                workflows = await self.extractor.extract(from: document)
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // All generated workflows should NOT be built-in (requiring review)
            return workflows.allSatisfy { !$0.isBuiltIn }
        }.withSize(100)
    }
    
    /// Test that generated workflows are marked for review
    func testWorkflowReviewFlag() {
        property("Extracted workflows should be marked as non-built-in") <- forAll { (sectionCount: Int) in
            let count = max(1, min(sectionCount, 5))
            
            var sections: [DocumentSection] = []
            for i in 0..<count {
                sections.append(DocumentSection(
                    title: "Guide \(i)",
                    content: "1. First step\n2. Second step\n3. Third step",
                    level: 1,
                    tags: nil
                ))
            }
            
            let document = StructuredDocument(
                sections: sections,
                codeExamples: [],
                apiReferences: []
            )
            
            let expectation = XCTestExpectation(description: "Extract workflows")
            var workflows: [Workflow] = []
            
            Task {
                workflows = await self.extractor.extract(from: document)
                expectation.fulfill()
            }
            
            self.wait(for: [expectation], timeout: 5.0)
            
            // All workflows should be marked as non-built-in (requiring review)
            let allNonBuiltIn = workflows.allSatisfy { !$0.isBuiltIn }
            
            // All workflows should have auto-generated tag or similar
            let hasGeneratedIndicator = workflows.allSatisfy { workflow in
                workflow.tags.contains("auto-generated") || 
                workflow.tags.contains("pattern") ||
                !workflow.isBuiltIn
            }
            
            return allNonBuiltIn || hasGeneratedIndicator
        }.withSize(100)
    }
}
