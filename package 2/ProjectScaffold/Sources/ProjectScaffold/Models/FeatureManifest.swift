//
//  FeatureManifest.swift
//  ProjectScaffold
//
//  Defines the structure of a feature module
//

import Foundation

/// Manifest describing a feature module
public struct FeatureManifest: Codable {
    public var feature: String
    public var version: String
    public var description: String
    public var tags: [String]
    public var files: FeatureFiles
    public var combined: [String: String]
    public var externalDependencies: [String]
    public var projectConnections: [String]
    
    public init(
        feature: String,
        version: String = "1.0.0",
        description: String = "",
        tags: [String] = [],
        files: FeatureFiles = FeatureFiles(),
        combined: [String: String] = [:],
        externalDependencies: [String] = ["Foundation"],
        projectConnections: [String] = []
    ) {
        self.feature = feature
        self.version = version
        self.description = description
        self.tags = tags
        self.files = files
        self.combined = combined
        self.externalDependencies = externalDependencies
        self.projectConnections = projectConnections
    }
}

/// Files within a feature module
public struct FeatureFiles: Codable {
    public var models: [FileEntry]
    public var services: [FileEntry]
    public var views: [FileEntry]
    public var viewModels: [FileEntry]
    public var protocols: [FileEntry]
    
    public init(
        models: [FileEntry] = [],
        services: [FileEntry] = [],
        views: [FileEntry] = [],
        viewModels: [FileEntry] = [],
        protocols: [FileEntry] = []
    ) {
        self.models = models
        self.services = services
        self.views = views
        self.viewModels = viewModels
        self.protocols = protocols
    }
}

/// Entry for a single file in the manifest
public struct FileEntry: Codable {
    public var file: String
    public var kind: CodeKind
    public var name: String
    public var tags: [String]
    public var dependencies: [String]
    
    public init(
        file: String,
        kind: CodeKind,
        name: String,
        tags: [String] = [],
        dependencies: [String] = []
    ) {
        self.file = file
        self.kind = kind
        self.name = name
        self.tags = tags
        self.dependencies = dependencies
    }
}

/// Kind of code unit
public enum CodeKind: String, Codable, CaseIterable {
    case `struct`
    case `class`
    case `enum`
    case `protocol`
    case actor
    case `extension`
}

/// Category of code unit
public enum CodeCategory: String, Codable, CaseIterable {
    case models
    case services
    case views
    case viewModels
    case protocols
}
