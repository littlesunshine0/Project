//
//  ArtifactGraph.swift
//  IdeaKit - Project Operating System
//
//  The Shared Artifact Graph - packages communicate through artifacts, not directly
//  This enables loose coupling, easy reordering, and safe experimentation
//

import Foundation

/// The shared artifact graph that all packages communicate through
/// Packages don't talk to each other directly - they read/write artifacts
public actor ArtifactGraph {
    
    // MARK: - Singleton
    
    public static let shared = ArtifactGraph()
    
    // MARK: - State
    
    private var artifacts: [String: ArtifactNode] = [:]
    private var dependencies: [String: Set<String>] = [:]
    private var history: [ArtifactEvent] = []
    
    private init() {}
    
    // MARK: - Artifact Management
    
    /// Register an artifact in the graph
    public func register<T: Artifact>(_ artifact: T, producedBy packageId: String) {
        let node = ArtifactNode(
            id: artifact.artifactId,
            type: String(describing: T.self),
            producedBy: packageId,
            timestamp: Date(),
            data: artifact
        )
        
        artifacts[artifact.artifactId] = node
        
        // Record event
        history.append(ArtifactEvent(
            type: .created,
            artifactId: artifact.artifactId,
            packageId: packageId,
            timestamp: Date()
        ))
    }
    
    /// Retrieve an artifact by ID
    public func get<T: Artifact>(_ id: String, as type: T.Type) -> T? {
        guard let node = artifacts[id] else { return nil }
        return node.data as? T
    }
    
    /// Retrieve an artifact by type (returns first match)
    public func get<T: Artifact>(ofType type: T.Type) -> T? {
        for node in artifacts.values {
            if let artifact = node.data as? T {
                return artifact
            }
        }
        return nil
    }
    
    /// Get all artifacts of a specific type
    public func getAll<T: Artifact>(ofType type: T.Type) -> [T] {
        artifacts.values.compactMap { $0.data as? T }
    }
    
    /// Check if an artifact exists
    public func exists(_ id: String) -> Bool {
        artifacts[id] != nil
    }
    
    /// Declare a dependency between artifacts
    public func declareDependency(from: String, to: String) {
        if dependencies[from] == nil {
            dependencies[from] = []
        }
        dependencies[from]?.insert(to)
    }
    
    /// Get dependencies for an artifact
    public func getDependencies(for id: String) -> Set<String> {
        dependencies[id] ?? []
    }
    
    /// Get all artifact IDs
    public func allArtifactIds() -> [String] {
        Array(artifacts.keys)
    }
    
    /// Get artifact metadata
    public func metadata(for id: String) -> ArtifactMetadata? {
        guard let node = artifacts[id] else { return nil }
        return ArtifactMetadata(
            id: node.id,
            type: node.type,
            producedBy: node.producedBy,
            timestamp: node.timestamp
        )
    }
    
    /// Clear all artifacts (for testing or reset)
    public func clear() {
        artifacts.removeAll()
        dependencies.removeAll()
        history.removeAll()
    }
    
    /// Get execution history
    public func getHistory() -> [ArtifactEvent] {
        history
    }
    
    // MARK: - Graph Visualization
    
    /// Generate a DOT graph representation
    public func toDOT() -> String {
        var dot = "digraph ArtifactGraph {\n"
        dot += "  rankdir=TB;\n"
        dot += "  node [shape=box];\n\n"
        
        // Nodes
        for (id, node) in artifacts {
            dot += "  \"\(id)\" [label=\"\(node.type)\\n\(id)\"];\n"
        }
        
        dot += "\n"
        
        // Edges
        for (from, tos) in dependencies {
            for to in tos {
                dot += "  \"\(from)\" -> \"\(to)\";\n"
            }
        }
        
        dot += "}\n"
        return dot
    }
    
    /// Generate markdown summary
    public func toMarkdown() -> String {
        var md = "# Artifact Graph\n\n"
        
        md += "## Artifacts (\(artifacts.count))\n\n"
        md += "| ID | Type | Produced By | Timestamp |\n"
        md += "|----|----|-------------|----------|\n"
        
        for (id, node) in artifacts.sorted(by: { $0.value.timestamp < $1.value.timestamp }) {
            let dateStr = ISO8601DateFormatter().string(from: node.timestamp)
            md += "| \(id) | \(node.type) | \(node.producedBy) | \(dateStr) |\n"
        }
        
        md += "\n## Dependencies\n\n"
        
        if dependencies.isEmpty {
            md += "_No dependencies declared_\n"
        } else {
            for (from, tos) in dependencies {
                md += "- **\(from)** depends on:\n"
                for to in tos {
                    md += "  - \(to)\n"
                }
            }
        }
        
        return md
    }
}

// MARK: - Supporting Types

/// A node in the artifact graph
struct ArtifactNode {
    let id: String
    let type: String
    let producedBy: String
    let timestamp: Date
    let data: Any
}

/// Metadata about an artifact
public struct ArtifactMetadata: Sendable {
    public let id: String
    public let type: String
    public let producedBy: String
    public let timestamp: Date
}

/// Event in artifact history
public struct ArtifactEvent: Sendable {
    public let type: ArtifactEventType
    public let artifactId: String
    public let packageId: String
    public let timestamp: Date
}

public enum ArtifactEventType: String, Sendable {
    case created
    case updated
    case consumed
    case invalidated
}
