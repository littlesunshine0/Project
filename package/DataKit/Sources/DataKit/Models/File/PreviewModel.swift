//
//  PreviewModel.swift
//  DataKit
//

import Foundation

/// Preview model
public struct PreviewModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let sourceId: String
    public let type: PreviewType
    public let url: String?
    public let thumbnail: String?
    public let metadata: [String: String]
    
    public init(id: String = UUID().uuidString, sourceId: String, type: PreviewType, url: String? = nil, thumbnail: String? = nil, metadata: [String: String] = [:]) {
        self.id = id
        self.sourceId = sourceId
        self.type = type
        self.url = url
        self.thumbnail = thumbnail
        self.metadata = metadata
    }
}
