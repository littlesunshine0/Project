//
//  RiskModels.swift
//  AIKit - Risk Engine Models
//

import Foundation

// MARK: - Uncertainty Estimation

public struct PredictionInput: Sendable {
    public let id: String
    public let value: Float
    public let context: [String: String]
    
    public init(id: String, value: Float, context: [String: String] = [:]) {
        self.id = id
        self.value = value
        self.context = context
    }
}

public struct UncertaintyEstimate: Sendable {
    public let predictionId: String
    public let totalUncertainty: Float
    public let aleatoricUncertainty: Float
    public let epistemicUncertainty: Float
    public let confidenceInterval: ConfidenceInterval
    public let confidenceLevel: Float
    public let sources: [UncertaintySource]
    public let recommendations: [String]
    public let processingTime: TimeInterval
}

public struct ConfidenceInterval: Sendable {
    public let lower: Float
    public let upper: Float
    public let level: Float
}

public struct UncertaintySource: Sendable {
    public let source: String
    public let contribution: Float
    public let mitigation: String
}

// MARK: - Failure Mode Prediction

public struct SystemInput: Sendable {
    public let id: String
    public let name: String
    public let components: [SystemComponent]
    
    public init(id: String, name: String, components: [SystemComponent]) {
        self.id = id
        self.name = name
        self.components = components
    }
}

public struct SystemComponent: Sendable {
    public let id: String
    public let name: String
    public let criticality: Criticality
    public let hasExternalDependency: Bool
    
    public init(id: String, name: String, criticality: Criticality = .medium, hasExternalDependency: Bool = false) {
        self.id = id
        self.name = name
        self.criticality = criticality
        self.hasExternalDependency = hasExternalDependency
    }
}

public enum Criticality: String, Sendable {
    case low, medium, high, critical
}

public struct FailureModePrediction: Sendable {
    public let systemId: String
    public let failureModes: [FailureMode]
    public let overallRisk: Float
    public let criticalFailures: [FailureMode]
    public let mitigationPlan: [MitigationStep]
    public let processingTime: TimeInterval
}

public struct FailureMode: Sendable {
    public let id: String
    public let description: String
    public let probability: Float
    public let impact: Float
    public let severity: Severity
    public let detection: String
    public let mitigation: String
}

public enum Severity: String, Sendable {
    case minor, moderate, major, critical
}

public struct MitigationStep: Sendable {
    public let failureModeId: String
    public let action: String
    public let priority: Int
    public let effort: EffortLevel
}

// MARK: - Belief Revision

public struct Belief: Sendable {
    public let id: String
    public let statement: String
    public var confidence: Float
    public var evidence: [String]
    public var lastUpdated: Date
    
    public init(id: String, statement: String, confidence: Float, evidence: [String] = [], lastUpdated: Date = Date()) {
        self.id = id
        self.statement = statement
        self.confidence = confidence
        self.evidence = evidence
        self.lastUpdated = lastUpdated
    }
}

public struct EvidenceInput: Sendable {
    public let description: String
    public let source: EvidenceSource
    public let supports: Bool
    public let strength: Float
    public let sampleSize: Int
    public let recency: Int // Days old
    
    public init(description: String, source: EvidenceSource, supports: Bool, strength: Float = 0.5, sampleSize: Int = 1, recency: Int = 0) {
        self.description = description
        self.source = source
        self.supports = supports
        self.strength = strength
        self.sampleSize = sampleSize
        self.recency = recency
    }
}

public enum EvidenceSource: String, Sendable {
    case empirical, expert, anecdotal, theoretical
}

public struct BeliefRevision: Sendable {
    public let beliefId: String
    public let priorConfidence: Float
    public let posteriorConfidence: Float
    public let evidenceImpact: Float
    public let shouldRevise: Bool
    public let revisionType: RevisionType
    public let reasoning: String
    public let processingTime: TimeInterval
}

public enum RevisionType: String, Sendable {
    case none, slightStrengthen, strengthen, slightWeaken, weaken
}

// MARK: - Bias Detection

public struct BiasDetectionInput: Sendable {
    public let id: String
    public let text: String
    public let context: String
    
    public init(id: String, text: String, context: String = "") {
        self.id = id
        self.text = text
        self.context = context
    }
}

public struct BiasDetectionResult: Sendable {
    public let inputId: String
    public let detectedBiases: [DetectedBias]
    public let overallBiasRisk: Float
    public let recommendations: [String]
    public let debiasedAlternatives: [String]
    public let processingTime: TimeInterval
}

public struct DetectedBias: Sendable {
    public let biasType: String
    public let confidence: Float
    public let indicators: [String]
    public let impact: Float
    public let mitigation: String
}

struct BiasPattern {
    let id: String
    let name: String
    let indicators: [String]
    let impact: Float
}

// MARK: - Metric Reliability

public struct MetricInput: Sendable {
    public let id: String
    public let name: String
    public let hasDefinition: Bool
    public let isStandardized: Bool
    public let historicalDataPoints: Int
    public let variance: Float
    public let isActionable: Bool
    public let isEasilyGamed: Bool
    
    public init(id: String, name: String, hasDefinition: Bool = true, isStandardized: Bool = false, historicalDataPoints: Int = 0, variance: Float = 0.5, isActionable: Bool = true, isEasilyGamed: Bool = false) {
        self.id = id
        self.name = name
        self.hasDefinition = hasDefinition
        self.isStandardized = isStandardized
        self.historicalDataPoints = historicalDataPoints
        self.variance = variance
        self.isActionable = isActionable
        self.isEasilyGamed = isEasilyGamed
    }
}

public struct MetricReliabilityScore: Sendable {
    public let metricId: String
    public let overallScore: Float
    public let validity: Float
    public let reliability: Float
    public let actionability: Float
    public let gameability: Float
    public let trustLevel: TrustLevel
    public let warnings: [String]
    public let alternatives: [String]
    public let processingTime: TimeInterval
}

public enum TrustLevel: String, Sendable {
    case high, medium, low, unreliable
}

struct MetricRecord {
    let metric: MetricInput
    let score: Float
    let timestamp: Date
}

// MARK: - Human-in-the-Loop

public struct DecisionInput: Sendable {
    public let id: String
    public let description: String
    public let context: [String: String]
    public let options: [String]
    
    public init(id: String, description: String, context: [String: String] = [:], options: [String] = []) {
        self.id = id
        self.description = description
        self.context = context
        self.options = options
    }
}

public struct HumanInputRecommendation: Sendable {
    public let decisionId: String
    public let shouldRequestInput: Bool
    public let urgency: Urgency
    public let reason: String
    public let questionsForHuman: [String]
    public let automationConfidence: Float
    public let processingTime: TimeInterval
}

public enum Urgency: String, Sendable {
    case low, normal, high, critical
}

public enum StakesLevel: String, Sendable {
    case low, medium, high
}

public enum Reversibility: String, Sendable {
    case fullyReversible, partiallyReversible, irreversible
}

public enum Novelty: String, Sendable {
    case routine, familiar, novel
}

// MARK: - Execution Log

struct RiskExecution {
    let type: RiskExecutionType
    let timestamp: Date
}

enum RiskExecutionType {
    case uncertainty, failureMode, beliefRevision, biasDetection, metricReliability, humanInput
}

// MARK: - Stats

public struct RiskStats: Sendable {
    public let beliefCount: Int
    public let biasPatternCount: Int
    public let metricRecords: Int
    public let totalExecutions: Int
}
