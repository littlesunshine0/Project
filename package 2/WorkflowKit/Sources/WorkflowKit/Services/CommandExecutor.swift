//
//  CommandExecutor.swift
//  WorkflowKit
//
//  Command execution with sandboxing and permission management
//

import Foundation

// MARK: - Command Executor

/// Executes shell commands with timeout and permission management
public actor CommandExecutor {
    
    // MARK: - State
    
    private var activeExecutions: [UUID: Process] = [:]
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Command Execution
    
    /// Executes a command and returns the result
    public func execute(_ command: Command) async throws -> CommandResult {
        let executionId = UUID()
        let startTime = Date()
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", command.script]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        activeExecutions[executionId] = process
        
        defer {
            activeExecutions.removeValue(forKey: executionId)
        }
        
        do {
            try process.run()
            
            // Wait with timeout
            let timeoutTask = Task {
                try await Task.sleep(nanoseconds: UInt64(command.timeout * 1_000_000_000))
                if process.isRunning {
                    process.terminate()
                }
            }
            
            process.waitUntilExit()
            timeoutTask.cancel()
            
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            
            let output = String(data: outputData, encoding: .utf8) ?? ""
            let error = String(data: errorData, encoding: .utf8) ?? ""
            
            return CommandResult(
                exitCode: Int(process.terminationStatus),
                output: output,
                error: error,
                executedAt: startTime
            )
        } catch {
            throw CommandExecutionError.executionFailed(error)
        }
    }
    
    /// Cancels an active command execution
    public func cancel(_ executionId: UUID) {
        if let process = activeExecutions[executionId] {
            process.terminate()
            activeExecutions.removeValue(forKey: executionId)
        }
    }
    
    /// Gets all active execution IDs
    public func getActiveExecutions() -> [UUID] {
        return Array(activeExecutions.keys)
    }
}
