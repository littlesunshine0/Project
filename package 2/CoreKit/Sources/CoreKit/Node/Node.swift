//
//  Node.swift
//  CoreKit - The Core Data Model
//
//  Everything is a Node with Extensions.
//  This is the unifying abstraction that prevents chaos.
//

import Foundation

// MARK: - Node

/// The fundamental unit of the Project Operating System.
/// Everything (files, scripts, agents, workflows, assets) is a Node.
public struct Node: Identifiable, Codable, Sendable {
    public let id: String
    public let type: NodeType
    public var path: String
    public var name: String
    public var extensions: [NodeExtension]
    public var relationships: [NodeRelationship]
    public var representations: NodeRepresentations
    public var metadata: NodeMetadata
    public var capabilities: Set<NodeCapability>
    public let createdAt: Date
    public var modifiedAt: Date
    
    public init(
        id: String = UUID().uuidString,
        type: NodeType,
        path: String,
        name: String,
        extensions: [NodeExtension] = [],
        relationships: [NodeRelationship] = [],
        representations: NodeRepresentations = NodeRepresentations(),
        metadata: NodeMetadata = NodeMetadata(),
        capabilities: Set<NodeCapability> = [],
        createdAt: Date = Date(),
        modifiedAt: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.path = path
        self.name = name
        self.extensions = extensions
        self.relationships = relationships
        self.representations = representations
        self.metadata = metadata
        self.capabilities = capabilities
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
}

// MARK: - Node Type

/// The semantic type of a Node
public enum NodeType: String, Codable, Sendable, CaseIterable {
    // Project Structure
    case project
    case package
    case module
    case directory
    
    // Code
    case sourceFile
    case component
    case view
    case model
    case service
    case test
    
    // Automation
    case script
    case command
    case workflow
    case agent
    case task
    
    // Assets
    case asset
    case image
    case icon
    case data
    case config
    
    // Documentation
    case document
    case readme
    case spec
    case changelog
    
    // Unknown / Extensible
    case unknown
    case custom
}

// MARK: - Node Extension

/// Extensions add capabilities to Nodes
public struct NodeExtension: Identifiable, Codable, Sendable {
    public let id: String
    public let type: ExtensionType
    public var config: [String: String]
    public var isEnabled: Bool
    
    public init(
        id: String = UUID().uuidString,
        type: ExtensionType,
        config: [String: String] = [:],
        isEnabled: Bool = true
    ) {
        self.id = id
        self.type = type
        self.config = config
        self.isEnabled = isEnabled
    }
}

public enum ExtensionType: String, Codable, Sendable, CaseIterable {
    // Parsing & Syntax
    case syntax          // Syntax highlighting, AST
    case parser          // Custom parser
    
    // Preview & Rendering
    case preview         // Live preview capability
    case renderer        // Custom renderer
    
    // Execution
    case runtime         // Can be executed
    case sandbox         // Sandboxed execution
    
    // Intelligence
    case ml              // ML embeddings, analysis
    case explanation     // AI explanation
    case suggestion      // AI suggestions
    
    // Metadata
    case metadata        // Extended metadata
    case tags            // Tagging system
    case versioning      // Version tracking
    
    // Integration
    case sync            // External sync
    case webhook         // Webhook triggers
}

// MARK: - Node Relationship

/// Relationships connect Nodes in a semantic graph
public struct NodeRelationship: Identifiable, Codable, Sendable {
    public let id: String
    public let type: RelationshipType
    public let targetId: String
    public var metadata: [String: String]
    
    public init(
        id: String = UUID().uuidString,
        type: RelationshipType,
        targetId: String,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.type = type
        self.targetId = targetId
        self.metadata = metadata
    }
}

public enum RelationshipType: String, Codable, Sendable, CaseIterable {
    // Structural
    case contains        // Parent contains child
    case belongsTo       // Child belongs to parent
    
    // Dependencies
    case dependsOn       // A depends on B
    case imports         // A imports B
    case uses            // A uses B
    
    // Execution
    case executes        // A executes B
    case triggers        // A triggers B
    case produces        // A produces B
    
    // Rendering
    case renders         // A renders B
    case previews        // A previews B
    
    // Ownership
    case owns            // A owns B
    case manages         // A manages B
    
    // Reference
    case references      // A references B
    case documents       // A documents B
    case tests           // A tests B
}

// MARK: - Node Representations

/// Multiple representations of the same Node
public struct NodeRepresentations: Codable, Sendable {
    public var raw: RawRepresentation?
    public var parsed: ParsedRepresentation?
    public var indexed: IndexedRepresentation?
    public var humanReadable: HumanReadableRepresentation?
    public var mlEmbeddings: MLEmbeddingsRepresentation?
    
    public init(
        raw: RawRepresentation? = nil,
        parsed: ParsedRepresentation? = nil,
        indexed: IndexedRepresentation? = nil,
        humanReadable: HumanReadableRepresentation? = nil,
        mlEmbeddings: MLEmbeddingsRepresentation? = nil
    ) {
        self.raw = raw
        self.parsed = parsed
        self.indexed = indexed
        self.humanReadable = humanReadable
        self.mlEmbeddings = mlEmbeddings
    }
}

public struct RawRepresentation: Codable, Sendable {
    public let content: Data
    public let encoding: String
    public let mimeType: String
    public let size: Int
    public let hash: String
    
    public init(content: Data, encoding: String = "utf-8", mimeType: String = "text/plain", hash: String = "") {
        self.content = content
        self.encoding = encoding
        self.mimeType = mimeType
        self.size = content.count
        self.hash = hash
    }
}

public struct ParsedRepresentation: Codable, Sendable {
    public let structure: String  // JSON-encoded AST or structure
    public let symbols: [String]
    public let imports: [String]
    public let exports: [String]
    public let language: String?
    
    public init(structure: String = "{}", symbols: [String] = [], imports: [String] = [], exports: [String] = [], language: String? = nil) {
        self.structure = structure
        self.symbols = symbols
        self.imports = imports
        self.exports = exports
        self.language = language
    }
}

public struct IndexedRepresentation: Codable, Sendable {
    public let keywords: [String]
    public let topics: [String]
    public let searchableText: String
    public let lastIndexed: Date
    
    public init(keywords: [String] = [], topics: [String] = [], searchableText: String = "", lastIndexed: Date = Date()) {
        self.keywords = keywords
        self.topics = topics
        self.searchableText = searchableText
        self.lastIndexed = lastIndexed
    }
}

public struct HumanReadableRepresentation: Codable, Sendable {
    public let summary: String
    public let description: String
    public let explanation: String?
    public let documentation: String?
    
    public init(summary: String = "", description: String = "", explanation: String? = nil, documentation: String? = nil) {
        self.summary = summary
        self.description = description
        self.explanation = explanation
        self.documentation = documentation
    }
}

public struct MLEmbeddingsRepresentation: Codable, Sendable {
    public let vector: [Float]
    public let model: String
    public let generatedAt: Date
    
    public init(vector: [Float] = [], model: String = "local", generatedAt: Date = Date()) {
        self.vector = vector
        self.model = model
        self.generatedAt = generatedAt
    }
}

// MARK: - Node Metadata

/// Extended metadata for a Node
public struct NodeMetadata: Codable, Sendable {
    public var tags: [String]
    public var labels: [String: String]
    public var annotations: [String: String]
    public var version: String?
    public var author: String?
    public var license: String?
    public var custom: [String: String]
    
    public init(
        tags: [String] = [],
        labels: [String: String] = [:],
        annotations: [String: String] = [:],
        version: String? = nil,
        author: String? = nil,
        license: String? = nil,
        custom: [String: String] = [:]
    ) {
        self.tags = tags
        self.labels = labels
        self.annotations = annotations
        self.version = version
        self.author = author
        self.license = license
        self.custom = custom
    }
}

// MARK: - Node Capability

/// What a Node can do
public enum NodeCapability: String, Codable, Sendable, CaseIterable {
    // View
    case viewable        // Can be viewed
    case previewable     // Has live preview
    case renderable      // Can be rendered
    
    // Edit
    case editable        // Can be edited
    case refactorable    // Can be refactored
    case convertible     // Can be converted to other formats
    
    // Execute
    case executable      // Can be executed
    case testable        // Can be tested
    case debuggable      // Can be debugged
    
    // AI
    case explainable     // AI can explain it
    case suggestible     // AI can suggest improvements
    case generatable     // AI can generate similar
    
    // Index
    case indexable       // Can be indexed
    case searchable      // Can be searched
    case embeddable      // Can generate embeddings
    
    // Sync
    case syncable        // Can be synced
    case versionable     // Can be versioned
    case exportable      // Can be exported
}
