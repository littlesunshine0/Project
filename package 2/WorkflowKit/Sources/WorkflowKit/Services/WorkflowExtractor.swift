//
//  WorkflowExtractor.swift
//  WorkflowKit
//
//  Extracts workflows from structured documentation
//

import Foundation

// MARK: - Supporting Types

/// Represents a recurring pattern identified in documentation
public struct RecurringPattern: Codable, Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let description: String
    public let steps: [String]
    public let frequency: Int
    public let category: WorkflowCategory
    
    public init(name: String, description: String, steps: [String], frequency: Int = 1, category: WorkflowCategory = .general) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.steps = steps
        self.frequency = frequency
        self.category = category
    }
}

/// Structured document for workflow extraction
public struct StructuredDocument: Sendable {
    public let title: String
    public let sections: [DocumentSection]
    public let codeExamples: [CodeExample]
    
    public init(title: String, sections: [DocumentSection], codeExamples: [CodeExample] = []) {
        self.title = title
        self.sections = sections
        self.codeExamples = codeExamples
    }
}

/// Document section
public struct DocumentSection: Sendable {
    public let title: String
    public let content: String
    public let tags: [String]?
    
    public init(title: String, content: String, tags: [String]? = nil) {
        self.title = title
        self.content = content
        self.tags = tags
    }
}

/// Code example from documentation
public struct CodeExample: Sendable {
    public let language: String
    public let code: String
    public let description: String?
    
    public init(language: String, code: String, description: String? = nil) {
        self.language = language
        self.code = code
        self.description = description
    }
}

// MARK: - Workflow Extractor

/// Extracts workflows from structured documentation
public class WorkflowExtractor {
    
    private var identifiedPatterns: [RecurringPattern] = []
    
    public init() {}
    
    /// Extract workflows from structured document
    public func extract(from document: StructuredDocument) async -> [Workflow] {
        var workflows: [Workflow] = []
        
        for section in document.sections {
            if isProcedural(section) {
                if let workflow = extractWorkflow(from: section) {
                    workflows.append(workflow)
                }
            }
        }
        
        for codeExample in document.codeExamples {
            if let workflow = extractWorkflowFromCode(codeExample) {
                workflows.append(workflow)
            }
        }
        
        identifyPatterns(in: workflows)
        
        return workflows
    }
    
    /// Identify recurring patterns in workflows
    public func identifyPatterns(in workflows: [Workflow]) {
        var patternMap: [String: RecurringPattern] = [:]
        
        for workflow in workflows {
            let stepDescriptions = workflow.steps.map { $0.name }
            let signature = stepDescriptions.joined(separator: "|")
            
            if let existing = patternMap[signature] {
                patternMap[signature] = RecurringPattern(
                    name: existing.name,
                    description: existing.description,
                    steps: existing.steps,
                    frequency: existing.frequency + 1,
                    category: existing.category
                )
            } else {
                patternMap[signature] = RecurringPattern(
                    name: workflow.name,
                    description: workflow.description,
                    steps: stepDescriptions,
                    frequency: 1,
                    category: workflow.category
                )
            }
        }
        
        identifiedPatterns = patternMap.values.filter { $0.frequency > 1 }
    }
    
    /// Get identified patterns
    public func getIdentifiedPatterns() -> [RecurringPattern] {
        return identifiedPatterns
    }
    
    // MARK: - Procedural Detection
    
    private func isProcedural(_ section: DocumentSection) -> Bool {
        let content = section.content.lowercased()
        let title = section.title.lowercased()
        
        let proceduralKeywords = [
            "step", "steps", "how to", "tutorial", "guide",
            "install", "setup", "configure", "create",
            "first", "then", "next", "finally",
            "procedure", "instructions", "walkthrough"
        ]
        
        for keyword in proceduralKeywords {
            if title.contains(keyword) || content.contains(keyword) {
                return true
            }
        }
        
        let lines = section.content.components(separatedBy: .newlines)
        var listItemCount = 0
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            if trimmed.range(of: "^\\d+\\.", options: .regularExpression) != nil {
                listItemCount += 1
            }
            
            if trimmed.hasPrefix("-") || trimmed.hasPrefix("*") || trimmed.hasPrefix("+") {
                listItemCount += 1
            }
        }
        
        return listItemCount >= 3
    }
    
    // MARK: - Workflow Extraction
    
    private func extractWorkflow(from section: DocumentSection) -> Workflow? {
        let steps = extractSteps(from: section.content)
        
        guard !steps.isEmpty else { return nil }
        
        return Workflow(
            name: section.title,
            description: extractDescription(from: section.content),
            steps: steps,
            category: inferCategory(from: section),
            tags: section.tags ?? [],
            isBuiltIn: false
        )
    }
    
    private func extractSteps(from content: String) -> [WorkflowStep] {
        var steps: [WorkflowStep] = []
        let lines = content.components(separatedBy: .newlines)
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { continue }
            
            if let step = parseNumberedStep(trimmed) {
                steps.append(step)
            } else if let step = parseBulletedStep(trimmed) {
                steps.append(step)
            }
        }
        
        return steps
    }
    
    private func parseNumberedStep(_ line: String) -> WorkflowStep? {
        guard let range = line.range(of: "^\\d+\\.\\s*", options: .regularExpression) else {
            return nil
        }
        
        let stepText = String(line[range.upperBound...]).trimmingCharacters(in: .whitespaces)
        return createStep(from: stepText)
    }
    
    private func parseBulletedStep(_ line: String) -> WorkflowStep? {
        guard line.hasPrefix("-") || line.hasPrefix("*") || line.hasPrefix("+") else {
            return nil
        }
        
        let stepText = String(line.dropFirst()).trimmingCharacters(in: .whitespaces)
        return createStep(from: stepText)
    }
    
    private func createStep(from text: String) -> WorkflowStep {
        if let command = extractCommand(from: text) {
            return .command(Command(
                script: command,
                description: text,
                requiresPermission: requiresPermission(command),
                timeout: 60.0
            ))
        }
        
        if requiresInput(text) {
            return .prompt(Prompt(message: text, inputType: .text, defaultValue: nil))
        }
        
        return .command(Command(script: "", description: text, requiresPermission: false, timeout: 30.0))
    }
    
    private func extractCommand(from text: String) -> String? {
        let patterns = [
            "`([^`]+)`",
            "```([^`]+)```",
            "\\$\\s*(.+)",
            "Run:\\s*(.+)",
            "Execute:\\s*(.+)"
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]),
               let match = regex.firstMatch(in: text, range: NSRange(location: 0, length: text.utf16.count)),
               match.numberOfRanges >= 2 {
                let nsString = text as NSString
                let command = nsString.substring(with: match.range(at: 1))
                return command.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        return nil
    }
    
    private func requiresInput(_ text: String) -> Bool {
        let inputKeywords = ["enter", "input", "provide", "specify", "type", "choose", "select", "configure"]
        let lowercaseText = text.lowercased()
        return inputKeywords.contains { lowercaseText.contains($0) }
    }
    
    private func requiresPermission(_ command: String) -> Bool {
        let privilegedCommands = ["sudo", "su", "chmod", "chown", "rm -rf", "dd", "mkfs"]
        let lowercaseCommand = command.lowercased()
        return privilegedCommands.contains { lowercaseCommand.contains($0) }
    }
    
    private func extractDescription(from content: String) -> String {
        let paragraphs = content.components(separatedBy: "\n\n")
        
        for paragraph in paragraphs {
            let trimmed = paragraph.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimmed.hasPrefix("-") || trimmed.hasPrefix("*") ||
               trimmed.range(of: "^\\d+\\.", options: .regularExpression) != nil {
                continue
            }
            
            if !trimmed.isEmpty {
                return trimmed
            }
        }
        
        return "Extracted workflow"
    }
    
    private func inferCategory(from section: DocumentSection) -> WorkflowCategory {
        let text = (section.title + " " + section.content).lowercased()
        
        if text.contains("test") { return .testing }
        if text.contains("deploy") || text.contains("release") { return .deployment }
        if text.contains("document") || text.contains("doc") { return .documentation }
        if text.contains("build") || text.contains("compile") { return .build }
        if text.contains("git") || text.contains("commit") || text.contains("push") { return .git }
        if text.contains("api") { return .api }
        if text.contains("database") || text.contains("db") { return .database }
        if text.contains("security") || text.contains("auth") { return .security }
        if text.contains("performance") || text.contains("optimize") { return .performance }
        
        return .general
    }
    
    // MARK: - Code Example Extraction
    
    private func extractWorkflowFromCode(_ codeExample: CodeExample) -> Workflow? {
        guard codeExample.language == "bash" ||
              codeExample.language == "sh" ||
              codeExample.language == "shell" else {
            return nil
        }
        
        let lines = codeExample.code.components(separatedBy: .newlines)
        var steps: [WorkflowStep] = []
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty && !trimmed.hasPrefix("#") else { continue }
            
            steps.append(.command(Command(
                script: trimmed,
                description: trimmed,
                requiresPermission: requiresPermission(trimmed),
                timeout: 60.0
            )))
        }
        
        guard !steps.isEmpty else { return nil }
        
        return Workflow(
            name: "Script Workflow",
            description: codeExample.description ?? "Extracted from code example",
            steps: steps,
            category: .automation,
            tags: ["script", codeExample.language],
            isBuiltIn: false
        )
    }
}
