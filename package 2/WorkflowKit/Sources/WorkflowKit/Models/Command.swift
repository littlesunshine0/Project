//
//  Command.swift
//  WorkflowKit
//
//  Command execution models
//

import Foundation

// MARK: - Command

public struct Command: Codable, Equatable, Sendable {
    public let script: String
    public let description: String
    public let requiresPermission: Bool
    public let timeout: TimeInterval
    
    public init(
        script: String,
        description: String,
        requiresPermission: Bool = false,
        timeout: TimeInterval = 30.0
    ) {
        self.script = script
        self.description = description
        self.requiresPermission = requiresPermission
        self.timeout = timeout
    }
}

// MARK: - Prompt

public struct Prompt: Codable, Equatable, Sendable {
    public let message: String
    public let inputType: PromptInputType
    public let defaultValue: String?
    
    public init(
        message: String,
        inputType: PromptInputType = .text,
        defaultValue: String? = nil
    ) {
        self.message = message
        self.inputType = inputType
        self.defaultValue = defaultValue
    }
}

public enum PromptInputType: String, Codable, Sendable {
    case text
    case number
    case boolean
    case choice
}

// MARK: - Condition

public struct Condition: Codable, Equatable, Sendable {
    public let expression: String
    public let variables: [String: String]
    
    public init(expression: String, variables: [String: String] = [:]) {
        self.expression = expression
        self.variables = variables
    }
}

// MARK: - Command Result

public struct CommandResult: Codable, Equatable, Sendable {
    public let exitCode: Int
    public let output: String
    public let error: String
    public let executedAt: Date
    
    public init(
        exitCode: Int,
        output: String,
        error: String,
        executedAt: Date = Date()
    ) {
        self.exitCode = exitCode
        self.output = output
        self.error = error
        self.executedAt = executedAt
    }
    
    public var isSuccess: Bool { exitCode == 0 }
}
