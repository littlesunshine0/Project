//
//  ContentMetadata.swift
//  DataKit
//

import Foundation

public struct ContentMetadata: Codable, Sendable, Hashable {
    public let author: String?
    public let tags: [String]
    public let version: Int
    public let isPublished: Bool
    
    public init(author: String? = nil, tags: [String] = [], version: Int = 1, isPublished: Bool = false) {
        self.author = author
        self.tags = tags
        self.version = version
        self.isPublished = isPublished
    }
}
