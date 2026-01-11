//
//  DependencyModel.swift
//  DataKit
//

import Foundation

/// Dependency model
public struct DependencyModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let version: String
    public let type: DependencyType
    public let isRequired: Bool
    public let resolvedVersion: String?
    
    public init(id: String, name: String, version: String, type: DependencyType = .package, isRequired: Bool = true, resolvedVersion: String? = nil) {
        self.id = id
        self.name = name
        self.version = version
        self.type = type
        self.isRequired = isRequired
        self.resolvedVersion = resolvedVersion
    }
}
