//
//  CommandModel.swift
//  DataKit
//

import Foundation

/// Command definition
public struct CommandModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let syntax: String
    public let name: String
    public let description: String
    public let category: String
    public let handler: String
    public let parameters: [ParameterModel]
    
    public init(id: String, syntax: String, name: String, description: String = "", category: String = "general", handler: String, parameters: [ParameterModel] = []) {
        self.id = id
        self.syntax = syntax
        self.name = name
        self.description = description
        self.category = category
        self.handler = handler
        self.parameters = parameters
    }
}
