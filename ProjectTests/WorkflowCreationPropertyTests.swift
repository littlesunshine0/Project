//
//  WorkflowCreationPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for workflow creation and customization
//

import XCTest
import SwiftCheck
@testable import Project

class WorkflowCreationPropertyTests: XCTestCase {
    
    // MARK: - Property 40: Workflow element specification
    // **Feature: workflow-assistant-app, Property 40: Workflow element specification**
    // For any workflow being created, the system should allow specification of commands, prompts, and decision points
    // **Validates: Requirements 10.2**
    
    func testProperty40_WorkflowElementSpecification() async {
        // Run 100 iterations as specified in the design document
        for iteration in 0..<100 {
            let testCases = [
                ("Workflow A", "Description A", WorkflowCategory.general),
                ("Workflow B", "Description B", WorkflowCategory.development),
                ("Workflow C", "Description C", WorkflowCategory.testing),
                ("Workflow D", "Description D", WorkflowCategory.automation),
                ("Workflow E", "Description E", WorkflowCategory.deployment)
            ]
            
            let testCase = testCases[iteration % testCases.count]
            let (name, description, category) = testCase
            
            let editorService = WorkflowEditorService()
            
            // Create a workflow
            let workflow = await editorService.createWorkflow(
                name: "\(name) \(iteration)",
                description: description,
                category: category
            )
            
            // Test 1: Add a command step
            let commandStep = WorkflowStep.command(Command(
                script: "echo 'test command'",
                description: "Test command step",
                requiresPermission: false,
                timeout: 30.0
            ))
            
            guard let withCommand = try? await editorService.addStep(to: workflow.id, step: commandStep) else {
                XCTFail("Failed to add command step (iteration \(iteration))")
                continue
            }
            
            XCTAssertEqual(withCommand.steps.count, 1, "Should have 1 step after adding command (iteration \(iteration))")
            
            // Test 2: Add a prompt step
            let promptStep = WorkflowStep.prompt(Prompt(
                message: "Enter a value",
                inputType: .text,
                defaultValue: nil
            ))
            
            guard let withPrompt = try? await editorService.addStep(to: workflow.id, step: promptStep) else {
                XCTFail("Failed to add prompt step (iteration \(iteration))")
                continue
            }
            
            XCTAssertEqual(withPrompt.steps.count, 2, "Should have 2 steps after adding prompt (iteration \(iteration))")
            
            // Test 3: Add a conditional (decision point) step
            let condition = Condition(expression: "x > 0")
            let trueCommand = Command(script: "echo 'true branch'", description: "True branch")
            let falseCommand = Command(script: "echo 'false branch'", description: "False branch")
            let conditionalStep = WorkflowStep.conditional(
                condition,
                trueBranch: .command(trueCommand),
                falseBranch: .command(falseCommand)
            )
            
            guard let withConditional = try? await editorService.addStep(to: workflow.id, step: conditionalStep) else {
                XCTFail("Failed to add conditional step (iteration \(iteration))")
                continue
            }
            
            XCTAssertEqual(withConditional.steps.count, 3, "Should have 3 steps after adding conditional (iteration \(iteration))")
            
            // Verify all steps were added correctly
            guard let final = try? await editorService.loadWorkflow(workflow.id) else {
                XCTFail("Failed to load workflow (iteration \(iteration))")
                continue
            }
            
            // Property: All three types of workflow elements should be specifiable
            XCTAssertEqual(final.steps.count, 3, "Workflow should have all 3 step types (iteration \(iteration))")
        }
    }
    
    // MARK: - Property 41: Workflow validation
    // **Feature: workflow-assistant-app, Property 41: Workflow validation**
    // For any created custom workflow, the system should validate it for syntax and security issues before activation
    // **Validates: Requirements 10.3**
    
    func testProperty41_WorkflowValidation() async {
        // Run 100 iterations as specified in the design document
        for iteration in 0..<100 {
            let editorService = WorkflowEditorService()
            
            // Test Case 1: Dangerous commands should be detected
            let dangerousCommands = [
                "rm -rf /",
                "sudo rm -rf /tmp",
                "mkfs.ext4 /dev/sda",
                "dd if=/dev/zero of=/dev/sda",
                "> /dev/sda",
                ":(){ :|:& };:",  // Fork bomb
                "chmod -R 777 /",
                "chown -R root:root /"
            ]
            
            let dangerousCommand = dangerousCommands[iteration % dangerousCommands.count]
            let workflow1 = await editorService.createWorkflow(
                name: "Dangerous Workflow \(iteration)",
                description: "Test dangerous command detection",
                category: .general
            )
            
            let dangerousStep = WorkflowStep.command(Command(
                script: dangerousCommand,
                description: "Dangerous command",
                requiresPermission: false,
                timeout: 30.0
            ))
            
            _ = try? await editorService.addStep(to: workflow1.id, step: dangerousStep)
            
            let result1 = try? await editorService.validateWorkflow(workflow1.id)
            XCTAssertNotNil(result1, "Should return validation result for dangerous command (iteration \(iteration))")
            if let result = result1 {
                XCTAssertFalse(result.isValid, "Dangerous command '\(dangerousCommand)' should fail validation (iteration \(iteration))")
                XCTAssertFalse(result.errors.isEmpty, "Should have validation errors for dangerous command (iteration \(iteration))")
            }
            
            // Test Case 2: Empty or whitespace-only names should be rejected
            let invalidNames = ["", "   ", "\t", "\n", "  \t\n  "]
            let invalidName = invalidNames[iteration % invalidNames.count]
            
            let workflow2 = await editorService.createWorkflow(
                name: invalidName,
                description: "Test empty name validation",
                category: .general
            )
            
            let validStep = WorkflowStep.command(Command(
                script: "echo 'test'",
                description: "Valid command",
                requiresPermission: false,
                timeout: 30.0
            ))
            
            _ = try? await editorService.addStep(to: workflow2.id, step: validStep)
            
            let result2 = try? await editorService.validateWorkflow(workflow2.id)
            XCTAssertNotNil(result2, "Should return validation result for empty name (iteration \(iteration))")
            if let result = result2 {
                XCTAssertFalse(result.isValid, "Empty/whitespace name should fail validation (iteration \(iteration))")
                XCTAssertTrue(result.errors.contains { error in
                    if case .emptyName = error { return true }
                    return false
                }, "Should have emptyName error (iteration \(iteration))")
            }
            
            // Test Case 3: Workflows with no steps should be rejected
            let workflow3 = await editorService.createWorkflow(
                name: "No Steps Workflow \(iteration)",
                description: "Test no steps validation",
                category: .general
            )
            
            let result3 = try? await editorService.validateWorkflow(workflow3.id)
            XCTAssertNotNil(result3, "Should return validation result for no steps (iteration \(iteration))")
            if let result = result3 {
                XCTAssertFalse(result.isValid, "Workflow with no steps should fail validation (iteration \(iteration))")
                XCTAssertTrue(result.errors.contains { error in
                    if case .noSteps = error { return true }
                    return false
                }, "Should have noSteps error (iteration \(iteration))")
            }
            
            // Test Case 4: Empty command scripts should be rejected
            let workflow4 = await editorService.createWorkflow(
                name: "Empty Command Workflow \(iteration)",
                description: "Test empty command validation",
                category: .general
            )
            
            let emptyCommandStep = WorkflowStep.command(Command(
                script: "   ",
                description: "Empty command",
                requiresPermission: false,
                timeout: 30.0
            ))
            
            _ = try? await editorService.addStep(to: workflow4.id, step: emptyCommandStep)
            
            let result4 = try? await editorService.validateWorkflow(workflow4.id)
            XCTAssertNotNil(result4, "Should return validation result for empty command (iteration \(iteration))")
            if let result = result4 {
                XCTAssertFalse(result.isValid, "Empty command script should fail validation (iteration \(iteration))")
            }
            
            // Test Case 5: Empty prompt messages should be rejected
            let workflow5 = await editorService.createWorkflow(
                name: "Empty Prompt Workflow \(iteration)",
                description: "Test empty prompt validation",
                category: .general
            )
            
            let emptyPromptStep = WorkflowStep.prompt(Prompt(
                message: "",
                inputType: .text,
                defaultValue: nil
            ))
            
            _ = try? await editorService.addStep(to: workflow5.id, step: emptyPromptStep)
            
            let result5 = try? await editorService.validateWorkflow(workflow5.id)
            XCTAssertNotNil(result5, "Should return validation result for empty prompt (iteration \(iteration))")
            if let result = result5 {
                XCTAssertFalse(result.isValid, "Empty prompt message should fail validation (iteration \(iteration))")
            }
            
            // Test Case 6: Empty conditional expressions should be rejected
            let workflow6 = await editorService.createWorkflow(
                name: "Empty Condition Workflow \(iteration)",
                description: "Test empty condition validation",
                category: .general
            )
            
            let emptyConditionStep = WorkflowStep.conditional(
                Condition(expression: ""),
                trueBranch: .command(Command(script: "echo 'true'", description: "True")),
                falseBranch: .command(Command(script: "echo 'false'", description: "False"))
            )
            
            _ = try? await editorService.addStep(to: workflow6.id, step: emptyConditionStep)
            
            let result6 = try? await editorService.validateWorkflow(workflow6.id)
            XCTAssertNotNil(result6, "Should return validation result for empty condition (iteration \(iteration))")
            if let result = result6 {
                XCTAssertFalse(result.isValid, "Empty conditional expression should fail validation (iteration \(iteration))")
            }
            
            // Test Case 7: Empty parallel steps should be rejected
            let workflow7 = await editorService.createWorkflow(
                name: "Empty Parallel Workflow \(iteration)",
                description: "Test empty parallel validation",
                category: .general
            )
            
            let emptyParallelStep = WorkflowStep.parallel([])
            
            _ = try? await editorService.addStep(to: workflow7.id, step: emptyParallelStep)
            
            let result7 = try? await editorService.validateWorkflow(workflow7.id)
            XCTAssertNotNil(result7, "Should return validation result for empty parallel (iteration \(iteration))")
            if let result = result7 {
                XCTAssertFalse(result.isValid, "Empty parallel steps should fail validation (iteration \(iteration))")
            }
            
            // Test Case 8: Valid workflows should pass validation
            let workflow8 = await editorService.createWorkflow(
                name: "Valid Workflow \(iteration)",
                description: "Test valid workflow",
                category: .general
            )
            
            let safeCommands = [
                "echo 'Hello World'",
                "ls -la",
                "pwd",
                "date",
                "whoami",
                "uname -a",
                "df -h",
                "ps aux"
            ]
            
            let safeCommand = safeCommands[iteration % safeCommands.count]
            let safeStep = WorkflowStep.command(Command(
                script: safeCommand,
                description: "Safe command",
                requiresPermission: false,
                timeout: 30.0
            ))
            
            _ = try? await editorService.addStep(to: workflow8.id, step: safeStep)
            
            let result8 = try? await editorService.validateWorkflow(workflow8.id)
            XCTAssertNotNil(result8, "Should return validation result for valid workflow (iteration \(iteration))")
            if let result = result8 {
                XCTAssertTrue(result.isValid, "Valid workflow should pass validation (iteration \(iteration))")
                XCTAssertTrue(result.errors.isEmpty, "Valid workflow should have no errors (iteration \(iteration))")
            }
            
            // Test Case 9: Nested validation - conditional branches with errors
            let workflow9 = await editorService.createWorkflow(
                name: "Nested Validation Workflow \(iteration)",
                description: "Test nested validation",
                category: .general
            )
            
            let nestedConditionStep = WorkflowStep.conditional(
                Condition(expression: "x > 0"),
                trueBranch: .command(Command(script: "rm -rf /", description: "Dangerous")),
                falseBranch: .command(Command(script: "echo 'safe'", description: "Safe"))
            )
            
            _ = try? await editorService.addStep(to: workflow9.id, step: nestedConditionStep)
            
            let result9 = try? await editorService.validateWorkflow(workflow9.id)
            XCTAssertNotNil(result9, "Should return validation result for nested validation (iteration \(iteration))")
            if let result = result9 {
                XCTAssertFalse(result.isValid, "Conditional with dangerous branch should fail validation (iteration \(iteration))")
            }
            
            // Test Case 10: Parallel steps with errors
            let workflow10 = await editorService.createWorkflow(
                name: "Parallel Validation Workflow \(iteration)",
                description: "Test parallel validation",
                category: .general
            )
            
            let parallelWithErrorStep = WorkflowStep.parallel([
                .command(Command(script: "echo 'safe'", description: "Safe")),
                .command(Command(script: "rm -rf /", description: "Dangerous"))
            ])
            
            _ = try? await editorService.addStep(to: workflow10.id, step: parallelWithErrorStep)
            
            let result10 = try? await editorService.validateWorkflow(workflow10.id)
            XCTAssertNotNil(result10, "Should return validation result for parallel validation (iteration \(iteration))")
            if let result = result10 {
                XCTAssertFalse(result.isValid, "Parallel with dangerous step should fail validation (iteration \(iteration))")
            }
        }
    }
    
    // MARK: - Property 42: Safe workflow testing
    // **Feature: workflow-assistant-app, Property 42: Safe workflow testing**
    // For any custom workflow, the system should allow testing in a safe environment before activation
    // **Validates: Requirements 10.4**
    
    func testSafeWorkflowTesting() async {
        // Run 100 iterations as specified in the design document
        for iteration in 0..<100 {
            let name = "Test Workflow \(iteration)"
            let desc = "Test Description \(iteration)"
            
            let editorService = WorkflowEditorService()
            
            // Create a workflow
            let workflow = await editorService.createWorkflow(
                name: name,
                description: desc,
                category: .general
            )
            
            // Add a command that would be dangerous if executed for real
            let step = WorkflowStep.command(Command(
                script: "echo 'This would delete files'",
                description: "Test command",
                requiresPermission: false,
                timeout: 30.0
            ))
            
            _ = try? await editorService.addStep(to: workflow.id, step: step)
            
            // Test the workflow (should not actually execute)
            let testResult = try? await editorService.testWorkflow(workflow.id)
            
            // Should return a test result without actually executing
            XCTAssertNotNil(testResult, "Should return test result (iteration \(iteration))")
            if let result = testResult {
                XCTAssertEqual(result.stepResults.count, 1, "Should have 1 step result (iteration \(iteration))")
            }
        }
    }
    
    func testSafeWorkflowTestingMultipleSteps() async {
        // Run 100 iterations as specified in the design document
        for iteration in 0..<100 {
            let name = "Test Workflow \(iteration)"
            let desc = "Test Description \(iteration)"
            let count = (iteration % 10) + 1 // 1-10 steps
            
            let editorService = WorkflowEditorService()
            
            // Create a workflow
            let workflow = await editorService.createWorkflow(
                name: name,
                description: desc,
                category: .general
            )
            
            // Add multiple steps
            for i in 0..<count {
                let step = WorkflowStep.command(Command(
                    script: "echo 'Step \(i)'",
                    description: "Step \(i)",
                    requiresPermission: false,
                    timeout: 30.0
                ))
                
                _ = try? await editorService.addStep(to: workflow.id, step: step)
            }
            
            // Test the workflow
            let testResult = try? await editorService.testWorkflow(workflow.id)
            
            // Should test all steps
            XCTAssertNotNil(testResult, "Should return test result (iteration \(iteration))")
            if let result = testResult {
                XCTAssertEqual(result.stepResults.count, count, "Should have \(count) step results (iteration \(iteration))")
            }
        }
    }
    
    // MARK: - Property 43: Custom workflow availability
    // **Feature: workflow-assistant-app, Property 43: Custom workflow availability**
    // For any saved custom workflow, the system should make it available alongside built-in workflows
    // **Validates: Requirements 10.5**
    
    func testCustomWorkflowAvailability() async {
        // Run 100 iterations as specified in the design document
        for iteration in 0..<100 {
            let name = "Custom Workflow \(iteration)"
            let desc = "Custom workflow description \(iteration)"
            
            let editorService = WorkflowEditorService()
            
            // Create a custom workflow
            let workflow = await editorService.createWorkflow(
                name: name,
                description: desc,
                category: .general
            )
            
            // Add a step
            let step = WorkflowStep.command(Command(
                script: "echo 'test'",
                description: "Test",
                requiresPermission: false,
                timeout: 30.0
            ))
            
            _ = try? await editorService.addStep(to: workflow.id, step: step)
            
            // Save the workflow
            try? await editorService.saveWorkflow(workflow.id)
            
            // Verify it's available in custom workflows list
            let customWorkflows = await editorService.getCustomWorkflows()
            
            // Should be in the list of custom workflows
            XCTAssertTrue(customWorkflows.contains { $0.id == workflow.id }, 
                         "Custom workflow should be available (iteration \(iteration))")
        }
    }
    
    func testCustomWorkflowNotBuiltIn() async {
        // Run 100 iterations as specified in the design document
        for iteration in 0..<100 {
            let name = "Custom Workflow \(iteration)"
            let desc = "Custom workflow description \(iteration)"
            
            let editorService = WorkflowEditorService()
            
            // Create a custom workflow
            let workflow = await editorService.createWorkflow(
                name: name,
                description: desc,
                category: .general
            )
            
            // Add a step
            let step = WorkflowStep.command(Command(
                script: "echo 'test'",
                description: "Test",
                requiresPermission: false,
                timeout: 30.0
            ))
            
            _ = try? await editorService.addStep(to: workflow.id, step: step)
            
            // Save the workflow
            try? await editorService.saveWorkflow(workflow.id)
            
            // Load it back
            let loaded = try? await editorService.loadWorkflow(workflow.id)
            
            // Should not be marked as built-in
            XCTAssertNotNil(loaded, "Should be able to load workflow (iteration \(iteration))")
            XCTAssertEqual(loaded?.isBuiltIn, false, "Custom workflow should not be built-in (iteration \(iteration))")
        }
    }
    
    func testCustomWorkflowPersistence() async {
        // Run 100 iterations as specified in the design document
        for iteration in 0..<100 {
            let name = "Persistent Workflow \(iteration)"
            let desc = "Test description \(iteration)"
            
            let editorService1 = WorkflowEditorService()
            
            // Create and save a workflow with first service instance
            let workflow = await editorService1.createWorkflow(
                name: name,
                description: desc,
                category: .general
            )
            
            let step = WorkflowStep.command(Command(
                script: "echo 'test'",
                description: "Test",
                requiresPermission: false,
                timeout: 30.0
            ))
            
            _ = try? await editorService1.addStep(to: workflow.id, step: step)
            try? await editorService1.saveWorkflow(workflow.id)
            
            // Create a new service instance and try to load the workflow
            let editorService2 = WorkflowEditorService()
            let loaded = try? await editorService2.loadWorkflow(workflow.id)
            
            // Should be able to load the workflow
            XCTAssertNotNil(loaded, "Should be able to load workflow (iteration \(iteration))")
            XCTAssertEqual(loaded?.id, workflow.id, "Workflow ID should match (iteration \(iteration))")
            XCTAssertEqual(loaded?.name, workflow.name, "Workflow name should match (iteration \(iteration))")
        }
    }
}
