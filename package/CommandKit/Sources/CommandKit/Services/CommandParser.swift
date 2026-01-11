//
//  CommandParser.swift
//  CommandKit
//

import Foundation

public actor CommandParser {
    public static let shared = CommandParser()
    
    private var registeredCommands: [String: Command] = [:]
    
    private init() {}
    
    // MARK: - Registration
    
    public func register(_ command: Command) {
        registeredCommands[command.name.lowercased()] = command
        for alias in command.aliases {
            registeredCommands[alias.lowercased()] = command
        }
    }
    
    public func registerBatch(_ commands: [Command]) {
        for command in commands {
            register(command)
        }
    }
    
    // MARK: - Parsing
    
    public func parse(_ input: String) throws -> ParsedCommand {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        
        guard trimmed.hasPrefix("/") else {
            throw CommandError.notACommand
        }
        
        let withoutSlash = String(trimmed.dropFirst())
        let components = withoutSlash.split(separator: " ", omittingEmptySubsequences: true).map(String.init)
        
        guard let commandName = components.first else {
            throw CommandError.emptyCommand
        }
        
        guard let command = registeredCommands[commandName.lowercased()] else {
            throw CommandError.unknownCommand(commandName)
        }
        
        let arguments = Array(components.dropFirst())
        
        // Validate required parameters
        let requiredParams = command.parameters.filter { $0.required }
        if arguments.count < requiredParams.count {
            throw CommandError.invalidArguments("Missing required arguments: \(requiredParams.map { $0.name }.joined(separator: ", "))")
        }
        
        return ParsedCommand(command: command, arguments: arguments, rawInput: input)
    }
    
    public func parseNatural(_ input: String) throws -> ParsedCommand? {
        let lowered = input.lowercased()
        
        // Simple pattern matching for natural language
        for (_, command) in registeredCommands {
            if lowered.contains(command.name.lowercased()) {
                return ParsedCommand(command: command, arguments: [], rawInput: input)
            }
            
            // Check aliases
            for alias in command.aliases {
                if lowered.contains(alias.lowercased()) {
                    return ParsedCommand(command: command, arguments: [], rawInput: input)
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Autocomplete
    
    public func getCompletions(for partial: String) -> [Command] {
        guard partial.hasPrefix("/") else { return [] }
        
        let withoutSlash = String(partial.dropFirst()).lowercased()
        
        if withoutSlash.isEmpty {
            return Array(registeredCommands.values)
        }
        
        return registeredCommands.values.filter { command in
            command.name.lowercased().hasPrefix(withoutSlash) ||
            command.aliases.contains { $0.lowercased().hasPrefix(withoutSlash) }
        }
    }
    
    public func getSuggestions(for context: String, limit: Int = 5) -> [Command] {
        let words = context.lowercased().split(separator: " ").map(String.init)
        
        var scores: [(Command, Int)] = []
        
        for command in registeredCommands.values {
            var score = 0
            for word in words {
                if command.name.lowercased().contains(word) { score += 3 }
                if command.description.lowercased().contains(word) { score += 1 }
                if command.category.rawValue.lowercased().contains(word) { score += 2 }
            }
            if score > 0 {
                scores.append((command, score))
            }
        }
        
        return scores
            .sorted { $0.1 > $1.1 }
            .prefix(limit)
            .map { $0.0 }
    }
    
    // MARK: - Validation
    
    public func validate(_ input: String) -> ValidationResult {
        do {
            let parsed = try parse(input)
            return ValidationResult(isValid: true, command: parsed.command, errors: [])
        } catch let error as CommandError {
            return ValidationResult(isValid: false, command: nil, errors: [error.localizedDescription])
        } catch {
            return ValidationResult(isValid: false, command: nil, errors: [error.localizedDescription])
        }
    }
}

public struct ValidationResult: Sendable {
    public let isValid: Bool
    public let command: Command?
    public let errors: [String]
}
