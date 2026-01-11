//
//  MLIndexer.swift
//  DataKit
//
//  ML indexing and memory pipeline for intelligent package operations
//  Indexes everything for: search, recommendations, predictions, explanations
//

import Foundation

// MARK: - ML Indexer

public actor MLIndexer {
    public static let shared = MLIndexer()
    
    // Indexes
    private var packageIndex: [String: PackageMLEntry] = [:]
    private var actionIndex: [String: ActionMLEntry] = [:]
    private var commandIndex: [String: CommandMLEntry] = [:]
    private var workflowIndex: [String: WorkflowMLEntry] = [:]
    private var agentIndex: [String: AgentMLEntry] = [:]
    
    // Embeddings (simplified - in production use actual ML embeddings)
    private var textEmbeddings: [String: [Float]] = [:]
    
    // Usage tracking for recommendations
    private var usageHistory: [UsageEvent] = []
    private var frequencyMap: [String: Int] = [:]
    private var cooccurrenceMap: [String: [String: Int]] = [:]
    
    private init() {}
    
    // MARK: - Indexing Pipeline
    
    /// Index a complete package contract
    public func indexPackage(_ contract: PackageContract) async {
        let packageId = contract.manifest.id
        
        // 1. Index package metadata
        let packageDescription = "\(contract.manifest.name) - \(contract.manifest.category.rawValue)"
        let packageEntry = PackageMLEntry(
            id: packageId,
            name: contract.manifest.name,
            description: packageDescription,
            category: contract.manifest.category.rawValue,
            keywords: extractKeywords(from: contract),
            capabilities: contract.capabilities.actions + contract.capabilities.commands,
            embedding: await generateEmbedding(for: contract.manifest.name + " " + packageDescription)
        )
        packageIndex[packageId] = packageEntry
        
        // 2. Index actions
        for action in contract.actions.actions {
            let actionEntry = ActionMLEntry(
                id: action.id,
                packageId: packageId,
                name: action.name,
                description: action.description,
                category: action.category.rawValue,
                inputTypes: action.input.map { $0.type.rawValue },
                outputType: action.output,
                embedding: await generateEmbedding(for: action.name + " " + action.description)
            )
            actionIndex[action.id] = actionEntry
        }
        
        // 3. Index workflows
        for workflow in contract.workflows.workflows {
            let workflowEntry = WorkflowMLEntry(
                id: workflow.id,
                packageId: packageId,
                name: workflow.name,
                description: workflow.description,
                steps: workflow.steps.map { $0.action },
                embedding: await generateEmbedding(for: workflow.name + " " + workflow.description)
            )
            workflowIndex[workflow.id] = workflowEntry
        }
        
        // 4. Index agents
        for agent in contract.agents.agents {
            let agentEntry = AgentMLEntry(
                id: agent.id,
                packageId: packageId,
                name: agent.name,
                description: agent.description,
                triggers: agent.triggers.map { $0.type.rawValue },
                actions: agent.actions,
                embedding: await generateEmbedding(for: agent.name + " " + agent.description)
            )
            agentIndex[agent.id] = agentEntry
        }
        
        // 5. Generate command index from actions
        for action in contract.actions.actions {
            let commandEntry = CommandMLEntry(
                id: action.id,
                packageId: packageId,
                syntax: "/\(action.id.replacingOccurrences(of: ".", with: " "))",
                description: action.description,
                embedding: await generateEmbedding(for: action.description)
            )
            commandIndex[action.id] = commandEntry
        }
    }
    
    // MARK: - Search & Retrieval
    
    /// Semantic search across all indexed content
    public func search(query: String, limit: Int = 10) async -> [SearchResult] {
        let queryEmbedding = await generateEmbedding(for: query)
        var results: [SearchResult] = []
        
        // Search packages
        for (id, entry) in packageIndex {
            let score = cosineSimilarity(queryEmbedding, entry.embedding)
            if score > 0.3 {
                results.append(SearchResult(id: id, type: .package, name: entry.name, description: entry.description, score: score))
            }
        }
        
        // Search actions
        for (id, entry) in actionIndex {
            let score = cosineSimilarity(queryEmbedding, entry.embedding)
            if score > 0.3 {
                results.append(SearchResult(id: id, type: .action, name: entry.name, description: entry.description, score: score))
            }
        }
        
        // Search workflows
        for (id, entry) in workflowIndex {
            let score = cosineSimilarity(queryEmbedding, entry.embedding)
            if score > 0.3 {
                results.append(SearchResult(id: id, type: .workflow, name: entry.name, description: entry.description, score: score))
            }
        }
        
        // Sort by score and limit
        return results.sorted { $0.score > $1.score }.prefix(limit).map { $0 }
    }
    
    /// Find similar items
    public func findSimilar(to id: String, type: SearchResultType, limit: Int = 5) async -> [SearchResult] {
        guard let embedding = getEmbedding(for: id, type: type) else { return [] }
        
        var results: [SearchResult] = []
        let index: [String: any MLEntry] = switch type {
        case .package: packageIndex as [String: any MLEntry]
        case .action: actionIndex as [String: any MLEntry]
        case .workflow: workflowIndex as [String: any MLEntry]
        case .agent: agentIndex as [String: any MLEntry]
        case .command: commandIndex as [String: any MLEntry]
        }
        
        for (entryId, entry) in index where entryId != id {
            let score = cosineSimilarity(embedding, entry.embedding)
            if score > 0.5 {
                results.append(SearchResult(id: entryId, type: type, name: entry.name, description: entry.entryDescription, score: score))
            }
        }
        
        return results.sorted { $0.score > $1.score }.prefix(limit).map { $0 }
    }
    
    // MARK: - Recommendations
    
    /// Get recommended actions based on context and history
    public func recommendActions(context: MLIndexerContext) async -> [RecommendedAction] {
        var recommendations: [RecommendedAction] = []
        
        // 1. Frequency-based recommendations
        let frequentActions = frequencyMap.sorted { $0.value > $1.value }.prefix(5)
        for (actionId, count) in frequentActions {
            if let entry = actionIndex[actionId] {
                recommendations.append(RecommendedAction(
                    id: actionId,
                    name: entry.name,
                    reason: .frequent,
                    confidence: min(Double(count) / 100.0, 0.9)
                ))
            }
        }
        
        // 2. Co-occurrence based (if user just did action X, suggest Y)
        if let lastAction = context.lastAction, let cooccurrences = cooccurrenceMap[lastAction] {
            let related = cooccurrences.sorted { $0.value > $1.value }.prefix(3)
            for (actionId, count) in related {
                if let entry = actionIndex[actionId] {
                    recommendations.append(RecommendedAction(
                        id: actionId,
                        name: entry.name,
                        reason: .cooccurrence,
                        confidence: min(Double(count) / 50.0, 0.8)
                    ))
                }
            }
        }
        
        // 3. Context-based (semantic similarity to current context)
        if let contextText = context.contextDescription {
            let contextEmbedding = await generateEmbedding(for: contextText)
            for (actionId, entry) in actionIndex {
                let score = cosineSimilarity(contextEmbedding, entry.embedding)
                if score > 0.6 {
                    recommendations.append(RecommendedAction(
                        id: actionId,
                        name: entry.name,
                        reason: .contextual,
                        confidence: Double(score)
                    ))
                }
            }
        }
        
        // Deduplicate and sort
        let unique = Dictionary(grouping: recommendations, by: { $0.id })
            .mapValues { $0.max(by: { $0.confidence < $1.confidence })! }
            .values
            .sorted { $0.confidence > $1.confidence }
        
        return Array(unique.prefix(10))
    }
    
    /// Get recommended workflows for a task
    public func recommendWorkflows(for task: String) async -> [RecommendedWorkflow] {
        let taskEmbedding = await generateEmbedding(for: task)
        var recommendations: [RecommendedWorkflow] = []
        
        for (id, entry) in workflowIndex {
            let score = cosineSimilarity(taskEmbedding, entry.embedding)
            if score > 0.4 {
                recommendations.append(RecommendedWorkflow(
                    id: id,
                    name: entry.name,
                    description: entry.description,
                    steps: entry.steps,
                    confidence: Double(score)
                ))
            }
        }
        
        return recommendations.sorted { $0.confidence > $1.confidence }.prefix(5).map { $0 }
    }
    
    // MARK: - Usage Tracking
    
    /// Record usage event for learning
    public func recordUsage(_ event: UsageEvent) {
        usageHistory.append(event)
        
        // Update frequency
        frequencyMap[event.actionId, default: 0] += 1
        
        // Update co-occurrence
        if let previous = usageHistory.dropLast().last {
            cooccurrenceMap[previous.actionId, default: [:]][event.actionId, default: 0] += 1
        }
        
        // Trim history if too large
        if usageHistory.count > 10000 {
            usageHistory = Array(usageHistory.suffix(5000))
        }
    }
    
    // MARK: - Predictions
    
    /// Predict next likely action
    public func predictNextAction(after actionId: String) -> PredictedAction? {
        guard let cooccurrences = cooccurrenceMap[actionId] else { return nil }
        guard let (nextId, count) = cooccurrences.max(by: { $0.value < $1.value }) else { return nil }
        guard let entry = actionIndex[nextId] else { return nil }
        
        let total = cooccurrences.values.reduce(0, +)
        let probability = Double(count) / Double(total)
        
        return PredictedAction(
            id: nextId,
            name: entry.name,
            probability: probability
        )
    }
    
    /// Predict workflow completion time
    public func predictWorkflowDuration(workflowId: String) -> TimeInterval? {
        // Simplified - would use actual timing data in production
        guard let workflow = workflowIndex[workflowId] else { return nil }
        return TimeInterval(workflow.steps.count * 5) // 5 seconds per step estimate
    }
    
    // MARK: - Explanations
    
    /// Explain why an action was recommended
    public func explainRecommendation(_ recommendation: RecommendedAction) -> String {
        switch recommendation.reason {
        case .frequent:
            return "You use '\(recommendation.name)' frequently"
        case .cooccurrence:
            return "Users often do '\(recommendation.name)' after similar actions"
        case .contextual:
            return "'\(recommendation.name)' matches your current context"
        case .similar:
            return "'\(recommendation.name)' is similar to what you're working on"
        }
    }
    
    /// Explain a workflow
    public func explainWorkflow(workflowId: String) -> WorkflowExplanation? {
        guard let workflow = workflowIndex[workflowId] else { return nil }
        
        let stepExplanations = workflow.steps.compactMap { stepId -> StepExplanation? in
            guard let action = actionIndex[stepId] else { return nil }
            return StepExplanation(
                action: action.name,
                description: action.description,
                inputTypes: action.inputTypes,
                outputType: action.outputType
            )
        }
        
        return WorkflowExplanation(
            name: workflow.name,
            description: workflow.description,
            steps: stepExplanations,
            estimatedDuration: TimeInterval(workflow.steps.count * 5)
        )
    }
    
    // MARK: - Helpers
    
    private func extractKeywords(from contract: PackageContract) -> [String] {
        var keywords: [String] = []
        keywords.append(contract.manifest.name.lowercased())
        keywords.append(contract.manifest.category.rawValue)
        keywords.append(contentsOf: contract.capabilities.actions)
        keywords.append(contentsOf: contract.capabilities.commands)
        return keywords
    }
    
    private func generateEmbedding(for text: String) async -> [Float] {
        // Simplified embedding - in production use actual ML model
        // This creates a simple bag-of-words style embedding
        let words = text.lowercased().split(separator: " ").map(String.init)
        var embedding = [Float](repeating: 0, count: 128)
        
        for (i, word) in words.enumerated() {
            let hash = abs(word.hashValue)
            let index = hash % 128
            embedding[index] += 1.0 / Float(words.count)
        }
        
        // Normalize
        let magnitude = sqrt(embedding.reduce(0) { $0 + $1 * $1 })
        if magnitude > 0 {
            embedding = embedding.map { $0 / magnitude }
        }
        
        return embedding
    }
    
    private func cosineSimilarity(_ a: [Float], _ b: [Float]) -> Float {
        guard a.count == b.count else { return 0 }
        let dot = zip(a, b).reduce(0) { $0 + $1.0 * $1.1 }
        let magA = sqrt(a.reduce(0) { $0 + $1 * $1 })
        let magB = sqrt(b.reduce(0) { $0 + $1 * $1 })
        guard magA > 0 && magB > 0 else { return 0 }
        return dot / (magA * magB)
    }
    
    private func getEmbedding(for id: String, type: SearchResultType) -> [Float]? {
        switch type {
        case .package: return packageIndex[id]?.embedding
        case .action: return actionIndex[id]?.embedding
        case .workflow: return workflowIndex[id]?.embedding
        case .agent: return agentIndex[id]?.embedding
        case .command: return commandIndex[id]?.embedding
        }
    }
}

// MARK: - ML Entry Types

protocol MLEntry {
    var embedding: [Float] { get }
    var name: String { get }
    var entryDescription: String { get }
}

struct PackageMLEntry: MLEntry {
    let id: String
    let name: String
    let description: String
    let category: String
    let keywords: [String]
    let capabilities: [String]
    let embedding: [Float]
    var entryDescription: String { description }
}

struct ActionMLEntry: MLEntry {
    let id: String
    let packageId: String
    let name: String
    let description: String
    let category: String
    let inputTypes: [String]
    let outputType: String
    let embedding: [Float]
    var entryDescription: String { description }
}

struct CommandMLEntry: MLEntry {
    let id: String
    let packageId: String
    let syntax: String
    let description: String
    let embedding: [Float]
    var name: String { syntax }
    var entryDescription: String { description }
}

struct WorkflowMLEntry: MLEntry {
    let id: String
    let packageId: String
    let name: String
    let description: String
    let steps: [String]
    let embedding: [Float]
    var entryDescription: String { description }
}

struct AgentMLEntry: MLEntry {
    let id: String
    let packageId: String
    let name: String
    let description: String
    let triggers: [String]
    let actions: [String]
    let embedding: [Float]
    var entryDescription: String { description }
}

// MARK: - Result Types

public struct SearchResult: Identifiable, Sendable {
    public let id: String
    public let type: SearchResultType
    public let name: String
    public let description: String
    public let score: Float
}

public enum SearchResultType: Sendable {
    case package, action, workflow, agent, command
}

public struct RecommendedAction: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let reason: RecommendationReason
    public let confidence: Double
}

public enum RecommendationReason: Sendable {
    case frequent, cooccurrence, contextual, similar
}

public struct RecommendedWorkflow: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let steps: [String]
    public let confidence: Double
}

public struct PredictedAction: Sendable {
    public let id: String
    public let name: String
    public let probability: Double
}

public struct WorkflowExplanation: Sendable {
    public let name: String
    public let description: String
    public let steps: [StepExplanation]
    public let estimatedDuration: TimeInterval
}

public struct StepExplanation: Sendable {
    public let action: String
    public let description: String
    public let inputTypes: [String]
    public let outputType: String
}

// MARK: - Context & Events

/// Indexer-specific context for ML recommendations
public struct MLIndexerContext: Sendable {
    public let lastAction: String?
    public let contextDescription: String?
    public let currentPackage: String?
    public let currentView: String?
    
    public init(lastAction: String? = nil, contextDescription: String? = nil, currentPackage: String? = nil, currentView: String? = nil) {
        self.lastAction = lastAction
        self.contextDescription = contextDescription
        self.currentPackage = currentPackage
        self.currentView = currentView
    }
}

public struct UsageEvent: Sendable {
    public let actionId: String
    public let packageId: String
    public let timestamp: Date
    public let context: String?
    
    public init(actionId: String, packageId: String, timestamp: Date = Date(), context: String? = nil) {
        self.actionId = actionId
        self.packageId = packageId
        self.timestamp = timestamp
        self.context = context
    }
}
