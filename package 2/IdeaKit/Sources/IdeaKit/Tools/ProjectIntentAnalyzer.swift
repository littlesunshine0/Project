//
//  ProjectIntentAnalyzer.swift
//  IdeaKit - Project Operating System
//
//  Tool: ProjectIntentAnalyzer
//  Phase: Idea & Intent
//  Purpose: Convert raw idea → structured intent
//  Outputs: intent.json, problem.md, success_criteria.md
//

import Foundation

/// Analyzes raw project ideas and extracts structured intent
public final class ProjectIntentAnalyzer: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "project_intent_analyzer"
    public static let name = "Project Intent Analyzer"
    public static let description = "Convert raw idea into structured intent with problem statement, target user, and value proposition"
    public static let phase = ProjectPhase.ideaAndIntent
    public static let outputs = ["intent.json", "problem.md", "success_criteria.md"]
    public static let inputs: [String] = []
    public static let isDefault = true
    
    // MARK: - Singleton
    
    public static let shared = ProjectIntentAnalyzer()
    private init() {}
    
    // MARK: - Analysis
    
    /// Analyze a raw idea and extract structured intent
    public func analyze(idea: String) async throws -> ProjectIntent {
        var intent = ProjectIntent()
        
        // Extract problem statement
        intent.problemStatement = extractProblemStatement(from: idea)
        
        // Identify target user
        intent.targetUser = extractTargetUser(from: idea)
        
        // Extract value proposition
        intent.valueProposition = extractValueProposition(from: idea)
        
        // Classify project type
        intent.projectType = classifyProjectType(from: idea)
        
        // Identify non-goals
        intent.nonGoals = extractNonGoals(from: idea)
        
        // Extract constraints
        intent.constraints = extractConstraints(from: idea)
        
        // Define success criteria
        intent.successCriteria = extractSuccessCriteria(from: idea)
        
        return intent
    }
    
    /// Generate markdown for problem statement
    public func generateProblemMarkdown(from intent: ProjectIntent) -> String {
        """
        # Problem Statement
        
        ## Overview
        \(intent.problemStatement)
        
        ## Target User
        \(intent.targetUser)
        
        ## Value Proposition
        \(intent.valueProposition)
        
        ## Project Type
        \(intent.projectType.rawValue.capitalized)
        
        ## Constraints
        \(intent.constraints.map { "- \($0)" }.joined(separator: "\n"))
        
        ## Non-Goals
        \(intent.nonGoals.map { "- \($0)" }.joined(separator: "\n"))
        """
    }
    
    /// Generate markdown for success criteria
    public func generateSuccessCriteriaMarkdown(from intent: ProjectIntent) -> String {
        """
        # Success Criteria
        
        The project will be considered successful when:
        
        \(intent.successCriteria.enumerated().map { index, criterion in "\\(index + 1). \\(criterion)" }.joined(separator: "\n"))
        """
    }
    
    // MARK: - Private Extraction Methods
    
    private func extractProblemStatement(from idea: String) -> String {
        // Look for problem indicators
        let problemKeywords = ["problem", "issue", "challenge", "need", "want", "should", "must"]
        let sentences = idea.components(separatedBy: ". ")
        
        for sentence in sentences {
            let lower = sentence.lowercased()
            if problemKeywords.contains(where: { lower.contains($0) }) {
                return sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        // Default to first sentence or full idea
        return sentences.first ?? idea
    }
    
    private func extractTargetUser(from idea: String) -> String {
        let userKeywords = ["user", "developer", "customer", "team", "people", "anyone", "everyone"]
        let lower = idea.lowercased()
        
        for keyword in userKeywords {
            if lower.contains(keyword) {
                return keyword.capitalized + "s"
            }
        }
        
        return "General users"
    }
    
    private func extractValueProposition(from idea: String) -> String {
        let valueKeywords = ["help", "enable", "allow", "make", "provide", "simplify", "automate"]
        let sentences = idea.components(separatedBy: ". ")
        
        for sentence in sentences {
            let lower = sentence.lowercased()
            if valueKeywords.contains(where: { lower.contains($0) }) {
                return sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        return "Provides value through \(idea.prefix(50))..."
    }
    
    private func classifyProjectType(from idea: String) -> ProjectType {
        let lower = idea.lowercased()
        
        if lower.contains("app") || lower.contains("application") {
            return .app
        } else if lower.contains("library") || lower.contains("package") {
            return .library
        } else if lower.contains("cli") || lower.contains("command line") {
            return .cli
        } else if lower.contains("api") || lower.contains("service") {
            return .api
        } else if lower.contains("saas") || lower.contains("subscription") {
            return .saas
        } else if lower.contains("framework") {
            return .framework
        } else if lower.contains("plugin") || lower.contains("extension") {
            return .plugin
        }
        
        return .app
    }
    
    private func extractNonGoals(from idea: String) -> [String] {
        let nonGoalKeywords = ["not", "won't", "don't", "exclude", "out of scope"]
        var nonGoals: [String] = []
        
        let sentences = idea.components(separatedBy: ". ")
        for sentence in sentences {
            let lower = sentence.lowercased()
            if nonGoalKeywords.contains(where: { lower.contains($0) }) {
                nonGoals.append(sentence.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        return nonGoals
    }
    
    private func extractConstraints(from idea: String) -> [String] {
        let constraintKeywords = ["must", "require", "need", "only", "limit", "constraint"]
        var constraints: [String] = []
        
        let sentences = idea.components(separatedBy: ". ")
        for sentence in sentences {
            let lower = sentence.lowercased()
            if constraintKeywords.contains(where: { lower.contains($0) }) {
                constraints.append(sentence.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        return constraints
    }
    
    private func extractSuccessCriteria(from idea: String) -> [String] {
        // Generate default success criteria based on project type
        return [
            "Core functionality is implemented and working",
            "User can complete primary workflow",
            "No critical bugs or crashes",
            "Documentation is complete"
        ]
    }
}
