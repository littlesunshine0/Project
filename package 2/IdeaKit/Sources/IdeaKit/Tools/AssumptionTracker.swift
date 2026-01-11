//
//  AssumptionTracker.swift
//  IdeaKit - Project Operating System
//
//  Tool: AssumptionTracker
//  Phase: Idea & Intent
//  Purpose: Make implicit assumptions explicit
//  Outputs: assumptions.md
//

import Foundation

/// Tracks and manages project assumptions
public final class AssumptionTracker: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "assumption_tracker"
    public static let name = "Assumption Tracker"
    public static let description = "Extract and track implicit assumptions with confidence scores"
    public static let phase = ProjectPhase.ideaAndIntent
    public static let outputs = ["assumptions.md"]
    public static let inputs = ["intent.json"]
    public static let isDefault = true
    
    // MARK: - Singleton
    
    public static let shared = AssumptionTracker()
    private init() {}
    
    // MARK: - Extraction
    
    /// Extract assumptions from project intent
    public func extract(from intent: ProjectIntent) async throws -> AssumptionSet {
        var assumptions: [Assumption] = []
        
        // Technical assumptions
        assumptions.append(contentsOf: extractTechnicalAssumptions(from: intent))
        
        // User behavior assumptions
        assumptions.append(contentsOf: extractUserAssumptions(from: intent))
        
        // Timeline assumptions
        assumptions.append(contentsOf: extractTimelineAssumptions(from: intent))
        
        // Skill assumptions
        assumptions.append(contentsOf: extractSkillAssumptions(from: intent))
        
        // Resource assumptions
        assumptions.append(contentsOf: extractResourceAssumptions(from: intent))
        
        return AssumptionSet(assumptions: assumptions)
    }
    
    /// Generate markdown report
    public func generateMarkdown(from assumptions: AssumptionSet) -> String {
        var md = """
        # Project Assumptions
        
        > **Important**: These assumptions should be validated early to prevent architectural mistakes.
        
        """
        
        // Group by category
        let grouped = Dictionary(grouping: assumptions.assumptions, by: { $0.category })
        
        for category in AssumptionCategory.allCases {
            guard let categoryAssumptions = grouped[category], !categoryAssumptions.isEmpty else { continue }
            
            md += "\n## \(category.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)\n\n"
            
            for assumption in categoryAssumptions {
                let confidenceEmoji = confidenceEmoji(for: assumption.confidence)
                md += "- \(confidenceEmoji) **\(assumption.statement)**\n"
                md += "  - Confidence: \(Int(assumption.confidence * 100))%\n"
                if !assumption.notes.isEmpty {
                    md += "  - Notes: \(assumption.notes)\n"
                }
                md += "\n"
            }
        }
        
        md += """
        
        ---
        
        ## Confidence Legend
        
        - 🟢 High confidence (>70%)
        - 🟡 Medium confidence (40-70%)
        - 🔴 Low confidence (<40%)
        
        """
        
        return md
    }
    
    /// Validate an assumption
    public func validate(assumption: inout Assumption, result: Bool, notes: String = "") {
        assumption.validatedAt = Date()
        assumption.validationResult = result
        if !notes.isEmpty {
            assumption.notes = notes
        }
    }
    
    // MARK: - Private Extraction Methods
    
    private func extractTechnicalAssumptions(from intent: ProjectIntent) -> [Assumption] {
        var assumptions: [Assumption] = []
        
        // Platform assumption
        assumptions.append(Assumption(
            category: .technical,
            statement: "Target platform supports required features",
            confidence: 0.8
        ))
        
        // API availability
        if intent.projectType == .api || intent.projectType == .saas {
            assumptions.append(Assumption(
                category: .technical,
                statement: "External APIs will remain stable and available",
                confidence: 0.6
            ))
        }
        
        // Performance
        assumptions.append(Assumption(
            category: .technical,
            statement: "Performance requirements can be met with chosen architecture",
            confidence: 0.7
        ))
        
        return assumptions
    }
    
    private func extractUserAssumptions(from intent: ProjectIntent) -> [Assumption] {
        var assumptions: [Assumption] = []
        
        assumptions.append(Assumption(
            category: .userBehavior,
            statement: "Users will understand the core workflow without extensive training",
            confidence: 0.5
        ))
        
        assumptions.append(Assumption(
            category: .userBehavior,
            statement: "Target users have basic technical proficiency",
            confidence: 0.6
        ))
        
        return assumptions
    }
    
    private func extractTimelineAssumptions(from intent: ProjectIntent) -> [Assumption] {
        [
            Assumption(
                category: .timeline,
                statement: "No major scope changes during development",
                confidence: 0.4
            ),
            Assumption(
                category: .timeline,
                statement: "Dependencies will be available when needed",
                confidence: 0.7
            )
        ]
    }
    
    private func extractSkillAssumptions(from intent: ProjectIntent) -> [Assumption] {
        [
            Assumption(
                category: .skill,
                statement: "Team has required skills or can acquire them quickly",
                confidence: 0.6
            )
        ]
    }
    
    private func extractResourceAssumptions(from intent: ProjectIntent) -> [Assumption] {
        [
            Assumption(
                category: .resource,
                statement: "Sufficient time and budget allocated for completion",
                confidence: 0.5
            )
        ]
    }
    
    private func confidenceEmoji(for confidence: Double) -> String {
        if confidence > 0.7 { return "🟢" }
        if confidence > 0.4 { return "🟡" }
        return "🔴"
    }
}
