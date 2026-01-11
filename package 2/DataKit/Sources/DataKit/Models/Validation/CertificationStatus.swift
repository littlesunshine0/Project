//
//  CertificationStatus.swift
//  DataKit
//

import Foundation

/// Package certification status
public struct CertificationStatus: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let packageId: String
    public let level: CertificationLevel
    public let badges: [CertificationBadge]
    public let issuedAt: Date
    public let expiresAt: Date?
    public let issuer: String
    
    public init(id: String = UUID().uuidString, packageId: String, level: CertificationLevel, badges: [CertificationBadge] = [], expiresAt: Date? = nil, issuer: String = "FlowKit") {
        self.id = id
        self.packageId = packageId
        self.level = level
        self.badges = badges
        self.issuedAt = Date()
        self.expiresAt = expiresAt
        self.issuer = issuer
    }
    
    public var isValid: Bool {
        guard let expires = expiresAt else { return true }
        return Date() < expires
    }
}

public enum CertificationLevel: String, Codable, Sendable, CaseIterable {
    case none, basic, verified, certified, premium
}

public struct CertificationBadge: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let icon: String
    public let description: String
    
    public init(id: String, name: String, icon: String, description: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.description = description
    }
}
