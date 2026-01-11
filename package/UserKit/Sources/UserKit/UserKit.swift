//
//  UserKit.swift
//  UserKit - User Profile & Preferences Management
//

import Foundation

// MARK: - User Profile

public struct UserProfile: Identifiable, Sendable {
    public let id: String
    public var name: String
    public var email: String?
    public var avatar: String?
    public var preferences: [String: String]
    public let createdAt: Date
    public var updatedAt: Date
    
    public init(id: String = UUID().uuidString, name: String, email: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.avatar = nil
        self.preferences = [:]
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - User Session

public struct UserSession: Identifiable, Sendable {
    public let id: String
    public let userId: String
    public let startedAt: Date
    public var lastActiveAt: Date
    public var isActive: Bool
    
    public init(userId: String) {
        self.id = UUID().uuidString
        self.userId = userId
        self.startedAt = Date()
        self.lastActiveAt = Date()
        self.isActive = true
    }
}

// MARK: - User Manager

public actor UserManager {
    public static let shared = UserManager()
    
    private var profiles: [String: UserProfile] = [:]
    private var sessions: [String: UserSession] = [:]
    private var currentUserId: String?
    
    private init() {}
    
    public func createProfile(name: String, email: String? = nil) -> UserProfile {
        let profile = UserProfile(name: name, email: email)
        profiles[profile.id] = profile
        return profile
    }
    
    public func getProfile(_ id: String) -> UserProfile? {
        profiles[id]
    }
    
    public func updateProfile(_ id: String, name: String? = nil, email: String? = nil) -> UserProfile? {
        guard var profile = profiles[id] else { return nil }
        if let name = name { profile.name = name }
        if let email = email { profile.email = email }
        profile.updatedAt = Date()
        profiles[id] = profile
        return profile
    }
    
    public func setPreference(_ key: String, value: String, for userId: String) {
        guard var profile = profiles[userId] else { return }
        profile.preferences[key] = value
        profile.updatedAt = Date()
        profiles[userId] = profile
    }
    
    public func getPreference(_ key: String, for userId: String) -> String? {
        profiles[userId]?.preferences[key]
    }
    
    public func startSession(userId: String) -> UserSession {
        let session = UserSession(userId: userId)
        sessions[session.id] = session
        currentUserId = userId
        return session
    }
    
    public func endSession(_ sessionId: String) {
        sessions[sessionId]?.isActive = false
        if sessions[sessionId]?.userId == currentUserId {
            currentUserId = nil
        }
    }
    
    public func getCurrentUser() -> UserProfile? {
        guard let id = currentUserId else { return nil }
        return profiles[id]
    }
    
    public var stats: UserStats {
        UserStats(
            totalProfiles: profiles.count,
            activeSessions: sessions.values.filter { $0.isActive }.count
        )
    }
}

public struct UserStats: Sendable {
    public let totalProfiles: Int
    public let activeSessions: Int
}
