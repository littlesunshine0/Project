//
//  FileMetadata.swift
//  DataKit
//

import Foundation

public struct FileMetadata: Codable, Sendable, Hashable {
    public let isHidden: Bool
    public let isReadOnly: Bool
    public let permissions: String?
    public let owner: String?
    
    public init(isHidden: Bool = false, isReadOnly: Bool = false, permissions: String? = nil, owner: String? = nil) {
        self.isHidden = isHidden
        self.isReadOnly = isReadOnly
        self.permissions = permissions
        self.owner = owner
    }
}
