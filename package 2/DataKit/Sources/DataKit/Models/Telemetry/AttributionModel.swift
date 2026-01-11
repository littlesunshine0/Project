//
//  AttributionModel.swift
//  DataKit
//

import Foundation

/// Attribution model for tracking sources
public struct AttributionModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let source: String
    public let medium: String?
    public let campaign: String?
    public let content: String?
    public let term: String?
    public let referrer: String?
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, source: String, medium: String? = nil, campaign: String? = nil, content: String? = nil, term: String? = nil, referrer: String? = nil) {
        self.id = id
        self.source = source
        self.medium = medium
        self.campaign = campaign
        self.content = content
        self.term = term
        self.referrer = referrer
        self.timestamp = Date()
    }
}
