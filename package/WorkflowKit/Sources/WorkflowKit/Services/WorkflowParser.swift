//
//  WorkflowParser.swift
//  WorkflowKit
//

import Foundation

public actor WorkflowParser {
    public static let shared = WorkflowParser()
    
    private init() {}
    
    // MARK: - Parse YAML
    
    public func parseYAML(_ yaml: String) throws -> Workflow {
        // Simple YAML parsing (for production, use a proper YAML library)
        var name = ""
        var description = ""
        var category = WorkflowCategory.general
        var tags: [String] = []
        var steps: [WorkflowStep] = []
        
        let lines = yaml.components(separatedBy: .newlines)
        var currentSection = ""
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            if trimmed.hasPrefix("name:") {
                name = trimmed.replacingOccurrences(of: "name:", with: "").trimmingCharacters(in: .whitespaces)
            } else if trimmed.hasPrefix("description:") {
                description = trimmed.replacingOccurrences(of: "description:", with: "").trimmingCharacters(in: .whitespaces)
            } else if trimmed.hasPrefix("category:") {
                let catStr = trimmed.replacingOccurrences(of: "category:", with: "").trimmingCharacters(in: .whitespaces)
                category = WorkflowCategory(rawValue: catStr) ?? .general
            } else if trimmed == "tags:" {
                currentSection = "tags"
            } else if trimmed == "steps:" {
                currentSection = "steps"
            } else if trimmed.hasPrefix("- ") && currentSection == "tags" {
                let tag = trimmed.replacingOccurrences(of: "- ", with: "")
                tags.append(tag)
            }
        }
        
        guard !name.isEmpty else {
            throw WorkflowError.invalidStep
        }
        
        return Workflow(
            name: name,
            description: description,
            steps: steps,
            category: category,
            tags: tags
        )
    }
    
    // MARK: - Parse JSON
    
    public func parseJSON(_ json: String) throws -> Workflow {
        guard let data = json.data(using: .utf8) else {
            throw WorkflowError.invalidStep
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(Workflow.self, from: data)
    }
    
    // MARK: - Parse Natural Language
    
    public func parseNaturalLanguage(_ input: String) -> WorkflowSuggestion? {
        let lowered = input.lowercased()
        
        // Simple pattern matching
        if lowered.contains("build") && lowered.contains("test") {
            return WorkflowSuggestion(
                name: "Build and Test",
                description: "Build the project and run tests",
                suggestedSteps: ["swift build", "swift test"],
                category: .development
            )
        }
        
        if lowered.contains("deploy") {
            return WorkflowSuggestion(
                name: "Deploy",
                description: "Deploy the application",
                suggestedSteps: ["swift build -c release", "deploy.sh"],
                category: .deployment
            )
        }
        
        if lowered.contains("git") && lowered.contains("commit") {
            return WorkflowSuggestion(
                name: "Git Commit",
                description: "Stage and commit changes",
                suggestedSteps: ["git add .", "git commit -m 'Update'"],
                category: .git
            )
        }
        
        return nil
    }
    
    // MARK: - Validation
    
    public func validate(_ workflow: Workflow) -> ValidationResult {
        var errors: [String] = []
        
        if workflow.name.isEmpty {
            errors.append("Workflow name is required")
        }
        
        if workflow.steps.isEmpty {
            errors.append("Workflow must have at least one step")
        }
        
        return ValidationResult(
            isValid: errors.isEmpty,
            errors: errors
        )
    }
}

public struct WorkflowSuggestion: Sendable {
    public let name: String
    public let description: String
    public let suggestedSteps: [String]
    public let category: WorkflowCategory
}

public struct ValidationResult: Sendable {
    public let isValid: Bool
    public let errors: [String]
}
