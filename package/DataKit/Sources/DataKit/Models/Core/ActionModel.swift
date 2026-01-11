//
//  ActionModel.swift
//  DataKit
//

import Foundation

/// Universal action definition
public struct ActionModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let icon: String
    public let category: ActionCategory
    public let input: [ParameterModel]
    public let output: String
    public let shortcut: String?
    
    public init(id: String, name: String, description: String, icon: String = "play", category: ActionCategory = .general, input: [ParameterModel] = [], output: String = "Void", shortcut: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.category = category
        self.input = input
        self.output = output
        self.shortcut = shortcut
    }
}
