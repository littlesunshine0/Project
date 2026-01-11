//
//  RiskEngine.swift
//  AIKit - Core Intelligence Engine #5
//
//  Purpose: Know how confident the system should be
//  Capabilities: Uncertainty estimation, failure mode prediction,
//                belief revision, bias detection, metric reliability scoring
//

import Foundation

// MARK: - Risk, Uncertainty & Meta-Reasoning Engine

/// Core Engine #5: Knows how confident the system should be
public actor RiskEngine {
    public static let shared = RiskEngine()
    
    private var beliefStore: [String: Belief] = [:]
    private var biasPatterns: [BiasPattern]
    private var metricHistory: [MetricRecord] = []
    private var executionLog: [RiskExecution] = []
    
    private init() {
        // Initialize patterns inline for Swift 6 actor isolation
        biasPatterns = [
            BiasPattern(id: "optimism", name: "Optimism Bias", indicators: ["easy", "quick", "simple", "just"], impact: 0.3),
            BiasPattern(id: "anchoring", name: "Anchoring Bias", indicators: ["similar to", "like before", "same as"], impact: 0.25),
            BiasPattern(id: "confirmation", name: "Confirmation Bias", indicators: ["as expected", "confirms", "proves"], impact: 0.2),
            BiasPattern(id: "sunk_cost", name: "Sunk Cost Fallacy", indicators: ["already invested", "too far", "can't stop"], impact: 0.35),
            BiasPattern(id: "planning", name: "Planning Fallacy", indicators: ["should be done by", "will only take", "at most"], impact: 0.3)
        ]
    }
    
    // MARK: - Uncertainty Estimation
    
    /// Estimate uncertainty for any prediction or decision
    public func estimateUncertainty(prediction: PredictionInput) async -> UncertaintyEstimate {
        let start = Date()
        
        // Analyze input characteristics
        let dataQuality = assessDataQuality(prediction: prediction)
        let modelConfidence = assessModelConfidence(prediction: prediction)
        let contextClarity = assessContextClarity(prediction: prediction)
        
        // Calculate uncertainty components
        let aleatoricUncertainty = calculateAleatoricUncertainty(dataQuality: dataQuality)
        let epistemicUncertainty = calculateEpistemicUncertainty(modelConfidence: modelConfidence)
        
        // Combined uncertainty
        let totalUncertainty = sqrt(pow(aleatoricUncertainty, 2) + pow(epistemicUncertainty, 2))
        
        // Generate confidence interval
        let confidenceInterval = calculateConfidenceInterval(
            prediction: prediction,
            uncertainty: totalUncertainty
        )
        
        // Identify uncertainty sources
        let sources = identifyUncertaintySources(
            dataQuality: dataQuality,
            modelConfidence: modelConfidence,
            contextClarity: contextClarity
        )
        
        return UncertaintyEstimate(
            predictionId: prediction.id,
            totalUncertainty: totalUncertainty,
            aleatoricUncertainty: aleatoricUncertainty,
            epistemicUncertainty: epistemicUncertainty,
            confidenceInterval: confidenceInterval,
            confidenceLevel: 1.0 - totalUncertainty,
            sources: sources,
            recommendations: generateUncertaintyRecommendations(uncertainty: totalUncertainty, sources: sources),
            processingTime: Date().timeIntervalSince(start)
        )
    }
    
    // MARK: - Failure Mode Prediction
    
    /// Predict how and why something might fail
    public func predictFailureModes(system: SystemInput) async -> FailureModePrediction {
        let start = Date()
        
        var failureModes: [FailureMode] = []
        
        // Analyze system components
        for component in system.components {
            let componentFailures = analyzeComponentFailures(component: component, system: system)
            failureModes.append(contentsOf: componentFailures)
        }
        
        // Analyze interactions
        let interactionFailures = analyzeInteractionFailures(system: system)
        failureModes.append(contentsOf: interactionFailures)
        
        // Analyze external dependencies
        let dependencyFailures = analyzeDependencyFailures(system: system)
        failureModes.append(contentsOf: dependencyFailures)
        
        // Sort by risk (probability * impact)
        failureModes.sort { ($0.probability * $0.impact) > ($1.probability * $1.impact) }
        
        // Calculate overall system risk
        let overallRisk = calculateOverallSystemRisk(failureModes: failureModes)
        
        return FailureModePrediction(
            systemId: system.id,
            failureModes: failureModes,
            overallRisk: overallRisk,
            criticalFailures: failureModes.filter { $0.severity == .critical },
            mitigationPlan: generateMitigationPlan(failureModes: failureModes),
            processingTime: Date().timeIntervalSince(start)
        )
    }
    
    // MARK: - Belief Revision
    
    /// Determine when new information should override existing beliefs
    public func reviseBeliefs(newEvidence: EvidenceInput, beliefId: String) async -> BeliefRevision {
        let start = Date()
        
        // Get existing belief
        let existingBelief = beliefStore[beliefId] ?? Belief(
            id: beliefId,
            statement: "Unknown",
            confidence: 0.5,
            evidence: [],
            lastUpdated: Date()
        )
        
        // Assess evidence quality
        let evidenceQuality = assessEvidenceQuality(evidence: newEvidence)
        
        // Calculate belief update using Bayesian-like reasoning
        let priorConfidence = existingBelief.confidence
        let likelihoodRatio = calculateLikelihoodRatio(evidence: newEvidence, belief: existingBelief)
        
        // Update confidence
        let posteriorConfidence = updateConfidence(
            prior: priorConfidence,
            likelihoodRatio: likelihoodRatio,
            evidenceQuality: evidenceQuality
        )
        
        // Determine if belief should change
        let shouldRevise = abs(posteriorConfidence - priorConfidence) > 0.1
        let revisionType = determineRevisionType(prior: priorConfidence, posterior: posteriorConfidence)
        
        // Update belief store
        var updatedBelief = existingBelief
        updatedBelief.confidence = posteriorConfidence
        updatedBelief.evidence.append(newEvidence.description)
        updatedBelief.lastUpdated = Date()
        beliefStore[beliefId] = updatedBelief
        
        return BeliefRevision(
            beliefId: beliefId,
            priorConfidence: priorConfidence,
            posteriorConfidence: posteriorConfidence,
            evidenceImpact: posteriorConfidence - priorConfidence,
            shouldRevise: shouldRevise,
            revisionType: revisionType,
            reasoning: generateRevisionReasoning(
                prior: priorConfidence,
                posterior: posteriorConfidence,
                evidence: newEvidence
            ),
            processingTime: Date().timeIntervalSince(start)
        )
    }
    
    /// Store a belief for tracking
    public func storeBelief(_ belief: Belief) {
        beliefStore[belief.id] = belief
    }
    
    // MARK: - Bias Detection
    
    /// Detect cognitive biases in reasoning or decisions
    public func detectBiases(input: BiasDetectionInput) async -> BiasDetectionResult {
        let start = Date()
        
        var detectedBiases: [DetectedBias] = []
        let lowercased = input.text.lowercased()
        
        // Check for known bias patterns
        for pattern in biasPatterns {
            let indicators = pattern.indicators.filter { lowercased.contains($0) }
            if !indicators.isEmpty {
                let confidence = Float(indicators.count) / Float(pattern.indicators.count)
                detectedBiases.append(DetectedBias(
                    biasType: pattern.name,
                    confidence: min(0.9, confidence + 0.3),
                    indicators: indicators,
                    impact: pattern.impact,
                    mitigation: generateBiasMitigation(pattern: pattern)
                ))
            }
        }
        
        // Check for structural biases
        let structuralBiases = detectStructuralBiases(input: input)
        detectedBiases.append(contentsOf: structuralBiases)
        
        // Calculate overall bias risk
        let overallBiasRisk = detectedBiases.isEmpty ? 0.1 :
            detectedBiases.reduce(0) { $0 + $1.confidence * $1.impact } / Float(detectedBiases.count)
        
        return BiasDetectionResult(
            inputId: input.id,
            detectedBiases: detectedBiases,
            overallBiasRisk: overallBiasRisk,
            recommendations: generateBiasRecommendations(biases: detectedBiases),
            debiasedAlternatives: generateDebiasedAlternatives(input: input, biases: detectedBiases),
            processingTime: Date().timeIntervalSince(start)
        )
    }
    
    // MARK: - Metric Reliability Scoring
    
    /// Score how reliable a metric is for decision-making
    public func scoreMetricReliability(metric: MetricInput) async -> MetricReliabilityScore {
        let start = Date()
        
        // Assess metric characteristics
        let validity = assessMetricValidity(metric: metric)
        let reliability = assessMetricReliability(metric: metric)
        let actionability = assessMetricActionability(metric: metric)
        let gameability = assessMetricGameability(metric: metric)
        
        // Calculate overall score
        let overallScore = (validity * 0.3 + reliability * 0.3 + actionability * 0.2 + (1.0 - gameability) * 0.2)
        
        // Determine if metric can be trusted
        let trustLevel: TrustLevel
        switch overallScore {
        case 0.8...: trustLevel = .high
        case 0.6..<0.8: trustLevel = .medium
        case 0.4..<0.6: trustLevel = .low
        default: trustLevel = .unreliable
        }
        
        // Record for learning
        metricHistory.append(MetricRecord(metric: metric, score: overallScore, timestamp: Date()))
        
        return MetricReliabilityScore(
            metricId: metric.id,
            overallScore: overallScore,
            validity: validity,
            reliability: reliability,
            actionability: actionability,
            gameability: gameability,
            trustLevel: trustLevel,
            warnings: generateMetricWarnings(validity: validity, reliability: reliability, gameability: gameability),
            alternatives: suggestAlternativeMetrics(metric: metric, score: overallScore),
            processingTime: Date().timeIntervalSince(start)
        )
    }
    
    // MARK: - Human-in-the-Loop Routing
    
    /// Determine when to ask for human input
    public func shouldRequestHumanInput(decision: DecisionInput) async -> HumanInputRecommendation {
        let start = Date()
        
        // Assess decision characteristics
        let uncertainty = await estimateUncertainty(prediction: PredictionInput(
            id: decision.id,
            value: 0,
            context: decision.context
        ))
        
        let stakes = assessDecisionStakes(decision: decision)
        let reversibility = assessDecisionReversibility(decision: decision)
        let novelty = assessDecisionNovelty(decision: decision)
        
        // Calculate human input need
        var humanInputScore: Float = 0
        
        if uncertainty.totalUncertainty > 0.5 { humanInputScore += 0.3 }
        if stakes == .high { humanInputScore += 0.3 }
        if reversibility == .irreversible { humanInputScore += 0.25 }
        if novelty == .novel { humanInputScore += 0.15 }
        
        let shouldRequest = humanInputScore > 0.5
        
        // Determine what to ask
        let questionsForHuman = generateQuestionsForHuman(
            decision: decision,
            uncertainty: uncertainty,
            stakes: stakes
        )
        
        return HumanInputRecommendation(
            decisionId: decision.id,
            shouldRequestInput: shouldRequest,
            urgency: shouldRequest && stakes == .high ? .high : .normal,
            reason: generateHumanInputReason(
                uncertainty: uncertainty.totalUncertainty,
                stakes: stakes,
                reversibility: reversibility
            ),
            questionsForHuman: questionsForHuman,
            automationConfidence: 1.0 - humanInputScore,
            processingTime: Date().timeIntervalSince(start)
        )
    }
    
    // MARK: - Private Helpers
    
    private func assessDataQuality(prediction: PredictionInput) -> Float {
        // Simplified assessment based on context completeness
        let contextSize = prediction.context.count
        return min(1.0, Float(contextSize) / 5.0 * 0.5 + 0.5)
    }
    
    private func assessModelConfidence(prediction: PredictionInput) -> Float {
        // Base confidence, would be from actual model in production
        return 0.7
    }
    
    private func assessContextClarity(prediction: PredictionInput) -> Float {
        let hasContext = !prediction.context.isEmpty
        return hasContext ? 0.8 : 0.5
    }
    
    private func calculateAleatoricUncertainty(dataQuality: Float) -> Float {
        // Irreducible uncertainty from data
        return (1.0 - dataQuality) * 0.5
    }
    
    private func calculateEpistemicUncertainty(modelConfidence: Float) -> Float {
        // Reducible uncertainty from model limitations
        return (1.0 - modelConfidence) * 0.5
    }
    
    private func calculateConfidenceInterval(prediction: PredictionInput, uncertainty: Float) -> ConfidenceInterval {
        let margin = prediction.value * uncertainty
        return ConfidenceInterval(
            lower: prediction.value - margin,
            upper: prediction.value + margin,
            level: 0.95
        )
    }
    
    private func identifyUncertaintySources(dataQuality: Float, modelConfidence: Float, contextClarity: Float) -> [UncertaintySource] {
        var sources: [UncertaintySource] = []
        
        if dataQuality < 0.7 {
            sources.append(UncertaintySource(source: "Data Quality", contribution: (1.0 - dataQuality) * 0.4, mitigation: "Improve data collection"))
        }
        if modelConfidence < 0.7 {
            sources.append(UncertaintySource(source: "Model Confidence", contribution: (1.0 - modelConfidence) * 0.4, mitigation: "Retrain or improve model"))
        }
        if contextClarity < 0.7 {
            sources.append(UncertaintySource(source: "Context Clarity", contribution: (1.0 - contextClarity) * 0.2, mitigation: "Gather more context"))
        }
        
        return sources
    }
    
    private func generateUncertaintyRecommendations(uncertainty: Float, sources: [UncertaintySource]) -> [String] {
        var recommendations: [String] = []
        
        if uncertainty > 0.5 {
            recommendations.append("High uncertainty - consider gathering more information before deciding")
        }
        
        for source in sources.sorted(by: { $0.contribution > $1.contribution }).prefix(2) {
            recommendations.append(source.mitigation)
        }
        
        return recommendations
    }
    
    private func analyzeComponentFailures(component: SystemComponent, system: SystemInput) -> [FailureMode] {
        var failures: [FailureMode] = []
        
        // Check for common failure patterns
        if component.criticality == .high {
            failures.append(FailureMode(
                id: "\(component.id)_unavailable",
                description: "\(component.name) becomes unavailable",
                probability: 0.1,
                impact: 0.9,
                severity: .critical,
                detection: "Health checks, monitoring",
                mitigation: "Redundancy, failover"
            ))
        }
        
        if component.hasExternalDependency {
            failures.append(FailureMode(
                id: "\(component.id)_dep_failure",
                description: "External dependency of \(component.name) fails",
                probability: 0.2,
                impact: 0.6,
                severity: .major,
                detection: "Dependency monitoring",
                mitigation: "Circuit breaker, fallback"
            ))
        }
        
        return failures
    }
    
    private func analyzeInteractionFailures(system: SystemInput) -> [FailureMode] {
        var failures: [FailureMode] = []
        
        if system.components.count > 3 {
            failures.append(FailureMode(
                id: "cascade_failure",
                description: "Cascading failure across components",
                probability: 0.15,
                impact: 0.8,
                severity: .critical,
                detection: "Distributed tracing",
                mitigation: "Bulkheads, isolation"
            ))
        }
        
        return failures
    }
    
    private func analyzeDependencyFailures(system: SystemInput) -> [FailureMode] {
        let externalDeps = system.components.filter { $0.hasExternalDependency }.count
        if externalDeps > 2 {
            return [FailureMode(
                id: "multi_dep_failure",
                description: "Multiple external dependencies fail simultaneously",
                probability: 0.05,
                impact: 0.9,
                severity: .critical,
                detection: "Comprehensive monitoring",
                mitigation: "Graceful degradation"
            )]
        }
        return []
    }
    
    private func calculateOverallSystemRisk(failureModes: [FailureMode]) -> Float {
        if failureModes.isEmpty { return 0.1 }
        
        // Combine risks (not simply additive)
        var combinedRisk: Float = 0
        for mode in failureModes {
            combinedRisk = combinedRisk + (1 - combinedRisk) * mode.probability * mode.impact
        }
        return min(1.0, combinedRisk)
    }
    
    private func generateMitigationPlan(failureModes: [FailureMode]) -> [MitigationStep] {
        failureModes.filter { $0.severity == .critical || $0.severity == .major }
            .prefix(5)
            .map { mode in
                MitigationStep(
                    failureModeId: mode.id,
                    action: mode.mitigation,
                    priority: mode.severity == .critical ? 1 : 2,
                    effort: .medium
                )
            }
    }
    
    private func assessEvidenceQuality(evidence: EvidenceInput) -> Float {
        var quality: Float = 0.5
        
        if evidence.source == .empirical { quality += 0.3 }
        if evidence.source == .expert { quality += 0.2 }
        if evidence.sampleSize > 100 { quality += 0.1 }
        if evidence.recency < 30 { quality += 0.1 } // Days old
        
        return min(1.0, quality)
    }
    
    private func calculateLikelihoodRatio(evidence: EvidenceInput, belief: Belief) -> Float {
        // Simplified likelihood ratio
        if evidence.supports {
            return 1.0 + evidence.strength
        } else {
            return 1.0 / (1.0 + evidence.strength)
        }
    }
    
    private func updateConfidence(prior: Float, likelihoodRatio: Float, evidenceQuality: Float) -> Float {
        // Bayesian-like update weighted by evidence quality
        let effectiveLR = 1.0 + (likelihoodRatio - 1.0) * evidenceQuality
        let odds = prior / (1.0 - prior)
        let posteriorOdds = odds * effectiveLR
        return posteriorOdds / (1.0 + posteriorOdds)
    }
    
    private func determineRevisionType(prior: Float, posterior: Float) -> RevisionType {
        let change = posterior - prior
        if abs(change) < 0.1 { return .none }
        if change > 0.3 { return .strengthen }
        if change < -0.3 { return .weaken }
        if change > 0 { return .slightStrengthen }
        return .slightWeaken
    }
    
    private func generateRevisionReasoning(prior: Float, posterior: Float, evidence: EvidenceInput) -> String {
        let change = posterior - prior
        if abs(change) < 0.1 {
            return "Evidence does not significantly change belief"
        }
        let direction = change > 0 ? "strengthens" : "weakens"
        return "New evidence \(direction) belief by \(Int(abs(change) * 100))%"
    }
    
    private func detectStructuralBiases(input: BiasDetectionInput) -> [DetectedBias] {
        var biases: [DetectedBias] = []
        
        // Check for recency bias (only considering recent events)
        if input.text.lowercased().contains("recently") || input.text.lowercased().contains("just happened") {
            biases.append(DetectedBias(
                biasType: "Recency Bias",
                confidence: 0.6,
                indicators: ["recently", "just happened"],
                impact: 0.25,
                mitigation: "Consider longer-term patterns and historical data"
            ))
        }
        
        return biases
    }
    
    private func generateBiasMitigation(pattern: BiasPattern) -> String {
        switch pattern.id {
        case "optimism": return "Add buffer time and consider worst-case scenarios"
        case "anchoring": return "Generate estimates independently before comparing"
        case "confirmation": return "Actively seek disconfirming evidence"
        case "sunk_cost": return "Evaluate based on future value, not past investment"
        case "planning": return "Use reference class forecasting"
        default: return "Seek diverse perspectives"
        }
    }
    
    private func generateBiasRecommendations(biases: [DetectedBias]) -> [String] {
        if biases.isEmpty { return ["No significant biases detected"] }
        return biases.map { "Address \($0.biasType): \($0.mitigation)" }
    }
    
    private func generateDebiasedAlternatives(input: BiasDetectionInput, biases: [DetectedBias]) -> [String] {
        if biases.isEmpty { return [] }
        return ["Consider: What would someone with opposite assumptions conclude?",
                "Consider: What evidence would change your mind?"]
    }
    
    private func assessMetricValidity(metric: MetricInput) -> Float {
        // Does it measure what it claims to measure?
        var validity: Float = 0.6
        if metric.hasDefinition { validity += 0.2 }
        if metric.isStandardized { validity += 0.2 }
        return validity
    }
    
    private func assessMetricReliability(metric: MetricInput) -> Float {
        // Is it consistent over time?
        var reliability: Float = 0.5
        if metric.historicalDataPoints > 10 { reliability += 0.2 }
        if metric.variance < 0.3 { reliability += 0.2 }
        return min(1.0, reliability)
    }
    
    private func assessMetricActionability(metric: MetricInput) -> Float {
        // Can you act on it?
        return metric.isActionable ? 0.8 : 0.4
    }
    
    private func assessMetricGameability(metric: MetricInput) -> Float {
        // Can it be gamed?
        return metric.isEasilyGamed ? 0.7 : 0.2
    }
    
    private func generateMetricWarnings(validity: Float, reliability: Float, gameability: Float) -> [String] {
        var warnings: [String] = []
        if validity < 0.6 { warnings.append("Low validity - may not measure intended concept") }
        if reliability < 0.6 { warnings.append("Low reliability - inconsistent measurements") }
        if gameability > 0.5 { warnings.append("High gameability - susceptible to manipulation") }
        return warnings
    }
    
    private func suggestAlternativeMetrics(metric: MetricInput, score: Float) -> [String] {
        if score > 0.7 { return [] }
        return ["Consider composite metrics", "Add qualitative measures", "Use leading indicators"]
    }
    
    private func assessDecisionStakes(decision: DecisionInput) -> StakesLevel {
        let lowercased = decision.description.lowercased()
        if lowercased.contains("critical") || lowercased.contains("major") || lowercased.contains("significant") {
            return .high
        }
        if lowercased.contains("minor") || lowercased.contains("small") {
            return .low
        }
        return .medium
    }
    
    private func assessDecisionReversibility(decision: DecisionInput) -> Reversibility {
        let lowercased = decision.description.lowercased()
        if lowercased.contains("permanent") || lowercased.contains("cannot undo") {
            return .irreversible
        }
        if lowercased.contains("easily change") || lowercased.contains("can revert") {
            return .fullyReversible
        }
        return .partiallyReversible
    }
    
    private func assessDecisionNovelty(decision: DecisionInput) -> Novelty {
        let lowercased = decision.description.lowercased()
        if lowercased.contains("new") || lowercased.contains("first time") || lowercased.contains("never before") {
            return .novel
        }
        if lowercased.contains("routine") || lowercased.contains("standard") {
            return .routine
        }
        return .familiar
    }
    
    private func generateQuestionsForHuman(decision: DecisionInput, uncertainty: UncertaintyEstimate, stakes: StakesLevel) -> [String] {
        var questions: [String] = []
        
        if uncertainty.totalUncertainty > 0.5 {
            questions.append("What additional information would reduce uncertainty?")
        }
        if stakes == .high {
            questions.append("What are the consequences if this decision is wrong?")
            questions.append("Who else should be consulted?")
        }
        
        return questions
    }
    
    private func generateHumanInputReason(uncertainty: Float, stakes: StakesLevel, reversibility: Reversibility) -> String {
        var reasons: [String] = []
        if uncertainty > 0.5 { reasons.append("high uncertainty") }
        if stakes == .high { reasons.append("high stakes") }
        if reversibility == .irreversible { reasons.append("irreversible") }
        
        if reasons.isEmpty { return "Routine decision - automation recommended" }
        return "Human input recommended due to: \(reasons.joined(separator: ", "))"
    }
    
    // MARK: - Stats
    
    public var stats: RiskStats {
        RiskStats(
            beliefCount: beliefStore.count,
            biasPatternCount: biasPatterns.count,
            metricRecords: metricHistory.count,
            totalExecutions: executionLog.count
        )
    }
}
