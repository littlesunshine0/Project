//
//  DocumentModel.swift
//  DataKit
//

import Foundation

/// Document model
public struct DocumentModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let sections: [SectionModel]
    public let format: ContentFormat
    public let createdAt: Date
    public var updatedAt: Date
    
    public init(id: String = UUID().uuidString, title: String, sections: [SectionModel] = [], format: ContentFormat = .markdown) {
        self.id = id
        self.title = title
        self.sections = sections
        self.format = format
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
