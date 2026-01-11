//
//  PlanningEngine.swift
//  AIKit - Core Intelligence Engine #3
//
//  Purpose: Predict how plans break and how to improve them
//  Capabilities: Task decomposition learning, estimate accuracy prediction,
//                critical path risk prediction, effort vs outcome optimization,
//                feature ROI modeling
//

import Foundation

// MARK: - Planning & Optimization Engine

/// Core Engine #3: Predicts how plans break and how to improve them
public actor PlanningEngine {
    public static let shared = PlanningEngine()
    
    private var estimateHistory: [EstimateRecord] = []
    private var taskPatterns: [TaskPattern]
    private var riskModels: [String: RiskModel] = [:]
    private var executionLog: [PlanningExecution] = []
    
    private init() {
        // Initialize patterns inline for Swift 6 actor isolation
        taskPatterns = [
            TaskPattern(type: "feature", avgComplexityMultiplier: 1.5, commonRisks: ["scope creep", "unclear requirements"]),
            TaskPattern(type: "bugfix", avgComplexityMultiplier: 1.2, commonRisks: ["root cause unclear", "regression"]),
            TaskPattern(type: "refactor", avgComplexityMultiplier: 1.8, commonRisks: ["hidden dependencies", "test coverage"]),
            TaskPattern(type: "integration", avgComplexityMultiplier: 2.0, commonRisks: ["API changes", "compatibility"]),
            TaskPattern(type: "infrastructure", avgComplexityMultiplier: 1.6, commonRisks: ["environment differences", "permissions"])
        ]
    }
    
    // MARK: - Task Decomposition
    
    /// Learn how to decompose goals into tasks like an expert
    public func decomposeTask(_ task: TaskInput) async -> TaskDecomposition {
        let start = Date()
        
        // Analyze task complexity
        let complexity = analyzeTaskComplexity(task)
        
        // Generate subtasks based on patterns
        let subtasks = generateSubtasks(task: task, complexity: complexity)
        
        // Identify dependencies
        let dependencies = identifyDependencies(subtasks: subtasks)
        
        // Calculate critical path
        let criticalPath = calculateCriticalPath(subtasks: subtasks, dependencies: dependencies)
        
        // Estimate total effort
        let totalEstimate = estimateTotalEffort(subtasks: subtasks)
        
        let result = TaskDecomposition(
            originalTask: task.description,
            subtasks: subtasks,
            dependencies: dependencies,
            criticalPath: criticalPath,
            totalEstimatedHours: totalEstimate,
            complexityScore: complexity,
            risks: identifyDecompositionRisks(task: task, subtasks: subtasks),
            recommendations: generateDecompositionRecommendations(complexity: complexity, subtasks: subtasks),
            processingTime: Date().timeIntervalSince(start)
        )
        
        executionLog.append(PlanningExecution(type: .decomposition, timestamp: Date()))
        return result
    }
    
    // MARK: - Estimate Accuracy Prediction
    
    /// Predict which estimates will be wrong
    public func predictEstimateAccuracy(_ estimate: EstimateInput) async -> EstimateAccuracyPrediction {
        let start = Date()
        
        // Analyze estimate characteristics
        let characteristics = analyzeEstimateCharacteristics(estimate)
        
        // Calculate accuracy probability based on historical data and characteristics
        let accuracyProbability = calculateAccuracyProbability(characteristics: characteristics)
        
        // Identify risk factors
        let riskFactors = identifyEstimateRisks(estimate: estimate, characteristics: characteristics)
        
        // Generate confidence range
        let confidenceRange = calculateConfidenceRange(estimate: estimate, accuracy: accuracyProbability)
        
        // Suggest adjustments
        let adjustedEstimate = suggestAdjustedEstimate(estimate: estimate, accuracy: accuracyProbability)
        
        return EstimateAccuracyPrediction(
            originalEstimate: estimate.hours,
            accuracyProbability: accuracyProbability,
            confidenceRange: confidenceRange,
            adjustedEstimate: adjustedEstimate,
            riskFactors: riskFactors,
            historicalComparison: compareToHistorical(estimate: estimate),
            recommendations: generateEstimateRecommendations(accuracy: accuracyProbability, risks: riskFactors),
            processingTime: Date().timeIntervalSince(start)
        )
    }
    
    /// Record actual vs estimated for learning
    public func recordEstimateOutcome(estimateId: String, estimated: Float, actual: Float, context: [String: String] = [:]) {
        let record = EstimateRecord(
            id: estimateId,
            estimated: estimated,
            actual: actual,
            ratio: actual / max(0.1, estimated),
            context: context,
            timestamp: Date()
        )
        estimateHistory.append(record)
    }
    
    // MARK: - Critical Path Risk Prediction
    
    /// Learn where plans typically break
    public func predictCriticalPathRisks(plan: PlanInput) async -> CriticalPathRiskPrediction {
        let start = Date()
        
        var taskRisks: [TaskRiskAssessment] = []
        var criticalTasks: [String] = []
        
        for task in plan.tasks {
            let risk = assessTaskRisk(task: task, plan: plan)
            taskRisks.append(risk)
            
            if risk.isOnCriticalPath && risk.overallRisk > 0.6 {
                criticalTasks.append(task.id)
            }
        }
        
        // Calculate overall plan risk
        let overallRisk = calculateOverallPlanRisk(taskRisks: taskRisks)
        
        // Identify failure points
        let failurePoints = identifyFailurePoints(taskRisks: taskRisks)
        
        // Generate mitigation strategies
        let mitigations = generateMitigationStrategies(failurePoints: failurePoints)
        
        return CriticalPathRiskPrediction(
            overallRisk: overallRisk,
            criticalTasks: criticalTasks,
            taskRisks: taskRisks,
            failurePoints: failurePoints,
            mitigationStrategies: mitigations,
            confidenceLevel: calculatePredictionConfidence(taskCount: plan.tasks.count),
            processingTime: Date().timeIntervalSince(start)
        )
    }
    
    // MARK: - Effort vs Outcome Optimization
    
    /// Find smallest effort for desired result
    public func optimizeEffort(goal: GoalInput, constraints: EffortConstraints) async -> EffortOptimization {
        let start = Date()
        
        // Generate possible approaches
        let approaches = generateApproaches(goal: goal)
        
        // Score each approach
        var scoredApproaches: [ScoredApproach] = []
        for approach in approaches {
            let effort = estimateApproachEffort(approach: approach)
            let outcome = predictApproachOutcome(approach: approach, goal: goal)
            let efficiency = outcome / max(0.1, effort)
            
            if effort <= constraints.maxEffort {
                scoredApproaches.append(ScoredApproach(
                    approach: approach,
                    estimatedEffort: effort,
                    predictedOutcome: outcome,
                    efficiencyScore: efficiency,
                    risks: identifyApproachRisks(approach: approach)
                ))
            }
        }
        
        // Sort by efficiency
        scoredApproaches.sort { $0.efficiencyScore > $1.efficiencyScore }
        
        return EffortOptimization(
            goal: goal.description,
            recommendedApproach: scoredApproaches.first,
            alternatives: Array(scoredApproaches.dropFirst().prefix(3)),
            constraints: constraints,
            tradeoffs: analyzeTradeoffs(approaches: scoredApproaches),
            processingTime: Date().timeIntervalSince(start)
        )
    }
    
    // MARK: - Feature ROI Modeling
    
    /// Model feature impact vs effort vs risk
    public func modelFeatureROI(feature: FeatureInput) async -> FeatureROIModel {
        let start = Date()
        
        // Estimate development effort
        let effort = estimateFeatureEffort(feature: feature)
        
        // Predict impact
        let impact = predictFeatureImpact(feature: feature)
        
        // Assess risks
        let risks = assessFeatureRisks(feature: feature)
        
        // Calculate ROI
        let roi = calculateROI(impact: impact, effort: effort, risks: risks)
        
        // Compare to alternatives
        let comparison = compareToAlternatives(feature: feature, roi: roi)
        
        return FeatureROIModel(
            feature: feature.name,
            estimatedEffort: effort,
            predictedImpact: impact,
            risks: risks,
            roiScore: roi,
            paybackPeriod: calculatePaybackPeriod(impact: impact, effort: effort),
            recommendation: generateROIRecommendation(roi: roi, risks: risks),
            comparison: comparison,
            processingTime: Date().timeIntervalSince(start)
        )
    }
    
    // MARK: - Private Helpers
    
    private func analyzeTaskComplexity(_ task: TaskInput) -> Float {
        var complexity: Float = 0.3
        
        // Check for complexity indicators
        let lowercased = task.description.lowercased()
        if lowercased.contains("complex") || lowercased.contains("advanced") { complexity += 0.2 }
        if lowercased.contains("integration") || lowercased.contains("api") { complexity += 0.15 }
        if lowercased.contains("refactor") || lowercased.contains("rewrite") { complexity += 0.2 }
        if lowercased.contains("new") || lowercased.contains("create") { complexity += 0.1 }
        
        // Adjust for task type
        if let pattern = taskPatterns.first(where: { lowercased.contains($0.type) }) {
            complexity *= pattern.avgComplexityMultiplier / 1.5
        }
        
        return min(1.0, complexity)
    }
    
    private func generateSubtasks(task: TaskInput, complexity: Float) -> [Subtask] {
        var subtasks: [Subtask] = []
        let lowercased = task.description.lowercased()
        
        // Always include planning
        subtasks.append(Subtask(id: "plan", name: "Planning & Design", estimatedHours: 2 * complexity, priority: 1))
        
        // Core implementation
        subtasks.append(Subtask(id: "impl", name: "Implementation", estimatedHours: task.estimatedHours * 0.5, priority: 2))
        
        // Testing
        subtasks.append(Subtask(id: "test", name: "Testing", estimatedHours: task.estimatedHours * 0.2, priority: 3))
        
        // Integration if needed
        if lowercased.contains("integration") || lowercased.contains("api") {
            subtasks.append(Subtask(id: "integrate", name: "Integration", estimatedHours: task.estimatedHours * 0.15, priority: 2))
        }
        
        // Documentation
        subtasks.append(Subtask(id: "docs", name: "Documentation", estimatedHours: 1 + complexity, priority: 4))
        
        // Review
        subtasks.append(Subtask(id: "review", name: "Code Review", estimatedHours: 1, priority: 5))
        
        return subtasks
    }
    
    private func identifyDependencies(subtasks: [Subtask]) -> [TaskDependency] {
        var dependencies: [TaskDependency] = []
        
        // Standard dependency chain
        if subtasks.contains(where: { $0.id == "plan" }) && subtasks.contains(where: { $0.id == "impl" }) {
            dependencies.append(TaskDependency(from: "plan", to: "impl", type: .finishToStart))
        }
        if subtasks.contains(where: { $0.id == "impl" }) && subtasks.contains(where: { $0.id == "test" }) {
            dependencies.append(TaskDependency(from: "impl", to: "test", type: .finishToStart))
        }
        if subtasks.contains(where: { $0.id == "test" }) && subtasks.contains(where: { $0.id == "review" }) {
            dependencies.append(TaskDependency(from: "test", to: "review", type: .finishToStart))
        }
        
        return dependencies
    }
    
    private func calculateCriticalPath(subtasks: [Subtask], dependencies: [TaskDependency]) -> [String] {
        // Simplified: return tasks in dependency order
        return subtasks.sorted { $0.priority < $1.priority }.map { $0.id }
    }
    
    private func estimateTotalEffort(subtasks: [Subtask]) -> Float {
        subtasks.reduce(0) { $0 + $1.estimatedHours }
    }
    
    private func identifyDecompositionRisks(task: TaskInput, subtasks: [Subtask]) -> [String] {
        var risks: [String] = []
        if subtasks.count > 8 { risks.append("High number of subtasks may indicate scope creep") }
        if task.estimatedHours > 40 { risks.append("Large task - consider breaking into smaller deliverables") }
        return risks
    }
    
    private func generateDecompositionRecommendations(complexity: Float, subtasks: [Subtask]) -> [String] {
        var recommendations: [String] = []
        if complexity > 0.7 {
            recommendations.append("Consider spike/prototype phase before full implementation")
        }
        recommendations.append("Review subtask estimates with team")
        return recommendations
    }
    
    private func analyzeEstimateCharacteristics(_ estimate: EstimateInput) -> EstimateCharacteristics {
        let isRoundNumber = estimate.hours.truncatingRemainder(dividingBy: 4) == 0
        let isLarge = estimate.hours > 20
        let hasUncertainty = estimate.description.lowercased().contains("maybe") || estimate.description.lowercased().contains("about")
        
        return EstimateCharacteristics(
            isRoundNumber: isRoundNumber,
            isLarge: isLarge,
            hasUncertaintyLanguage: hasUncertainty,
            taskType: detectTaskType(estimate.description)
        )
    }
    
    private func detectTaskType(_ description: String) -> String {
        let lowercased = description.lowercased()
        for pattern in taskPatterns {
            if lowercased.contains(pattern.type) { return pattern.type }
        }
        return "general"
    }
    
    private func calculateAccuracyProbability(characteristics: EstimateCharacteristics) -> Float {
        var accuracy: Float = 0.7
        
        if characteristics.isRoundNumber { accuracy -= 0.1 }
        if characteristics.isLarge { accuracy -= 0.15 }
        if characteristics.hasUncertaintyLanguage { accuracy -= 0.1 }
        
        // Historical adjustment
        if !estimateHistory.isEmpty {
            let avgRatio = estimateHistory.reduce(0.0) { $0 + $1.ratio } / Float(estimateHistory.count)
            if avgRatio > 1.3 { accuracy -= 0.1 }
        }
        
        return max(0.2, min(0.95, accuracy))
    }
    
    private func identifyEstimateRisks(estimate: EstimateInput, characteristics: EstimateCharacteristics) -> [String] {
        var risks: [String] = []
        if characteristics.isRoundNumber { risks.append("Round number estimates often underestimate") }
        if characteristics.isLarge { risks.append("Large estimates have higher variance") }
        if characteristics.hasUncertaintyLanguage { risks.append("Uncertainty language suggests incomplete understanding") }
        return risks
    }
    
    private func calculateConfidenceRange(estimate: EstimateInput, accuracy: Float) -> ConfidenceRange {
        let variance = (1.0 - accuracy) * estimate.hours
        return ConfidenceRange(
            low: max(1, estimate.hours - variance),
            expected: estimate.hours,
            high: estimate.hours + variance * 1.5
        )
    }
    
    private func suggestAdjustedEstimate(estimate: EstimateInput, accuracy: Float) -> Float {
        // Apply historical bias correction
        var adjustment: Float = 1.0
        if !estimateHistory.isEmpty {
            let avgRatio = estimateHistory.reduce(0.0) { $0 + $1.ratio } / Float(estimateHistory.count)
            adjustment = avgRatio
        }
        return estimate.hours * max(1.0, adjustment)
    }
    
    private func compareToHistorical(estimate: EstimateInput) -> String {
        if estimateHistory.isEmpty { return "No historical data available" }
        let avgRatio = estimateHistory.reduce(0.0) { $0 + $1.ratio } / Float(estimateHistory.count)
        if avgRatio > 1.3 { return "Historical data suggests estimates typically run \(Int((avgRatio - 1) * 100))% over" }
        if avgRatio < 0.9 { return "Historical data suggests estimates are typically conservative" }
        return "Historical estimates have been reasonably accurate"
    }
    
    private func generateEstimateRecommendations(accuracy: Float, risks: [String]) -> [String] {
        var recommendations: [String] = []
        if accuracy < 0.6 {
            recommendations.append("Consider breaking down into smaller, more estimable tasks")
            recommendations.append("Add buffer time for unknowns")
        }
        if !risks.isEmpty {
            recommendations.append("Address identified risk factors before committing to timeline")
        }
        return recommendations
    }
    
    private func assessTaskRisk(task: PlanTask, plan: PlanInput) -> TaskRiskAssessment {
        var risk: Float = 0.3
        
        // Check dependencies
        let dependencyCount = plan.tasks.filter { $0.dependencies.contains(task.id) }.count
        if dependencyCount > 2 { risk += 0.2 }
        
        // Check if on critical path (simplified)
        let isOnCriticalPath = dependencyCount > 0 || task.dependencies.isEmpty
        if isOnCriticalPath { risk += 0.1 }
        
        // Check estimate size
        if task.estimatedHours > 16 { risk += 0.15 }
        
        return TaskRiskAssessment(
            taskId: task.id,
            taskName: task.name,
            overallRisk: min(1.0, risk),
            isOnCriticalPath: isOnCriticalPath,
            riskFactors: identifyTaskRiskFactors(task: task),
            mitigations: suggestTaskMitigations(risk: risk)
        )
    }
    
    private func identifyTaskRiskFactors(task: PlanTask) -> [String] {
        var factors: [String] = []
        if task.dependencies.count > 2 { factors.append("Multiple dependencies") }
        if task.estimatedHours > 16 { factors.append("Large task size") }
        return factors
    }
    
    private func suggestTaskMitigations(risk: Float) -> [String] {
        if risk > 0.7 { return ["Add buffer time", "Identify backup resources", "Create contingency plan"] }
        if risk > 0.5 { return ["Monitor closely", "Have fallback approach ready"] }
        return []
    }
    
    private func calculateOverallPlanRisk(taskRisks: [TaskRiskAssessment]) -> Float {
        if taskRisks.isEmpty { return 0.5 }
        let criticalRisks = taskRisks.filter { $0.isOnCriticalPath }
        if criticalRisks.isEmpty { return taskRisks.reduce(0) { $0 + $1.overallRisk } / Float(taskRisks.count) }
        return criticalRisks.reduce(0) { $0 + $1.overallRisk } / Float(criticalRisks.count)
    }
    
    private func identifyFailurePoints(taskRisks: [TaskRiskAssessment]) -> [FailurePoint] {
        taskRisks.filter { $0.overallRisk > 0.6 }.map {
            FailurePoint(taskId: $0.taskId, probability: $0.overallRisk, impact: "Schedule delay", cause: $0.riskFactors.first ?? "Unknown")
        }
    }
    
    private func generateMitigationStrategies(failurePoints: [FailurePoint]) -> [MitigationStrategy] {
        failurePoints.map {
            MitigationStrategy(
                failurePointId: $0.taskId,
                strategy: "Add buffer and monitoring for \($0.taskId)",
                effort: .medium,
                effectiveness: 0.7
            )
        }
    }
    
    private func calculatePredictionConfidence(taskCount: Int) -> Float {
        // More tasks = more data = higher confidence, up to a point
        return min(0.9, 0.5 + Float(taskCount) * 0.05)
    }
    
    private func generateApproaches(goal: GoalInput) -> [Approach] {
        [
            Approach(id: "minimal", name: "Minimal Viable", description: "Smallest implementation that achieves core goal", scope: .minimal),
            Approach(id: "standard", name: "Standard", description: "Full implementation with standard features", scope: .standard),
            Approach(id: "comprehensive", name: "Comprehensive", description: "Full implementation with extras", scope: .comprehensive)
        ]
    }
    
    private func estimateApproachEffort(approach: Approach) -> Float {
        switch approach.scope {
        case .minimal: return 10
        case .standard: return 25
        case .comprehensive: return 50
        }
    }
    
    private func predictApproachOutcome(approach: Approach, goal: GoalInput) -> Float {
        switch approach.scope {
        case .minimal: return 0.6
        case .standard: return 0.85
        case .comprehensive: return 0.95
        }
    }
    
    private func identifyApproachRisks(approach: Approach) -> [String] {
        switch approach.scope {
        case .minimal: return ["May not fully meet needs", "Technical debt"]
        case .standard: return ["Moderate timeline risk"]
        case .comprehensive: return ["Scope creep", "Timeline risk", "Over-engineering"]
        }
    }
    
    private func analyzeTradeoffs(approaches: [ScoredApproach]) -> [String] {
        ["Speed vs completeness", "Effort vs quality", "Short-term vs long-term value"]
    }
    
    private func estimateFeatureEffort(feature: FeatureInput) -> FeatureEffort {
        let baseHours: Float = 20
        let complexity = feature.complexity
        return FeatureEffort(
            developmentHours: baseHours * complexity,
            testingHours: baseHours * complexity * 0.3,
            documentationHours: 4,
            totalHours: baseHours * complexity * 1.3 + 4
        )
    }
    
    private func predictFeatureImpact(feature: FeatureInput) -> FeatureImpact {
        FeatureImpact(
            userValue: feature.expectedValue,
            revenueImpact: feature.expectedValue * 0.8,
            retentionImpact: feature.expectedValue * 0.6,
            overallScore: feature.expectedValue
        )
    }
    
    private func assessFeatureRisks(feature: FeatureInput) -> [FeatureRisk] {
        var risks: [FeatureRisk] = []
        if feature.complexity > 0.7 {
            risks.append(FeatureRisk(risk: "High complexity", probability: 0.6, impact: 0.7))
        }
        if feature.dependencies.count > 2 {
            risks.append(FeatureRisk(risk: "Multiple dependencies", probability: 0.5, impact: 0.5))
        }
        return risks
    }
    
    private func calculateROI(impact: FeatureImpact, effort: FeatureEffort, risks: [FeatureRisk]) -> Float {
        let riskFactor = 1.0 - risks.reduce(0.0) { $0 + $1.probability * $1.impact } / max(1, Float(risks.count))
        return (impact.overallScore * riskFactor) / (effort.totalHours / 100.0)
    }
    
    private func calculatePaybackPeriod(impact: FeatureImpact, effort: FeatureEffort) -> String {
        let months = effort.totalHours / (impact.overallScore * 10)
        if months < 1 { return "< 1 month" }
        if months < 3 { return "1-3 months" }
        if months < 6 { return "3-6 months" }
        return "6+ months"
    }
    
    private func generateROIRecommendation(roi: Float, risks: [FeatureRisk]) -> String {
        if roi > 2.0 && risks.isEmpty { return "Strong recommendation to proceed" }
        if roi > 1.0 { return "Recommended with risk mitigation" }
        if roi > 0.5 { return "Consider alternatives or scope reduction" }
        return "Not recommended in current form"
    }
    
    private func compareToAlternatives(feature: FeatureInput, roi: Float) -> String {
        "ROI score of \(String(format: "%.1f", roi)) - compare against other features in backlog"
    }
    
    // MARK: - Stats
    
    public var stats: PlanningStats {
        PlanningStats(
            totalExecutions: executionLog.count,
            estimateRecords: estimateHistory.count,
            averageEstimateAccuracy: estimateHistory.isEmpty ? 0 : 1.0 / (estimateHistory.reduce(0) { $0 + abs($1.ratio - 1.0) } / Float(estimateHistory.count) + 1.0)
        )
    }
}
