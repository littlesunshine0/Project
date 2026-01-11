//
//  AgentParser.swift
//  AgentKit
//

import Foundation

public actor AgentParser {
    public static let shared = AgentParser()
    
    private init() {}
    
    // MARK: - Parse YAML
    
    public func parseYAML(_ yaml: String) throws -> Agent {
        var name = ""
        var description = ""
        var type = AgentType.task
        var capabilities: [AgentCapability] = []
        
        let lines = yaml.components(separatedBy: .newlines)
        var currentSection = ""
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            if trimmed.hasPrefix("name:") {
                name = trimmed.replacingOccurrences(of: "name:", with: "").trimmingCharacters(in: .whitespaces)
            } else if trimmed.hasPrefix("description:") {
                description = trimmed.replacingOccurrences(of: "description:", with: "").trimmingCharacters(in: .whitespaces)
            } else if trimmed.hasPrefix("type:") {
                let typeStr = trimmed.replacingOccurrences(of: "type:", with: "").trimmingCharacters(in: .whitespaces)
                type = AgentType(rawValue: typeStr) ?? .task
            } else if trimmed == "capabilities:" {
                currentSection = "capabilities"
            } else if trimmed.hasPrefix("- ") && currentSection == "capabilities" {
                let capStr = trimmed.replacingOccurrences(of: "- ", with: "")
                if let cap = AgentCapability(rawValue: capStr) {
                    capabilities.append(cap)
                }
            }
        }
        
        guard !name.isEmpty else {
            throw AgentError.configurationInvalid("Missing agent name")
        }
        
        return Agent(
            name: name,
            description: description,
            type: type,
            capabilities: capabilities
        )
    }
    
    // MARK: - Parse JSON
    
    public func parseJSON(_ json: String) throws -> Agent {
        guard let data = json.data(using: .utf8) else {
            throw AgentError.configurationInvalid("Invalid JSON encoding")
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(Agent.self, from: data)
    }
    
    // MARK: - Validation
    
    public func validate(_ agent: Agent) -> ValidationResult {
        var errors: [String] = []
        
        if agent.name.isEmpty {
            errors.append("Agent name is required")
        }
        
        if agent.capabilities.isEmpty {
            errors.append("Agent must have at least one capability")
        }
        
        return ValidationResult(
            isValid: errors.isEmpty,
            errors: errors
        )
    }
}

public struct ValidationResult: Sendable {
    public let isValid: Bool
    public let errors: [String]
}
