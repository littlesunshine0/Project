//
//  Command.swift
//  CommandKit
//

import Foundation

public struct Command: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var name: String
    public var description: String
    public var syntax: String
    public var type: CommandType
    public var category: CommandCategory
    public var format: CommandFormat
    public var kind: CommandKind
    public var parameters: [CommandParameter]
    public var examples: [String]
    public var aliases: [String]
    public var isBuiltIn: Bool
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        syntax: String = "",
        type: CommandType = .run,
        category: CommandCategory = .general,
        format: CommandFormat = .slash,
        kind: CommandKind = .action,
        parameters: [CommandParameter] = [],
        examples: [String] = [],
        aliases: [String] = [],
        isBuiltIn: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.syntax = syntax.isEmpty ? "/\(name) [args...]" : syntax
        self.type = type
        self.category = category
        self.format = format
        self.kind = kind
        self.parameters = parameters
        self.examples = examples
        self.aliases = aliases
        self.isBuiltIn = isBuiltIn
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct CommandParameter: Codable, Hashable, Sendable {
    public let name: String
    public let type: ParameterType
    public let required: Bool
    public let description: String
    public let defaultValue: String?
    
    public init(name: String, type: ParameterType, required: Bool = false, description: String = "", defaultValue: String? = nil) {
        self.name = name
        self.type = type
        self.required = required
        self.description = description
        self.defaultValue = defaultValue
    }
    
    public enum ParameterType: String, Codable, Sendable {
        case string, number, boolean, path, workflow, file, date, array
    }
}

public struct ParsedCommand: Sendable {
    public let command: Command
    public let arguments: [String]
    public let rawInput: String
    
    public var firstArgument: String? { arguments.first }
    public var remainingArguments: [String] { Array(arguments.dropFirst()) }
    
    public init(command: Command, arguments: [String], rawInput: String) {
        self.command = command
        self.arguments = arguments
        self.rawInput = rawInput
    }
}
