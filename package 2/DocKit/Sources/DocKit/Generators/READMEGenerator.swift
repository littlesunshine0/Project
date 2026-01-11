//
//  READMEGenerator.swift
//  DocKit
//
//  Professional README generation
//

import Foundation

public struct READMEGenerator {
    
    public static func generate(for project: ProjectInfo) -> String {
        var sections: [String] = []
        
        // Title and badges
        sections.append("# \(project.name)")
        sections.append("")
        sections.append(project.description)
        sections.append("")
        
        // Features
        if !project.features.isEmpty {
            sections.append("## Features")
            sections.append("")
            for feature in project.features {
                sections.append("- \(feature)")
            }
            sections.append("")
        }
        
        // Installation
        if let installation = project.installation {
            sections.append("## Installation")
            sections.append("")
            sections.append(installation)
            sections.append("")
        } else {
            sections.append("## Installation")
            sections.append("")
            sections.append("Add \(project.name) to your `Package.swift`:")
            sections.append("")
            sections.append("```swift")
            sections.append("dependencies: [")
            sections.append("    .package(path: \"../\(project.name)\")")
            sections.append("]")
            sections.append("```")
            sections.append("")
        }
        
        // Usage
        if let usage = project.usage {
            sections.append("## Usage")
            sections.append("")
            sections.append(usage)
            sections.append("")
        } else {
            sections.append("## Quick Start")
            sections.append("")
            sections.append("```swift")
            sections.append("import \(project.name)")
            sections.append("")
            sections.append("// Your code here")
            sections.append("```")
            sections.append("")
        }
        
        // Dependencies
        if !project.dependencies.isEmpty {
            sections.append("## Dependencies")
            sections.append("")
            for dep in project.dependencies {
                sections.append("- \(dep)")
            }
            sections.append("")
        }
        
        // License
        if let license = project.license {
            sections.append("## License")
            sections.append("")
            sections.append("\(license) License")
            sections.append("")
        }
        
        return sections.joined(separator: "\n")
    }
    
    /// Generate README from project directory analysis
    public static func generateFromDirectory(_ path: String) async throws -> String {
        let fm = FileManager.default
        let url = URL(fileURLWithPath: path)
        let name = url.lastPathComponent
        
        var features: [String] = []
        var dependencies: [String] = []
        
        // Check for Package.swift
        let packagePath = url.appendingPathComponent("Package.swift")
        if fm.fileExists(atPath: packagePath.path) {
            let content = try String(contentsOf: packagePath, encoding: .utf8)
            
            // Extract targets as features
            let targetPattern = #"\.target\s*\(\s*name:\s*"([^"]+)""#
            if let regex = try? NSRegularExpression(pattern: targetPattern) {
                let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))
                for match in matches {
                    if let range = Range(match.range(at: 1), in: content) {
                        features.append(String(content[range]))
                    }
                }
            }
            
            // Extract dependencies
            let depPattern = #"\.package\s*\(\s*url:\s*"([^"]+)""#
            if let regex = try? NSRegularExpression(pattern: depPattern) {
                let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))
                for match in matches {
                    if let range = Range(match.range(at: 1), in: content) {
                        dependencies.append(String(content[range]))
                    }
                }
            }
        }
        
        let project = ProjectInfo(
            name: name,
            description: "A Swift package",
            features: features,
            dependencies: dependencies
        )
        
        return generate(for: project)
    }
}
