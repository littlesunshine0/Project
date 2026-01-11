//
//  CapabilityModel.swift
//  DataKit
//

import Foundation

/// Capability model
public struct CapabilityModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let isEnabled: Bool
    public let requirements: [String]
    
    public init(id: String, name: String, description: String = "", isEnabled: Bool = true, requirements: [String] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.isEnabled = isEnabled
        self.requirements = requirements
    }
}
