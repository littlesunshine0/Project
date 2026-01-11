//
//  AIKit.swift
//  AIKit - Unified ML Intelligence Platform
//
//  A single, modular ML-powered platform that understands ideas, code,
//  documents, systems, and decisions, and continuously improves how
//  projects are planned, built, and evolved.
//
//  Core Intelligence Engines:
//  1. Understanding Engine - Turn unstructured input into structured meaning
//  2. Structure Engine - Learn how systems should be shaped
//  3. Planning Engine - Predict how plans break and how to improve them
//  4. Memory Engine - Maintain long-term, evolving intelligence
//  5. Risk Engine - Know how confident the system should be
//

import Foundation

public struct AIKit {
    public static let version = "2.0.0"
    public static let identifier = "com.flowkit.aikit"
    
    /// One-sentence pitch
    public static let pitch = "A unified ML platform that understands ideas, systems, and decisions—and continuously helps you build better ones."
    
    public init() {}
    
    // MARK: - Quick Access to Core Engines
    
    /// Understanding Engine - Turn unstructured input into structured meaning
    public static var understanding: UnderstandingEngine { UnderstandingEngine.shared }
    
    /// Structure Engine - Learn how systems should be shaped
    public static var structure: StructureEngine { StructureEngine.shared }
    
    /// Planning Engine - Predict how plans break and how to improve them
    public static var planning: PlanningEngine { PlanningEngine.shared }
    
    /// Memory Engine - Maintain long-term, evolving intelligence
    public static var memory: MemoryEngine { MemoryEngine.shared }
    
    /// Risk Engine - Know how confident the system should be
    public static var risk: RiskEngine { RiskEngine.shared }
    
    /// Intelligence Orchestrator - Routes requests and merges results
    public static var orchestrator: IntelligenceOrchestrator { IntelligenceOrchestrator.shared }
}

// MARK: - AI Orchestrator

public actor AIOrchestrator {
    public static let shared = AIOrchestrator()
    
    private var models: [String: AIModel] = [:]
    private var pipelines: [String: AIPipeline] = [:]
    private var executionHistory: [AIExecution] = []
    
    private init() {}
    
    // MARK: - Model Management
    
    public func registerModel(_ model: AIModel) {
        models[model.id] = model
    }
    
    public func getModel(_ id: String) -> AIModel? { models[id] }
    public func getAllModels() -> [AIModel] { Array(models.values) }
    
    // MARK: - Pipeline Management
    
    public func createPipeline(id: String, steps: [PipelineStep]) -> AIPipeline {
        let pipeline = AIPipeline(id: id, steps: steps)
        pipelines[id] = pipeline
        return pipeline
    }
    
    public func getPipeline(_ id: String) -> AIPipeline? { pipelines[id] }
    
    // MARK: - Execution
    
    public func execute(modelId: String, input: AIInput) async -> AIOutput {
        let start = Date()
        
        guard let model = models[modelId] else {
            return AIOutput(success: false, error: "Model not found: \(modelId)")
        }
        
        // Simulate model execution
        let result = model.process(input)
        let duration = Date().timeIntervalSince(start)
        
        let execution = AIExecution(modelId: modelId, input: input, output: result, duration: duration)
        executionHistory.append(execution)
        
        return result
    }
    
    public func executePipeline(_ pipelineId: String, input: AIInput) async -> AIOutput {
        guard let pipeline = pipelines[pipelineId] else {
            return AIOutput(success: false, error: "Pipeline not found")
        }
        
        var currentInput = input
        
        for step in pipeline.steps {
            guard let model = models[step.modelId] else {
                return AIOutput(success: false, error: "Model not found: \(step.modelId)")
            }
            
            let output = model.process(currentInput)
            if !output.success { return output }
            
            // Transform output to input for next step
            currentInput = AIInput(text: output.result ?? "", metadata: output.metadata)
        }
        
        return AIOutput(success: true, result: currentInput.text, metadata: currentInput.metadata)
    }
    
    public var stats: AIStats {
        AIStats(
            modelCount: models.count,
            pipelineCount: pipelines.count,
            totalExecutions: executionHistory.count,
            averageLatency: executionHistory.isEmpty ? 0 : executionHistory.reduce(0) { $0 + $1.duration } / Double(executionHistory.count)
        )
    }
}

// MARK: - Semantic Code Engine

public actor SemanticCodeEngine {
    public static let shared = SemanticCodeEngine()
    
    private var codeEmbeddings: [String: [Float]] = [:]
    private var symbolIndex: [String: [CodeSymbol]] = [:]
    
    private init() {}
    
    public func analyzeCode(_ code: String, language: String) -> CodeAnalysis {
        // Extract symbols
        let symbols = extractSymbols(code, language: language)
        
        // Calculate complexity
        let complexity = calculateComplexity(code)
        
        // Generate embedding (simplified)
        let embedding = generateEmbedding(code)
        
        return CodeAnalysis(
            language: language,
            symbols: symbols,
            complexity: complexity,
            embedding: embedding,
            lineCount: code.components(separatedBy: .newlines).count
        )
    }
    
    public func findSimilar(_ code: String, threshold: Float = 0.8) -> [String] {
        let embedding = generateEmbedding(code)
        var similar: [String] = []
        
        for (id, stored) in codeEmbeddings {
            let similarity = cosineSimilarity(embedding, stored)
            if similarity >= threshold {
                similar.append(id)
            }
        }
        
        return similar
    }
    
    public func indexCode(_ code: String, id: String, language: String) {
        codeEmbeddings[id] = generateEmbedding(code)
        symbolIndex[id] = extractSymbols(code, language: language)
    }
    
    private func extractSymbols(_ code: String, language: String) -> [CodeSymbol] {
        var symbols: [CodeSymbol] = []
        let lines = code.components(separatedBy: .newlines)
        
        for (index, line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            if trimmed.contains("func ") {
                let name = trimmed.components(separatedBy: "func ").last?.components(separatedBy: "(").first ?? "unknown"
                symbols.append(CodeSymbol(name: name, kind: .function, line: index + 1))
            } else if trimmed.contains("class ") {
                let name = trimmed.components(separatedBy: "class ").last?.components(separatedBy: " ").first ?? "unknown"
                symbols.append(CodeSymbol(name: name, kind: .class, line: index + 1))
            } else if trimmed.contains("struct ") {
                let name = trimmed.components(separatedBy: "struct ").last?.components(separatedBy: " ").first ?? "unknown"
                symbols.append(CodeSymbol(name: name, kind: .struct, line: index + 1))
            }
        }
        
        return symbols
    }
    
    private func calculateComplexity(_ code: String) -> Int {
        var complexity = 1
        let keywords = ["if", "else", "for", "while", "switch", "case", "catch", "guard"]
        for keyword in keywords {
            complexity += code.components(separatedBy: keyword).count - 1
        }
        return complexity
    }
    
    private func generateEmbedding(_ text: String) -> [Float] {
        // Simplified embedding - in production use actual ML model
        var embedding = [Float](repeating: 0, count: 128)
        for (i, char) in text.enumerated() {
            embedding[i % 128] += Float(char.asciiValue ?? 0) / 255.0
        }
        return embedding
    }
    
    private func cosineSimilarity(_ a: [Float], _ b: [Float]) -> Float {
        guard a.count == b.count else { return 0 }
        var dot: Float = 0, magA: Float = 0, magB: Float = 0
        for i in 0..<a.count {
            dot += a[i] * b[i]
            magA += a[i] * a[i]
            magB += b[i] * b[i]
        }
        let mag = sqrt(magA) * sqrt(magB)
        return mag > 0 ? dot / mag : 0
    }
}

// MARK: - Models

public struct AIModel: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let type: ModelType
    public let version: String
    
    public init(id: String, name: String, type: ModelType, version: String = "1.0") {
        self.id = id
        self.name = name
        self.type = type
        self.version = version
    }
    
    public func process(_ input: AIInput) -> AIOutput {
        // Simplified processing
        AIOutput(success: true, result: "Processed: \(input.text)", metadata: input.metadata)
    }
}

public enum ModelType: String, Sendable, CaseIterable {
    case classification, generation, embedding, extraction, translation
}

public struct AIInput: Sendable {
    public let text: String
    public let metadata: [String: String]
    
    public init(text: String, metadata: [String: String] = [:]) {
        self.text = text
        self.metadata = metadata
    }
}

public struct AIOutput: Sendable {
    public let success: Bool
    public let result: String?
    public let error: String?
    public let metadata: [String: String]
    public let confidence: Float?
    
    public init(success: Bool, result: String? = nil, error: String? = nil, metadata: [String: String] = [:], confidence: Float? = nil) {
        self.success = success
        self.result = result
        self.error = error
        self.metadata = metadata
        self.confidence = confidence
    }
}

public struct AIPipeline: Identifiable, Sendable {
    public let id: String
    public let steps: [PipelineStep]
    
    public init(id: String, steps: [PipelineStep]) {
        self.id = id
        self.steps = steps
    }
}

public struct PipelineStep: Sendable {
    public let modelId: String
    public let config: [String: String]
    
    public init(modelId: String, config: [String: String] = [:]) {
        self.modelId = modelId
        self.config = config
    }
}

public struct AIExecution: Sendable {
    public let modelId: String
    public let input: AIInput
    public let output: AIOutput
    public let duration: TimeInterval
    public let timestamp: Date
    
    public init(modelId: String, input: AIInput, output: AIOutput, duration: TimeInterval, timestamp: Date = Date()) {
        self.modelId = modelId
        self.input = input
        self.output = output
        self.duration = duration
        self.timestamp = timestamp
    }
}

public struct CodeAnalysis: Sendable {
    public let language: String
    public let symbols: [CodeSymbol]
    public let complexity: Int
    public let embedding: [Float]
    public let lineCount: Int
}

public struct CodeSymbol: Sendable {
    public let name: String
    public let kind: SymbolKind
    public let line: Int
}

public enum SymbolKind: String, Sendable, CaseIterable {
    case function, `class`, `struct`, `enum`, variable, constant, property
}

public struct AIStats: Sendable {
    public let modelCount: Int
    public let pipelineCount: Int
    public let totalExecutions: Int
    public let averageLatency: TimeInterval
}
