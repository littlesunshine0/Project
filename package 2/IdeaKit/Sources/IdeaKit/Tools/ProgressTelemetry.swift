//
//  ProgressTelemetry.swift
//  IdeaKit - Project Operating System
//
//  Tool: ProgressTelemetry
//  Phase: Execution
//  Purpose: Track project health, velocity, scope creep, spec-code drift
//  Outputs: status.md, health_score.json
//

import Foundation

/// Tracks project progress and health metrics
public final class ProgressTelemetry: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "progress_telemetry"
    public static let name = "Progress Telemetry"
    public static let description = "Track project health, task velocity, scope creep, and spec-code drift"
    public static let phase = ProjectPhase.execution
    public static let outputs = ["status.md", "health_score.json"]
    public static let inputs = ["tasks.md", "scope.md"]
    public static let isDefault = false
    
    // MARK: - Singleton
    
    public static let shared = ProgressTelemetry()
    private init() {}
    
    // MARK: - Tracking
    
    /// Calculate project health
    public func calculateHealth(tasks: TaskDecomposition, scope: ScopeDefinition) -> ProjectHealth {
        var health = ProjectHealth()
        
        // Task completion
        let completedTasks = tasks.tasks.filter { $0.status == .completed }.count
        let totalTasks = tasks.tasks.count
        health.taskCompletion = totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0
        
        // Velocity (simplified - tasks completed per milestone)
        let milestonesWithCompletedTasks = Set(tasks.tasks.filter { $0.status == .completed }.map { $0.milestone }).count
        health.velocity = milestonesWithCompletedTasks > 0 ? Double(completedTasks) / Double(milestonesWithCompletedTasks) : 0
        
        // Scope creep detection
        let mvpFeatureCount = scope.mvpFeatures.count
        let niceToHaveCount = scope.niceToHave.count
        health.scopeCreepRisk = niceToHaveCount > mvpFeatureCount ? 0.7 : 0.3
        
        // MVP gate progress
        let passedGates = scope.mvpGates.filter { $0.passed }.count
        health.gateProgress = scope.mvpGates.isEmpty ? 0 : Double(passedGates) / Double(scope.mvpGates.count)
        
        // Overall health score
        health.overallScore = (health.taskCompletion * 0.4) + ((1 - health.scopeCreepRisk) * 0.3) + (health.gateProgress * 0.3)
        
        return health
    }
    
    /// Generate status markdown
    public func generateStatusMarkdown(health: ProjectHealth, tasks: TaskDecomposition) -> String {
        let scoreEmoji = healthEmoji(health.overallScore)
        
        return """
        # Project Status
        
        _Generated: \(formatDate(Date()))_
        
        ## Health Score
        
        \(scoreEmoji) **\(Int(health.overallScore * 100))%**
        
        ## Metrics
        
        | Metric | Value | Status |
        |--------|-------|--------|
        | Task Completion | \(Int(health.taskCompletion * 100))% | \(metricStatus(health.taskCompletion)) |
        | Velocity | \(String(format: "%.1f", health.velocity)) tasks/milestone | \(velocityStatus(health.velocity)) |
        | Scope Creep Risk | \(Int(health.scopeCreepRisk * 100))% | \(riskStatus(health.scopeCreepRisk)) |
        | Gate Progress | \(Int(health.gateProgress * 100))% | \(metricStatus(health.gateProgress)) |
        
        ## Task Breakdown
        
        | Status | Count |
        |--------|-------|
        | ✅ Completed | \(tasks.tasks.filter { $0.status == .completed }.count) |
        | 🔄 In Progress | \(tasks.tasks.filter { $0.status == .inProgress }.count) |
        | ⏳ Pending | \(tasks.tasks.filter { $0.status == .pending }.count) |
        | 🚫 Blocked | \(tasks.tasks.filter { $0.status == .blocked }.count) |
        
        ## Milestone Progress
        
        \(milestoneProgress(tasks))
        
        ## Recommendations
        
        \(generateRecommendations(health: health))
        """
    }
    
    /// Generate health score JSON
    public func generateHealthJSON(health: ProjectHealth) -> [String: Any] {
        [
            "overallScore": health.overallScore,
            "metrics": [
                "taskCompletion": health.taskCompletion,
                "velocity": health.velocity,
                "scopeCreepRisk": health.scopeCreepRisk,
                "gateProgress": health.gateProgress
            ],
            "status": healthStatus(health.overallScore),
            "generatedAt": ISO8601DateFormatter().string(from: Date())
        ]
    }
    
    // MARK: - Private Helpers
    
    private func healthEmoji(_ score: Double) -> String {
        if score >= 0.8 { return "🟢" }
        if score >= 0.6 { return "🟡" }
        if score >= 0.4 { return "🟠" }
        return "🔴"
    }
    
    private func healthStatus(_ score: Double) -> String {
        if score >= 0.8 { return "healthy" }
        if score >= 0.6 { return "good" }
        if score >= 0.4 { return "at_risk" }
        return "critical"
    }
    
    private func metricStatus(_ value: Double) -> String {
        if value >= 0.7 { return "✅" }
        if value >= 0.4 { return "⚠️" }
        return "❌"
    }
    
    private func velocityStatus(_ velocity: Double) -> String {
        if velocity >= 3 { return "✅ Good" }
        if velocity >= 1 { return "⚠️ Slow" }
        return "❌ Stalled"
    }
    
    private func riskStatus(_ risk: Double) -> String {
        if risk < 0.3 { return "✅ Low" }
        if risk < 0.6 { return "⚠️ Medium" }
        return "❌ High"
    }
    
    private func milestoneProgress(_ tasks: TaskDecomposition) -> String {
        var progress = ""
        
        for milestone in tasks.milestones {
            let milestoneTasks = tasks.tasks.filter { $0.milestone == milestone.name }
            let completed = milestoneTasks.filter { $0.status == .completed }.count
            let total = milestoneTasks.count
            let percent = total > 0 ? (Double(completed) / Double(total)) * 100 : 0
            let bar = progressBar(percent / 100)
            
            progress += "- **\(milestone.name)**: \(bar) \(Int(percent))% (\(completed)/\(total))\n"
        }
        
        return progress
    }
    
    private func progressBar(_ progress: Double) -> String {
        let filled = Int(progress * 10)
        let empty = 10 - filled
        return "[" + String(repeating: "█", count: filled) + String(repeating: "░", count: empty) + "]"
    }
    
    private func generateRecommendations(health: ProjectHealth) -> String {
        var recommendations: [String] = []
        
        if health.taskCompletion < 0.5 {
            recommendations.append("- Focus on completing pending tasks before adding new ones")
        }
        
        if health.scopeCreepRisk > 0.5 {
            recommendations.append("- Review scope and defer non-MVP features")
        }
        
        if health.velocity < 2 {
            recommendations.append("- Identify and remove blockers to improve velocity")
        }
        
        if health.gateProgress < 0.5 {
            recommendations.append("- Prioritize MVP gate criteria completion")
        }
        
        return recommendations.isEmpty ? "- Project is on track! Keep up the good work." : recommendations.joined(separator: "\n")
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Types

public struct ProjectHealth: Sendable {
    public var overallScore: Double = 0
    public var taskCompletion: Double = 0
    public var velocity: Double = 0
    public var scopeCreepRisk: Double = 0
    public var gateProgress: Double = 0
    
    public init() {}
}
