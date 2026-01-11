//
//  PackageManifest.swift
//  DataKit
//

import Foundation

/// Package manifest loaded from Package.manifest.json
public struct PackageManifest: Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let version: String
    public let description: String
    public let category: String
    public let kind: String
    public let type: String
    public let author: String?
    public let license: String?
    public let dependencies: [String]
    public let exports: [String]
    
    public init(id: String, name: String, version: String = "1.0.0", description: String = "", category: String = "utility", kind: String = "standard", type: String = "library", author: String? = nil, license: String? = nil, dependencies: [String] = [], exports: [String] = []) {
        self.id = id
        self.name = name
        self.version = version
        self.description = description
        self.category = category
        self.kind = kind
        self.type = type
        self.author = author
        self.license = license
        self.dependencies = dependencies
        self.exports = exports
    }
}
