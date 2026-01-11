//
//  PlanningModels.swift
//  AIKit - Planning Engine Models
//

import Foundation

// MARK: - Task Decomposition

public struct TaskInput: Sendable {
    public let description: String
    public let estimatedHours: Float
    public let context: [String: String]
    
    public init(description: String, estimatedHours: Float = 8, context: [String: String] = [:]) {
        self.description = description
        self.estimatedHours = estimatedHours
        self.context = context
    }
}

public struct TaskDecomposition: Sendable {
    public let originalTask: String
    public let subtasks: [Subtask]
    public let dependencies: [TaskDependency]
    public let criticalPath: [String]
    public let totalEstimatedHours: Float
    public let complexityScore: Float
    public let risks: [String]
    public let recommendations: [String]
    public let processingTime: TimeInterval
}

public struct Subtask: Sendable {
    public let id: String
    public let name: String
    public let estimatedHours: Float
    public let priority: Int
}

public struct TaskDependency: Sendable {
    public let from: String
    public let to: String
    public let type: DependencyType
}

public enum DependencyType: String, Sendable {
    case finishToStart, startToStart, finishToFinish, startToFinish
}

public struct TaskPattern: Sendable {
    public let type: String
    public let avgComplexityMultiplier: Float
    public let commonRisks: [String]
}

// MARK: - Estimate Accuracy

public struct EstimateInput: Sendable {
    public let description: String
    public let hours: Float
    public let taskType: String
    
    public init(description: String, hours: Float, taskType: String = "general") {
        self.description = description
        self.hours = hours
        self.taskType = taskType
    }
}

public struct EstimateAccuracyPrediction: Sendable {
    public let originalEstimate: Float
    public let accuracyProbability: Float
    public let confidenceRange: ConfidenceRange
    public let adjustedEstimate: Float
    public let riskFactors: [String]
    public let historicalComparison: String
    public let recommendations: [String]
    public let processingTime: TimeInterval
}

public struct ConfidenceRange: Sendable {
    public let low: Float
    public let expected: Float
    public let high: Float
}

public struct EstimateRecord: Sendable {
    public let id: String
    public let estimated: Float
    public let actual: Float
    public let ratio: Float
    public let context: [String: String]
    public let timestamp: Date
}

struct EstimateCharacteristics {
    let isRoundNumber: Bool
    let isLarge: Bool
    let hasUncertaintyLanguage: Bool
    let taskType: String
}

// MARK: - Critical Path Risk

public struct PlanInput: Sendable {
    public let name: String
    public let tasks: [PlanTask]
    
    public init(name: String, tasks: [PlanTask]) {
        self.name = name
        self.tasks = tasks
    }
}

public struct PlanTask: Sendable {
    public let id: String
    public let name: String
    public let estimatedHours: Float
    public let dependencies: [String]
    
    public init(id: String, name: String, estimatedHours: Float, dependencies: [String] = []) {
        self.id = id
        self.name = name
        self.estimatedHours = estimatedHours
        self.dependencies = dependencies
    }
}

public struct CriticalPathRiskPrediction: Sendable {
    public let overallRisk: Float
    public let criticalTasks: [String]
    public let taskRisks: [TaskRiskAssessment]
    public let failurePoints: [FailurePoint]
    public let mitigationStrategies: [MitigationStrategy]
    public let confidenceLevel: Float
    public let processingTime: TimeInterval
}

public struct TaskRiskAssessment: Sendable {
    public let taskId: String
    public let taskName: String
    public let overallRisk: Float
    public let isOnCriticalPath: Bool
    public let riskFactors: [String]
    public let mitigations: [String]
}

public struct FailurePoint: Sendable {
    public let taskId: String
    public let probability: Float
    public let impact: String
    public let cause: String
}

public struct MitigationStrategy: Sendable {
    public let failurePointId: String
    public let strategy: String
    public let effort: EffortLevel
    public let effectiveness: Float
}

struct RiskModel {
    let id: String
    let factors: [String: Float]
}

// MARK: - Effort Optimization

public struct GoalInput: Sendable {
    public let description: String
    public let successCriteria: [String]
    public let constraints: [String]
    
    public init(description: String, successCriteria: [String] = [], constraints: [String] = []) {
        self.description = description
        self.successCriteria = successCriteria
        self.constraints = constraints
    }
}

public struct EffortConstraints: Sendable {
    public let maxEffort: Float
    public let deadline: Date?
    public let resources: Int
    
    public init(maxEffort: Float, deadline: Date? = nil, resources: Int = 1) {
        self.maxEffort = maxEffort
        self.deadline = deadline
        self.resources = resources
    }
}

public struct EffortOptimization: Sendable {
    public let goal: String
    public let recommendedApproach: ScoredApproach?
    public let alternatives: [ScoredApproach]
    public let constraints: EffortConstraints
    public let tradeoffs: [String]
    public let processingTime: TimeInterval
}

public struct Approach: Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let scope: ApproachScope
}

public enum ApproachScope: String, Sendable {
    case minimal, standard, comprehensive
}

public struct ScoredApproach: Sendable {
    public let approach: Approach
    public let estimatedEffort: Float
    public let predictedOutcome: Float
    public let efficiencyScore: Float
    public let risks: [String]
}

// MARK: - Feature ROI

public struct FeatureInput: Sendable {
    public let name: String
    public let description: String
    public let complexity: Float
    public let expectedValue: Float
    public let dependencies: [String]
    
    public init(name: String, description: String, complexity: Float = 0.5, expectedValue: Float = 0.7, dependencies: [String] = []) {
        self.name = name
        self.description = description
        self.complexity = complexity
        self.expectedValue = expectedValue
        self.dependencies = dependencies
    }
}

public struct FeatureROIModel: Sendable {
    public let feature: String
    public let estimatedEffort: FeatureEffort
    public let predictedImpact: FeatureImpact
    public let risks: [FeatureRisk]
    public let roiScore: Float
    public let paybackPeriod: String
    public let recommendation: String
    public let comparison: String
    public let processingTime: TimeInterval
}

public struct FeatureEffort: Sendable {
    public let developmentHours: Float
    public let testingHours: Float
    public let documentationHours: Float
    public let totalHours: Float
}

public struct FeatureImpact: Sendable {
    public let userValue: Float
    public let revenueImpact: Float
    public let retentionImpact: Float
    public let overallScore: Float
}

public struct FeatureRisk: Sendable {
    public let risk: String
    public let probability: Float
    public let impact: Float
}

// MARK: - Execution Log

struct PlanningExecution {
    let type: PlanningExecutionType
    let timestamp: Date
}

enum PlanningExecutionType {
    case decomposition, estimateAccuracy, criticalPath, effortOptimization, featureROI
}

// MARK: - Stats

public struct PlanningStats: Sendable {
    public let totalExecutions: Int
    public let estimateRecords: Int
    public let averageEstimateAccuracy: Float
}
