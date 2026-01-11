//
//  AgentGenerator.swift
//  AgentKit
//

import Foundation

public actor AgentGenerator {
    public static let shared = AgentGenerator()
    
    private init() {}
    
    // MARK: - Generate Agents
    
    public func generateFromDefinition(_ definition: AgentDefinition) -> Agent {
        Agent(
            name: definition.name,
            description: definition.description,
            type: definition.type,
            capabilities: definition.capabilities,
            triggers: definition.triggers,
            actions: definition.actions
        )
    }
    
    public func generateBatch(from definitions: [AgentDefinition]) -> [Agent] {
        definitions.map { generateFromDefinition($0) }
    }
    
    public func generateYAML(for agent: Agent) -> String {
        var yaml = """
        name: \(agent.name)
        description: \(agent.description)
        type: \(agent.type.rawValue)
        status: \(agent.status.rawValue)
        capabilities:
        """
        
        for capability in agent.capabilities {
            yaml += "\n  - \(capability.rawValue)"
        }
        
        yaml += "\ntriggers:"
        for trigger in agent.triggers {
            yaml += "\n  - type: \(trigger.type.rawValue)"
            yaml += "\n    condition: \(trigger.condition)"
        }
        
        yaml += "\nactions:"
        for action in agent.actions {
            yaml += "\n  - name: \(action.name)"
            yaml += "\n    type: \(action.type.rawValue)"
            yaml += "\n    command: \(action.command)"
        }
        
        return yaml
    }
    
    public func generateJSON(for agent: Agent) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        if let data = try? encoder.encode(agent),
           let json = String(data: data, encoding: .utf8) {
            return json
        }
        
        return "{}"
    }
    
    public func generateMarkdownDocs(for agents: [Agent]) -> String {
        var md = "# Agent Reference\n\n"
        
        let grouped = Dictionary(grouping: agents) { $0.type }
        
        for type in AgentType.allCases {
            guard let typeAgents = grouped[type], !typeAgents.isEmpty else { continue }
            
            md += "## \(type.rawValue)\n\n"
            
            for agent in typeAgents.sorted(by: { $0.name < $1.name }) {
                md += "### \(agent.name)\n\n"
                md += "\(agent.description)\n\n"
                md += "**Status:** \(agent.status.rawValue)\n\n"
                
                if !agent.capabilities.isEmpty {
                    md += "**Capabilities:**\n"
                    for cap in agent.capabilities {
                        md += "- \(cap.rawValue)\n"
                    }
                    md += "\n"
                }
            }
        }
        
        return md
    }
}

public struct AgentDefinition: Sendable {
    public let name: String
    public let description: String
    public let type: AgentType
    public let capabilities: [AgentCapability]
    public let triggers: [AgentTrigger]
    public let actions: [AgentAction]
    
    public init(
        name: String,
        description: String,
        type: AgentType = .task,
        capabilities: [AgentCapability] = [],
        triggers: [AgentTrigger] = [],
        actions: [AgentAction] = []
    ) {
        self.name = name
        self.description = description
        self.type = type
        self.capabilities = capabilities
        self.triggers = triggers
        self.actions = actions
    }
}
