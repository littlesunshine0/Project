//
//  AgentModel.swift
//  DataKit
//

import Foundation

/// Agent definition
public struct AgentModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let triggers: [TriggerModel]
    public let actions: [String]
    public let config: AgentConfig
    
    public init(id: String, name: String, description: String = "", triggers: [TriggerModel] = [], actions: [String] = [], config: AgentConfig = AgentConfig()) {
        self.id = id
        self.name = name
        self.description = description
        self.triggers = triggers
        self.actions = actions
        self.config = config
    }
}
