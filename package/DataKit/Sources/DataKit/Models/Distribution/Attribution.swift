//
//  Attribution.swift
//  DataKit
//

import Foundation

/// Attribution for package credits
public struct Attribution: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let role: AttributionRole
    public let url: String?
    public let email: String?
    
    public init(id: String = UUID().uuidString, name: String, role: AttributionRole, url: String? = nil, email: String? = nil) {
        self.id = id
        self.name = name
        self.role = role
        self.url = url
        self.email = email
    }
}

public enum AttributionRole: String, Codable, Sendable, CaseIterable {
    case author, contributor, maintainer, sponsor, translator
}
