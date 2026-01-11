//
//  ScaffoldCLI.swift
//  ScaffoldCLI
//
//  Command-line interface for ProjectScaffold
//

import Foundation
import ArgumentParser
import ProjectScaffold

@main
struct ScaffoldCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "scaffold",
        abstract: "Create modular Swift projects and features",
        subcommands: [
            CreateProject.self,
            CreateFeature.self,
            AddUnit.self
        ],
        defaultSubcommand: CreateProject.self
    )
}

// MARK: - Create Project

struct CreateProject: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "project",
        abstract: "Create a new project with modular architecture"
    )
    
    @Argument(help: "Name of the project")
    var name: String
    
    @Option(name: .shortAndLong, help: "Output directory")
    var output: String = "."
    
    @Option(name: .shortAndLong, help: "Platform (macOS, iOS, visionOS, multiplatform)")
    var platform: String = "macOS"
    
    @Option(name: .shortAndLong, parsing: .upToNextOption, help: "Features to include")
    var features: [String] = []
    
    @Flag(name: .long, help: "Skip database schema")
    var noDatabase: Bool = false
    
    @Flag(name: .long, help: "Skip core module")
    var noCore: Bool = false
    
    func run() throws {
        let outputURL = URL(fileURLWithPath: output)
        let platformEnum = Platform(rawValue: platform) ?? .macOS
        
        let projectPath = try ProjectScaffold.createProject(
            name: name,
            at: outputURL,
            platform: platformEnum,
            features: features,
            includeDatabase: !noDatabase,
            includeCoreModule: !noCore
        )
        
        print("✅ Created project at: \(projectPath.path)")
    }
}

// MARK: - Create Feature

struct CreateFeature: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "feature",
        abstract: "Create a new feature module"
    )
    
    @Argument(help: "Name of the feature")
    var name: String
    
    @Option(name: .shortAndLong, help: "Features directory path")
    var path: String = "./Features"
    
    @Option(name: .shortAndLong, help: "Feature description")
    var description: String = ""
    
    @Option(name: .shortAndLong, parsing: .upToNextOption, help: "Tags for the feature")
    var tags: [String] = []
    
    func run() throws {
        let featuresURL = URL(fileURLWithPath: path)
        
        let featurePath = try ProjectScaffold.createFeature(
            name: name,
            at: featuresURL,
            description: description,
            tags: tags
        )
        
        print("✅ Created feature at: \(featurePath.path)")
    }
}

// MARK: - Add Code Unit

struct AddUnit: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "unit",
        abstract: "Add a code unit to a feature"
    )
    
    @Argument(help: "Name of the code unit")
    var name: String
    
    @Option(name: .shortAndLong, help: "Feature path")
    var feature: String
    
    @Option(name: .shortAndLong, help: "Kind (struct, class, enum, protocol, actor)")
    var kind: String = "struct"
    
    @Option(name: .shortAndLong, help: "Category (models, services, views, viewModels, protocols)")
    var category: String = "models"
    
    @Option(name: .shortAndLong, parsing: .upToNextOption, help: "Tags")
    var tags: [String] = []
    
    @Option(name: .shortAndLong, parsing: .upToNextOption, help: "Dependencies")
    var dependencies: [String] = []
    
    func run() throws {
        let featureURL = URL(fileURLWithPath: feature)
        let kindEnum = CodeKind(rawValue: kind) ?? .struct
        let categoryEnum = CodeCategory(rawValue: category) ?? .models
        
        let filePath = try ProjectScaffold.addCodeUnit(
            to: featureURL,
            name: name,
            kind: kindEnum,
            category: categoryEnum,
            tags: tags,
            dependencies: dependencies
        )
        
        print("✅ Created: \(filePath.path)")
    }
}
