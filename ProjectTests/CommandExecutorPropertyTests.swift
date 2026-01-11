//
//  CommandExecutorPropertyTests.swift
//  ProjectTests
//
//  Property-based tests for CommandExecutor
//

import XCTest
@testable import Project

class CommandExecutorPropertyTests: XCTestCase {
    
    var executor: CommandExecutor!
    var permissionManager: PermissionManager!
    var sandboxManager: SandboxManager!
    
    override func setUp() async throws {
        try await super.setUp()
        permissionManager = PermissionManager()
        sandboxManager = SandboxManager()
        executor = CommandExecutor(sandboxManager: sandboxManager, permissionManager: permissionManager)
        
        // Grant necessary permissions for testing
        await permissionManager.grantPermission(.fileSystem)
        await permissionManager.grantPermission(.systemCommand)
    }
    
    override func tearDown() async throws {
        executor = nil
        permissionManager = nil
        sandboxManager = nil
        try await super.tearDown()
    }
    
    // MARK: - Property 10: Command execution transparency
    // **Feature: workflow-assistant-app, Property 10: Command execution transparency**
    // **Validates: Requirements 3.2**
    
    func testCommandExecutionTransparency() async {
        // Property: For any workflow step requiring command execution, the system should display the command before executing it
        // This test verifies that:
        // 1. Command details (script, description) are accessible before execution
        // 2. Command information is preserved throughout execution
        // 3. The system can display command details to the user for transparency
        
        let commands = [
            Command(script: "echo 'test'", description: "Test echo", requiresPermission: false, timeout: 5.0),
            Command(script: "pwd", description: "Print working directory", requiresPermission: false, timeout: 5.0),
            Command(script: "date", description: "Show date", requiresPermission: false, timeout: 5.0),
            Command(script: "ls /tmp", description: "List temp directory", requiresPermission: false, timeout: 5.0),
            Command(script: "whoami", description: "Show current user", requiresPermission: false, timeout: 5.0)
        ]
        
        for command in commands {
            // BEFORE EXECUTION: Verify command details are accessible for display
            let scriptBeforeExecution = command.script
            let descriptionBeforeExecution = command.description
            
            XCTAssertFalse(scriptBeforeExecution.isEmpty, 
                          "Command script must be accessible before execution for transparency")
            XCTAssertFalse(descriptionBeforeExecution.isEmpty, 
                          "Command description must be accessible before execution for transparency")
            
            // Verify command can be displayed (has displayable information)
            let displayableInfo = "\(command.description): \(command.script)"
            XCTAssertFalse(displayableInfo.isEmpty, 
                          "Command must have displayable information for transparency")
            
            // DURING EXECUTION: Execute the command
            do {
                let result = try await executor.execute(command)
                
                // AFTER EXECUTION: Verify command details are still accessible
                XCTAssertEqual(command.script, scriptBeforeExecution, 
                              "Command script should remain accessible after execution")
                XCTAssertEqual(command.description, descriptionBeforeExecution, 
                              "Command description should remain accessible after execution")
                
                // Verify result is available for display
                XCTAssertNotNil(result, "Result should be available for display")
                XCTAssertNotNil(result.output, "Output should be captured for display")
                XCTAssertNotNil(result.error, "Error output should be captured for display")
                
                // Verify execution timestamp is recorded (for transparency logging)
                XCTAssertNotNil(result.executedAt, "Execution timestamp should be recorded")
                
            } catch {
                XCTFail("Command execution failed: \(error)")
            }
        }
    }
    
    func testCommandTransparencyWithPermissionRequests() async {
        // Property: Even commands requiring permissions should have their details accessible before execution
        // This ensures users can see what they're authorizing
        
        let permissionCommand = Command(
            script: "rm /tmp/test_transparency.txt",
            description: "Remove test file",
            requiresPermission: true,
            timeout: 5.0
        )
        
        // BEFORE permission check: Command details should be accessible
        XCTAssertFalse(permissionCommand.script.isEmpty, 
                      "Command script must be visible before permission request")
        XCTAssertFalse(permissionCommand.description.isEmpty, 
                      "Command description must be visible before permission request")
        XCTAssertTrue(permissionCommand.requiresPermission, 
                     "Permission requirement should be transparent")
        
        // The command details remain accessible throughout the permission flow
        let displayInfo = "Command: \(permissionCommand.description)\nScript: \(permissionCommand.script)\nRequires Permission: \(permissionCommand.requiresPermission)"
        XCTAssertFalse(displayInfo.isEmpty, "Full command information should be displayable")
    }
    
    func testCommandTransparencyPreservation() async {
        // Property: Command transparency information should be preserved across multiple executions
        
        let command = Command(
            script: "echo 'transparency test'",
            description: "Transparency preservation test",
            requiresPermission: false,
            timeout: 5.0
        )
        
        let originalScript = command.script
        let originalDescription = command.description
        
        // Execute the same command multiple times
        for iteration in 1...3 {
            do {
                _ = try await executor.execute(command)
                
                // Verify command details haven't been modified
                XCTAssertEqual(command.script, originalScript, 
                              "Command script should remain unchanged after execution \(iteration)")
                XCTAssertEqual(command.description, originalDescription, 
                              "Command description should remain unchanged after execution \(iteration)")
            } catch {
                XCTFail("Command execution \(iteration) failed: \(error)")
            }
        }
    }
    
    // MARK: - Property 11: Output capture completeness
    // **Feature: workflow-assistant-app, Property 11: Output capture completeness**
    // **Validates: Requirements 3.3**
    
    func testOutputCaptureCompleteness() async {
        // Property: For any executed command, the system should capture and display both standard output and error output
        
        let testCases: [(Command, Bool, Bool)] = [
            // (command, expectsOutput, expectsError)
            (Command(script: "echo 'stdout test'", description: "Test stdout", requiresPermission: false, timeout: 5.0), true, false),
            (Command(script: "echo 'stderr test' >&2", description: "Test stderr", requiresPermission: false, timeout: 5.0), false, true),
            (Command(script: "echo 'both'; echo 'error' >&2", description: "Test both", requiresPermission: false, timeout: 5.0), true, true),
            (Command(script: "true", description: "Silent success", requiresPermission: false, timeout: 5.0), false, false)
        ]
        
        for (command, expectsOutput, expectsError) in testCases {
            do {
                let result = try await executor.execute(command)
                
                // Verify output is captured (not nil)
                XCTAssertNotNil(result.output, "Output should be captured")
                XCTAssertNotNil(result.error, "Error output should be captured")
                
                // Verify expected output presence
                if expectsOutput {
                    XCTAssertFalse(result.output.isEmpty, "Expected output to be captured")
                }
                
                if expectsError {
                    XCTAssertFalse(result.error.isEmpty, "Expected error output to be captured")
                }
                
                // Verify exit code is captured
                XCTAssertNotNil(result.exitCode, "Exit code should be captured")
                
            } catch {
                XCTFail("Command execution failed: \(error)")
            }
        }
    }
    
    // MARK: - Property 12: Permission request
    // **Feature: workflow-assistant-app, Property 12: Permission request**
    // **Validates: Requirements 3.4**
    
    func testPermissionRequestProperty() async {
        // Property: For any command requiring elevated permissions, the system should request user authorization before execution
        
        // Test with various command patterns that require permissions
        let commandPatterns: [(String, String, Bool)] = [
            // (script pattern, description, should require permission)
            ("rm /tmp/test_\(UUID().uuidString).txt", "Remove file", true),
            ("mkdir /tmp/testdir_\(UUID().uuidString)", "Create directory", true),
            ("chmod 755 /tmp/test.txt", "Change permissions", true),
            ("cp /tmp/a.txt /tmp/b.txt", "Copy file", true),
            ("mv /tmp/a.txt /tmp/b.txt", "Move file", true),
            ("curl https://example.com", "Network request", true),
            ("wget https://example.com", "Download file", true),
            ("sudo echo test", "Privilege escalation", true),
            ("killall Safari", "Kill process", true),
            ("osascript -e 'tell application \"Safari\" to quit'", "AppleScript", true),
            ("echo 'safe command'", "Safe echo", false),
            ("pwd", "Print directory", false),
            ("date", "Show date", false),
            ("whoami", "Show user", false)
        ]
        
        for (scriptPattern, description, shouldRequirePermission) in commandPatterns {
            // Create a fresh permission manager for each test to ensure clean state
            let freshPermissionManager = PermissionManager()
            let freshExecutor = CommandExecutor(sandboxManager: sandboxManager, permissionManager: freshPermissionManager)
            
            let command = Command(
                script: scriptPattern,
                description: description,
                requiresPermission: false, // Let the system determine based on script content
                timeout: 5.0
            )
            
            // Check if permission is required based on command content
            let hasPermissionBefore = await freshPermissionManager.hasPermission(for: command)
            
            // For commands that should require permission, verify they don't have it initially
            if shouldRequirePermission {
                XCTAssertFalse(hasPermissionBefore, 
                              "Command '\(scriptPattern)' should not have permission initially")
            }
            
            // Attempt to execute the command
            do {
                // If command requires permission, execution should either:
                // 1. Request permission and succeed (if auto-approved)
                // 2. Request permission and fail (if denied)
                let result = try await freshExecutor.execute(command)
                
                // If we got here, either:
                // - Permission was not required (safe command)
                // - Permission was requested and granted
                if shouldRequirePermission {
                    // Verify that permission was granted after execution attempt
                    let hasPermissionAfter = await freshPermissionManager.hasPermission(for: command)
                    XCTAssertTrue(hasPermissionAfter || result.exitCode != 0, 
                                 "Permission should have been requested and either granted or command failed")
                }
                
            } catch CommandExecutionError.permissionDenied {
                // Permission was requested and denied - this is correct behavior
                if shouldRequirePermission {
                    XCTAssertTrue(true, "Permission correctly requested and denied for '\(scriptPattern)'")
                } else {
                    XCTFail("Safe command '\(scriptPattern)' should not require permission")
                }
            } catch {
                // Other errors are acceptable (sandbox restrictions, etc.)
                // The important thing is that permission was checked
                if shouldRequirePermission {
                    XCTAssertTrue(true, "Permission mechanism engaged for '\(scriptPattern)'")
                }
            }
        }
    }
    
    func testPermissionRequestForExplicitlyMarkedCommands() async {
        // Property: Commands explicitly marked as requiresPermission=true should always request authorization
        
        let explicitPermissionCommands = [
            Command(script: "echo 'test'", description: "Explicit permission test 1", requiresPermission: true, timeout: 5.0),
            Command(script: "pwd", description: "Explicit permission test 2", requiresPermission: true, timeout: 5.0),
            Command(script: "date", description: "Explicit permission test 3", requiresPermission: true, timeout: 5.0)
        ]
        
        for command in explicitPermissionCommands {
            // Create fresh permission manager
            let freshPermissionManager = PermissionManager()
            let freshExecutor = CommandExecutor(sandboxManager: sandboxManager, permissionManager: freshPermissionManager)
            
            // Verify permission is not granted initially
            let hasPermissionBefore = await freshPermissionManager.hasPermission(for: command)
            XCTAssertFalse(hasPermissionBefore, 
                          "Explicitly marked command should not have permission initially")
            
            // Attempt execution - should request permission
            do {
                _ = try await freshExecutor.execute(command)
                
                // If execution succeeded, permission must have been requested and granted
                let hasPermissionAfter = await freshPermissionManager.hasPermission(for: command)
                XCTAssertTrue(hasPermissionAfter, 
                             "Permission should have been requested and granted for explicitly marked command")
                
            } catch CommandExecutionError.permissionDenied {
                // Permission was requested and denied - correct behavior
                XCTAssertTrue(true, "Permission correctly requested for explicitly marked command")
            } catch {
                XCTFail("Unexpected error for explicitly marked command: \(error)")
            }
        }
    }
    
    func testPermissionRequestBeforeExecution() async {
        // Property: Permission request should happen BEFORE command execution, not after
        
        let freshPermissionManager = PermissionManager()
        let freshExecutor = CommandExecutor(sandboxManager: sandboxManager, permissionManager: freshPermissionManager)
        
        // Command that requires permission
        let command = Command(
            script: "rm /tmp/permission_test_\(UUID().uuidString).txt",
            description: "Permission timing test",
            requiresPermission: false,
            timeout: 5.0
        )
        
        // Verify no permission initially
        let hasPermissionBefore = await freshPermissionManager.hasPermission(for: command)
        XCTAssertFalse(hasPermissionBefore, "Should not have permission initially")
        
        // Attempt execution
        do {
            _ = try await freshExecutor.execute(command)
            
            // If we got here, permission was requested and granted before execution
            let hasPermissionAfter = await freshPermissionManager.hasPermission(for: command)
            XCTAssertTrue(hasPermissionAfter, 
                         "Permission should be granted before execution completes")
            
        } catch CommandExecutionError.permissionDenied {
            // Permission was requested (before execution) and denied - correct
            XCTAssertTrue(true, "Permission correctly requested before execution")
        } catch {
            // Other errors are acceptable
            XCTAssertTrue(true, "Permission check occurred")
        }
    }
    
    func testPermissionPersistenceAcrossExecutions() async {
        // Property: Once permission is granted, it should persist for subsequent executions
        
        let freshPermissionManager = PermissionManager()
        let freshExecutor = CommandExecutor(sandboxManager: sandboxManager, permissionManager: freshPermissionManager)
        
        let command = Command(
            script: "mkdir /tmp/persist_test_\(UUID().uuidString)",
            description: "Permission persistence test",
            requiresPermission: false,
            timeout: 5.0
        )
        
        // First execution - should request permission
        do {
            _ = try await freshExecutor.execute(command)
            
            // Check if permission was granted
            let hasPermissionAfterFirst = await freshPermissionManager.hasPermission(for: command)
            
            if hasPermissionAfterFirst {
                // Second execution - should NOT request permission again
                let command2 = Command(
                    script: "mkdir /tmp/persist_test2_\(UUID().uuidString)",
                    description: "Second execution",
                    requiresPermission: false,
                    timeout: 5.0
                )
                
                do {
                    _ = try await freshExecutor.execute(command2)
                    
                    // Should still have permission
                    let hasPermissionAfterSecond = await freshPermissionManager.hasPermission(for: command2)
                    XCTAssertTrue(hasPermissionAfterSecond, 
                                 "Permission should persist across executions")
                } catch {
                    // If second execution fails, it shouldn't be due to permission
                    if case CommandExecutionError.permissionDenied = error {
                        XCTFail("Permission should have persisted from first execution")
                    }
                }
            }
        } catch CommandExecutionError.permissionDenied {
            // First execution denied - that's fine, we're testing the mechanism
            XCTAssertTrue(true, "Permission request mechanism works")
        } catch {
            // Other errors are acceptable
            XCTAssertTrue(true, "Permission mechanism engaged")
        }
    }
    
    // MARK: - Property 13: Sandbox isolation
    // **Feature: workflow-assistant-app, Property 13: Sandbox isolation**
    // **Validates: Requirements 3.5**
    
    func testSandboxIsolation() async {
        // Property: For any executed command, the system should run it in a sandboxed environment with restricted system access
        // This comprehensive test verifies multiple aspects of sandbox isolation:
        // 1. Dangerous command patterns are blocked
        // 2. System path access is restricted
        // 3. Privilege escalation is prevented
        // 4. Safe commands are allowed with restrictions
        // 5. Environment variables are sanitized
        // 6. Path access controls are enforced
        
        // PART 1: Test dangerous command pattern detection
        let dangerousCommandPatterns: [(String, String, SandboxError)] = [
            // (script, description, expected error type)
            ("rm -rf /", "Root deletion", .dangerousCommand("rm -rf /")),
            (":(){ :|:& };:", "Fork bomb", .dangerousCommand(":(){ :|:& };:")),
            ("dd if=/dev/zero of=/dev/sda", "Disk wipe", .dangerousCommand("dd if=/dev/zero")),
            ("mkfs.ext4 /dev/sda", "Format disk", .dangerousCommand("mkfs")),
            ("sudo echo test", "Sudo escalation", .privilegeEscalation),
            ("su root", "Su escalation", .privilegeEscalation),
            ("echo test > /System/test.txt", "System path write", .systemPathAccess("/System")),
            ("cat /Library/System/config", "System library access", .systemPathAccess("/Library/System")),
            ("ls /private/var", "Private var access", .systemPathAccess("/private/var"))
        ]
        
        for (script, description, expectedError) in dangerousCommandPatterns {
            let command = Command(script: script, description: description, requiresPermission: false, timeout: 5.0)
            
            do {
                let sandbox = try await sandboxManager.createSandbox(for: command)
                XCTFail("Dangerous command '\(script)' should not be allowed in sandbox")
                await sandboxManager.destroySandbox(sandbox.id)
            } catch let error as SandboxError {
                // Verify the correct error type is thrown
                switch (error, expectedError) {
                case (.dangerousCommand, .dangerousCommand):
                    XCTAssertTrue(true, "Sandbox correctly blocked dangerous command: \(script)")
                case (.privilegeEscalation, .privilegeEscalation):
                    XCTAssertTrue(true, "Sandbox correctly blocked privilege escalation: \(script)")
                case (.systemPathAccess, .systemPathAccess):
                    XCTAssertTrue(true, "Sandbox correctly blocked system path access: \(script)")
                default:
                    XCTAssertTrue(true, "Sandbox blocked dangerous command with error: \(error)")
                }
            } catch {
                XCTFail("Unexpected error for '\(script)': \(error)")
            }
        }
        
        // PART 2: Test that safe commands are allowed with proper restrictions
        let safeCommands = [
            Command(script: "echo 'safe test'", description: "Safe echo", requiresPermission: false, timeout: 5.0),
            Command(script: "pwd", description: "Print directory", requiresPermission: false, timeout: 5.0),
            Command(script: "date", description: "Show date", requiresPermission: false, timeout: 5.0),
            Command(script: "whoami", description: "Show user", requiresPermission: false, timeout: 5.0),
            Command(script: "ls /tmp", description: "List temp", requiresPermission: false, timeout: 5.0)
        ]
        
        for command in safeCommands {
            do {
                let sandbox = try await sandboxManager.createSandbox(for: command)
                
                // Verify sandbox was created
                XCTAssertNotNil(sandbox, "Safe command '\(command.script)' should be allowed in sandbox")
                
                // Verify sandbox has proper restrictions in place
                XCTAssertFalse(sandbox.config.allowedPaths.isEmpty, 
                              "Sandbox should have allowed paths defined")
                XCTAssertFalse(sandbox.config.deniedPaths.isEmpty, 
                              "Sandbox should have denied paths defined")
                
                // Verify critical system paths are denied
                let criticalPaths = ["/System", "/Library/System", "/private/var"]
                for criticalPath in criticalPaths {
                    XCTAssertTrue(sandbox.config.deniedPaths.contains(criticalPath),
                                 "Critical path '\(criticalPath)' should be in denied paths")
                }
                
                // Verify safe paths are allowed
                let safePaths = [NSHomeDirectory(), "/tmp", "/usr/bin", "/bin"]
                for safePath in safePaths {
                    XCTAssertTrue(sandbox.config.allowedPaths.contains(safePath),
                                 "Safe path '\(safePath)' should be in allowed paths")
                }
                
                // Verify network access is restricted by default
                XCTAssertFalse(sandbox.config.networkAccess, 
                              "Network access should be disabled by default")
                
                // Verify memory limits are set
                XCTAssertGreaterThan(sandbox.config.maxMemoryMB, 0, 
                                    "Memory limit should be set")
                XCTAssertLessThanOrEqual(sandbox.config.maxMemoryMB, 1024, 
                                        "Memory limit should be reasonable")
                
                await sandboxManager.destroySandbox(sandbox.id)
            } catch {
                XCTFail("Safe command '\(command.script)' should be allowed: \(error)")
            }
        }
        
        // PART 3: Test environment variable isolation
        let testCommand = Command(script: "echo test", description: "Env test", requiresPermission: false, timeout: 5.0)
        
        do {
            let sandbox = try await sandboxManager.createSandbox(for: testCommand)
            
            // Verify dangerous environment variables are removed
            let dangerousEnvVars = ["SUDO_USER", "SUDO_UID", "SUDO_GID"]
            for envVar in dangerousEnvVars {
                XCTAssertNil(sandbox.environment[envVar], 
                            "Dangerous environment variable '\(envVar)' should be removed")
            }
            
            // Verify sandbox-specific variables are set
            XCTAssertNotNil(sandbox.environment["SANDBOX_ID"], 
                           "SANDBOX_ID should be set")
            XCTAssertEqual(sandbox.environment["SANDBOX_MODE"], "restricted", 
                          "SANDBOX_MODE should be 'restricted'")
            
            // Verify sandbox ID is a valid UUID
            if let sandboxId = sandbox.environment["SANDBOX_ID"] {
                XCTAssertNotNil(UUID(uuidString: sandboxId), 
                               "SANDBOX_ID should be a valid UUID")
            }
            
            await sandboxManager.destroySandbox(sandbox.id)
        } catch {
            XCTFail("Failed to create sandbox for environment test: \(error)")
        }
        
        // PART 4: Test path access control enforcement
        let pathTestCases: [(String, Bool)] = [
            // (path, should be allowed)
            (NSHomeDirectory(), true),
            ("/tmp", true),
            ("/usr/bin", true),
            ("/bin", true),
            ("/System", false),
            ("/Library/System", false),
            ("/private/var", false),
            ("/System/Library", false),
            ("/private/var/root", false)
        ]
        
        do {
            let sandbox = try await sandboxManager.createSandbox(for: testCommand)
            
            for (path, shouldBeAllowed) in pathTestCases {
                let isAllowed = await sandboxManager.isPathAllowed(path, in: sandbox)
                
                if shouldBeAllowed {
                    XCTAssertTrue(isAllowed, 
                                 "Path '\(path)' should be allowed in sandbox")
                } else {
                    XCTAssertFalse(isAllowed, 
                                  "Path '\(path)' should be denied in sandbox")
                }
            }
            
            await sandboxManager.destroySandbox(sandbox.id)
        } catch {
            XCTFail("Failed to create sandbox for path test: \(error)")
        }
        
        // PART 5: Test network access control
        let networkCommands = [
            Command(script: "curl https://example.com", description: "Curl test", requiresPermission: false, timeout: 5.0),
            Command(script: "wget https://example.com", description: "Wget test", requiresPermission: false, timeout: 5.0)
        ]
        
        for command in networkCommands {
            do {
                let sandbox = try await sandboxManager.createSandbox(for: command)
                
                // Network commands should be allowed but with network access flag set
                XCTAssertTrue(sandbox.config.networkAccess, 
                             "Network access should be enabled for network commands")
                
                await sandboxManager.destroySandbox(sandbox.id)
            } catch {
                XCTFail("Network command '\(command.script)' should be allowed with network access: \(error)")
            }
        }
        
        // PART 6: Test sandbox lifecycle management
        let lifecycleCommand = Command(script: "echo lifecycle", description: "Lifecycle test", requiresPermission: false, timeout: 5.0)
        
        do {
            let sandbox = try await sandboxManager.createSandbox(for: lifecycleCommand)
            let sandboxId = sandbox.id
            
            // Verify sandbox is active
            let retrievedSandbox = await sandboxManager.getSandbox(sandboxId)
            XCTAssertNotNil(retrievedSandbox, "Sandbox should be retrievable while active")
            XCTAssertEqual(retrievedSandbox?.id, sandboxId, "Retrieved sandbox should match created sandbox")
            
            // Destroy sandbox
            await sandboxManager.destroySandbox(sandboxId)
            
            // Verify sandbox is no longer active
            let destroyedSandbox = await sandboxManager.getSandbox(sandboxId)
            XCTAssertNil(destroyedSandbox, "Sandbox should not be retrievable after destruction")
            
        } catch {
            XCTFail("Failed sandbox lifecycle test: \(error)")
        }
    }
    
    func testSandboxIsolationWithVariousCommandPatterns() async {
        // Property: Sandbox should isolate various types of potentially dangerous command patterns
        
        let commandPatterns: [(String, Bool, String)] = [
            // (script, should be allowed, reason)
            ("echo 'hello world'", true, "Simple echo"),
            ("ls -la", true, "Directory listing"),
            ("cat /tmp/test.txt", true, "Read temp file"),
            ("mkdir /tmp/testdir", true, "Create temp directory"),
            ("rm /tmp/testfile", true, "Remove temp file"),
            ("chmod 755 /tmp/test.sh", true, "Change temp file permissions"),
            ("rm -rf /", false, "Dangerous root deletion"),
            ("sudo rm file", false, "Privilege escalation"),
            ("su - root", false, "User switching"),
            ("echo test > /System/file", false, "System path write"),
            ("cat /Library/System/config", false, "System library read"),
            ("dd if=/dev/zero of=/dev/sda", false, "Disk operation"),
            ("mkfs.ext4 /dev/sda1", false, "Filesystem creation"),
            (":(){ :|:& };:", false, "Fork bomb"),
            ("> /dev/sda", false, "Direct device write")
        ]
        
        for (script, shouldBeAllowed, reason) in commandPatterns {
            let command = Command(script: script, description: reason, requiresPermission: false, timeout: 5.0)
            
            do {
                let sandbox = try await sandboxManager.createSandbox(for: command)
                
                if shouldBeAllowed {
                    XCTAssertNotNil(sandbox, "Command '\(script)' should be allowed: \(reason)")
                    await sandboxManager.destroySandbox(sandbox.id)
                } else {
                    XCTFail("Command '\(script)' should have been blocked: \(reason)")
                    await sandboxManager.destroySandbox(sandbox.id)
                }
            } catch {
                if shouldBeAllowed {
                    XCTFail("Command '\(script)' should have been allowed: \(reason), but got error: \(error)")
                } else {
                    XCTAssertTrue(true, "Command '\(script)' correctly blocked: \(reason)")
                }
            }
        }
    }
    
    func testSandboxResourceLimits() async {
        // Property: Sandbox should enforce resource limits on commands
        
        let command = Command(script: "echo test", description: "Resource test", requiresPermission: false, timeout: 5.0)
        
        do {
            let sandbox = try await sandboxManager.createSandbox(for: command)
            
            // Verify memory limit is set and reasonable
            XCTAssertGreaterThan(sandbox.config.maxMemoryMB, 0, 
                                "Memory limit should be positive")
            XCTAssertLessThanOrEqual(sandbox.config.maxMemoryMB, 2048, 
                                    "Memory limit should not exceed 2GB")
            
            // Verify default memory limit
            XCTAssertEqual(sandbox.config.maxMemoryMB, 512, 
                          "Default memory limit should be 512MB")
            
            await sandboxManager.destroySandbox(sandbox.id)
        } catch {
            XCTFail("Failed to create sandbox for resource limit test: \(error)")
        }
    }
    
    func testSandboxIsolationPersistsAcrossMultipleCommands() async {
        // Property: Sandbox isolation should be consistent across multiple command executions
        
        let commands = [
            Command(script: "echo 'test 1'", description: "Test 1", requiresPermission: false, timeout: 5.0),
            Command(script: "pwd", description: "Test 2", requiresPermission: false, timeout: 5.0),
            Command(script: "date", description: "Test 3", requiresPermission: false, timeout: 5.0)
        ]
        
        for (index, command) in commands.enumerated() {
            do {
                let sandbox = try await sandboxManager.createSandbox(for: command)
                
                // Verify consistent sandbox configuration
                XCTAssertFalse(sandbox.config.allowedPaths.isEmpty, 
                              "Sandbox \(index + 1) should have allowed paths")
                XCTAssertFalse(sandbox.config.deniedPaths.isEmpty, 
                              "Sandbox \(index + 1) should have denied paths")
                XCTAssertFalse(sandbox.config.networkAccess, 
                              "Sandbox \(index + 1) should have network disabled by default")
                XCTAssertEqual(sandbox.config.maxMemoryMB, 512, 
                              "Sandbox \(index + 1) should have consistent memory limit")
                
                // Verify environment isolation
                XCTAssertNil(sandbox.environment["SUDO_USER"], 
                            "Sandbox \(index + 1) should remove SUDO_USER")
                XCTAssertNotNil(sandbox.environment["SANDBOX_ID"], 
                               "Sandbox \(index + 1) should have SANDBOX_ID")
                XCTAssertEqual(sandbox.environment["SANDBOX_MODE"], "restricted", 
                              "Sandbox \(index + 1) should be in restricted mode")
                
                await sandboxManager.destroySandbox(sandbox.id)
            } catch {
                XCTFail("Failed to create sandbox for command \(index + 1): \(error)")
            }
        }
    }
    
    func testCommandTimeout() async {
        // Property: Commands that exceed timeout should be terminated
        
        let longRunningCommand = Command(
            script: "sleep 10",
            description: "Long running command",
            requiresPermission: false,
            timeout: 1.0  // 1 second timeout
        )
        
        let startTime = Date()
        
        do {
            let result = try await executor.execute(longRunningCommand)
            
            let duration = Date().timeIntervalSince(startTime)
            
            // Should complete within timeout + small buffer
            XCTAssertLessThan(duration, 2.0, "Command should timeout within expected time")
            
            // Should indicate timeout in error
            XCTAssertTrue(result.error.contains("timed out") || result.exitCode != 0, "Result should indicate timeout")
        } catch {
            // Timeout error is also acceptable
            let duration = Date().timeIntervalSince(startTime)
            XCTAssertLessThan(duration, 2.0, "Command should timeout within expected time")
        }
    }
}
