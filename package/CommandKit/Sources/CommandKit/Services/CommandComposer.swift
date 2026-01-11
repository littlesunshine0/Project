//
//  CommandComposer.swift
//  CommandKit
//
//  Visual command composition and template system
//

import Foundation

// MARK: - Command Composer

@MainActor
public class CommandComposer: ObservableObject {
    public static let shared = CommandComposer()
    
    @Published public var composedCommands: [ComposedCommand] = []
    @Published public var templates: [CommandTemplate] = []
    @Published public var draftCommand: CommandDraft?
    @Published public var history: [CommandHistoryEntry] = []
    
    private let maxHistory = 100
    
    private init() {
        loadTemplates()
        loadHistory()
    }
    
    // MARK: - Composition
    
    public func startComposition(from template: CommandTemplate? = nil) -> CommandDraft {
        let draft = CommandDraft(template: template)
        draftCommand = draft
        return draft
    }
    
    public func addArgument(_ argument: CommandArgument) {
        draftCommand?.arguments.append(argument)
    }
    
    public func finalize() -> ComposedCommand? {
        guard let draft = draftCommand else { return nil }
        
        let command = ComposedCommand(
            name: draft.name,
            description: draft.description,
            script: draft.script,
            arguments: draft.arguments,
            category: draft.category,
            isFavorite: false
        )
        
        composedCommands.append(command)
        draftCommand = nil
        saveComposedCommands()
        
        return command
    }
    
    public func cancelComposition() {
        draftCommand = nil
    }
    
    // MARK: - Execution
    
    public func execute(_ command: ComposedCommand, arguments: [String: String] = [:]) async -> CommandResult {
        let startTime = Date()
        var script = command.script
        
        // Replace argument placeholders
        for (key, value) in arguments {
            script = script.replacingOccurrences(of: "${\(key)}", with: value)
        }
        
        let result = await executeScript(script)
        let endTime = Date()
        
        // Add to history
        let entry = CommandHistoryEntry(
            command: command.script,
            output: result.output,
            success: result.success,
            timestamp: startTime,
            duration: endTime.timeIntervalSince(startTime)
        )
        addToHistory(entry)
        
        return result
    }
    
    public func executeRaw(_ script: String) async -> CommandResult {
        let startTime = Date()
        let result = await executeScript(script)
        let endTime = Date()
        
        let entry = CommandHistoryEntry(
            command: script,
            output: result.output,
            success: result.success,
            timestamp: startTime,
            duration: endTime.timeIntervalSince(startTime)
        )
        addToHistory(entry)
        
        return result
    }
    
    private func executeScript(_ script: String) async -> CommandResult {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", script]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            
            let output = String(data: outputData, encoding: .utf8) ?? ""
            let error = String(data: errorData, encoding: .utf8)
            
            let success = process.terminationStatus == 0
            return CommandResult(
                success: success,
                output: output,
                error: success ? nil : error,
                exitCode: Int(process.terminationStatus)
            )
        } catch {
            return CommandResult(
                success: false,
                output: "",
                error: error.localizedDescription,
                exitCode: -1
            )
        }
    }
    
    // MARK: - History
    
    private func addToHistory(_ entry: CommandHistoryEntry) {
        history.insert(entry, at: 0)
        if history.count > maxHistory {
            history.removeLast()
        }
        saveHistory()
    }
    
    public func clearHistory() {
        history.removeAll()
        saveHistory()
    }
    
    // MARK: - Templates
    
    public func templates(for category: CommandCategory) -> [CommandTemplate] {
        templates.filter { $0.category == category }
    }
    
    private func loadTemplates() {
        templates = CommandTemplate.builtInTemplates
    }
    
    // MARK: - Persistence
    
    private func saveComposedCommands() {
        if let encoded = try? JSONEncoder().encode(composedCommands) {
            UserDefaults.standard.set(encoded, forKey: "composedCommands")
        }
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: "commandHistory"),
           let decoded = try? JSONDecoder().decode([CommandHistoryEntry].self, from: data) {
            history = decoded
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: "commandHistory")
        }
    }
}

// MARK: - Command Draft

public struct CommandDraft {
    public var name: String
    public var description: String
    public var script: String
    public var arguments: [CommandArgument]
    public var category: CommandCategory
    
    public init(template: CommandTemplate? = nil) {
        if let template = template {
            self.name = template.name
            self.description = template.description
            self.script = template.script
            self.arguments = template.arguments
            self.category = template.category
        } else {
            self.name = "New Command"
            self.description = ""
            self.script = ""
            self.arguments = []
            self.category = .general
        }
    }
}

// MARK: - Composed Command

public struct ComposedCommand: Codable, Identifiable, Sendable {
    public let id: UUID
    public var name: String
    public var description: String
    public var script: String
    public var arguments: [CommandArgument]
    public var category: CommandCategory
    public var isFavorite: Bool
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        script: String,
        arguments: [CommandArgument] = [],
        category: CommandCategory = .general,
        isFavorite: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.script = script
        self.arguments = arguments
        self.category = category
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }
}

// MARK: - Command Argument

public struct CommandArgument: Codable, Identifiable, Sendable {
    public let id: UUID
    public var name: String
    public var placeholder: String
    public var defaultValue: String?
    public var isRequired: Bool
    
    public init(id: UUID = UUID(), name: String, placeholder: String, defaultValue: String? = nil, isRequired: Bool = true) {
        self.id = id
        self.name = name
        self.placeholder = placeholder
        self.defaultValue = defaultValue
        self.isRequired = isRequired
    }
}

// MARK: - Command Result

public struct CommandResult: Sendable {
    public let success: Bool
    public let output: String
    public let error: String?
    public let exitCode: Int
    
    public init(success: Bool, output: String, error: String?, exitCode: Int) {
        self.success = success
        self.output = output
        self.error = error
        self.exitCode = exitCode
    }
}

// MARK: - Command History Entry

public struct CommandHistoryEntry: Codable, Identifiable, Sendable {
    public let id: UUID
    public let command: String
    public let output: String
    public let success: Bool
    public let timestamp: Date
    public let duration: TimeInterval
    
    public init(id: UUID = UUID(), command: String, output: String, success: Bool, timestamp: Date, duration: TimeInterval) {
        self.id = id
        self.command = command
        self.output = output
        self.success = success
        self.timestamp = timestamp
        self.duration = duration
    }
}

// MARK: - Command Template

public struct CommandTemplate: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let description: String
    public let script: String
    public let arguments: [CommandArgument]
    public let category: CommandCategory
    public let icon: String
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        script: String,
        arguments: [CommandArgument] = [],
        category: CommandCategory = .general,
        icon: String = "terminal"
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.script = script
        self.arguments = arguments
        self.category = category
        self.icon = icon
    }
    
    public static let builtInTemplates: [CommandTemplate] = [
        CommandTemplate(
            name: "Git Status",
            description: "Show working tree status",
            script: "git status",
            category: .general,
            icon: "arrow.triangle.branch"
        ),
        CommandTemplate(
            name: "Git Pull",
            description: "Fetch and merge from remote",
            script: "git pull",
            category: .general,
            icon: "arrow.down.circle"
        ),
        CommandTemplate(
            name: "Swift Build",
            description: "Build Swift package",
            script: "swift build",
            category: .general,
            icon: "hammer"
        ),
        CommandTemplate(
            name: "Swift Test",
            description: "Run Swift tests",
            script: "swift test",
            category: .general,
            icon: "checkmark.circle"
        ),
        CommandTemplate(
            name: "List Files",
            description: "List directory contents",
            script: "ls -la",
            category: .file,
            icon: "folder"
        ),
        CommandTemplate(
            name: "Disk Usage",
            description: "Show disk usage",
            script: "df -h",
            category: .system,
            icon: "internaldrive"
        )
    ]
}
