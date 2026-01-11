//
//  SyncState.swift
//  DataKit
//

import Foundation

/// Synchronization state for offline-first
public struct SyncState: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public var status: SyncStatus
    public var pendingChanges: Int
    public var lastSyncAt: Date?
    public var nextSyncAt: Date?
    public var error: ErrorModel?
    
    public init(id: String = UUID().uuidString, status: SyncStatus = .synced, pendingChanges: Int = 0, lastSyncAt: Date? = nil) {
        self.id = id
        self.status = status
        self.pendingChanges = pendingChanges
        self.lastSyncAt = lastSyncAt
    }
}

public enum SyncStatus: String, Codable, Sendable, CaseIterable {
    case synced, syncing, pending, offline, error
}
