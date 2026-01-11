//
//  DependencyAdvisor.swift
//  IdeaKit - Project Operating System
//
//  Tool: DependencyAdvisor
//  Phase: Architecture
//  Purpose: Safe dependency selection and risk assessment
//  Outputs: dependencies.md
//

import Foundation

/// Advises on dependency selection and risks
public final class DependencyAdvisor: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "dependency_advisor"
    public static let name = "Dependency Advisor"
    public static let description = "Recommend libraries, flag risky dependencies, suggest alternatives"
    public static let phase = ProjectPhase.architecture
    public static let outputs = ["dependencies.md"]
    public static let inputs = ["architecture.md"]
    public static let isDefault = false
    
    // MARK: - Singleton
    
    public static let shared = DependencyAdvisor()
    private init() {}
    
    // MARK: - Analysis
    
    /// Analyze dependencies for a project
    public func analyze(dependencies: [Dependency]) -> DependencyAnalysis {
        var analysis = DependencyAnalysis()
        
        for dep in dependencies {
            let risk = assessRisk(dep)
            analysis.assessments.append(DependencyAssessment(dependency: dep, risk: risk))
            
            if risk.level == .high || risk.level == .critical {
                if let alternative = findAlternative(for: dep) {
                    analysis.alternatives[dep.name] = alternative
                }
            }
        }
        
        return analysis
    }
    
    /// Generate dependencies markdown
    public func generateMarkdown(from analysis: DependencyAnalysis) -> String {
        var md = """
        # Dependencies Analysis
        
        ## Summary
        
        | Risk Level | Count |
        |------------|-------|
        | Critical | \(analysis.assessments.filter { $0.risk.level == .critical }.count) |
        | High | \(analysis.assessments.filter { $0.risk.level == .high }.count) |
        | Medium | \(analysis.assessments.filter { $0.risk.level == .medium }.count) |
        | Low | \(analysis.assessments.filter { $0.risk.level == .low }.count) |
        
        ## Dependencies
        
        """
        
        for assessment in analysis.assessments.sorted(by: { riskOrder($0.risk.level) > riskOrder($1.risk.level) }) {
            let emoji = riskEmoji(assessment.risk.level)
            let dep = assessment.dependency
            
            md += """
            
            ### \(emoji) \(dep.name)
            
            - **Version**: \(dep.version)
            - **Purpose**: \(dep.purpose)
            - **Risk Level**: \(assessment.risk.level.rawValue.capitalized)
            - **Risk Factors**: \(assessment.risk.factors.joined(separator: ", "))
            
            """
            
            if let alt = analysis.alternatives[dep.name] {
                md += "**Suggested Alternative**: \(alt)\n"
            }
        }
        
        md += """
        
        ---
        
        ## Best Practices
        
        1. Pin dependency versions in production
        2. Regularly audit for security vulnerabilities
        3. Prefer dependencies with active maintenance
        4. Minimize total dependency count
        5. Avoid dependencies with restrictive licenses
        """
        
        return md
    }
    
    // MARK: - Private Methods
    
    private func assessRisk(_ dep: Dependency) -> DependencyRisk {
        var factors: [String] = []
        var level: DependencyRiskLevel = .low
        
        // Check maintenance status
        if dep.lastUpdate < Date().addingTimeInterval(-365 * 24 * 60 * 60) {
            factors.append("Not updated in over a year")
            level = max(level, .medium)
        }
        
        // Check popularity (simplified)
        if dep.stars < 100 {
            factors.append("Low community adoption")
            level = max(level, .medium)
        }
        
        // Check for known issues
        if dep.hasKnownVulnerabilities {
            factors.append("Known security vulnerabilities")
            level = .critical
        }
        
        return DependencyRisk(level: level, factors: factors)
    }
    
    private func findAlternative(for dep: Dependency) -> String? {
        // Simplified alternative lookup
        let alternatives: [String: String] = [
            "Alamofire": "URLSession (built-in)",
            "SwiftyJSON": "Codable (built-in)",
            "SnapKit": "SwiftUI layouts",
            "RxSwift": "Combine (built-in)"
        ]
        return alternatives[dep.name]
    }
    
    private func riskOrder(_ level: DependencyRiskLevel) -> Int {
        switch level {
        case .critical: return 4
        case .high: return 3
        case .medium: return 2
        case .low: return 1
        }
    }
    
    private func riskEmoji(_ level: DependencyRiskLevel) -> String {
        switch level {
        case .critical: return "🔴"
        case .high: return "🟠"
        case .medium: return "🟡"
        case .low: return "🟢"
        }
    }
}

// MARK: - Supporting Types

public struct Dependency: Sendable {
    public let name: String
    public let version: String
    public let purpose: String
    public let lastUpdate: Date
    public let stars: Int
    public let hasKnownVulnerabilities: Bool
    
    public init(name: String, version: String, purpose: String = "", lastUpdate: Date = Date(), stars: Int = 1000, hasKnownVulnerabilities: Bool = false) {
        self.name = name
        self.version = version
        self.purpose = purpose
        self.lastUpdate = lastUpdate
        self.stars = stars
        self.hasKnownVulnerabilities = hasKnownVulnerabilities
    }
}

public struct DependencyRisk: Sendable {
    public let level: DependencyRiskLevel
    public let factors: [String]
}

public enum DependencyRiskLevel: String, Sendable, Comparable {
    case low, medium, high, critical
    
    public static func < (lhs: DependencyRiskLevel, rhs: DependencyRiskLevel) -> Bool {
        let order: [DependencyRiskLevel] = [.low, .medium, .high, .critical]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}

public struct DependencyAssessment: Sendable {
    public let dependency: Dependency
    public let risk: DependencyRisk
}

public struct DependencyAnalysis: Sendable {
    public var assessments: [DependencyAssessment] = []
    public var alternatives: [String: String] = [:]
}
