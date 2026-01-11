//
//  WorkflowModel.swift
//  DataKit
//

import Foundation

/// Workflow definition
public struct WorkflowModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let steps: [StepModel]
    public let triggers: [String]
    public let isEnabled: Bool
    
    public init(id: String, name: String, description: String = "", steps: [StepModel] = [], triggers: [String] = [], isEnabled: Bool = true) {
        self.id = id
        self.name = name
        self.description = description
        self.steps = steps
        self.triggers = triggers
        self.isEnabled = isEnabled
    }
}
