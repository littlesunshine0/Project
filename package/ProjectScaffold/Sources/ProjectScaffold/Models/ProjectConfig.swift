//
//  ProjectConfig.swift
//  ProjectScaffold
//
//  Configuration for a new project
//

import Foundation

/// Configuration for creating a new project
public struct ProjectConfig: Codable {
    public var name: String
    public var bundleIdentifier: String
    public var platform: Platform
    public var features: [String]
    public var includeDatabase: Bool
    public var includeCoreModule: Bool
    public var author: String?
    public var organization: String?
    
    public init(
        name: String,
        bundleIdentifier: String? = nil,
        platform: Platform = .macOS,
        features: [String] = [],
        includeDatabase: Bool = true,
        includeCoreModule: Bool = true,
        author: String? = nil,
        organization: String? = nil
    ) {
        self.name = name
        self.bundleIdentifier = bundleIdentifier ?? "com.example.\(name.lowercased())"
        self.platform = platform
        self.features = features
        self.includeDatabase = includeDatabase
        self.includeCoreModule = includeCoreModule
        self.author = author
        self.organization = organization
    }
}

/// Target platform
public enum Platform: String, Codable, CaseIterable {
    case macOS
    case iOS
    case visionOS
    case multiplatform
}
