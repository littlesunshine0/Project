//
//  IntelligenceOrchestrator.swift
//  AIKit - Unified Intelligence Orchestration Layer
//
//  Routes requests to engines, merges results, handles confidence aggregation,
//  conflict resolution, and human-in-the-loop triggers.
//

import Foundation

// MARK: - Intelligence Orchestrator

/// Central orchestration layer for the Unified ML Intelligence Platform
public actor IntelligenceOrchestrator {
    public static let shared = IntelligenceOrchestrator()
    
    // Core Engines
    private let understanding = UnderstandingEngine.shared
    private let structure = StructureEngine.shared
    private let planning = PlanningEngine.shared
    private let memory = MemoryEngine.shared
    private let risk = RiskEngine.shared
    
    // Configuration
    private var config: OrchestratorConfig = OrchestratorConfig()
    private var executionLog: [OrchestratorExecution] = []
    
    private init() {}
    
    // MARK: - Configuration
    
    public func configure(_ config: OrchestratorConfig) {
        self.config = config
    }
    
    // MARK: - High-Level Intelligence Operations
    
    /// Analyze an idea end-to-end: understand, assess risk, plan, remember
    public func analyzeIdea(_ idea: String, projectId: String? = nil) async -> IdeaAnalysisResult {
        let start = Date()
        
        // 1. Understand the idea
        let understanding = await self.understanding.understand(idea)
        
        // 2. Infer requirements
        let requirements = await self.understanding.inferRequirements(from: idea)
        
        // 3. Detect assumptions and risks
        let assumptions = understanding.assumptions
        let risks = understanding.risks
        
        // 4. Estimate uncertainty
        let uncertainty = await risk.estimateUncertainty(prediction: PredictionInput(
            id: UUID().uuidString,
            value: understanding.confidence,
            context: ["type": "idea_analysis"]
        ))
        
        // 5. Check for biases
        let biasCheck = await risk.detectBiases(input: BiasDetectionInput(
            id: UUID().uuidString,
            text: idea
        ))
        
        // 6. Store in memory if project provided
        if let projectId = projectId {
            await memory.remember(projectId: projectId, content: MemoryContent(
                type: .note,
                summary: "Idea: \(idea.prefix(100))",
                details: idea
            ))
        }
        
        // 7. Determine if human input needed
        let humanInput = await risk.shouldRequestHumanInput(decision: DecisionInput(
            id: UUID().uuidString,
            description: "Proceed with idea: \(idea.prefix(50))",
            context: ["confidence": String(understanding.confidence)]
        ))
        
        let result = IdeaAnalysisResult(
            idea: idea,
            understanding: understanding,
            requirements: requirements,
            assumptions: assumptions,
            risks: risks,
            uncertainty: uncertainty,
            biasCheck: biasCheck,
            humanInputNeeded: humanInput.shouldRequestInput,
            humanInputQuestions: humanInput.questionsForHuman,
            overallConfidence: calculateOverallConfidence(
                understanding: understanding.confidence,
                uncertainty: uncertainty.totalUncertainty,
                biasRisk: biasCheck.overallBiasRisk
            ),
            processingTime: Date().timeIntervalSince(start)
        )
        
        executionLog.append(OrchestratorExecution(type: .ideaAnalysis, timestamp: Date()))
        return result
    }
    
    /// Analyze a codebase: structure, complexity, refactor opportunities
    public func analyzeCodebase(_ codebase: CodebaseInfo) async -> CodebaseAnalysisResult {
        let start = Date()
        
        // 1. Classify architecture
        let files = codebase.modules.flatMap { $0.files }
        let architecture = await structure.classifyArchitecture(files: files)
        
        // 2. Analyze coupling/cohesion
        let coupling = await structure.analyzeCouplingCohesion(modules: codebase.modules)
        
        // 3. Estimate complexity
        let complexity = await structure.estimateComplexity(codebase: codebase)
        
        // 4. Detect refactor opportunities
        let refactorOpportunities = await structure.detectRefactorOpportunities(codebase: codebase)
        
        // 5. Detect reusable boundaries
        let reusableBoundaries = await structure.detectReusableBoundaries(codebase: codebase)
        
        // 6. Predict stability
        let stability = await structure.predictStability(codebase: codebase)
        
        let result = CodebaseAnalysisResult(
            codebase: codebase.name,
            architecture: architecture,
            coupling: coupling,
            complexity: complexity,
            refactorOpportunities: refactorOpportunities,
            reusableBoundaries: reusableBoundaries,
            stability: stability,
            healthScore: calculateHealthScore(
                architecture: architecture,
                coupling: coupling,
                complexity: complexity
            ),
            processingTime: Date().timeIntervalSince(start)
        )
        
        executionLog.append(OrchestratorExecution(type: .codebaseAnalysis, timestamp: Date()))
        return result
    }
    
    /// Plan a project: decompose tasks, estimate, identify risks
    public func planProject(goal: String, constraints: EffortConstraints) async -> ProjectPlanResult {
        let start = Date()
        
        // 1. Understand the goal
        let understanding = await self.understanding.understand(goal)
        
        // 2. Decompose into tasks
        let decomposition = await planning.decomposeTask(TaskInput(
            description: goal,
            estimatedHours: constraints.maxEffort
        ))
        
        // 3. Optimize effort
        let optimization = await planning.optimizeEffort(
            goal: GoalInput(description: goal),
            constraints: constraints
        )
        
        // 4. Predict critical path risks
        let planTasks = decomposition.subtasks.map { subtask in
            PlanTask(
                id: subtask.id,
                name: subtask.name,
                estimatedHours: subtask.estimatedHours,
                dependencies: []
            )
        }
        let criticalPathRisks = await planning.predictCriticalPathRisks(plan: PlanInput(
            name: goal,
            tasks: planTasks
        ))
        
        // 5. Estimate accuracy of estimates
        var estimateAccuracies: [EstimateAccuracyPrediction] = []
        for subtask in decomposition.subtasks {
            let accuracy = await planning.predictEstimateAccuracy(EstimateInput(
                description: subtask.name,
                hours: subtask.estimatedHours
            ))
            estimateAccuracies.append(accuracy)
        }
        
        let result = ProjectPlanResult(
            goal: goal,
            understanding: understanding,
            decomposition: decomposition,
            optimization: optimization,
            criticalPathRisks: criticalPathRisks,
            estimateAccuracies: estimateAccuracies,
            overallConfidence: calculatePlanConfidence(
                decomposition: decomposition,
                risks: criticalPathRisks,
                accuracies: estimateAccuracies
            ),
            processingTime: Date().timeIntervalSince(start)
        )
        
        executionLog.append(OrchestratorExecution(type: .projectPlanning, timestamp: Date()))
        return result
    }
    
    /// Make a decision with full intelligence support
    public func supportDecision(_ decision: DecisionInput) async -> DecisionSupportResult {
        let start = Date()
        
        // 1. Understand the decision
        let understanding = await self.understanding.understand(decision.description)
        
        // 2. Estimate uncertainty
        let uncertainty = await risk.estimateUncertainty(prediction: PredictionInput(
            id: decision.id,
            value: 0.5,
            context: decision.context
        ))
        
        // 3. Detect biases
        let biases = await risk.detectBiases(input: BiasDetectionInput(
            id: decision.id,
            text: decision.description
        ))
        
        // 4. Check if human input needed
        let humanInput = await risk.shouldRequestHumanInput(decision: decision)
        
        // 5. Recall relevant memories
        var relevantMemories: [RecalledMemory] = []
        if let projectId = decision.context["projectId"] {
            relevantMemories = await memory.recall(projectId: projectId, query: decision.description)
        }
        
        let result = DecisionSupportResult(
            decision: decision,
            understanding: understanding,
            uncertainty: uncertainty,
            biases: biases,
            humanInputRecommendation: humanInput,
            relevantMemories: relevantMemories,
            recommendation: generateDecisionRecommendation(
                understanding: understanding,
                uncertainty: uncertainty,
                biases: biases,
                humanInput: humanInput
            ),
            processingTime: Date().timeIntervalSince(start)
        )
        
        executionLog.append(OrchestratorExecution(type: .decisionSupport, timestamp: Date()))
        return result
    }
    
    /// Monitor project health continuously
    public func monitorProjectHealth(projectId: String, codebase: CodebaseInfo) async -> ProjectHealthReport {
        let start = Date()
        
        // 1. Analyze codebase
        let codebaseAnalysis = await analyzeCodebase(codebase)
        
        // 2. Check knowledge decay
        let decayPrediction = await memory.predictDecay(projectId: projectId)
        
        // 3. Get significant memories
        let significantMemories = await memory.getSignificantMemories(projectId: projectId)
        
        // 4. Calculate overall health
        let healthScore = calculateProjectHealth(
            codebaseHealth: codebaseAnalysis.healthScore,
            decayRisk: Float(decayPrediction.atRiskEntries.count) / 10.0,
            memoryHealth: Float(significantMemories.count) / 20.0
        )
        
        let result = ProjectHealthReport(
            projectId: projectId,
            codebaseAnalysis: codebaseAnalysis,
            knowledgeDecay: decayPrediction,
            significantMemories: significantMemories.count,
            overallHealth: healthScore,
            alerts: generateHealthAlerts(
                codebaseAnalysis: codebaseAnalysis,
                decayPrediction: decayPrediction
            ),
            recommendations: generateHealthRecommendations(healthScore: healthScore),
            processingTime: Date().timeIntervalSince(start)
        )
        
        executionLog.append(OrchestratorExecution(type: .healthMonitoring, timestamp: Date()))
        return result
    }
    
    // MARK: - Engine Access (Direct)
    
    /// Direct access to Understanding Engine
    public var understandingEngine: UnderstandingEngine { understanding }
    
    /// Direct access to Structure Engine
    public var structureEngine: StructureEngine { structure }
    
    /// Direct access to Planning Engine
    public var planningEngine: PlanningEngine { planning }
    
    /// Direct access to Memory Engine
    public var memoryEngine: MemoryEngine { memory }
    
    /// Direct access to Risk Engine
    public var riskEngine: RiskEngine { risk }
    
    // MARK: - Private Helpers
    
    private func calculateOverallConfidence(understanding: Float, uncertainty: Float, biasRisk: Float) -> Float {
        let base = understanding * (1.0 - uncertainty)
        let biasAdjustment = 1.0 - (biasRisk * 0.3)
        return base * biasAdjustment
    }
    
    private func calculateHealthScore(architecture: ArchitectureClassification, coupling: CouplingCohesionAnalysis, complexity: ComplexityEstimate) -> Float {
        let archScore = architecture.consistencyScore
        let couplingScore = coupling.overallHealth
        let complexityScore = 1.0 - complexity.overallScore
        return (archScore + couplingScore + complexityScore) / 3.0
    }
    
    private func calculatePlanConfidence(decomposition: TaskDecomposition, risks: CriticalPathRiskPrediction, accuracies: [EstimateAccuracyPrediction]) -> Float {
        let riskFactor = 1.0 - risks.overallRisk
        let accuracyFactor = accuracies.isEmpty ? 0.5 : accuracies.reduce(0) { $0 + $1.accuracyProbability } / Float(accuracies.count)
        let complexityFactor = 1.0 - decomposition.complexityScore
        return (riskFactor + accuracyFactor + complexityFactor) / 3.0
    }
    
    private func generateDecisionRecommendation(understanding: UnderstandingResult, uncertainty: UncertaintyEstimate, biases: BiasDetectionResult, humanInput: HumanInputRecommendation) -> String {
        if humanInput.shouldRequestInput {
            return "Recommend human review: \(humanInput.reason)"
        }
        if uncertainty.totalUncertainty > 0.5 {
            return "Proceed with caution - high uncertainty"
        }
        if biases.overallBiasRisk > 0.5 {
            return "Review for potential biases before proceeding"
        }
        if understanding.confidence > 0.7 {
            return "Proceed - high confidence in understanding"
        }
        return "Gather more information before deciding"
    }
    
    private func calculateProjectHealth(codebaseHealth: Float, decayRisk: Float, memoryHealth: Float) -> Float {
        let codeWeight: Float = 0.5
        let decayWeight: Float = 0.3
        let memoryWeight: Float = 0.2
        return codebaseHealth * codeWeight + (1.0 - decayRisk) * decayWeight + memoryHealth * memoryWeight
    }
    
    private func generateHealthAlerts(codebaseAnalysis: CodebaseAnalysisResult, decayPrediction: DecayPrediction) -> [String] {
        var alerts: [String] = []
        
        if codebaseAnalysis.healthScore < 0.5 {
            alerts.append("⚠️ Codebase health is below threshold")
        }
        if codebaseAnalysis.complexity.maintainability == .critical {
            alerts.append("🚨 Critical complexity level detected")
        }
        if decayPrediction.atRiskEntries.count > 5 {
            alerts.append("📚 Multiple knowledge entries at risk of decay")
        }
        if !codebaseAnalysis.refactorOpportunities.isEmpty {
            alerts.append("🔧 \(codebaseAnalysis.refactorOpportunities.count) refactoring opportunities identified")
        }
        
        return alerts
    }
    
    private func generateHealthRecommendations(healthScore: Float) -> [String] {
        if healthScore > 0.8 { return ["Continue current practices", "Consider documenting successful patterns"] }
        if healthScore > 0.6 { return ["Address identified issues", "Schedule regular health checks"] }
        if healthScore > 0.4 { return ["Prioritize technical debt reduction", "Review architecture decisions"] }
        return ["Immediate attention required", "Consider architecture review", "Reduce complexity"]
    }
    
    // MARK: - Stats
    
    public func stats() async -> OrchestratorStats {
        let understandingStats = await understanding.stats
        let structureStats = await structure.stats
        let planningStats = await planning.stats
        let memoryStats = await memory.stats
        let riskStats = await risk.stats
        
        return OrchestratorStats(
            totalExecutions: executionLog.count,
            understandingStats: understandingStats,
            structureStats: structureStats,
            planningStats: planningStats,
            memoryStats: memoryStats,
            riskStats: riskStats
        )
    }
}

// MARK: - Orchestrator Models

public struct OrchestratorConfig: Sendable {
    public var confidenceThreshold: Float
    public var humanInputThreshold: Float
    public var enableCaching: Bool
    
    public init(confidenceThreshold: Float = 0.7, humanInputThreshold: Float = 0.5, enableCaching: Bool = true) {
        self.confidenceThreshold = confidenceThreshold
        self.humanInputThreshold = humanInputThreshold
        self.enableCaching = enableCaching
    }
}

public struct IdeaAnalysisResult: Sendable {
    public let idea: String
    public let understanding: UnderstandingResult
    public let requirements: InferredRequirements
    public let assumptions: [Assumption]
    public let risks: [Risk]
    public let uncertainty: UncertaintyEstimate
    public let biasCheck: BiasDetectionResult
    public let humanInputNeeded: Bool
    public let humanInputQuestions: [String]
    public let overallConfidence: Float
    public let processingTime: TimeInterval
}

public struct CodebaseAnalysisResult: Sendable {
    public let codebase: String
    public let architecture: ArchitectureClassification
    public let coupling: CouplingCohesionAnalysis
    public let complexity: ComplexityEstimate
    public let refactorOpportunities: [RefactorOpportunity]
    public let reusableBoundaries: [ReusableBoundary]
    public let stability: StabilityPrediction
    public let healthScore: Float
    public let processingTime: TimeInterval
}

public struct ProjectPlanResult: Sendable {
    public let goal: String
    public let understanding: UnderstandingResult
    public let decomposition: TaskDecomposition
    public let optimization: EffortOptimization
    public let criticalPathRisks: CriticalPathRiskPrediction
    public let estimateAccuracies: [EstimateAccuracyPrediction]
    public let overallConfidence: Float
    public let processingTime: TimeInterval
}

public struct DecisionSupportResult: Sendable {
    public let decision: DecisionInput
    public let understanding: UnderstandingResult
    public let uncertainty: UncertaintyEstimate
    public let biases: BiasDetectionResult
    public let humanInputRecommendation: HumanInputRecommendation
    public let relevantMemories: [RecalledMemory]
    public let recommendation: String
    public let processingTime: TimeInterval
}

public struct ProjectHealthReport: Sendable {
    public let projectId: String
    public let codebaseAnalysis: CodebaseAnalysisResult
    public let knowledgeDecay: DecayPrediction
    public let significantMemories: Int
    public let overallHealth: Float
    public let alerts: [String]
    public let recommendations: [String]
    public let processingTime: TimeInterval
}

public struct OrchestratorStats: Sendable {
    public let totalExecutions: Int
    public let understandingStats: UnderstandingStats
    public let structureStats: StructureStats
    public let planningStats: PlanningStats
    public let memoryStats: MemoryStats
    public let riskStats: RiskStats
}

struct OrchestratorExecution {
    let type: OrchestratorExecutionType
    let timestamp: Date
}

enum OrchestratorExecutionType {
    case ideaAnalysis, codebaseAnalysis, projectPlanning, decisionSupport, healthMonitoring
}
