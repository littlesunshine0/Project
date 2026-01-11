//
//  NodeMetadata.swift
//  DataKit
//

import Foundation

public struct NodeMetadata: Codable, Sendable, Hashable {
    public let tags: [String]
    public let source: String?
    public let version: Int
    
    public init(tags: [String] = [], source: String? = nil, version: Int = 1) {
        self.tags = tags
        self.source = source
        self.version = version
    }
}
