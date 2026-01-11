//
//  ProjectScaffold.swift
//  ProjectScaffold
//
//  Main entry point for the ProjectScaffold library
//

import Foundation

/// Main entry point for ProjectScaffold
public struct ProjectScaffold {
    
    /// Project generator for creating new projects
    public static let projectGenerator = ProjectGenerator()
    
    /// Feature generator for creating feature modules
    public static let featureGenerator = FeatureGenerator()
    
    /// Create a new project with modular architecture
    public static func createProject(
        name: String,
        at path: URL,
        platform: Platform = .macOS,
        features: [String] = [],
        includeDatabase: Bool = true,
        includeCoreModule: Bool = true
    ) throws -> URL {
        let config = ProjectConfig(
            name: name,
            platform: platform,
            features: features,
            includeDatabase: includeDatabase,
            includeCoreModule: includeCoreModule
        )
        return try projectGenerator.createProject(config: config, at: path)
    }
    
    /// Create a new feature module
    public static func createFeature(
        name: String,
        at path: URL,
        description: String = "",
        tags: [String] = []
    ) throws -> URL {
        return try featureGenerator.createFeature(
            name: name,
            at: path,
            description: description,
            tags: tags
        )
    }
    
    /// Add a code unit to a feature
    public static func addCodeUnit(
        to featurePath: URL,
        name: String,
        kind: CodeKind,
        category: CodeCategory,
        tags: [String] = [],
        dependencies: [String] = []
    ) throws -> URL {
        return try featureGenerator.addCodeUnit(
            to: featurePath,
            name: name,
            kind: kind,
            category: category,
            tags: tags,
            dependencies: dependencies
        )
    }
}
