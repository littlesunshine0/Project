//
//  SectionModel.swift
//  DataKit
//

import Foundation

/// Section within a document
public struct SectionModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let content: String
    public let level: Int
    public let order: Int
    
    public init(id: String = UUID().uuidString, title: String, content: String = "", level: Int = 1, order: Int = 0) {
        self.id = id
        self.title = title
        self.content = content
        self.level = level
        self.order = order
    }
}
