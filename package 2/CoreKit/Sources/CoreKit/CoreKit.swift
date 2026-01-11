//
//  CoreKit.swift
//  CoreKit - The Core Data Model for the Project Operating System
//
//  A local-first, AI-native project explorer that turns any directory
//  into a fully navigable, editable, explainable, and automatable system
//  — controlled entirely through chat.
//
//  This is not an IDE. It's an intelligence layer over the filesystem.
//

import Foundation

// MARK: - CoreKit

public struct CoreKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.corekit"
    
    /// One-sentence description
    public static let description = "A local-first, AI-native project explorer that turns any directory into a fully navigable, editable, explainable, and automatable system — controlled entirely through chat."
    
    public init() {}
    
    // MARK: - Quick Access
    
    /// The semantic graph of all nodes
    public static var graph: NodeGraph { NodeGraph.shared }
    
    /// The chat intent parser
    public static var chat: ChatIntentParser { ChatIntentParser.shared }
}

// MARK: - Node Factory

/// Factory for creating common node types
public struct NodeFactory {
    
    /// Create a project node
    public static func project(path: String, name: String) -> Node {
        Node(
            type: .project,
            path: path,
            name: name,
            capabilities: [.viewable, .indexable, .searchable, .explainable]
        )
    }
    
    /// Create a source file node
    public static func sourceFile(path: String, name: String, language: String) -> Node {
        var node = Node(
            type: .sourceFile,
            path: path,
            name: name,
            capabilities: [.viewable, .editable, .indexable, .searchable, .explainable, .refactorable]
        )
        node.metadata.labels["language"] = language
        return node
    }
    
    /// Create a view node (previewable)
    public static func view(path: String, name: String) -> Node {
        Node(
            type: .view,
            path: path,
            name: name,
            capabilities: [.viewable, .editable, .previewable, .indexable, .explainable, .refactorable]
        )
    }
    
    /// Create a script node (executable)
    public static func script(path: String, name: String) -> Node {
        Node(
            type: .script,
            path: path,
            name: name,
            capabilities: [.viewable, .editable, .executable, .explainable, .testable]
        )
    }
    
    /// Create a command node
    public static func command(path: String, name: String) -> Node {
        Node(
            type: .command,
            path: path,
            name: name,
            capabilities: [.viewable, .editable, .executable, .explainable]
        )
    }
    
    /// Create a workflow node
    public static func workflow(path: String, name: String) -> Node {
        Node(
            type: .workflow,
            path: path,
            name: name,
            capabilities: [.viewable, .editable, .executable, .explainable, .previewable]
        )
    }
    
    /// Create an agent node
    public static func agent(path: String, name: String) -> Node {
        Node(
            type: .agent,
            path: path,
            name: name,
            capabilities: [.viewable, .editable, .executable, .explainable]
        )
    }
    
    /// Create an asset node
    public static func asset(path: String, name: String, mimeType: String) -> Node {
        var node = Node(
            type: .asset,
            path: path,
            name: name,
            capabilities: [.viewable, .previewable, .indexable]
        )
        node.metadata.labels["mimeType"] = mimeType
        return node
    }
    
    /// Create a document node
    public static func document(path: String, name: String) -> Node {
        Node(
            type: .document,
            path: path,
            name: name,
            capabilities: [.viewable, .editable, .indexable, .searchable, .explainable, .previewable]
        )
    }
    
    /// Create a config node
    public static func config(path: String, name: String) -> Node {
        Node(
            type: .config,
            path: path,
            name: name,
            capabilities: [.viewable, .editable, .explainable]
        )
    }
    
    /// Create a directory node
    public static func directory(path: String, name: String) -> Node {
        Node(
            type: .directory,
            path: path,
            name: name,
            capabilities: [.viewable, .indexable]
        )
    }
    
    /// Detect node type from file extension
    public static func detectType(from path: String) -> NodeType {
        let ext = (path as NSString).pathExtension.lowercased()
        
        switch ext {
        // Source files
        case "swift", "m", "mm", "c", "cpp", "h", "hpp":
            return .sourceFile
        case "js", "ts", "jsx", "tsx":
            return .sourceFile
        case "py", "rb", "go", "rs", "java", "kt":
            return .sourceFile
            
        // Scripts
        case "sh", "bash", "zsh", "fish":
            return .script
            
        // Config
        case "json", "yaml", "yml", "toml", "xml", "plist":
            return .config
            
        // Documents
        case "md", "markdown", "txt", "rtf":
            return .document
            
        // Assets
        case "png", "jpg", "jpeg", "gif", "svg", "webp":
            return .image
        case "mp3", "wav", "aac", "m4a":
            return .asset
        case "mp4", "mov", "avi", "webm":
            return .asset
            
        // Data
        case "csv", "tsv", "sqlite", "db":
            return .data
            
        default:
            return .unknown
        }
    }
    
    /// Create a node from a file path with auto-detection
    public static func fromPath(_ path: String) -> Node {
        let name = (path as NSString).lastPathComponent
        let type = detectType(from: path)
        
        var capabilities: Set<NodeCapability> = [.viewable, .indexable]
        
        switch type {
        case .sourceFile, .view, .model, .service:
            capabilities.formUnion([.editable, .searchable, .explainable, .refactorable, .embeddable])
        case .script, .command:
            capabilities.formUnion([.editable, .executable, .explainable])
        case .document:
            capabilities.formUnion([.editable, .searchable, .explainable, .previewable])
        case .image, .asset:
            capabilities.formUnion([.previewable])
        case .config:
            capabilities.formUnion([.editable, .explainable])
        default:
            break
        }
        
        return Node(
            type: type,
            path: path,
            name: name,
            capabilities: capabilities
        )
    }
}

// MARK: - Relationship Factory

/// Factory for creating common relationships
public struct RelationshipFactory {
    
    /// Create a contains relationship (parent → child)
    public static func contains(targetId: String) -> NodeRelationship {
        NodeRelationship(type: .contains, targetId: targetId)
    }
    
    /// Create a depends-on relationship
    public static func dependsOn(targetId: String) -> NodeRelationship {
        NodeRelationship(type: .dependsOn, targetId: targetId)
    }
    
    /// Create an imports relationship
    public static func imports(targetId: String) -> NodeRelationship {
        NodeRelationship(type: .imports, targetId: targetId)
    }
    
    /// Create an executes relationship
    public static func executes(targetId: String) -> NodeRelationship {
        NodeRelationship(type: .executes, targetId: targetId)
    }
    
    /// Create a tests relationship
    public static func tests(targetId: String) -> NodeRelationship {
        NodeRelationship(type: .tests, targetId: targetId)
    }
    
    /// Create a documents relationship
    public static func documents(targetId: String) -> NodeRelationship {
        NodeRelationship(type: .documents, targetId: targetId)
    }
}

// MARK: - Extension Factory

/// Factory for creating common extensions
public struct ExtensionFactory {
    
    /// Create a syntax extension
    public static func syntax(language: String) -> NodeExtension {
        NodeExtension(type: .syntax, config: ["language": language])
    }
    
    /// Create a preview extension
    public static func preview(renderer: String) -> NodeExtension {
        NodeExtension(type: .preview, config: ["renderer": renderer])
    }
    
    /// Create a runtime extension
    public static func runtime(executor: String) -> NodeExtension {
        NodeExtension(type: .runtime, config: ["executor": executor])
    }
    
    /// Create an ML extension
    public static func ml(model: String) -> NodeExtension {
        NodeExtension(type: .ml, config: ["model": model])
    }
    
    /// Create an explanation extension
    public static func explanation() -> NodeExtension {
        NodeExtension(type: .explanation)
    }
}
