//
//  PackageState.swift
//  DataKit
//

import Foundation

/// State of an individual package
public struct PackageState: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let packageId: String
    public var lifecycle: LifecycleState
    public var isActive: Bool
    public var lastError: ErrorModel?
    public var data: [String: AnyCodable]
    public let attachedAt: Date
    public var updatedAt: Date
    
    public init(id: String = UUID().uuidString, packageId: String, lifecycle: LifecycleState = .uninitialized, isActive: Bool = false, lastError: ErrorModel? = nil, data: [String: AnyCodable] = [:]) {
        self.id = id
        self.packageId = packageId
        self.lifecycle = lifecycle
        self.isActive = isActive
        self.lastError = lastError
        self.data = data
        self.attachedAt = Date()
        self.updatedAt = Date()
    }
}
