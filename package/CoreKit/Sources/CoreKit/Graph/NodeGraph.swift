//
//  NodeGraph.swift
//  CoreKit - Semantic Graph
//
//  The directory becomes a semantic graph, not a tree.
//  Layered with meaning, relationships, and AI context.
//

import Foundation

// MARK: - Node Graph

/// The semantic graph of all Nodes in a project
public actor NodeGraph {
    public static let shared = NodeGraph()
    
    private var nodes: [String: Node] = [:]
    private var pathIndex: [String: String] = [:]  // path -> nodeId
    private var typeIndex: [NodeType: Set<String>] = [:]  // type -> nodeIds
    private var relationshipIndex: [String: [NodeRelationship]] = [:]  // nodeId -> relationships
    private var reverseRelationshipIndex: [String: [String]] = [:]  // targetId -> sourceNodeIds
    
    private init() {}
    
    // MARK: - Node Operations
    
    /// Add a node to the graph
    public func add(_ node: Node) {
        nodes[node.id] = node
        pathIndex[node.path] = node.id
        typeIndex[node.type, default: []].insert(node.id)
        
        // Index relationships
        for relationship in node.relationships {
            relationshipIndex[node.id, default: []].append(relationship)
            reverseRelationshipIndex[relationship.targetId, default: []].append(node.id)
        }
    }
    
    /// Get a node by ID
    public func get(_ id: String) -> Node? {
        nodes[id]
    }
    
    /// Get a node by path
    public func getByPath(_ path: String) -> Node? {
        guard let id = pathIndex[path] else { return nil }
        return nodes[id]
    }
    
    /// Update a node
    public func update(_ node: Node) {
        // Remove old indexes
        if let existing = nodes[node.id] {
            pathIndex.removeValue(forKey: existing.path)
            typeIndex[existing.type]?.remove(node.id)
            relationshipIndex.removeValue(forKey: node.id)
            for rel in existing.relationships {
                reverseRelationshipIndex[rel.targetId]?.removeAll { $0 == node.id }
            }
        }
        
        // Add with new indexes
        add(node)
    }
    
    /// Remove a node
    public func remove(_ id: String) {
        guard let node = nodes[id] else { return }
        
        nodes.removeValue(forKey: id)
        pathIndex.removeValue(forKey: node.path)
        typeIndex[node.type]?.remove(id)
        relationshipIndex.removeValue(forKey: id)
        
        for rel in node.relationships {
            reverseRelationshipIndex[rel.targetId]?.removeAll { $0 == id }
        }
    }
    
    /// Get all nodes
    public func all() -> [Node] {
        Array(nodes.values)
    }
    
    // MARK: - Query Operations
    
    /// Get nodes by type
    public func byType(_ type: NodeType) -> [Node] {
        guard let ids = typeIndex[type] else { return [] }
        return ids.compactMap { nodes[$0] }
    }
    
    /// Get nodes by capability
    public func byCapability(_ capability: NodeCapability) -> [Node] {
        nodes.values.filter { $0.capabilities.contains(capability) }
    }
    
    /// Get children of a node (nodes that belong to it)
    public func children(of nodeId: String) -> [Node] {
        guard let relationships = relationshipIndex[nodeId] else { return [] }
        return relationships
            .filter { $0.type == .contains }
            .compactMap { nodes[$0.targetId] }
    }
    
    /// Get parent of a node
    public func parent(of nodeId: String) -> Node? {
        guard let parentIds = reverseRelationshipIndex[nodeId] else { return nil }
        for parentId in parentIds {
            if let parent = nodes[parentId],
               parent.relationships.contains(where: { $0.targetId == nodeId && $0.type == .contains }) {
                return parent
            }
        }
        return nil
    }
    
    /// Get dependencies of a node
    public func dependencies(of nodeId: String) -> [Node] {
        guard let relationships = relationshipIndex[nodeId] else { return [] }
        return relationships
            .filter { $0.type == .dependsOn || $0.type == .imports || $0.type == .uses }
            .compactMap { nodes[$0.targetId] }
    }
    
    /// Get dependents of a node (nodes that depend on it)
    public func dependents(of nodeId: String) -> [Node] {
        guard let sourceIds = reverseRelationshipIndex[nodeId] else { return [] }
        return sourceIds.compactMap { sourceId in
            guard let source = nodes[sourceId] else { return nil }
            let hasDependency = source.relationships.contains {
                $0.targetId == nodeId && ($0.type == .dependsOn || $0.type == .imports || $0.type == .uses)
            }
            return hasDependency ? source : nil
        }
    }
    
    /// Get related nodes
    public func related(to nodeId: String, by type: RelationshipType? = nil) -> [Node] {
        guard let relationships = relationshipIndex[nodeId] else { return [] }
        let filtered = type == nil ? relationships : relationships.filter { $0.type == type }
        return filtered.compactMap { nodes[$0.targetId] }
    }
    
    /// Search nodes by text
    public func search(query: String) -> [Node] {
        let lowercased = query.lowercased()
        return nodes.values.filter { node in
            node.name.lowercased().contains(lowercased) ||
            node.path.lowercased().contains(lowercased) ||
            node.metadata.tags.contains { $0.lowercased().contains(lowercased) } ||
            (node.representations.indexed?.searchableText.lowercased().contains(lowercased) ?? false)
        }
    }
    
    /// Find similar nodes by embeddings
    public func findSimilar(to nodeId: String, limit: Int = 10) -> [(node: Node, similarity: Float)] {
        guard let node = nodes[nodeId],
              let embeddings = node.representations.mlEmbeddings else { return [] }
        
        var results: [(Node, Float)] = []
        
        for other in nodes.values where other.id != nodeId {
            guard let otherEmbeddings = other.representations.mlEmbeddings else { continue }
            let similarity = cosineSimilarity(embeddings.vector, otherEmbeddings.vector)
            results.append((other, similarity))
        }
        
        return results.sorted { $0.1 > $1.1 }.prefix(limit).map { ($0.0, $0.1) }
    }
    
    // MARK: - Graph Analysis
    
    /// Get the full path from root to a node
    public func pathToRoot(from nodeId: String) -> [Node] {
        var path: [Node] = []
        var currentId: String? = nodeId
        
        while let id = currentId, let node = nodes[id] {
            path.append(node)
            currentId = parent(of: id)?.id
        }
        
        return path.reversed()
    }
    
    /// Get all nodes in a subtree
    public func subtree(from nodeId: String) -> [Node] {
        var result: [Node] = []
        var queue: [String] = [nodeId]
        
        while !queue.isEmpty {
            let currentId = queue.removeFirst()
            if let node = nodes[currentId] {
                result.append(node)
                let childIds = children(of: currentId).map { $0.id }
                queue.append(contentsOf: childIds)
            }
        }
        
        return result
    }
    
    /// Detect cycles in relationships
    public func detectCycles() -> [[String]] {
        var cycles: [[String]] = []
        var visited: Set<String> = []
        var recursionStack: Set<String> = []
        var path: [String] = []
        
        func dfs(_ nodeId: String) {
            visited.insert(nodeId)
            recursionStack.insert(nodeId)
            path.append(nodeId)
            
            if let relationships = relationshipIndex[nodeId] {
                for rel in relationships where rel.type == .dependsOn {
                    if !visited.contains(rel.targetId) {
                        dfs(rel.targetId)
                    } else if recursionStack.contains(rel.targetId) {
                        // Found cycle
                        if let startIndex = path.firstIndex(of: rel.targetId) {
                            cycles.append(Array(path[startIndex...]))
                        }
                    }
                }
            }
            
            path.removeLast()
            recursionStack.remove(nodeId)
        }
        
        for nodeId in nodes.keys where !visited.contains(nodeId) {
            dfs(nodeId)
        }
        
        return cycles
    }
    
    // MARK: - Stats
    
    public var stats: GraphStats {
        var relationshipCount = 0
        for rels in relationshipIndex.values {
            relationshipCount += rels.count
        }
        
        return GraphStats(
            nodeCount: nodes.count,
            relationshipCount: relationshipCount,
            typeDistribution: typeIndex.mapValues { $0.count }
        )
    }
    
    // MARK: - Private Helpers
    
    private func cosineSimilarity(_ a: [Float], _ b: [Float]) -> Float {
        guard a.count == b.count, !a.isEmpty else { return 0 }
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

// MARK: - Graph Stats

public struct GraphStats: Sendable {
    public let nodeCount: Int
    public let relationshipCount: Int
    public let typeDistribution: [NodeType: Int]
}
