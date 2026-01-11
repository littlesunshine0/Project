//
//  WorkflowKitTests.swift
//  WorkflowKit
//
//  Tests for WorkflowKit package
//

import XCTest
@testable import WorkflowKit

final class WorkflowKitTests: XCTestCase {
    
    // MARK: - Workflow Model Tests
    
    func testWorkflowCreation() {
        let workflow = Workflow(
            name: "Test Workflow",
            description: "A test workflow",
            category: .testing
        )
        
        XCTAssertEqual(workflow.name, "Test Workflow")
        XCTAssertEqual(workflow.description, "A test workflow")
        XCTAssertEqual(workflow.category, .testing)
        XCTAssertTrue(workflow.steps.isEmpty)
        XCTAssertFalse(workflow.isBuiltIn)
    }
    
    func testWorkflowWithSteps() {
        let command = Command(script: "echo 'Hello'", description: "Print hello")
        let step = WorkflowStep.command(command)
        
        let workflow = Workflow(
            name: "Echo Workflow",
            description: "Prints hello",
            steps: [step],
            category: .general
        )
        
        XCTAssertEqual(workflow.steps.count, 1)
        XCTAssertEqual(workflow.steps[0].name, "Print hello")
    }
    
    func testWorkflowKeywords() {
        let workflow = Workflow(
            name: "Build iOS App",
            description: "Builds an iOS application",
            tags: ["xcode", "swift"]
        )
        
        let keywords = workflow.keywords
        XCTAssertTrue(keywords.contains("xcode"))
        XCTAssertTrue(keywords.contains("swift"))
        XCTAssertTrue(keywords.contains("build"))
        XCTAssertTrue(keywords.contains("ios"))
    }
    
    // MARK: - Command Tests
    
    func testCommandCreation() {
        let command = Command(
            script: "swift build",
            description: "Build Swift package",
            requiresPermission: false,
            timeout: 120.0
        )
        
        XCTAssertEqual(command.script, "swift build")
        XCTAssertEqual(command.description, "Build Swift package")
        XCTAssertFalse(command.requiresPermission)
        XCTAssertEqual(command.timeout, 120.0)
    }
    
    func testCommandResult() {
        let result = CommandResult(
            exitCode: 0,
            output: "Build succeeded",
            error: ""
        )
        
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.output, "Build succeeded")
    }
    
    func testCommandResultFailure() {
        let result = CommandResult(
            exitCode: 1,
            output: "",
            error: "Build failed"
        )
        
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.error, "Build failed")
    }
    
    // MARK: - Workflow Step Tests
    
    func testCommandStep() {
        let command = Command(script: "ls -la", description: "List files")
        let step = WorkflowStep.command(command)
        
        XCTAssertEqual(step.name, "List files")
        XCTAssertEqual(step.command, "ls -la")
        XCTAssertFalse(step.requiresInput)
    }
    
    func testPromptStep() {
        let prompt = Prompt(message: "Enter your name", inputType: .text)
        let step = WorkflowStep.prompt(prompt)
        
        XCTAssertEqual(step.name, "Enter your name")
        XCTAssertTrue(step.requiresInput)
    }
    
    func testParallelStep() {
        let cmd1 = WorkflowStep.command(Command(script: "task1", description: "Task 1"))
        let cmd2 = WorkflowStep.command(Command(script: "task2", description: "Task 2"))
        let step = WorkflowStep.parallel([cmd1, cmd2])
        
        XCTAssertEqual(step.name, "Parallel execution (2 steps)")
    }
    
    // MARK: - Workflow Execution Tests
    
    func testWorkflowExecutionCreation() {
        let workflow = Workflow(name: "Test", description: "Test workflow")
        let execution = WorkflowExecution(workflow: workflow)
        
        XCTAssertEqual(execution.state, .running)
        XCTAssertEqual(execution.currentStepIndex, 0)
        XCTAssertTrue(execution.results.isEmpty)
        XCTAssertNil(execution.completedAt)
    }
    
    func testExecutionContext() {
        var context = ExecutionContext()
        
        context.setVariable("name", value: "test")
        XCTAssertEqual(context.getVariable("name"), "test")
        
        let results = [StepResult(stepIndex: 0, success: true, output: "OK", duration: 1.0)]
        context.storeBranchResults("branch1", results: results)
        XCTAssertEqual(context.getBranchResults("branch1")?.count, 1)
    }
    
    // MARK: - Workflow State Tests
    
    func testWorkflowState() {
        let workflow = Workflow(
            name: "Test",
            description: "Test",
            steps: [
                .command(Command(script: "step1", description: "Step 1")),
                .command(Command(script: "step2", description: "Step 2")),
                .command(Command(script: "step3", description: "Step 3"))
            ]
        )
        
        var execution = WorkflowExecution(workflow: workflow)
        execution.currentStepIndex = 1
        
        let state = WorkflowState(execution: execution)
        let summary = state.summary
        
        XCTAssertEqual(summary.totalSteps, 3)
        XCTAssertEqual(summary.completedSteps, 1)
        XCTAssertEqual(summary.remainingSteps, 2)
        XCTAssertFalse(state.isStale)
    }
    
    // MARK: - Workflow Extractor Tests
    
    func testWorkflowExtraction() async {
        let extractor = WorkflowExtractor()
        
        let section = DocumentSection(
            title: "How to Build",
            content: """
            Follow these steps:
            1. Clone the repository
            2. Run `swift build`
            3. Run `swift test`
            """,
            tags: ["build", "swift"]
        )
        
        let document = StructuredDocument(
            title: "Build Guide",
            sections: [section]
        )
        
        let workflows = await extractor.extract(from: document)
        
        XCTAssertEqual(workflows.count, 1)
        XCTAssertEqual(workflows[0].name, "How to Build")
        XCTAssertEqual(workflows[0].steps.count, 3)
    }
    
    func testCodeExampleExtraction() async {
        let extractor = WorkflowExtractor()
        
        let codeExample = CodeExample(
            language: "bash",
            code: """
            git clone repo
            cd repo
            swift build
            """,
            description: "Build script"
        )
        
        let document = StructuredDocument(
            title: "Scripts",
            sections: [],
            codeExamples: [codeExample]
        )
        
        let workflows = await extractor.extract(from: document)
        
        XCTAssertEqual(workflows.count, 1)
        XCTAssertEqual(workflows[0].steps.count, 3)
        XCTAssertEqual(workflows[0].category, .automation)
    }
    
    // MARK: - Workflow Category Tests
    
    func testAllCategories() {
        let categories = WorkflowCategory.allCases
        XCTAssertTrue(categories.count > 20)
        XCTAssertTrue(categories.contains(.development))
        XCTAssertTrue(categories.contains(.testing))
        XCTAssertTrue(categories.contains(.deployment))
    }
    
    // MARK: - Codable Tests
    
    func testWorkflowCodable() throws {
        let workflow = Workflow(
            name: "Test",
            description: "Test workflow",
            steps: [
                .command(Command(script: "echo test", description: "Echo")),
                .prompt(Prompt(message: "Enter value"))
            ],
            category: .testing,
            tags: ["test"]
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(workflow)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Workflow.self, from: data)
        
        XCTAssertEqual(decoded.name, workflow.name)
        XCTAssertEqual(decoded.steps.count, workflow.steps.count)
        XCTAssertEqual(decoded.category, workflow.category)
    }
    
    func testConditionalStepCodable() throws {
        let condition = Condition(expression: "true", variables: ["key": "value"])
        let trueBranch = WorkflowStep.command(Command(script: "true", description: "True"))
        let falseBranch = WorkflowStep.command(Command(script: "false", description: "False"))
        let step = WorkflowStep.conditional(condition, trueBranch: trueBranch, falseBranch: falseBranch)
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(step)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(WorkflowStep.self, from: data)
        
        if case .conditional(let decodedCondition, _, _) = decoded {
            XCTAssertEqual(decodedCondition.expression, "true")
        } else {
            XCTFail("Expected conditional step")
        }
    }
}
