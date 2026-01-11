//
//  CommandManager.swift
//  CommandKit
//

import Foundation
import Combine

@MainActor
public class CommandManager: ObservableObject {
    public static let shared = CommandManager()
    
    @Published public var commands: [Command] = []
    @Published public var recentCommands: [Command] = []
    @Published public var isLoading = false
    
    private var favorites: Set<UUID> = []
    private let maxRecent = 20
    
    private init() {
        Task { await loadBuiltInCommands() }
    }
    
    // MARK: - CRUD
    
    public func register(_ command: Command) async {
        commands.append(command)
        await CommandParser.shared.register(command)
    }
    
    public func update(_ command: Command) async {
        if let index = commands.firstIndex(where: { $0.id == command.id }) {
            commands[index] = command
            await CommandParser.shared.register(command)
        }
    }
    
    public func delete(_ id: UUID) async {
        commands.removeAll { $0.id == id }
    }
    
    public func getAllCommands() async -> [Command] {
        commands
    }
    
    public func getCommand(named name: String) -> Command? {
        commands.first { $0.name.lowercased() == name.lowercased() }
    }
    
    // MARK: - Execution
    
    public func execute(_ command: Command, arguments: [String] = []) async throws -> ExecutionResult {
        let startTime = Date()
        
        // Add to recent
        recentCommands.insert(command, at: 0)
        if recentCommands.count > maxRecent {
            recentCommands.removeLast()
        }
        
        // Simulate execution
        try await Task.sleep(nanoseconds: 100_000_000)
        
        let duration = Date().timeIntervalSince(startTime)
        return ExecutionResult(
            success: true,
            output: "Executed /\(command.name) \(arguments.joined(separator: " "))",
            duration: duration,
            command: command
        )
    }
    
    // MARK: - Favorites
    
    public func toggleFavorite(_ id: UUID) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
    }
    
    public func isFavorite(_ id: UUID) -> Bool {
        favorites.contains(id)
    }
    
    // MARK: - Loading
    
    public func loadBuiltInCommands() async {
        isLoading = true
        defer { isLoading = false }
        
        // Load from JSON resource
        if let url = Bundle.module.url(forResource: "commands", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let json = try? JSONDecoder().decode(CommandsJSON.self, from: data) {
            for cmdJSON in json.commands {
                let command = Command(
                    name: cmdJSON.name,
                    description: cmdJSON.description,
                    syntax: cmdJSON.syntax,
                    type: CommandType(rawValue: cmdJSON.type.capitalized) ?? .run,
                    category: CommandCategory(rawValue: cmdJSON.category.capitalized) ?? .general,
                    format: CommandFormat(rawValue: cmdJSON.format.capitalized) ?? .slash,
                    kind: CommandKind(rawValue: cmdJSON.kind.capitalized) ?? .action,
                    parameters: cmdJSON.parameters.map {
                        CommandParameter(
                            name: $0.name,
                            type: CommandParameter.ParameterType(rawValue: $0.type) ?? .string,
                            required: $0.required,
                            description: $0.description,
                            defaultValue: $0.defaultValue
                        )
                    },
                    examples: cmdJSON.examples,
                    aliases: cmdJSON.aliases,
                    isBuiltIn: true
                )
                commands.append(command)
                await CommandParser.shared.register(command)
            }
        } else {
            // Fallback to hardcoded commands
            await loadFallbackCommands()
        }
    }
    
    private func loadFallbackCommands() async {
        let builtIn: [(String, String, CommandType, CommandCategory)] = [
            ("workflow", "Execute a workflow", .workflow, .workflow),
            ("run", "Run a command", .run, .system),
            ("search", "Search content", .search, .general),
            ("docs", "Search documentation", .docs, .documentation),
            ("help", "Show help", .help, .system),
            ("list", "List items", .list, .general),
            ("create", "Create item", .create, .general),
            ("delete", "Delete item", .delete, .general),
            ("config", "Configure settings", .config, .configuration),
            ("clear", "Clear screen", .clear, .system)
        ]
        
        for (name, desc, type, cat) in builtIn {
            let command = Command(name: name, description: desc, type: type, category: cat, isBuiltIn: true)
            commands.append(command)
            await CommandParser.shared.register(command)
        }
    }
}

// MARK: - JSON Models

private struct CommandsJSON: Codable {
    let version: String
    let commands: [CommandJSON]
}

private struct CommandJSON: Codable {
    let name: String
    let description: String
    let syntax: String
    let type: String
    let category: String
    let format: String
    let kind: String
    let parameters: [ParameterJSON]
    let examples: [String]
    let aliases: [String]
}

private struct ParameterJSON: Codable {
    let name: String
    let type: String
    let required: Bool
    let description: String
    let defaultValue: String?
}
