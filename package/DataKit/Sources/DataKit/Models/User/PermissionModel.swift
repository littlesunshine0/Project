//
//  PermissionModel.swift
//  DataKit
//

import Foundation

/// Permission model
public struct PermissionModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let type: PermissionType
    public var isGranted: Bool
    public let isRequired: Bool
    
    public init(id: String, name: String, description: String = "", type: PermissionType, isGranted: Bool = false, isRequired: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.isGranted = isGranted
        self.isRequired = isRequired
    }
}
