//
//  WorkflowGenerator.swift
//  WorkflowKit
//

import Foundation

public actor WorkflowGenerator {
    public static let shared = WorkflowGenerator()
    
    private init() {}
    
    // MARK: - Generate Workflows
    
    public func generateFromDefinition(_ definition: WorkflowDefinition) -> Workflow {
        Workflow(
            name: definition.name,
            description: definition.description,
            steps: definition.steps,
            category: definition.category,
            tags: definition.tags,
            isBuiltIn: true
        )
    }
    
    public func generateBatch(from definitions: [WorkflowDefinition]) -> [Workflow] {
        definitions.map { generateFromDefinition($0) }
    }
    
    public func generateYAML(for workflow: Workflow) -> String {
        var yaml = """
        name: \(workflow.name)
        description: \(workflow.description)
        category: \(workflow.category.rawValue)
        tags:
        """
        
        for tag in workflow.tags {
            yaml += "\n  - \(tag)"
        }
        
        yaml += "\nsteps:"
        
        for (index, step) in workflow.steps.enumerated() {
            yaml += "\n  - name: Step \(index + 1)"
            yaml += "\n    type: \(stepType(step))"
            yaml += "\n    command: \(step.command)"
        }
        
        return yaml
    }
    
    public func generateJSON(for workflow: Workflow) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        if let data = try? encoder.encode(workflow),
           let json = String(data: data, encoding: .utf8) {
            return json
        }
        
        return "{}"
    }
    
    public func generateMarkdownDocs(for workflows: [Workflow]) -> String {
        var md = "# Workflow Reference\n\n"
        
        let grouped = Dictionary(grouping: workflows) { $0.category }
        
        for category in WorkflowCategory.allCases {
            guard let categoryWorkflows = grouped[category], !categoryWorkflows.isEmpty else { continue }
            
            md += "## \(category.rawValue)\n\n"
            
            for workflow in categoryWorkflows.sorted(by: { $0.name < $1.name }) {
                md += "### \(workflow.name)\n\n"
                md += "\(workflow.description)\n\n"
                md += "**Steps:** \(workflow.steps.count)\n\n"
                
                if !workflow.tags.isEmpty {
                    md += "**Tags:** \(workflow.tags.joined(separator: ", "))\n\n"
                }
            }
        }
        
        return md
    }
    
    private func stepType(_ step: WorkflowStep) -> String {
        switch step {
        case .command: return "command"
        case .prompt: return "prompt"
        case .conditional: return "conditional"
        case .parallel: return "parallel"
        case .subworkflow: return "subworkflow"
        }
    }
}

public struct WorkflowDefinition: Sendable {
    public let name: String
    public let description: String
    public let steps: [WorkflowStep]
    public let category: WorkflowCategory
    public let tags: [String]
    
    public init(
        name: String,
        description: String,
        steps: [WorkflowStep] = [],
        category: WorkflowCategory = .general,
        tags: [String] = []
    ) {
        self.name = name
        self.description = description
        self.steps = steps
        self.category = category
        self.tags = tags
    }
}
