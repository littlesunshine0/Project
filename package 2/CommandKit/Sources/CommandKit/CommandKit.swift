//
//  CommandKit.swift
//  CommandKit
//
//  Command Parsing, Autocomplete & Template System
//

import Foundation

/// CommandKit - Professional Command System
public struct CommandKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.commandkit"
    
    public init() {}
    
    /// Parse a slash command
    public static func parse(_ input: String) async throws -> ParsedCommand {
        try await CommandParser.shared.parse(input)
    }
    
    /// Check if input is a command
    public static func isCommand(_ input: String) -> Bool {
        input.trimmingCharacters(in: .whitespaces).hasPrefix("/")
    }
    
    /// Get autocomplete suggestions
    public static func autocomplete(_ partial: String) async -> [Command] {
        await CommandParser.shared.getCompletions(for: partial)
    }
    
    /// Register a custom command
    public static func register(_ command: Command) async {
        await CommandParser.shared.register(command)
    }
    
    /// Load built-in commands from JSON
    public static func loadBuiltInCommands() async {
        await CommandManager.shared.loadBuiltInCommands()
    }
}
