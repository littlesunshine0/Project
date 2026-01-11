//
//  FileModel.swift
//  DataKit
//

import Foundation

/// File model
public struct FileModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let path: String
    public let type: FileType
    public let format: FormatModel
    public let size: Int64
    public let encoding: EncodingModel?
    public let metadata: FileMetadata
    public let createdAt: Date
    public var modifiedAt: Date
    
    public init(id: String = UUID().uuidString, name: String, path: String, type: FileType, format: FormatModel, size: Int64 = 0, encoding: EncodingModel? = nil, metadata: FileMetadata = FileMetadata()) {
        self.id = id
        self.name = name
        self.path = path
        self.type = type
        self.format = format
        self.size = size
        self.encoding = encoding
        self.metadata = metadata
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
}
