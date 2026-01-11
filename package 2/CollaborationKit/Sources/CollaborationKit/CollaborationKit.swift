//
//  CollaborationKit.swift
//  CollaborationKit
//
//  Multi-user collaboration, conflict resolution, version control
//

import Foundation

public struct CollaborationKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.collaborationkit"
    public init() {}
}

// MARK: - Collaboration Manager

public actor CollaborationManager {
    public static let shared = CollaborationManager()
    
    private var sessions: [UUID: CollaborationSession] = [:]
    private var users: [String: CollaboratorInfo] = [:]
    private var locks: [String: ResourceLock] = [:]
    
    private init() {}
    
    public func createSession(name: String, ownerId: String) -> CollaborationSession {
        let session = CollaborationSession(name: name, ownerId: ownerId)
        sessions[session.id] = session
        return session
    }
    
    public func joinSession(_ sessionId: UUID, userId: String, name: String) -> Bool {
        guard var session = sessions[sessionId] else { return false }
        let collaborator = CollaboratorInfo(id: userId, name: name)
        session.collaborators.append(collaborator)
        users[userId] = collaborator
        sessions[sessionId] = session
        return true
    }

    public func leaveSession(_ sessionId: UUID, userId: String) {
        guard var session = sessions[sessionId] else { return }
        session.collaborators.removeAll { $0.id == userId }
        sessions[sessionId] = session
    }
    
    public func getSession(_ id: UUID) -> CollaborationSession? { sessions[id] }
    public func getAllSessions() -> [CollaborationSession] { Array(sessions.values) }
    
    // MARK: - Resource Locking
    
    public func lock(resource: String, by userId: String) -> Bool {
        if locks[resource] != nil { return false }
        locks[resource] = ResourceLock(resourceId: resource, lockedBy: userId)
        return true
    }
    
    public func unlock(resource: String, by userId: String) -> Bool {
        guard let lock = locks[resource], lock.lockedBy == userId else { return false }
        locks.removeValue(forKey: resource)
        return true
    }
    
    public func isLocked(_ resource: String) -> Bool { locks[resource] != nil }
    public func getLock(_ resource: String) -> ResourceLock? { locks[resource] }
    
    public var stats: CollaborationStats {
        CollaborationStats(
            sessionCount: sessions.count,
            activeUsers: users.count,
            lockedResources: locks.count
        )
    }
}

// MARK: - Conflict Resolver

public actor ConflictResolver {
    public static let shared = ConflictResolver()
    
    private var conflicts: [UUID: Conflict] = [:]
    private var resolutions: [UUID: Resolution] = [:]
    
    private init() {}
    
    public func detectConflict(resource: String, version1: String, version2: String, user1: String, user2: String) -> Conflict {
        let conflict = Conflict(resourceId: resource, version1: version1, version2: version2, user1: user1, user2: user2)
        conflicts[conflict.id] = conflict
        return conflict
    }
    
    public func resolve(_ conflictId: UUID, strategy: ResolutionStrategy, resolvedContent: String, resolvedBy: String) -> Resolution {
        let resolution = Resolution(conflictId: conflictId, strategy: strategy, resolvedContent: resolvedContent, resolvedBy: resolvedBy)
        resolutions[conflictId] = resolution
        conflicts.removeValue(forKey: conflictId)
        return resolution
    }
    
    public func getConflict(_ id: UUID) -> Conflict? { conflicts[id] }
    public func getPendingConflicts() -> [Conflict] { Array(conflicts.values) }
    
    public func autoMerge(version1: String, version2: String) -> String? {
        // Simple line-based merge
        let lines1 = version1.components(separatedBy: .newlines)
        let lines2 = version2.components(separatedBy: .newlines)
        
        if lines1 == lines2 { return version1 }
        
        // If one is subset of other, take longer
        if lines1.count > lines2.count { return version1 }
        if lines2.count > lines1.count { return version2 }
        
        return nil // Cannot auto-merge
    }
}

// MARK: - Version Control

public actor VersionControl {
    public static let shared = VersionControl()
    
    private var versions: [String: [Version]] = [:]  // resource -> versions
    private var branches: [String: Branch] = [:]
    
    private init() {}
    
    public func commit(resource: String, content: String, message: String, author: String) -> Version {
        let version = Version(resourceId: resource, content: content, message: message, author: author, number: (versions[resource]?.count ?? 0) + 1)
        versions[resource, default: []].append(version)
        return version
    }
    
    public func getVersions(for resource: String) -> [Version] { versions[resource] ?? [] }
    
    public func getVersion(resource: String, number: Int) -> Version? {
        versions[resource]?.first { $0.number == number }
    }
    
    public func getLatest(for resource: String) -> Version? { versions[resource]?.last }
    
    public func createBranch(name: String, from resource: String) -> Branch {
        let branch = Branch(name: name, baseResource: resource, baseVersion: versions[resource]?.last?.number ?? 0)
        branches[name] = branch
        return branch
    }
    
    public func getBranch(_ name: String) -> Branch? { branches[name] }
    
    public func diff(resource: String, from: Int, to: Int) -> String? {
        guard let v1 = getVersion(resource: resource, number: from),
              let v2 = getVersion(resource: resource, number: to) else { return nil }
        return "Diff from v\(from) to v\(to): \(v1.content.count) -> \(v2.content.count) chars"
    }
}

// MARK: - Models

public struct CollaborationSession: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let ownerId: String
    public var collaborators: [CollaboratorInfo]
    public let createdAt: Date
    
    public init(id: UUID = UUID(), name: String, ownerId: String, collaborators: [CollaboratorInfo] = [], createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.ownerId = ownerId
        self.collaborators = collaborators
        self.createdAt = createdAt
    }
}

public struct CollaboratorInfo: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let joinedAt: Date
    
    public init(id: String, name: String, joinedAt: Date = Date()) {
        self.id = id
        self.name = name
        self.joinedAt = joinedAt
    }
}

public struct ResourceLock: Sendable {
    public let resourceId: String
    public let lockedBy: String
    public let lockedAt: Date
    
    public init(resourceId: String, lockedBy: String, lockedAt: Date = Date()) {
        self.resourceId = resourceId
        self.lockedBy = lockedBy
        self.lockedAt = lockedAt
    }
}

public struct Conflict: Identifiable, Sendable {
    public let id: UUID
    public let resourceId: String
    public let version1: String
    public let version2: String
    public let user1: String
    public let user2: String
    public let detectedAt: Date
    
    public init(id: UUID = UUID(), resourceId: String, version1: String, version2: String, user1: String, user2: String, detectedAt: Date = Date()) {
        self.id = id
        self.resourceId = resourceId
        self.version1 = version1
        self.version2 = version2
        self.user1 = user1
        self.user2 = user2
        self.detectedAt = detectedAt
    }
}

public struct Resolution: Sendable {
    public let conflictId: UUID
    public let strategy: ResolutionStrategy
    public let resolvedContent: String
    public let resolvedBy: String
    public let resolvedAt: Date
    
    public init(conflictId: UUID, strategy: ResolutionStrategy, resolvedContent: String, resolvedBy: String, resolvedAt: Date = Date()) {
        self.conflictId = conflictId
        self.strategy = strategy
        self.resolvedContent = resolvedContent
        self.resolvedBy = resolvedBy
        self.resolvedAt = resolvedAt
    }
}

public enum ResolutionStrategy: String, Sendable, CaseIterable {
    case keepFirst, keepSecond, merge, manual
}

public struct Version: Identifiable, Sendable {
    public let id: UUID
    public let resourceId: String
    public let content: String
    public let message: String
    public let author: String
    public let number: Int
    public let createdAt: Date
    
    public init(id: UUID = UUID(), resourceId: String, content: String, message: String, author: String, number: Int, createdAt: Date = Date()) {
        self.id = id
        self.resourceId = resourceId
        self.content = content
        self.message = message
        self.author = author
        self.number = number
        self.createdAt = createdAt
    }
}

public struct Branch: Sendable {
    public let name: String
    public let baseResource: String
    public let baseVersion: Int
    public let createdAt: Date
    
    public init(name: String, baseResource: String, baseVersion: Int, createdAt: Date = Date()) {
        self.name = name
        self.baseResource = baseResource
        self.baseVersion = baseVersion
        self.createdAt = createdAt
    }
}

public struct CollaborationStats: Sendable {
    public let sessionCount: Int
    public let activeUsers: Int
    public let lockedResources: Int
}
