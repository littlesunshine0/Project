//
//  StructureEngine.swift
//  AIKit - Core Intelligence Engine #2
//
//  Purpose: Learn how systems should be shaped
//  Capabilities: Architecture pattern classification, coupling/cohesion modeling,
//                reusable boundary detection, refactor opportunity detection,
//                system complexity estimation
//

import Foundation

// MARK: - Structure & Systems Engine

/// Core Engine #2: Learns how systems should be shaped
public actor StructureEngine {
    public static let shared = StructureEngine()
    
    private var analysisCache: [String: StructureAnalysis] = [:]
    private var patternDatabase: [ArchitecturePattern]
    private var boundaryModels: [String: BoundaryModel] = [:]
    private var executionLog: [StructureExecution] = []
    
    private init() {
        // Initialize patterns inline for Swift 6 actor isolation
        patternDatabase = [
            ArchitecturePattern(id: "mvc", name: "MVC", indicators: ["model", "view", "controller"], healthyBoundaries: ["Model-View separation", "Controller mediates"]),
            ArchitecturePattern(id: "mvvm", name: "MVVM", indicators: ["model", "view", "viewmodel", "binding"], healthyBoundaries: ["ViewModel owns logic", "View is passive"]),
            ArchitecturePattern(id: "clean", name: "Clean Architecture", indicators: ["entity", "usecase", "repository", "presenter"], healthyBoundaries: ["Dependency rule", "Use case isolation"]),
            ArchitecturePattern(id: "hexagonal", name: "Hexagonal", indicators: ["port", "adapter", "domain", "application"], healthyBoundaries: ["Ports define contracts", "Adapters are replaceable"]),
            ArchitecturePattern(id: "layered", name: "Layered", indicators: ["presentation", "business", "data", "layer"], healthyBoundaries: ["Layer isolation", "Downward dependencies"]),
            ArchitecturePattern(id: "microservices", name: "Microservices", indicators: ["service", "api", "gateway", "event"], healthyBoundaries: ["Service autonomy", "API contracts"]),
            ArchitecturePattern(id: "modular", name: "Modular Monolith", indicators: ["module", "package", "internal", "public"], healthyBoundaries: ["Module boundaries", "Explicit interfaces"])
        ]
    }
    
    // MARK: - Architecture Classification
    
    /// Classify the architecture pattern of a codebase
    public func classifyArchitecture(files: [FileStructure]) async -> ArchitectureClassification {
        let start = Date()
        
        var patternScores: [String: Float] = [:]
        var detectedIndicators: [String: [String]] = [:]
        
        // Analyze file structure
        let allPaths = files.map { $0.path.lowercased() }
        let allNames = files.map { $0.name.lowercased() }
        let combined = (allPaths + allNames).joined(separator: " ")
        
        for pattern in patternDatabase {
            var score: Float = 0
            var indicators: [String] = []
            
            for indicator in pattern.indicators {
                let count = combined.components(separatedBy: indicator).count - 1
                if count > 0 {
                    score += Float(min(count, 5)) * 0.2
                    indicators.append(indicator)
                }
            }
            
            patternScores[pattern.id] = score
            detectedIndicators[pattern.id] = indicators
        }
        
        // Find best match
        let sorted = patternScores.sorted { $0.value > $1.value }
        let bestMatch = sorted.first
        let pattern = patternDatabase.first { $0.id == bestMatch?.key }
        
        // Calculate consistency
        let consistency = calculateConsistency(files: files, pattern: pattern)
        
        let result = ArchitectureClassification(
            primaryPattern: pattern?.name ?? "Unknown",
            confidence: min(1.0, (bestMatch?.value ?? 0) / 2.0),
            detectedIndicators: detectedIndicators[bestMatch?.key ?? ""] ?? [],
            alternativePatterns: Array(sorted.dropFirst().prefix(2).map { item in patternDatabase.first { p in p.id == item.key }?.name ?? "" }),
            consistencyScore: consistency,
            recommendations: generateArchitectureRecommendations(pattern: pattern, consistency: consistency),
            processingTime: Date().timeIntervalSince(start)
        )
        
        executionLog.append(StructureExecution(type: .classification, timestamp: Date()))
        return result
    }
    
    // MARK: - Coupling & Cohesion Analysis
    
    /// Analyze coupling and cohesion of modules
    public func analyzeCouplingCohesion(modules: [ModuleInfo]) async -> CouplingCohesionAnalysis {
        var moduleAnalyses: [ModuleCouplingAnalysis] = []
        
        for module in modules {
            let coupling = calculateCoupling(module: module, allModules: modules)
            let cohesion = calculateCohesion(module: module)
            let health = assessModuleHealth(coupling: coupling, cohesion: cohesion)
            
            moduleAnalyses.append(ModuleCouplingAnalysis(
                moduleName: module.name,
                afferentCoupling: coupling.afferent,
                efferentCoupling: coupling.efferent,
                instability: coupling.efferent / max(1, coupling.afferent + coupling.efferent),
                cohesionScore: cohesion,
                health: health,
                recommendations: generateCouplingRecommendations(coupling: coupling, cohesion: cohesion)
            ))
        }
        
        let overallHealth = moduleAnalyses.reduce(0.0) { $0 + ($1.health == .healthy ? 1.0 : $1.health == .warning ? 0.5 : 0) } / Float(max(1, moduleAnalyses.count))
        
        return CouplingCohesionAnalysis(
            modules: moduleAnalyses,
            overallHealth: overallHealth,
            hotspots: identifyHotspots(analyses: moduleAnalyses),
            suggestions: generateOverallSuggestions(analyses: moduleAnalyses)
        )
    }
    
    // MARK: - Reusable Boundary Detection
    
    /// Detect potential reusable package boundaries
    public func detectReusableBoundaries(codebase: CodebaseInfo) async -> [ReusableBoundary] {
        var boundaries: [ReusableBoundary] = []
        
        // Analyze each module for reusability potential
        for module in codebase.modules {
            let reusabilityScore = calculateReusabilityScore(module: module, codebase: codebase)
            
            if reusabilityScore > 0.6 {
                boundaries.append(ReusableBoundary(
                    name: module.name,
                    files: module.files,
                    reusabilityScore: reusabilityScore,
                    dependencyCount: module.dependencies.count,
                    dependentCount: countDependents(module: module, codebase: codebase),
                    extractionComplexity: assessExtractionComplexity(module: module),
                    suggestedPackageName: suggestPackageName(module: module),
                    benefits: identifyExtractionBenefits(module: module, reusabilityScore: reusabilityScore)
                ))
            }
        }
        
        return boundaries.sorted { $0.reusabilityScore > $1.reusabilityScore }
    }
    
    // MARK: - Refactor Opportunity Detection
    
    /// Detect refactoring opportunities
    public func detectRefactorOpportunities(codebase: CodebaseInfo) async -> [RefactorOpportunity] {
        var opportunities: [RefactorOpportunity] = []
        
        // Check for code duplication
        let duplications = detectDuplication(codebase: codebase)
        for dup in duplications {
            opportunities.append(RefactorOpportunity(
                type: .extractSharedModule,
                description: "Duplicated logic found in \(dup.locations.count) locations",
                affectedFiles: dup.locations,
                impact: .high,
                effort: .medium,
                priority: calculatePriority(impact: .high, effort: .medium),
                suggestedAction: "Extract to shared module: \(dup.suggestedName)"
            ))
        }
        
        // Check for large files
        for module in codebase.modules {
            for file in module.files where file.lineCount > 500 {
                opportunities.append(RefactorOpportunity(
                    type: .splitLargeFile,
                    description: "Large file with \(file.lineCount) lines",
                    affectedFiles: [file.path],
                    impact: .medium,
                    effort: .medium,
                    priority: calculatePriority(impact: .medium, effort: .medium),
                    suggestedAction: "Split into smaller, focused files"
                ))
            }
        }
        
        // Check for high coupling
        let couplingAnalysis = await analyzeCouplingCohesion(modules: codebase.modules)
        for analysis in couplingAnalysis.modules where analysis.health == .unhealthy {
            opportunities.append(RefactorOpportunity(
                type: .reduceCoupling,
                description: "High coupling in \(analysis.moduleName)",
                affectedFiles: [],
                impact: .high,
                effort: .high,
                priority: calculatePriority(impact: .high, effort: .high),
                suggestedAction: analysis.recommendations.first ?? "Introduce abstractions to reduce coupling"
            ))
        }
        
        return opportunities.sorted { $0.priority > $1.priority }
    }
    
    // MARK: - System Complexity Estimation
    
    /// Estimate system complexity and maintainability threshold
    public func estimateComplexity(codebase: CodebaseInfo) async -> ComplexityEstimate {
        let start = Date()
        
        // Calculate various complexity metrics
        let structuralComplexity = calculateStructuralComplexity(codebase: codebase)
        let cognitiveComplexity = calculateCognitiveComplexity(codebase: codebase)
        let dependencyComplexity = calculateDependencyComplexity(codebase: codebase)
        
        let overallComplexity = (structuralComplexity + cognitiveComplexity + dependencyComplexity) / 3.0
        
        // Determine maintainability
        let maintainability: MaintainabilityLevel
        let threshold: String
        
        switch overallComplexity {
        case 0..<0.3:
            maintainability = .excellent
            threshold = "Well within maintainable range"
        case 0.3..<0.5:
            maintainability = .good
            threshold = "Maintainable with standard practices"
        case 0.5..<0.7:
            maintainability = .moderate
            threshold = "Approaching complexity threshold"
        case 0.7..<0.85:
            maintainability = .concerning
            threshold = "Above recommended complexity - consider refactoring"
        default:
            maintainability = .critical
            threshold = "Critical complexity - immediate action needed"
        }
        
        return ComplexityEstimate(
            overallScore: overallComplexity,
            structuralComplexity: structuralComplexity,
            cognitiveComplexity: cognitiveComplexity,
            dependencyComplexity: dependencyComplexity,
            maintainability: maintainability,
            thresholdAssessment: threshold,
            hotspots: identifyComplexityHotspots(codebase: codebase),
            recommendations: generateComplexityRecommendations(complexity: overallComplexity, codebase: codebase),
            processingTime: Date().timeIntervalSince(start)
        )
    }
    
    // MARK: - Architecture Stability Prediction
    
    /// Predict architecture stability over time
    public func predictStability(codebase: CodebaseInfo, changeHistory: [ChangeRecord] = []) async -> StabilityPrediction {
        let classification = await classifyArchitecture(files: codebase.modules.flatMap { $0.files })
        let complexity = await estimateComplexity(codebase: codebase)
        
        // Calculate stability factors
        let patternAdherence = classification.consistencyScore
        let complexityFactor = 1.0 - complexity.overallScore
        let changeFactor = calculateChangeStability(history: changeHistory)
        
        let stabilityScore = (patternAdherence + complexityFactor + changeFactor) / 3.0
        
        let prediction: String
        let timeframe: String
        
        switch stabilityScore {
        case 0.8...:
            prediction = "Architecture likely to remain stable"
            timeframe = "12+ months without major refactoring"
        case 0.6..<0.8:
            prediction = "Architecture moderately stable"
            timeframe = "6-12 months before significant changes needed"
        case 0.4..<0.6:
            prediction = "Architecture showing strain"
            timeframe = "3-6 months before refactoring recommended"
        default:
            prediction = "Architecture unstable"
            timeframe = "Immediate attention recommended"
        }
        
        return StabilityPrediction(
            stabilityScore: stabilityScore,
            prediction: prediction,
            timeframe: timeframe,
            riskFactors: identifyStabilityRisks(classification: classification, complexity: complexity),
            recommendations: generateStabilityRecommendations(score: stabilityScore)
        )
    }
    
    // MARK: - Private Helpers
    
    private func calculateConsistency(files: [FileStructure], pattern: ArchitecturePattern?) -> Float {
        guard let pattern = pattern else { return 0.5 }
        // Simplified consistency check
        let indicatorCount = pattern.indicators.count
        var foundCount = 0
        let allPaths = files.map { $0.path.lowercased() }.joined(separator: " ")
        for indicator in pattern.indicators where allPaths.contains(indicator) {
            foundCount += 1
        }
        return Float(foundCount) / Float(max(1, indicatorCount))
    }
    
    private func generateArchitectureRecommendations(pattern: ArchitecturePattern?, consistency: Float) -> [String] {
        var recommendations: [String] = []
        if consistency < 0.5 {
            recommendations.append("Consider establishing clearer architectural boundaries")
        }
        if let pattern = pattern {
            recommendations.append("Follow \(pattern.name) best practices: \(pattern.healthyBoundaries.joined(separator: ", "))")
        }
        return recommendations
    }
    
    private func calculateCoupling(module: ModuleInfo, allModules: [ModuleInfo]) -> (afferent: Float, efferent: Float) {
        let efferent = Float(module.dependencies.count)
        var afferent: Float = 0
        for other in allModules where other.name != module.name {
            if other.dependencies.contains(module.name) {
                afferent += 1
            }
        }
        return (afferent, efferent)
    }
    
    private func calculateCohesion(module: ModuleInfo) -> Float {
        // Simplified cohesion based on file count and naming consistency
        let fileCount = module.files.count
        if fileCount <= 1 { return 1.0 }
        
        // Check naming consistency
        let names = module.files.map { $0.name.lowercased() }
        let commonPrefix = findCommonPrefix(names)
        let prefixScore: Float = commonPrefix.isEmpty ? 0.3 : 0.7
        
        return min(Float(1.0), prefixScore + (1.0 / Float(fileCount)) * 0.3)
    }
    
    private func findCommonPrefix(_ strings: [String]) -> String {
        guard let first = strings.first else { return "" }
        var prefix = ""
        for char in first {
            let test = prefix + String(char)
            if strings.allSatisfy({ $0.hasPrefix(test) }) {
                prefix = test
            } else {
                break
            }
        }
        return prefix
    }
    
    private func assessModuleHealth(coupling: (afferent: Float, efferent: Float), cohesion: Float) -> ModuleHealth {
        let instability = coupling.efferent / max(1, coupling.afferent + coupling.efferent)
        if cohesion > 0.7 && instability < 0.7 { return .healthy }
        if cohesion > 0.4 || instability < 0.85 { return .warning }
        return .unhealthy
    }
    
    private func generateCouplingRecommendations(coupling: (afferent: Float, efferent: Float), cohesion: Float) -> [String] {
        var recommendations: [String] = []
        if coupling.efferent > 5 {
            recommendations.append("Reduce outgoing dependencies - consider dependency injection")
        }
        if cohesion < 0.5 {
            recommendations.append("Improve cohesion - group related functionality")
        }
        return recommendations
    }
    
    private func identifyHotspots(analyses: [ModuleCouplingAnalysis]) -> [String] {
        analyses.filter { $0.health == .unhealthy }.map { $0.moduleName }
    }
    
    private func generateOverallSuggestions(analyses: [ModuleCouplingAnalysis]) -> [String] {
        var suggestions: [String] = []
        let unhealthyCount = analyses.filter { $0.health == .unhealthy }.count
        if unhealthyCount > 0 {
            suggestions.append("Address \(unhealthyCount) modules with coupling issues")
        }
        return suggestions
    }
    
    private func calculateReusabilityScore(module: ModuleInfo, codebase: CodebaseInfo) -> Float {
        var score: Float = 0.5
        
        // Low dependencies = more reusable
        if module.dependencies.count <= 2 { score += 0.2 }
        
        // Multiple dependents = proven utility
        let dependentCount = countDependents(module: module, codebase: codebase)
        if dependentCount >= 2 { score += 0.2 }
        
        // Reasonable size
        let totalLines = module.files.reduce(0) { $0 + $1.lineCount }
        if totalLines > 50 && totalLines < 1000 { score += 0.1 }
        
        return min(1.0, score)
    }
    
    private func countDependents(module: ModuleInfo, codebase: CodebaseInfo) -> Int {
        codebase.modules.filter { $0.dependencies.contains(module.name) }.count
    }
    
    private func assessExtractionComplexity(module: ModuleInfo) -> ExtractionComplexity {
        if module.dependencies.count <= 1 { return .low }
        if module.dependencies.count <= 3 { return .medium }
        return .high
    }
    
    private func suggestPackageName(module: ModuleInfo) -> String {
        let name = module.name.replacingOccurrences(of: "Module", with: "").replacingOccurrences(of: "Service", with: "")
        return "\(name)Kit"
    }
    
    private func identifyExtractionBenefits(module: ModuleInfo, reusabilityScore: Float) -> [String] {
        var benefits: [String] = []
        if reusabilityScore > 0.7 {
            benefits.append("High reuse potential across projects")
        }
        benefits.append("Improved testability in isolation")
        benefits.append("Clearer dependency boundaries")
        return benefits
    }
    
    private func detectDuplication(codebase: CodebaseInfo) -> [DuplicationInfo] {
        // Simplified duplication detection
        return []
    }
    
    private func calculatePriority(impact: ImpactLevel, effort: EffortLevel) -> Float {
        let impactScore: Float = impact == .high ? 1.0 : impact == .medium ? 0.6 : 0.3
        let effortScore: Float = effort == .low ? 1.0 : effort == .medium ? 0.6 : 0.3
        return (impactScore + effortScore) / 2.0
    }
    
    private func calculateStructuralComplexity(codebase: CodebaseInfo) -> Float {
        let moduleCount = Float(codebase.modules.count)
        let avgDeps = codebase.modules.reduce(0.0) { $0 + Float($1.dependencies.count) } / max(1, moduleCount)
        return min(1.0, (moduleCount / 50.0) * 0.5 + (avgDeps / 10.0) * 0.5)
    }
    
    private func calculateCognitiveComplexity(codebase: CodebaseInfo) -> Float {
        let totalLines = codebase.modules.flatMap { $0.files }.reduce(0) { $0 + $1.lineCount }
        return min(1.0, Float(totalLines) / 50000.0)
    }
    
    private func calculateDependencyComplexity(codebase: CodebaseInfo) -> Float {
        let totalDeps = codebase.modules.reduce(0) { $0 + $1.dependencies.count }
        return min(1.0, Float(totalDeps) / Float(max(1, codebase.modules.count * 5)))
    }
    
    private func identifyComplexityHotspots(codebase: CodebaseInfo) -> [String] {
        codebase.modules.filter { $0.files.reduce(0) { $0 + $1.lineCount } > 1000 }.map { $0.name }
    }
    
    private func generateComplexityRecommendations(complexity: Float, codebase: CodebaseInfo) -> [String] {
        var recommendations: [String] = []
        if complexity > 0.7 {
            recommendations.append("Consider breaking down large modules")
            recommendations.append("Reduce inter-module dependencies")
        }
        return recommendations
    }
    
    private func calculateChangeStability(history: [ChangeRecord]) -> Float {
        if history.isEmpty { return 0.7 }
        // More changes = less stable
        let recentChanges = history.filter { $0.date > Date().addingTimeInterval(-30 * 24 * 3600) }.count
        return max(0.2, 1.0 - Float(recentChanges) / 50.0)
    }
    
    private func identifyStabilityRisks(classification: ArchitectureClassification, complexity: ComplexityEstimate) -> [String] {
        var risks: [String] = []
        if classification.consistencyScore < 0.5 {
            risks.append("Inconsistent architecture pattern adherence")
        }
        if complexity.overallScore > 0.7 {
            risks.append("High overall complexity")
        }
        return risks
    }
    
    private func generateStabilityRecommendations(score: Float) -> [String] {
        if score > 0.7 { return ["Continue current practices"] }
        return ["Establish clearer module boundaries", "Reduce coupling between components"]
    }
    
    // MARK: - Stats
    
    public var stats: StructureStats {
        StructureStats(
            totalAnalyses: executionLog.count,
            patternCount: patternDatabase.count,
            cacheSize: analysisCache.count
        )
    }
}
