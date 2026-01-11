//
//  CommandGenerator.swift
//  CommandKit
//

import Foundation

public actor CommandGenerator {
    public static let shared = CommandGenerator()
    
    private init() {}
    
    // MARK: - Generate Commands
    
    public func generateFromDefinition(_ definition: CommandDefinition) -> Command {
        Command(
            name: definition.name,
            description: definition.description,
            syntax: definition.syntax,
            type: definition.type,
            category: definition.category,
            format: definition.format,
            kind: definition.kind,
            parameters: definition.parameters,
            examples: definition.examples,
            isBuiltIn: true
        )
    }
    
    public func generateBatch(from definitions: [CommandDefinition]) -> [Command] {
        definitions.map { generateFromDefinition($0) }
    }
    
    public func generateHelp(for command: Command) -> String {
        var help = """
        \(command.name.uppercased())
        
        DESCRIPTION
            \(command.description)
        
        SYNTAX
            \(command.syntax)
        
        """
        
        if !command.parameters.isEmpty {
            help += "PARAMETERS\n"
            for param in command.parameters {
                let required = param.required ? "(required)" : "(optional)"
                help += "    \(param.name) \(required)\n"
                help += "        \(param.description)\n"
                if let defaultValue = param.defaultValue {
                    help += "        Default: \(defaultValue)\n"
                }
            }
            help += "\n"
        }
        
        if !command.examples.isEmpty {
            help += "EXAMPLES\n"
            for example in command.examples {
                help += "    \(example)\n"
            }
            help += "\n"
        }
        
        if !command.aliases.isEmpty {
            help += "ALIASES\n"
            help += "    \(command.aliases.joined(separator: ", "))\n"
        }
        
        return help
    }
    
    public func generateMarkdownDocs(for commands: [Command]) -> String {
        var md = "# Command Reference\n\n"
        
        let grouped = Dictionary(grouping: commands) { $0.category }
        
        for category in CommandCategory.allCases {
            guard let categoryCommands = grouped[category], !categoryCommands.isEmpty else { continue }
            
            md += "## \(category.rawValue)\n\n"
            
            for command in categoryCommands.sorted(by: { $0.name < $1.name }) {
                md += "### /\(command.name)\n\n"
                md += "\(command.description)\n\n"
                md += "**Syntax:** `\(command.syntax)`\n\n"
                
                if !command.parameters.isEmpty {
                    md += "**Parameters:**\n"
                    for param in command.parameters {
                        md += "- `\(param.name)` (\(param.type.rawValue)): \(param.description)\n"
                    }
                    md += "\n"
                }
                
                if !command.examples.isEmpty {
                    md += "**Examples:**\n```\n"
                    md += command.examples.joined(separator: "\n")
                    md += "\n```\n\n"
                }
            }
        }
        
        return md
    }
}

public struct CommandDefinition: Codable, Sendable {
    public let name: String
    public let description: String
    public let syntax: String
    public let type: CommandType
    public let category: CommandCategory
    public let format: CommandFormat
    public let kind: CommandKind
    public let parameters: [CommandParameter]
    public let examples: [String]
    
    public init(
        name: String,
        description: String,
        syntax: String = "",
        type: CommandType = .run,
        category: CommandCategory = .general,
        format: CommandFormat = .slash,
        kind: CommandKind = .action,
        parameters: [CommandParameter] = [],
        examples: [String] = []
    ) {
        self.name = name
        self.description = description
        self.syntax = syntax.isEmpty ? "/\(name) [args...]" : syntax
        self.type = type
        self.category = category
        self.format = format
        self.kind = kind
        self.parameters = parameters
        self.examples = examples
    }
}
