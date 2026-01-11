//
//  ProjectContext.swift
//  IdeaKit - Project Operating System
//
//  Central context object that holds project state and artifacts
//

import Foundation

/// Central context object that holds all project state
public class ProjectContext: @unchecked Sendable {
    
    // MARK: - Properties
    
    public let name: String
    public let path: URL
    public let createdAt: Date
    public private(set) var artifacts: [String: Any] = [:]
    public private(set) var metadata: [String: String] = [:]
    
    /// Path to the .ideakit folder
    public var ideaKitPath: URL {
        path.appendingPathComponent(".ideakit")
    }
    
    /// Path to artifacts folder
    public var artifactsPath: URL {
        ideaKitPath.appendingPathComponent("artifacts")
    }
    
    /// Path to docs folder
    public var docsPath: URL {
        ideaKitPath.appendingPathComponent("docs")
    }
    
    // MARK: - Initialization
    
    public init(name: String, path: URL) {
        self.name = name
        self.path = path
        self.createdAt = Date()
    }
    
    // MARK: - Directory Setup
    
    public func setupDirectories() throws {
        let fm = FileManager.default
        let directories = [ideaKitPath, artifactsPath, docsPath]
        
        for dir in directories {
            if !fm.fileExists(atPath: dir.path) {
                try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            }
        }
    }
    
    // MARK: - Artifact Management
    
    public func save(artifact: Encodable, as filename: String) throws {
        try setupDirectories()
        
        let filePath: URL
        if filename.hasSuffix(".md") {
            filePath = docsPath.appendingPathComponent(filename)
        } else {
            filePath = artifactsPath.appendingPathComponent(filename)
        }
        
        if let stringArtifact = artifact as? String {
            try stringArtifact.write(to: filePath, atomically: true, encoding: .utf8)
        } else {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(artifact)
            try data.write(to: filePath)
        }
        
        artifacts[filename] = artifact
    }
    
    public func load<T: Decodable>(artifact filename: String, as type: T.Type) throws -> T {
        let filePath: URL
        if filename.hasSuffix(".md") {
            filePath = docsPath.appendingPathComponent(filename)
        } else {
            filePath = artifactsPath.appendingPathComponent(filename)
        }
        
        let data = try Data(contentsOf: filePath)
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    public func loadMarkdown(filename: String) throws -> String {
        let filePath = docsPath.appendingPathComponent(filename)
        return try String(contentsOf: filePath, encoding: .utf8)
    }
    
    // MARK: - Metadata
    
    public func setMetadata(_ value: String, for key: String) {
        metadata[key] = value
    }
    
    public func getMetadata(_ key: String) -> String? {
        metadata[key]
    }
}
