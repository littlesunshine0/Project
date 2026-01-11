//
//  UserModel.swift
//  DataKit
//

import Foundation

/// User model
public struct UserModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let username: String
    public let displayName: String
    public let email: String?
    public let avatar: String?
    public let role: RoleModel
    public let preferences: PreferenceModel
    public let createdAt: Date
    public var lastActiveAt: Date
    
    public init(id: String = UUID().uuidString, username: String, displayName: String, email: String? = nil, avatar: String? = nil, role: RoleModel = .user, preferences: PreferenceModel = PreferenceModel()) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.email = email
        self.avatar = avatar
        self.role = role
        self.preferences = preferences
        self.createdAt = Date()
        self.lastActiveAt = Date()
    }
}
