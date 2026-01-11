//
//  PackageModel.swift
//  DataKit
//

import Foundation

/// Package identity and metadata
public struct PackageModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let version: String
    public let category: PackageCategory
    public let kind: PackageKind
    public let type: PackageType
    
    public init(id: String, name: String, version: String = "1.0.0", category: PackageCategory = .utility, kind: PackageKind = .standard, type: PackageType = .library) {
        self.id = id
        self.name = name
        self.version = version
        self.category = category
        self.kind = kind
        self.type = type
    }
}
