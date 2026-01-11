//
//  NodeModel.swift
//  DataKit
//

import Foundation

/// Universal node in the CoreKit graph
public struct NodeModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: String
    public let name: String
    public let data: [String: AnyCodable]
    public let metadata: NodeMetadata
    public let createdAt: Date
    public var updatedAt: Date
    
    public init(id: String = UUID().uuidString, type: String, name: String, data: [String: AnyCodable] = [:], metadata: NodeMetadata = NodeMetadata()) {
        self.id = id
        self.type = type
        self.name = name
        self.data = data
        self.metadata = metadata
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
