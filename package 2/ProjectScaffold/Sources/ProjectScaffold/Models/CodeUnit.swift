//
//  CodeUnit.swift
//  ProjectScaffold
//
//  Represents a single code unit (struct, class, enum, etc.)
//

import Foundation

/// A single code unit that can be tracked in the database
public struct CodeUnit: Codable, Identifiable {
    public let id: UUID
    public var fileName: String
    public var filePath: String
    public var featureId: UUID?
    public var category: CodeCategory
    public var kind: CodeKind
    public var name: String
    public var description: String
    public var tags: [String]
    public var dependencies: [String]
    public var lineCount: Int
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        fileName: String,
        filePath: String,
        featureId: UUID? = nil,
        category: CodeCategory,
        kind: CodeKind,
        name: String,
        description: String = "",
        tags: [String] = [],
        dependencies: [String] = [],
        lineCount: Int = 0,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.fileName = fileName
        self.filePath = filePath
        self.featureId = featureId
        self.category = category
        self.kind = kind
        self.name = name
        self.description = description
        self.tags = tags
        self.dependencies = dependencies
        self.lineCount = lineCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
