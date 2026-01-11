//
//  PackageValidator.swift
//  DataKit
//

import Foundation

/// Package compliance validator
public struct PackageValidator {
    
    /// Required contract files for every package
    public static let requiredFiles = [
        "Package.manifest.json",
        "Package.capabilities.json",
        "Package.state.json",
        "Package.actions.json",
        "Package.ui.json",
        "Package.agents.json",
        "Package.workflows.json"
    ]
    
    /// Validate package has all required files
    public static func validatePackage(at path: String, files: [String]) -> [ValidationIssue] {
        var issues: [ValidationIssue] = []
        
        for required in requiredFiles {
            if !files.contains(required) {
                issues.append(ValidationIssue(
                    field: "files",
                    message: "Missing required file: \(required)",
                    severity: .error,
                    code: "MISSING_CONTRACT_FILE"
                ))
            }
        }
        
        return issues
    }
    
    /// Validate manifest structure
    public static func validateManifest(_ manifest: PackageManifest) -> [ValidationIssue] {
        var issues: [ValidationIssue] = []
        
        if manifest.id.isEmpty {
            issues.append(ValidationIssue(field: "id", message: "Package ID is required", severity: .error))
        }
        if manifest.name.isEmpty {
            issues.append(ValidationIssue(field: "name", message: "Package name is required", severity: .error))
        }
        if !PackageCategory.allCases.map({ $0.rawValue }).contains(manifest.category) {
            issues.append(ValidationIssue(field: "category", message: "Invalid category: \(manifest.category)", severity: .warning))
        }
        
        return issues
    }
}
