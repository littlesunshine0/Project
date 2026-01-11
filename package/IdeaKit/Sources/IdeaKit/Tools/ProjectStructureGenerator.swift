//
//  ProjectStructureGenerator.swift
//  IdeaKit - Project Operating System
//
//  Tool: ProjectStructureGenerator
//  Phase: Architecture
//  Purpose: Create sane repo layout with folder structure and naming conventions
//  Outputs: Initial project tree, structure.md
//

import Foundation

/// Generates project folder structure
public final class ProjectStructureGenerator: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "project_structure_generator"
    public static let name = "Project Structure Generator"
    public static let description = "Create project folder structure with naming conventions and module boundaries"
    public static let phase = ProjectPhase.architecture
    public static let outputs = ["structure.md"]
    public static let inputs = ["architecture.md"]
    public static let isDefault = false
    
    // MARK: - Singleton
    
    public static let shared = ProjectStructureGenerator()
    private init() {}
    
    // MARK: - Generation
    
    /// Generate project structure
    public func generate(for architecture: ArchitectureRecommendation, projectName: String) -> ProjectStructure {
        let folders = generateFolders(for: architecture.pattern, projectName: projectName)
        let conventions = generateConventions(for: architecture.pattern)
        
        return ProjectStructure(
            rootName: projectName,
            folders: folders,
            conventions: conventions
        )
    }
    
    /// Create the actual folder structure
    public func createStructure(_ structure: ProjectStructure, at basePath: URL) throws {
        let fm = FileManager.default
        
        for folder in structure.folders {
            let folderPath = basePath.appendingPathComponent(folder.path)
            try fm.createDirectory(at: folderPath, withIntermediateDirectories: true)
            
            // Create README for each folder
            let readmePath = folderPath.appendingPathComponent("README.md")
            let readme = "# \(folder.name)\n\n\(folder.description)"
            try readme.write(to: readmePath, atomically: true, encoding: .utf8)
        }
    }
    
    /// Generate structure markdown
    public func generateMarkdown(from structure: ProjectStructure) -> String {
        var md = """
        # Project Structure
        
        ## Overview
        
        ```
        \(structure.rootName)/
        """
        
        for folder in structure.folders {
            let depth = folder.path.components(separatedBy: "/").count
            let indent = String(repeating: "│   ", count: depth - 1)
            md += "\n\(indent)├── \(folder.name)/"
        }
        
        md += """
        
        ```
        
        ## Folder Descriptions
        
        """
        
        for folder in structure.folders {
            md += """
            
            ### \(folder.name)
            
            **Path**: `\(folder.path)`
            
            \(folder.description)
            
            """
        }
        
        md += """
        
        ## Naming Conventions
        
        """
        
        for convention in structure.conventions {
            md += "- **\(convention.scope)**: \(convention.rule)\n"
        }
        
        return md
    }
    
    // MARK: - Private Methods
    
    private func generateFolders(for pattern: ArchitecturePattern, projectName: String) -> [FolderDefinition] {
        switch pattern {
        case .mvvm:
            return [
                FolderDefinition(name: "Models", path: "\(projectName)/Models", description: "Data structures and business entities"),
                FolderDefinition(name: "Views", path: "\(projectName)/Views", description: "SwiftUI views and UI components"),
                FolderDefinition(name: "ViewModels", path: "\(projectName)/ViewModels", description: "View state and presentation logic"),
                FolderDefinition(name: "Services", path: "\(projectName)/Services", description: "Business logic and data access"),
                FolderDefinition(name: "Resources", path: "\(projectName)/Resources", description: "Assets, configurations, and static files"),
                FolderDefinition(name: "Tests", path: "\(projectName)Tests", description: "Unit and integration tests")
            ]
        case .clean:
            return [
                FolderDefinition(name: "Domain", path: "\(projectName)/Domain", description: "Business rules and entities"),
                FolderDefinition(name: "Domain/Entities", path: "\(projectName)/Domain/Entities", description: "Core business objects"),
                FolderDefinition(name: "Domain/UseCases", path: "\(projectName)/Domain/UseCases", description: "Application business rules"),
                FolderDefinition(name: "Data", path: "\(projectName)/Data", description: "Data layer implementation"),
                FolderDefinition(name: "Presentation", path: "\(projectName)/Presentation", description: "UI layer"),
                FolderDefinition(name: "Tests", path: "\(projectName)Tests", description: "Unit and integration tests")
            ]
        case .modular:
            return [
                FolderDefinition(name: "Core", path: "\(projectName)/Core", description: "Shared utilities and types"),
                FolderDefinition(name: "Features", path: "\(projectName)/Features", description: "Feature modules"),
                FolderDefinition(name: "UI", path: "\(projectName)/UI", description: "Shared UI components"),
                FolderDefinition(name: "Data", path: "\(projectName)/Data", description: "Data layer"),
                FolderDefinition(name: "Tests", path: "\(projectName)Tests", description: "Unit and integration tests")
            ]
        default:
            return [
                FolderDefinition(name: "Sources", path: "\(projectName)/Sources", description: "Source code"),
                FolderDefinition(name: "Resources", path: "\(projectName)/Resources", description: "Assets and configurations"),
                FolderDefinition(name: "Tests", path: "\(projectName)Tests", description: "Tests")
            ]
        }
    }
    
    private func generateConventions(for pattern: ArchitecturePattern) -> [NamingConvention] {
        [
            NamingConvention(scope: "Files", rule: "PascalCase for types (e.g., UserModel.swift)"),
            NamingConvention(scope: "Folders", rule: "PascalCase for feature folders, lowercase for utility folders"),
            NamingConvention(scope: "Views", rule: "Suffix with 'View' (e.g., ProfileView.swift)"),
            NamingConvention(scope: "ViewModels", rule: "Suffix with 'ViewModel' (e.g., ProfileViewModel.swift)"),
            NamingConvention(scope: "Services", rule: "Suffix with 'Service' (e.g., AuthService.swift)"),
            NamingConvention(scope: "Protocols", rule: "Prefix with verb or suffix with 'Protocol' (e.g., Authenticating.swift)"),
            NamingConvention(scope: "Tests", rule: "Suffix with 'Tests' (e.g., UserModelTests.swift)")
        ]
    }
}

// MARK: - Supporting Types

public struct ProjectStructure: Sendable {
    public let rootName: String
    public let folders: [FolderDefinition]
    public let conventions: [NamingConvention]
}

public struct FolderDefinition: Sendable {
    public let name: String
    public let path: String
    public let description: String
}

public struct NamingConvention: Sendable {
    public let scope: String
    public let rule: String
}
