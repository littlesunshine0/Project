//
//  IntentPackage.swift
//  IdeaKit - Project Operating System
//
//  Kernel Package: Intent
//  Converts raw idea → structured intent
//  Produces: IntentArtifact, AssumptionArtifact
//

import Foundation

/// Intent Package - Project Genesis
/// Converts raw project ideas into structured intent
public struct IntentPackage: CapabilityPackage {
    
    // MARK: - Package Identity
    
    public static let packageId = "intent"
    public static let name = "Intent Package"
    public static let description = "Convert raw idea into structured intent with problem statement, target user, and value proposition"
    public static let version = "1.0.0"
    public static let produces = ["IntentArtifact", "AssumptionArtifact"]
    public static let consumes: [String] = []
    public static let isKernel = true
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Execution
    
    public func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        // Get the raw idea from context metadata
        guard let idea = context.getMetadata("idea") else {
            throw PackageError.missingInput("idea")
        }
        
        // Analyze intent
        let intent = analyze(idea: idea)
        
        // Register intent artifact
        await graph.register(intent, producedBy: Self.packageId)
        
        // Extract assumptions
        let assumptions = extractAssumptions(from: intent)
        await graph.register(assumptions, producedBy: Self.packageId)
        
        // Save rendered outputs
        try context.save(artifact: intent.toMarkdown(), as: "intent.md")
        try context.save(artifact: assumptions.toMarkdown(), as: "assumptions.md")
    }
    
    // MARK: - Analysis Logic
    
    private func analyze(idea: String) -> IntentArtifact {
        IntentArtifact(
            problemStatement: extractProblemStatement(from: idea),
            targetUser: extractTargetUser(from: idea),
            valueProposition: extractValueProposition(from: idea),
            projectType: classifyProjectType(from: idea),
            nonGoals: extractNonGoals(from: idea),
            constraints: extractConstraints(from: idea),
            successCriteria: generateSuccessCriteria(from: idea)
        )
    }
    
    private func extractAssumptions(from intent: IntentArtifact) -> AssumptionArtifact {
        var assumptions: [Assumption] = []
        
        // Technical assumptions
        assumptions.append(Assumption(
            category: .technical,
            statement: "Target platform supports required features",
            confidence: 0.8
        ))
        
        assumptions.append(Assumption(
            category: .technical,
            statement: "Performance requirements can be met with chosen architecture",
            confidence: 0.7
        ))
        
        // User assumptions
        assumptions.append(Assumption(
            category: .userBehavior,
            statement: "Users will understand the core workflow without extensive training",
            confidence: 0.5
        ))
        
        // Timeline assumptions
        assumptions.append(Assumption(
            category: .timeline,
            statement: "No major scope changes during development",
            confidence: 0.4
        ))
        
        // Resource assumptions
        assumptions.append(Assumption(
            category: .resource,
            statement: "Sufficient time and budget allocated for completion",
            confidence: 0.5
        ))
        
        return AssumptionArtifact(assumptions: assumptions)
    }
    
    // MARK: - Extraction Helpers
    
    private func extractProblemStatement(from idea: String) -> String {
        let problemKeywords = ["problem", "issue", "challenge", "need", "want"]
        let sentences = idea.components(separatedBy: ". ")
        
        for sentence in sentences {
            if problemKeywords.contains(where: { sentence.lowercased().contains($0) }) {
                return sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        return sentences.first ?? idea
    }
    
    private func extractTargetUser(from idea: String) -> String {
        let userKeywords = ["user", "developer", "customer", "team", "people"]
        let lower = idea.lowercased()
        
        for keyword in userKeywords {
            if lower.contains(keyword) {
                return keyword.capitalized + "s"
            }
        }
        
        return "General users"
    }
    
    private func extractValueProposition(from idea: String) -> String {
        let valueKeywords = ["help", "enable", "allow", "make", "provide", "simplify"]
        let sentences = idea.components(separatedBy: ". ")
        
        for sentence in sentences {
            if valueKeywords.contains(where: { sentence.lowercased().contains($0) }) {
                return sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        return "Provides value through \(idea.prefix(50))..."
    }
    
    private func classifyProjectType(from idea: String) -> ProjectType {
        let lower = idea.lowercased()
        
        if lower.contains("app") || lower.contains("application") { return .app }
        if lower.contains("library") || lower.contains("package") { return .library }
        if lower.contains("cli") || lower.contains("command line") { return .cli }
        if lower.contains("api") || lower.contains("service") { return .api }
        if lower.contains("framework") { return .framework }
        
        return .app
    }
    
    private func extractNonGoals(from idea: String) -> [String] {
        let nonGoalKeywords = ["not", "won't", "don't", "exclude"]
        var nonGoals: [String] = []
        
        let sentences = idea.components(separatedBy: ". ")
        for sentence in sentences {
            if nonGoalKeywords.contains(where: { sentence.lowercased().contains($0) }) {
                nonGoals.append(sentence.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        return nonGoals
    }
    
    private func extractConstraints(from idea: String) -> [String] {
        let constraintKeywords = ["must", "require", "need", "only", "limit"]
        var constraints: [String] = []
        
        let sentences = idea.components(separatedBy: ". ")
        for sentence in sentences {
            if constraintKeywords.contains(where: { sentence.lowercased().contains($0) }) {
                constraints.append(sentence.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        return constraints
    }
    
    private func generateSuccessCriteria(from idea: String) -> [String] {
        [
            "Core functionality is implemented and working",
            "User can complete primary workflow",
            "No critical bugs or crashes",
            "Documentation is complete"
        ]
    }
}

// MARK: - Package Errors

public enum PackageError: Error, LocalizedError {
    case missingInput(String)
    case missingArtifact(String)
    case invalidArtifact(String)
    case executionFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .missingInput(let input): return "Missing required input: \(input)"
        case .missingArtifact(let artifact): return "Missing required artifact: \(artifact)"
        case .invalidArtifact(let artifact): return "Invalid artifact: \(artifact)"
        case .executionFailed(let reason): return "Execution failed: \(reason)"
        }
    }
}
