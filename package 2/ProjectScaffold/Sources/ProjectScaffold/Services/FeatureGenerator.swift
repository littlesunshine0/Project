//
//  FeatureGenerator.swift
//  ProjectScaffold
//
//  Generates feature module structure
//

import Foundation

/// Generates feature module folders and files
public class FeatureGenerator: @unchecked Sendable {
    
    private let fileManager = FileManager.default
    
    public init() {}
    
    /// Create a new feature module
    public func createFeature(
        name: String,
        at basePath: URL,
        description: String = "",
        tags: [String] = []
    ) throws -> URL {
        let featurePath = basePath.appendingPathComponent(name)
        
        // Create directories
        let directories = ["Models", "Services", "Views", "ViewModels", "Protocols"]
        for dir in directories {
            let dirPath = featurePath.appendingPathComponent(dir)
            try fileManager.createDirectory(at: dirPath, withIntermediateDirectories: true)
        }
        
        // Create MANIFEST.json
        let manifest = FeatureManifest(
            feature: name,
            description: description,
            tags: tags
        )
        let manifestPath = featurePath.appendingPathComponent("\(name)_MANIFEST.json")
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let manifestData = try encoder.encode(manifest)
        try manifestData.write(to: manifestPath)
        
        return featurePath
    }
    
    /// Add a code unit to a feature
    public func addCodeUnit(
        to featurePath: URL,
        name: String,
        kind: CodeKind,
        category: CodeCategory,
        tags: [String] = [],
        dependencies: [String] = []
    ) throws -> URL {
        let categoryDir = featurePath.appendingPathComponent(category.rawValue.capitalized)
        let filePath = categoryDir.appendingPathComponent("\(name).swift")
        
        // Generate file content
        let content = generateFileContent(
            name: name,
            kind: kind,
            category: category,
            featureName: featurePath.lastPathComponent,
            tags: tags,
            dependencies: dependencies
        )
        
        try content.write(to: filePath, atomically: true, encoding: .utf8)
        
        return filePath
    }
    
    /// Generate Swift file content with proper header
    private func generateFileContent(
        name: String,
        kind: CodeKind,
        category: CodeCategory,
        featureName: String,
        tags: [String],
        dependencies: [String]
    ) -> String {
        let tagsStr = tags.isEmpty ? "[]" : "[\(tags.joined(separator: ", "))]"
        let depsStr = dependencies.isEmpty ? "[]" : "[\(dependencies.joined(separator: ", "))]"
        
        let kindDeclaration: String
        switch kind {
        case .struct:
            kindDeclaration = "struct \(name) {\n    \n}"
        case .class:
            kindDeclaration = "class \(name) {\n    \n}"
        case .enum:
            kindDeclaration = "enum \(name) {\n    \n}"
        case .protocol:
            kindDeclaration = "protocol \(name) {\n    \n}"
        case .actor:
            kindDeclaration = "actor \(name) {\n    \n}"
        case .extension:
            kindDeclaration = "extension \(name) {\n    \n}"
        }
        
        return """
        //
        //  \(name).swift
        //  \(featureName) Feature
        //
        //  Individual \(category.rawValue.capitalized): \(name) \(kind.rawValue)
        //  Feature: \(featureName)
        //  Category: \(category.rawValue.capitalized)
        //  Kind: \(kind.rawValue)
        //  Tags: \(tagsStr)
        //  Dependencies: \(depsStr)
        //
        
        import Foundation
        
        \(kindDeclaration)
        """
    }
    
    /// Generate combined file for a category
    public func generateCombinedFile(
        for featurePath: URL,
        category: CodeCategory
    ) throws -> URL {
        let featureName = featurePath.lastPathComponent
        let categoryDir = featurePath.appendingPathComponent(category.rawValue.capitalized)
        let combinedPath = featurePath.appendingPathComponent("\(featureName)\(category.rawValue.capitalized).swift")
        
        var content = """
        //
        //  \(featureName)\(category.rawValue.capitalized).swift
        //  \(featureName) Feature
        //
        //  COMBINED FILE: All \(featureName) \(category.rawValue) in one file
        //  Feature: \(featureName)
        //  Category: \(category.rawValue.capitalized) (Combined)
        //
        //  Individual files available in \(category.rawValue.capitalized)/ folder
        //
        
        import Foundation
        
        """
        
        // Read all files in category directory
        if let files = try? fileManager.contentsOfDirectory(at: categoryDir, includingPropertiesForKeys: nil) {
            for file in files where file.pathExtension == "swift" {
                if let fileContent = try? String(contentsOf: file, encoding: .utf8) {
                    // Extract just the code (skip header)
                    let lines = fileContent.components(separatedBy: "\n")
                    var inHeader = true
                    var codeLines: [String] = []
                    
                    for line in lines {
                        if inHeader && !line.hasPrefix("//") && !line.isEmpty {
                            inHeader = false
                        }
                        if !inHeader {
                            codeLines.append(line)
                        }
                    }
                    
                    content += "\n// MARK: - \(file.deletingPathExtension().lastPathComponent)\n\n"
                    content += codeLines.joined(separator: "\n")
                    content += "\n"
                }
            }
        }
        
        try content.write(to: combinedPath, atomically: true, encoding: .utf8)
        
        return combinedPath
    }
}
