//
//  MemoryModels.swift
//  AIKit - Memory Engine Models
//

import Foundation

// MARK: - Project Memory

public struct ProjectMemory: Sendable {
    public let projectId: String
    public var entries: [MemoryEntry]
    
    public init(projectId: String, entries: [MemoryEntry] = []) {
        self.projectId = projectId
        self.entries = entries
    }
}

public struct MemoryEntry: Sendable {
    public let id: String
    public let content: MemoryContent
    public let semantics: SemanticInfo
    public let importance: Float
    public let createdAt: Date
    public var lastAccessed: Date
    public var accessCount: Int
    public var decayFactor: Float
}

public struct MemoryContent: Sendable {
    public let type: MemoryContentType
    public let summary: String
    public let details: String
    public let references: [String]
    
    public init(type: MemoryContentType, summary: String, details: String = "", references: [String] = []) {
        self.type = type
        self.summary = summary
        self.details = details
        self.references = references
    }
}

public enum MemoryContentType: String, Sendable {
    case decision, architecture, requirement, codeReference, note
}

public struct SemanticInfo: Sendable {
    public let keywords: [String]
    public let topics: [String]
    public let sentiment: Float
}

public struct RecalledMemory: Sendable {
    public let entry: MemoryEntry
    public let relevanceScore: Float
}

// MARK: - Context Compression

public struct ContextInput: Sendable {
    public let id: String
    public let content: String
    public let metadata: [String: String]
    
    public init(id: String, content: String, metadata: [String: String] = [:]) {
        self.id = id
        self.content = content
        self.metadata = metadata
    }
}

public struct CompressedContext: Sendable {
    public let id: String
    public let originalLength: Int
    public let compressedLength: Int
    public let compressionRatio: Float
    public let summary: String
    public let keyPoints: [String]
    public let decisions: [String]
    public let actionItems: [String]
    public let entities: [String]
    public let timestamp: Date
    public let processingTime: TimeInterval
}

// MARK: - Knowledge Decay

public struct DecayPrediction: Sendable {
    public let projectId: String
    public let atRiskEntries: [DecayRiskEntry]
    public let recommendations: [String]
}

public struct DecayRiskEntry: Sendable {
    public let entryId: String
    public let content: String
    public let decayRisk: Float
    public let daysSinceAccessed: Int
    public let recommendation: String
}

// MARK: - Doc-Code Alignment

public struct DocumentInfo: Sendable {
    public let path: String
    public let content: String
    public let lastModified: Date
    
    public init(path: String, content: String, lastModified: Date = Date()) {
        self.path = path
        self.content = content
        self.lastModified = lastModified
    }
}

public struct CodeInfo: Sendable {
    public let path: String
    public let content: String
    public let lastModified: Date
    
    public init(path: String, content: String, lastModified: Date = Date()) {
        self.path = path
        self.content = content
        self.lastModified = lastModified
    }
}

public struct AlignmentAnalysis: Sendable {
    public let docPath: String
    public let codePath: String
    public let alignmentScore: Float
    public let driftLevel: DriftLevel
    public let missingInDoc: [String]
    public let extraInDoc: [String]
    public let suggestions: [String]
    public let processingTime: TimeInterval
}

public enum DriftLevel: String, Sendable {
    case none, minor, moderate, severe
}

// MARK: - Change Significance

public struct ChangeInput: Sendable {
    public let id: String
    public let description: String
    public let additions: Int
    public let deletions: Int
    public let files: [String]
    
    public init(id: String, description: String, additions: Int, deletions: Int, files: [String] = []) {
        self.id = id
        self.description = description
        self.additions = additions
        self.deletions = deletions
        self.files = files
    }
}

public struct ChangeSignificance: Sendable {
    public let changeId: String
    public let significanceScore: Float
    public let category: ChangeCategory
    public let isSignificant: Bool
    public let reasoning: String
    public let recommendations: [String]
    public let processingTime: TimeInterval
}

public enum ChangeCategory: String, Sendable {
    case breaking, structural, feature, refactoring, trivial
}

struct ChangeEvent {
    let change: ChangeInput
    let significance: Float
    let timestamp: Date
}

// MARK: - Cross-Domain Insights

public struct CrossDomainInsight: Sendable {
    public let pattern: String
    public let foundInProjects: [String]
    public let applicability: Float
    public let recommendation: String
}

struct CommonPattern {
    let description: String
    let projectIds: [String]
    let applicability: Float
}

// MARK: - Knowledge Graph

struct KnowledgeGraph {
    var nodes: [String: KnowledgeNode] = [:]
    var edges: [KnowledgeEdge] = []
    
    mutating func addNode(_ node: KnowledgeNode) {
        nodes[node.id] = node
    }
    
    mutating func addEdge(from: String, to: String, weight: Float) {
        edges.append(KnowledgeEdge(from: from, to: to, weight: weight))
    }
}

struct KnowledgeNode {
    let id: String
    let type: KnowledgeNodeType
    let projectId: String
}

enum KnowledgeNodeType {
    case concept, entity, decision, file
}

struct KnowledgeEdge {
    let from: String
    let to: String
    let weight: Float
}

// MARK: - Execution Log

struct MemoryExecution {
    let type: MemoryExecutionType
    let timestamp: Date
}

enum MemoryExecutionType {
    case store, recall, compress, decay, alignment, significance
}

// MARK: - Stats

public struct MemoryStats: Sendable {
    public let projectCount: Int
    public let totalEntries: Int
    public let compressionCacheSize: Int
    public let changeHistorySize: Int
}
