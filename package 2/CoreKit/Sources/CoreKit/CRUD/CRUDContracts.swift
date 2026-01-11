//
//  CRUDContracts.swift
//  CoreKit - CRUD at Multiple Layers
//
//  CRUD happens at multiple layers, not just files:
//  - File: Create/delete/edit file
//  - Node: Create logical entity
//  - Metadata: Change meaning without touching file
//  - Representation: Generate/regenerate views
//  - Relationships: Link nodes together
//  - Capabilities: Attach preview, runtime, ML tools
//

import Foundation

// MARK: - CRUD Layer

/// The layer at which CRUD operations occur
public enum CRUDLayer: String, Sendable, CaseIterable {
    case file           // Raw file operations
    case node           // Logical entity operations
    case metadata       // Metadata-only changes
    case representation // View/representation changes
    case relationship   // Link/unlink operations
    case capability     // Capability attachment
}

// MARK: - CRUD Operation

/// A CRUD operation with full context
public struct CRUDOperation: Identifiable, Sendable {
    public let id: String
    public let type: CRUDType
    public let layer: CRUDLayer
    public let nodeId: String?
    public let path: String?
    public let payload: CRUDPayload
    public let timestamp: Date
    public let source: CRUDSource
    
    public init(
        id: String = UUID().uuidString,
        type: CRUDType,
        layer: CRUDLayer,
        nodeId: String? = nil,
        path: String? = nil,
        payload: CRUDPayload,
        timestamp: Date = Date(),
        source: CRUDSource = .user
    ) {
        self.id = id
        self.type = type
        self.layer = layer
        self.nodeId = nodeId
        self.path = path
        self.payload = payload
        self.timestamp = timestamp
        self.source = source
    }
}

public enum CRUDType: String, Sendable {
    case create
    case read
    case update
    case delete
}

public enum CRUDSource: String, Sendable {
    case user           // User initiated
    case chat           // Chat command
    case agent          // Agent action
    case workflow       // Workflow step
    case system         // System event
    case sync           // External sync
}

// MARK: - CRUD Payload

/// The data for a CRUD operation
public enum CRUDPayload: Sendable {
    // File layer
    case fileContent(Data)
    case filePath(String)
    
    // Node layer
    case node(Node)
    case nodeType(NodeType)
    
    // Metadata layer
    case metadata(NodeMetadata)
    case tags([String])
    case labels([String: String])
    
    // Representation layer
    case representation(RepresentationType, String)
    case regenerate(RepresentationType)
    
    // Relationship layer
    case relationship(NodeRelationship)
    case link(String, RelationshipType)
    case unlink(String)
    
    // Capability layer
    case capability(NodeCapability)
    case extension_(NodeExtension)
    
    // Batch
    case batch([CRUDPayload])
    
    // Empty (for reads/deletes)
    case empty
}

public enum RepresentationType: String, Sendable {
    case raw, parsed, indexed, humanReadable, mlEmbeddings
}

// MARK: - CRUD Result

/// The result of a CRUD operation
public struct CRUDResult: Sendable {
    public let success: Bool
    public let operation: CRUDOperation
    public let affectedNodes: [String]
    public let changes: [CRUDChange]
    public let error: CRUDError?
    public let duration: TimeInterval
    
    public init(
        success: Bool,
        operation: CRUDOperation,
        affectedNodes: [String] = [],
        changes: [CRUDChange] = [],
        error: CRUDError? = nil,
        duration: TimeInterval = 0
    ) {
        self.success = success
        self.operation = operation
        self.affectedNodes = affectedNodes
        self.changes = changes
        self.error = error
        self.duration = duration
    }
}

public struct CRUDChange: Sendable {
    public let nodeId: String
    public let field: String
    public let oldValue: String?
    public let newValue: String?
    
    public init(nodeId: String, field: String, oldValue: String? = nil, newValue: String? = nil) {
        self.nodeId = nodeId
        self.field = field
        self.oldValue = oldValue
        self.newValue = newValue
    }
}

public enum CRUDError: Error, Sendable {
    case nodeNotFound(String)
    case pathNotFound(String)
    case permissionDenied(String)
    case invalidOperation(String)
    case conflictDetected(String)
    case validationFailed(String)
    case systemError(String)
}

// MARK: - CRUD Protocol

/// Protocol for CRUD operations at any layer
public protocol CRUDProvider: Sendable {
    var supportedLayers: Set<CRUDLayer> { get }
    
    func create(_ operation: CRUDOperation) async throws -> CRUDResult
    func read(_ operation: CRUDOperation) async throws -> CRUDResult
    func update(_ operation: CRUDOperation) async throws -> CRUDResult
    func delete(_ operation: CRUDOperation) async throws -> CRUDResult
}

// MARK: - Multi-Layer CRUD

/// When you CRUD a script, you're actually CRUDing:
/// - the file
/// - the node
/// - its runtime
/// - its AI explanation
/// - its preview
/// - its dependencies
public struct MultiLayerCRUD: Sendable {
    public let primaryOperation: CRUDOperation
    public let cascadingOperations: [CRUDOperation]
    public let affectedLayers: Set<CRUDLayer>
    
    public init(
        primaryOperation: CRUDOperation,
        cascadingOperations: [CRUDOperation] = [],
        affectedLayers: Set<CRUDLayer> = []
    ) {
        self.primaryOperation = primaryOperation
        self.cascadingOperations = cascadingOperations
        self.affectedLayers = affectedLayers
    }
    
    /// Generate cascading operations for a file change
    public static func forFileChange(nodeId: String, path: String, content: Data) -> MultiLayerCRUD {
        let primary = CRUDOperation(
            type: .update,
            layer: .file,
            nodeId: nodeId,
            path: path,
            payload: .fileContent(content)
        )
        
        let cascading: [CRUDOperation] = [
            // Regenerate parsed representation
            CRUDOperation(type: .update, layer: .representation, nodeId: nodeId, payload: .regenerate(.parsed)),
            // Regenerate indexed representation
            CRUDOperation(type: .update, layer: .representation, nodeId: nodeId, payload: .regenerate(.indexed)),
            // Regenerate human readable
            CRUDOperation(type: .update, layer: .representation, nodeId: nodeId, payload: .regenerate(.humanReadable)),
            // Regenerate embeddings
            CRUDOperation(type: .update, layer: .representation, nodeId: nodeId, payload: .regenerate(.mlEmbeddings))
        ]
        
        return MultiLayerCRUD(
            primaryOperation: primary,
            cascadingOperations: cascading,
            affectedLayers: [.file, .representation]
        )
    }
    
    /// Generate cascading operations for creating a new node
    public static func forNodeCreation(node: Node, content: Data) -> MultiLayerCRUD {
        let primary = CRUDOperation(
            type: .create,
            layer: .node,
            nodeId: node.id,
            path: node.path,
            payload: .node(node)
        )
        
        var cascading: [CRUDOperation] = [
            // Create file
            CRUDOperation(type: .create, layer: .file, nodeId: node.id, path: node.path, payload: .fileContent(content))
        ]
        
        // Add capability-based operations
        if node.capabilities.contains(.indexable) {
            cascading.append(CRUDOperation(type: .create, layer: .representation, nodeId: node.id, payload: .regenerate(.indexed)))
        }
        if node.capabilities.contains(.explainable) {
            cascading.append(CRUDOperation(type: .create, layer: .representation, nodeId: node.id, payload: .regenerate(.humanReadable)))
        }
        if node.capabilities.contains(.embeddable) {
            cascading.append(CRUDOperation(type: .create, layer: .representation, nodeId: node.id, payload: .regenerate(.mlEmbeddings)))
        }
        
        return MultiLayerCRUD(
            primaryOperation: primary,
            cascadingOperations: cascading,
            affectedLayers: [.node, .file, .representation, .capability]
        )
    }
}

// MARK: - CRUD Event

/// Events emitted by CRUD operations for reactive systems
public struct CRUDEvent: Sendable {
    public let id: String
    public let operation: CRUDOperation
    public let result: CRUDResult
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, operation: CRUDOperation, result: CRUDResult, timestamp: Date = Date()) {
        self.id = id
        self.operation = operation
        self.result = result
        self.timestamp = timestamp
    }
}
