//
//  FormatModel.swift
//  DataKit
//

import Foundation

/// Format model
public struct FormatModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let extension_: String
    public let mimeType: String
    public let category: FormatCategory
    public let isSupported: Bool
    
    public init(id: String, name: String, extension_: String, mimeType: String, category: FormatCategory, isSupported: Bool = true) {
        self.id = id
        self.name = name
        self.extension_ = extension_
        self.mimeType = mimeType
        self.category = category
        self.isSupported = isSupported
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, extension_ = "extension", mimeType, category, isSupported
    }
}
