//
//  ContentModel.swift
//  DataKit
//

import Foundation

/// Generic content model
public struct ContentModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: ContentType
    public let title: String
    public let body: String
    public let format: ContentFormat
    public let metadata: ContentMetadata
    public let createdAt: Date
    public var updatedAt: Date
    
    public init(id: String = UUID().uuidString, type: ContentType = .article, title: String, body: String = "", format: ContentFormat = .markdown, metadata: ContentMetadata = ContentMetadata()) {
        self.id = id
        self.type = type
        self.title = title
        self.body = body
        self.format = format
        self.metadata = metadata
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
