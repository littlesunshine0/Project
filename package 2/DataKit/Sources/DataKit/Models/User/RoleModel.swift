//
//  RoleModel.swift
//  DataKit
//

import Foundation

/// Role model
public struct RoleModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let permissions: [String]
    public let level: Int
    
    public init(id: String, name: String, permissions: [String] = [], level: Int = 0) {
        self.id = id
        self.name = name
        self.permissions = permissions
        self.level = level
    }
    
    public static let guest = RoleModel(id: "guest", name: "Guest", permissions: ["read"], level: 0)
    public static let user = RoleModel(id: "user", name: "User", permissions: ["read", "write"], level: 1)
    public static let admin = RoleModel(id: "admin", name: "Admin", permissions: ["read", "write", "delete", "admin"], level: 2)
}
