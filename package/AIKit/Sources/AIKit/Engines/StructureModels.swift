//
//  StructureModels.swift
//  AIKit - Structure Engine Models
//

import Foundation

// MARK: - Architecture

public struct ArchitecturePattern: Sendable {
    public let id: String
    public let name: String
    public let indicators: [String]
    public let healthyBoundaries: [String]
}

public struct ArchitectureClassification: Sendable {
    public let primaryPattern: String
    public let confidence: Float
    public let detectedIndicators: [String]
    public let alternativePatterns: [String]
    public let consistencyScore: Float
    public let recommendations: [String]
    public let processingTime: TimeInterval
}

// MARK: - File & Module Structure

public struct FileStructure: Sendable {
    public let path: String
    public let name: String
    public let lineCount: Int
    public let language: String
    
    public init(path: String, name: String, lineCount: Int = 0, language: String = "swift") {
        self.path = path
        self.name = name
        self.lineCount = lineCount
        self.language = language
    }
}

public struct ModuleInfo: Sendable {
    public let name: String
    public let files: [FileStructure]
    public let dependencies: [String]
    public let publicAPI: [String]
    
    public init(name: String, files: [FileStructure], dependencies: [String] = [], publicAPI: [String] = []) {
        self.name = name
        self.files = files
        self.dependencies = dependencies
        self.publicAPI = publicAPI
    }
}

public struct CodebaseInfo: Sendable {
    public let name: String
    public let modules: [ModuleInfo]
    public let totalFiles: Int
    public let totalLines: Int
    
    public init(name: String, modules: [ModuleInfo]) {
        self.name = name
        self.modules = modules
        self.totalFiles = modules.flatMap { $0.files }.count
        self.totalLines = modules.flatMap { $0.files }.reduce(0) { $0 + $1.lineCount }
    }
}

// MARK: - Coupling & Cohesion

public struct CouplingCohesionAnalysis: Sendable {
    public let modules: [ModuleCouplingAnalysis]
    public let overallHealth: Float
    public let hotspots: [String]
    public let suggestions: [String]
}

public struct ModuleCouplingAnalysis: Sendable {
    public let moduleName: String
    public let afferentCoupling: Float
    public let efferentCoupling: Float
    public let instability: Float
    public let cohesionScore: Float
    public let health: ModuleHealth
    public let recommendations: [String]
}

public enum ModuleHealth: String, Sendable {
    case healthy, warning, unhealthy
}

// MARK: - Reusable Boundaries

public struct ReusableBoundary: Sendable {
    public let name: String
    public let files: [FileStructure]
    public let reusabilityScore: Float
    public let dependencyCount: Int
    public let dependentCount: Int
    public let extractionComplexity: ExtractionComplexity
    public let suggestedPackageName: String
    public let benefits: [String]
}

public enum ExtractionComplexity: String, Sendable {
    case low, medium, high
}

// MARK: - Refactor Opportunities

public struct RefactorOpportunity: Sendable {
    public let type: RefactorType
    public let description: String
    public let affectedFiles: [String]
    public let impact: ImpactLevel
    public let effort: EffortLevel
    public let priority: Float
    public let suggestedAction: String
}

public enum RefactorType: String, Sendable {
    case extractSharedModule
    case splitLargeFile
    case reduceCoupling
    case improveNaming
    case removeDeadCode
    case consolidateDuplicates
}

public enum ImpactLevel: String, Sendable {
    case low, medium, high
}

public enum EffortLevel: String, Sendable {
    case low, medium, high
}

// MARK: - Complexity

public struct ComplexityEstimate: Sendable {
    public let overallScore: Float
    public let structuralComplexity: Float
    public let cognitiveComplexity: Float
    public let dependencyComplexity: Float
    public let maintainability: MaintainabilityLevel
    public let thresholdAssessment: String
    public let hotspots: [String]
    public let recommendations: [String]
    public let processingTime: TimeInterval
}

public enum MaintainabilityLevel: String, Sendable {
    case excellent, good, moderate, concerning, critical
}

// MARK: - Stability

public struct StabilityPrediction: Sendable {
    public let stabilityScore: Float
    public let prediction: String
    public let timeframe: String
    public let riskFactors: [String]
    public let recommendations: [String]
}

public struct ChangeRecord: Sendable {
    public let file: String
    public let changeType: String
    public let date: Date
    
    public init(file: String, changeType: String, date: Date) {
        self.file = file
        self.changeType = changeType
        self.date = date
    }
}

// MARK: - Internal Types

struct DuplicationInfo {
    let locations: [String]
    let suggestedName: String
}

struct StructureAnalysis {
    let timestamp: Date
    let result: Any
}

struct StructureExecution {
    let type: StructureExecutionType
    let timestamp: Date
}

enum StructureExecutionType {
    case classification, coupling, boundaries, refactor, complexity, stability
}

struct BoundaryModel {
    let id: String
    let rules: [String]
}

// MARK: - Stats

public struct StructureStats: Sendable {
    public let totalAnalyses: Int
    public let patternCount: Int
    public let cacheSize: Int
}
