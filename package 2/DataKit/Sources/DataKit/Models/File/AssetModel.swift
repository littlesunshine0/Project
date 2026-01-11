//
//  AssetModel.swift
//  DataKit
//

import Foundation

/// Asset model
public struct AssetModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let type: AssetType
    public let url: String
    public let mimeType: String
    public let size: Int64
    public let dimensions: AssetDimensions?
    public let duration: TimeInterval?
    
    public init(id: String = UUID().uuidString, name: String, type: AssetType, url: String, mimeType: String, size: Int64 = 0, dimensions: AssetDimensions? = nil, duration: TimeInterval? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.url = url
        self.mimeType = mimeType
        self.size = size
        self.dimensions = dimensions
        self.duration = duration
    }
}
