//
//  ScopeBoundaryEnforcer.swift
//  IdeaKit - Project Operating System
//
//  Tool: ScopeBoundaryEnforcer
//  Phase: Specification
//  Purpose: Protect MVP scope and detect feature creep
//  Outputs: scope.md, mvp_definition.md
//

import Foundation

/// Enforces project scope boundaries and detects feature creep
public final class ScopeBoundaryEnforcer: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "scope_boundary_enforcer"
    public static let name = "Scope Boundary Enforcer"
    public static let description = "Define MVP scope, detect feature creep, and enforce scope gates"
    public static let phase = ProjectPhase.specification
    public static let outputs = ["scope.md", "mvp_definition.md"]
    public static let inputs = ["requirements.md", "functional_spec.md"]
    public static let isDefault = true
    
    // MARK: - Singleton
    
    public static let shared = ScopeBoundaryEnforcer()
    private init() {}
    
    // MARK: - Scope Definition
    
    /// Define scope from specification
    public func define(from spec: Specification) async throws -> ScopeDefinition {
        var scope = ScopeDefinition()
        
        // Define MVP features
        scope.mvpFeatures = [
            ScopedFeature(name: "Core Workflow", description: "Primary user workflow", priority: .critical, effort: .large),
            ScopedFeature(name: "Data Persistence", description: "Save and load user data", priority: .critical, effort: .medium),
            ScopedFeature(name: "Basic UI", description: "Essential user interface", priority: .high, effort: .medium)
        ]
        
        // Nice to have
        scope.niceToHave = [
            ScopedFeature(name: "Advanced Settings", description: "Customization options", priority: .medium, effort: .small),
            ScopedFeature(name: "Export Options", description: "Multiple export formats", priority: .low, effort: .medium)
        ]
        
        // Out of scope
        scope.outOfScope = [
            ScopedFeature(name: "Multi-user Collaboration", description: "Real-time collaboration", priority: .low, effort: .epic),
            ScopedFeature(name: "Mobile App", description: "Native mobile application", priority: .low, effort: .epic)
        ]
        
        // MVP gates
        scope.mvpGates = [
            MVPGate(name: "Core Complete", criteria: "All critical features implemented"),
            MVPGate(name: "Quality Gate", criteria: "No critical bugs, 80% test coverage"),
            MVPGate(name: "Documentation Gate", criteria: "User documentation complete"),
            MVPGate(name: "Performance Gate", criteria: "Meets performance requirements")
        ]
        
        return scope
    }
    
    /// Check if a proposed feature is within scope
    public func checkFeature(_ feature: String, against scope: ScopeDefinition) -> ScopeCheckResult {
        // Check MVP features
        if scope.mvpFeatures.contains(where: { $0.name.lowercased().contains(feature.lowercased()) }) {
            return ScopeCheckResult(status: .inScope, category: .mvp, recommendation: "Proceed with implementation")
        }
        
        // Check nice-to-have
        if scope.niceToHave.contains(where: { $0.name.lowercased().contains(feature.lowercased()) }) {
            return ScopeCheckResult(status: .deferred, category: .niceToHave, recommendation: "Defer to post-MVP")
        }
        
        // Check out of scope
        if scope.outOfScope.contains(where: { $0.name.lowercased().contains(feature.lowercased()) }) {
            return ScopeCheckResult(status: .outOfScope, category: .outOfScope, recommendation: "Do not implement")
        }
        
        // Unknown feature - potential creep
        return ScopeCheckResult(status: .potentialCreep, category: .unknown, recommendation: "Review and categorize before proceeding")
    }
    
    /// Generate scope markdown
    public func generateScopeMarkdown(from scope: ScopeDefinition) -> String {
        """
        # Project Scope Definition
        
        ## MVP Features (Must Have)
        
        \(scope.mvpFeatures.map { featureRow($0) }.joined(separator: "\n"))
        
        ## Nice to Have (Post-MVP)
        
        \(scope.niceToHave.map { featureRow($0) }.joined(separator: "\n"))
        
        ## Out of Scope
        
        \(scope.outOfScope.map { featureRow($0) }.joined(separator: "\n"))
        
        ## MVP Gates
        
        | Gate | Criteria | Status |
        |------|----------|--------|
        \(scope.mvpGates.map { "| \($0.name) | \($0.criteria) | \($0.passed ? "✅" : "⏳") |" }.joined(separator: "\n"))
        
        ---
        
        ## Scope Change Process
        
        1. Document the proposed change
        2. Assess impact on timeline and resources
        3. Get stakeholder approval
        4. Update scope documentation
        5. Communicate to team
        """
    }
    
    /// Generate MVP definition markdown
    public func generateMVPMarkdown(from scope: ScopeDefinition) -> String {
        let totalEffort = scope.mvpFeatures.reduce(0) { $0 + effortValue($1.effort) }
        
        return """
        # MVP Definition
        
        ## What is MVP?
        
        The Minimum Viable Product includes only the features necessary to:
        1. Solve the core problem
        2. Validate the value proposition
        3. Gather user feedback
        
        ## MVP Features
        
        \(scope.mvpFeatures.enumerated().map { index, feature in "\\(index + 1). **\\(feature.name)**: \\(feature.description)" }.joined(separator: "\n"))
        
        ## Estimated Effort
        
        Total effort points: \(totalEffort)
        
        ## MVP Completion Criteria
        
        All of the following must be true:
        
        \(scope.mvpGates.map { "- [ ] \($0.name): \($0.criteria)" }.joined(separator: "\n"))
        
        ## What MVP is NOT
        
        - Not a prototype or proof of concept
        - Not feature-complete
        - Not the final product
        
        MVP is the smallest thing we can build that delivers real value.
        """
    }
    
    // MARK: - Private Helpers
    
    private func featureRow(_ feature: ScopedFeature) -> String {
        let priorityEmoji = priorityEmoji(for: feature.priority)
        return "- \(priorityEmoji) **\(feature.name)**: \(feature.description) (Effort: \(feature.effort.rawValue))"
    }
    
    private func priorityEmoji(for priority: FeaturePriority) -> String {
        switch priority {
        case .critical: return "🔴"
        case .high: return "🟠"
        case .medium: return "🟡"
        case .low: return "🟢"
        }
    }
    
    private func effortValue(_ effort: EffortEstimate) -> Int {
        switch effort {
        case .trivial: return 1
        case .small: return 2
        case .medium: return 5
        case .large: return 8
        case .epic: return 13
        }
    }
}

// MARK: - Supporting Types

public struct ScopeCheckResult: Sendable {
    public let status: ScopeStatus
    public let category: ScopeCategory
    public let recommendation: String
}

public enum ScopeStatus: String, Sendable {
    case inScope = "in_scope"
    case deferred = "deferred"
    case outOfScope = "out_of_scope"
    case potentialCreep = "potential_creep"
}

public enum ScopeCategory: String, Sendable {
    case mvp = "mvp"
    case niceToHave = "nice_to_have"
    case outOfScope = "out_of_scope"
    case unknown = "unknown"
}
