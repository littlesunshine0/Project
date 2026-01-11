//
//  RiskAnalyzer.swift
//  IdeaKit - Project Operating System
//
//  Tool: RiskAnalyzer
//  Phase: Quality
//  Purpose: Identify project risks early with severity and mitigation
//  Outputs: risks.md
//

import Foundation

/// Analyzes and tracks project risks
public final class RiskAnalyzer: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "risk_analyzer"
    public static let name = "Risk Analyzer"
    public static let description = "Identify project risks early with severity ratings and mitigation strategies"
    public static let phase = ProjectPhase.quality
    public static let outputs = ["risks.md"]
    public static let inputs = ["intent.json", "scope.md", "architecture.md"]
    public static let isDefault = true
    
    // MARK: - Singleton
    
    public static let shared = RiskAnalyzer()
    private init() {}
    
    // MARK: - Analysis
    
    /// Analyze risks for a project context
    public func analyze(context: ProjectContext) async throws -> RiskAnalysis {
        var risks: [Risk] = []
        
        // Technical risks
        risks.append(contentsOf: analyzeTechnicalRisks())
        
        // Timeline risks
        risks.append(contentsOf: analyzeTimelineRisks())
        
        // Dependency risks
        risks.append(contentsOf: analyzeDependencyRisks())
        
        // Scope risks
        risks.append(contentsOf: analyzeScopeRisks())
        
        // Calculate overall score
        let score = calculateOverallScore(risks: risks)
        
        return RiskAnalysis(risks: risks, overallRiskScore: score)
    }
    
    /// Generate risks markdown
    public func generateMarkdown(from analysis: RiskAnalysis) -> String {
        var md = """
        # Risk Analysis
        
        ## Summary
        
        **Overall Risk Score**: \(riskScoreEmoji(analysis.overallRiskScore)) \(Int(analysis.overallRiskScore * 100))%
        
        | Category | Count | Critical | High |
        |----------|-------|----------|------|
        """
        
        let grouped = Dictionary(grouping: analysis.risks, by: { $0.category })
        
        for category in RiskCategory.allCases {
            let categoryRisks = grouped[category] ?? []
            let critical = categoryRisks.filter { $0.severity == .critical }.count
            let high = categoryRisks.filter { $0.severity == .high }.count
            md += "\n| \(category.rawValue.capitalized) | \(categoryRisks.count) | \(critical) | \(high) |"
        }
        
        md += "\n\n## Risk Details\n"
        
        // Sort by severity
        let sortedRisks = analysis.risks.sorted { severityOrder($0.severity) > severityOrder($1.severity) }
        
        for risk in sortedRisks {
            let severityEmoji = severityEmoji(for: risk.severity)
            let likelihoodEmoji = likelihoodEmoji(for: risk.likelihood)
            
            md += """
            
            ### \(severityEmoji) \(risk.description)
            
            - **Category**: \(risk.category.rawValue.capitalized)
            - **Severity**: \(risk.severity.rawValue.capitalized)
            - **Likelihood**: \(likelihoodEmoji) \(risk.likelihood.rawValue.capitalized)
            - **Status**: \(risk.status.rawValue.capitalized)
            
            **Mitigation**: \(risk.mitigation)
            
            """
        }
        
        md += """
        
        ---
        
        ## Risk Matrix
        
        ```
                    │ Rare │ Unlikely │ Possible │ Likely │ Certain │
        ────────────┼──────┼──────────┼──────────┼────────┼─────────┤
        Critical    │  M   │    H     │    H     │   C    │    C    │
        High        │  L   │    M     │    H     │   H    │    C    │
        Medium      │  L   │    L     │    M     │   M    │    H    │
        Low         │  L   │    L     │    L     │   M    │    M    │
        
        L = Low Priority, M = Medium Priority, H = High Priority, C = Critical
        ```
        
        ## Next Steps
        
        1. Address all Critical risks immediately
        2. Create mitigation plans for High risks
        3. Monitor Medium risks weekly
        4. Review Low risks monthly
        """
        
        return md
    }
    
    // MARK: - Private Analysis Methods
    
    private func analyzeTechnicalRisks() -> [Risk] {
        [
            Risk(
                category: .technical,
                description: "Technology stack may not scale",
                severity: .medium,
                likelihood: .possible,
                mitigation: "Design for horizontal scaling from the start"
            ),
            Risk(
                category: .technical,
                description: "Integration complexity with external systems",
                severity: .high,
                likelihood: .likely,
                mitigation: "Create abstraction layers and mock services early"
            ),
            Risk(
                category: .technical,
                description: "Performance bottlenecks in critical paths",
                severity: .medium,
                likelihood: .possible,
                mitigation: "Implement performance testing early in development"
            )
        ]
    }
    
    private func analyzeTimelineRisks() -> [Risk] {
        [
            Risk(
                category: .timeline,
                description: "Underestimated complexity of features",
                severity: .high,
                likelihood: .likely,
                mitigation: "Add buffer time and use confidence-based estimates"
            ),
            Risk(
                category: .timeline,
                description: "Dependencies on external teams or services",
                severity: .medium,
                likelihood: .possible,
                mitigation: "Identify dependencies early and establish communication channels"
            )
        ]
    }
    
    private func analyzeDependencyRisks() -> [Risk] {
        [
            Risk(
                category: .dependency,
                description: "Third-party library becomes unmaintained",
                severity: .medium,
                likelihood: .unlikely,
                mitigation: "Prefer well-maintained libraries with active communities"
            ),
            Risk(
                category: .dependency,
                description: "Breaking changes in dependencies",
                severity: .medium,
                likelihood: .possible,
                mitigation: "Pin dependency versions and test updates in isolation"
            )
        ]
    }
    
    private func analyzeScopeRisks() -> [Risk] {
        [
            Risk(
                category: .scope,
                description: "Feature creep expanding MVP scope",
                severity: .high,
                likelihood: .likely,
                mitigation: "Use ScopeBoundaryEnforcer and require approval for changes"
            ),
            Risk(
                category: .scope,
                description: "Unclear requirements leading to rework",
                severity: .medium,
                likelihood: .possible,
                mitigation: "Validate requirements with stakeholders before implementation"
            )
        ]
    }
    
    private func calculateOverallScore(risks: [Risk]) -> Double {
        guard !risks.isEmpty else { return 0 }
        
        let totalWeight = risks.reduce(0.0) { total, risk in
            let severityWeight = Double(severityOrder(risk.severity)) / 4.0
            let likelihoodWeight = Double(likelihoodOrder(risk.likelihood)) / 5.0
            return total + (severityWeight * likelihoodWeight)
        }
        
        return min(1.0, totalWeight / Double(risks.count))
    }
    
    private func severityOrder(_ severity: RiskSeverity) -> Int {
        switch severity {
        case .critical: return 4
        case .high: return 3
        case .medium: return 2
        case .low: return 1
        }
    }
    
    private func likelihoodOrder(_ likelihood: RiskLikelihood) -> Int {
        switch likelihood {
        case .certain: return 5
        case .likely: return 4
        case .possible: return 3
        case .unlikely: return 2
        case .rare: return 1
        }
    }
    
    private func severityEmoji(for severity: RiskSeverity) -> String {
        switch severity {
        case .critical: return "🔴"
        case .high: return "🟠"
        case .medium: return "🟡"
        case .low: return "🟢"
        }
    }
    
    private func likelihoodEmoji(for likelihood: RiskLikelihood) -> String {
        switch likelihood {
        case .certain: return "⬛"
        case .likely: return "🔳"
        case .possible: return "◻️"
        case .unlikely: return "▫️"
        case .rare: return "·"
        }
    }
    
    private func riskScoreEmoji(_ score: Double) -> String {
        if score > 0.7 { return "🔴" }
        if score > 0.4 { return "🟡" }
        return "🟢"
    }
}
