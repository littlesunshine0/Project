//
//  ConfigGenerator.swift
//  DocKit
//
//  Generates JSON configuration files: commands.json, workflows.json, actions.json, scripts.json, agents.json
//

import Foundation

/// Generates JSON configuration files for projects
public struct ConfigGenerator {
    
    // MARK: - Commands.json
    
    public struct CommandConfig: Codable, Sendable {
        public let name: String
        public let description: String
        public let syntax: String
        public let category: String
        public let shortcut: String?
        public let icon: String
        public let parameters: [CommandParameter]
        public let examples: [String]
        
        public init(name: String, description: String, syntax: String, category: String, shortcut: String? = nil, icon: String, parameters: [CommandParameter] = [], examples: [String] = []) {
            self.name = name
            self.description = description
            self.syntax = syntax
            self.category = category
            self.shortcut = shortcut
            self.icon = icon
            self.parameters = parameters
            self.examples = examples
        }
    }
    
    public struct CommandParameter: Codable, Sendable {
        public let name: String
        public let type: String
        public let required: Bool
        public let description: String
        public let defaultValue: String?
        
        public init(name: String, type: String, required: Bool, description: String, defaultValue: String? = nil) {
            self.name = name
            self.type = type
            self.required = required
            self.description = description
            self.defaultValue = defaultValue
        }
    }
    
    public static func generateCommands(_ commands: [CommandConfig], projectName: String) -> String {
        let output = CommandsFile(
            version: "1.0",
            projectName: projectName,
            generatedAt: ISO8601DateFormatter().string(from: Date()),
            generatedBy: "DocKit",
            commands: commands
        )
        return encodeJSON(output)
    }
    
    private struct CommandsFile: Codable {
        let version: String
        let projectName: String
        let generatedAt: String
        let generatedBy: String
        let commands: [CommandConfig]
    }
    
    // MARK: - Workflows.json
    
    public struct WorkflowConfig: Codable, Sendable {
        public let id: String
        public let name: String
        public let description: String
        public let trigger: String
        public let steps: [WorkflowStep]
        public let timeout: Int
        public let continueOnError: Bool
        
        public init(id: String, name: String, description: String, trigger: String, steps: [WorkflowStep], timeout: Int = 300, continueOnError: Bool = false) {
            self.id = id
            self.name = name
            self.description = description
            self.trigger = trigger
            self.steps = steps
            self.timeout = timeout
            self.continueOnError = continueOnError
        }
    }
    
    public struct WorkflowStep: Codable, Sendable {
        public let name: String
        public let action: String
        public let parameters: [String: String]
        public let condition: String?
        
        public init(name: String, action: String, parameters: [String: String] = [:], condition: String? = nil) {
            self.name = name
            self.action = action
            self.parameters = parameters
            self.condition = condition
        }
    }
    
    public static func generateWorkflows(_ workflows: [WorkflowConfig], projectName: String) -> String {
        let output = WorkflowsFile(
            version: "1.0",
            projectName: projectName,
            generatedAt: ISO8601DateFormatter().string(from: Date()),
            generatedBy: "DocKit",
            workflows: workflows
        )
        return encodeJSON(output)
    }
    
    private struct WorkflowsFile: Codable {
        let version: String
        let projectName: String
        let generatedAt: String
        let generatedBy: String
        let workflows: [WorkflowConfig]
    }
    
    // MARK: - Actions.json
    
    public struct ActionConfig: Codable, Sendable {
        public let id: String
        public let name: String
        public let description: String
        public let type: String
        public let handler: String
        public let inputs: [ActionInput]
        public let outputs: [ActionOutput]
        
        public init(id: String, name: String, description: String, type: String, handler: String, inputs: [ActionInput] = [], outputs: [ActionOutput] = []) {
            self.id = id
            self.name = name
            self.description = description
            self.type = type
            self.handler = handler
            self.inputs = inputs
            self.outputs = outputs
        }
    }
    
    public struct ActionInput: Codable, Sendable {
        public let name: String
        public let type: String
        public let required: Bool
        
        public init(name: String, type: String, required: Bool) {
            self.name = name
            self.type = type
            self.required = required
        }
    }
    
    public struct ActionOutput: Codable, Sendable {
        public let name: String
        public let type: String
        
        public init(name: String, type: String) {
            self.name = name
            self.type = type
        }
    }
    
    public static func generateActions(_ actions: [ActionConfig], projectName: String) -> String {
        let output = ActionsFile(
            version: "1.0",
            projectName: projectName,
            generatedAt: ISO8601DateFormatter().string(from: Date()),
            generatedBy: "DocKit",
            actions: actions
        )
        return encodeJSON(output)
    }
    
    private struct ActionsFile: Codable {
        let version: String
        let projectName: String
        let generatedAt: String
        let generatedBy: String
        let actions: [ActionConfig]
    }
    
    // MARK: - Scripts.json
    
    public struct ScriptConfig: Codable, Sendable {
        public let id: String
        public let name: String
        public let description: String
        public let language: String
        public let path: String
        public let arguments: [String]
        public let environment: [String: String]
        public let timeout: Int
        
        public init(id: String, name: String, description: String, language: String, path: String, arguments: [String] = [], environment: [String: String] = [:], timeout: Int = 60) {
            self.id = id
            self.name = name
            self.description = description
            self.language = language
            self.path = path
            self.arguments = arguments
            self.environment = environment
            self.timeout = timeout
        }
    }
    
    public static func generateScripts(_ scripts: [ScriptConfig], projectName: String) -> String {
        let output = ScriptsFile(
            version: "1.0",
            projectName: projectName,
            generatedAt: ISO8601DateFormatter().string(from: Date()),
            generatedBy: "DocKit",
            scripts: scripts
        )
        return encodeJSON(output)
    }
    
    private struct ScriptsFile: Codable {
        let version: String
        let projectName: String
        let generatedAt: String
        let generatedBy: String
        let scripts: [ScriptConfig]
    }
    
    // MARK: - Agents.json
    
    public struct AgentConfig: Codable, Sendable {
        public let id: String
        public let name: String
        public let description: String
        public let type: String
        public let triggers: [AgentTrigger]
        public let actions: [String]
        public let schedule: String?
        public let enabled: Bool
        
        public init(id: String, name: String, description: String, type: String, triggers: [AgentTrigger], actions: [String], schedule: String? = nil, enabled: Bool = true) {
            self.id = id
            self.name = name
            self.description = description
            self.type = type
            self.triggers = triggers
            self.actions = actions
            self.schedule = schedule
            self.enabled = enabled
        }
    }
    
    public struct AgentTrigger: Codable, Sendable {
        public let type: String
        public let condition: String
        
        public init(type: String, condition: String) {
            self.type = type
            self.condition = condition
        }
    }
    
    public static func generateAgents(_ agents: [AgentConfig], projectName: String) -> String {
        let output = AgentsFile(
            version: "1.0",
            projectName: projectName,
            generatedAt: ISO8601DateFormatter().string(from: Date()),
            generatedBy: "DocKit",
            agents: agents
        )
        return encodeJSON(output)
    }
    
    private struct AgentsFile: Codable {
        let version: String
        let projectName: String
        let generatedAt: String
        let generatedBy: String
        let agents: [AgentConfig]
    }
    
    // MARK: - Helper
    
    private static func encodeJSON<T: Encodable>(_ value: T) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let data = try? encoder.encode(value),
           let json = String(data: data, encoding: .utf8) {
            return json
        }
        return "{}"
    }
}
