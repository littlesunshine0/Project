//
//  KitCatalog.swift
//  AppIdeaKit - Catalog of Available Kits
//

import Foundation

// MARK: - Kit Definition

public struct KitDefinition: Identifiable, Codable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let category: KitCategory
    public let capabilities: [String]
    public let dependencies: [String]
    public let autoAttach: Bool
    
    public init(
        id: String,
        name: String,
        description: String,
        category: KitCategory,
        capabilities: [String],
        dependencies: [String] = [],
        autoAttach: Bool = false
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.capabilities = capabilities
        self.dependencies = dependencies
        self.autoAttach = autoAttach
    }
}

public enum KitCategory: String, Codable, Sendable, CaseIterable {
    case core = "Core"
    case domain = "Domain"
    case intelligence = "Intelligence"
    case collaboration = "Collaboration"
    case system = "System"
    case files = "Files & Assets"
    case user = "User & Activity"
}

// MARK: - Built-in Kits Data

private let builtInKits: [KitDefinition] = [
    // Core Kits
    KitDefinition(id: "IdeaKit", name: "IdeaKit", description: "Project Operating System", category: .core, capabilities: ["intent-analysis", "spec-generation", "architecture"], autoAttach: true),
    KitDefinition(id: "IconKit", name: "IconKit", description: "Universal icon system", category: .core, capabilities: ["icon-generation", "asset-export"], autoAttach: true),
    KitDefinition(id: "ContentHub", name: "ContentHub", description: "Centralized content storage", category: .core, capabilities: ["content-storage", "indexing", "search"], autoAttach: true),
    KitDefinition(id: "BridgeKit", name: "BridgeKit", description: "Universal Kit bridging", category: .core, capabilities: ["kit-orchestration", "auto-bridging"], autoAttach: true),
    
    // Domain Kits
    KitDefinition(id: "DocKit", name: "DocKit", description: "Documentation generation", category: .domain, capabilities: ["readme-generation", "api-docs", "changelog"], autoAttach: true),
    KitDefinition(id: "ParseKit", name: "ParseKit", description: "Universal file parsing", category: .domain, capabilities: ["file-parsing", "ast-generation"]),
    KitDefinition(id: "CommandKit", name: "CommandKit", description: "Command parsing and execution", category: .domain, capabilities: ["command-parsing", "autocomplete"]),
    KitDefinition(id: "SearchKit", name: "SearchKit", description: "Full-text and semantic search", category: .domain, capabilities: ["full-text-search", "semantic-search"]),
    KitDefinition(id: "NLUKit", name: "NLUKit", description: "Natural language understanding", category: .domain, capabilities: ["intent-classification", "entity-extraction"]),
    KitDefinition(id: "LearnKit", name: "LearnKit", description: "Machine learning", category: .domain, capabilities: ["ml-training", "predictions"]),
    KitDefinition(id: "WorkflowKit", name: "WorkflowKit", description: "Workflow orchestration", category: .domain, capabilities: ["workflow-creation", "execution"]),
    KitDefinition(id: "AgentKit", name: "AgentKit", description: "Autonomous agents", category: .domain, capabilities: ["agent-creation", "task-execution"]),
    
    // Intelligence Kits
    KitDefinition(id: "AnalyticsKit", name: "AnalyticsKit", description: "Analytics and telemetry", category: .intelligence, capabilities: ["event-tracking", "metrics"]),
    KitDefinition(id: "KnowledgeKit", name: "KnowledgeKit", description: "Knowledge base management", category: .intelligence, capabilities: ["knowledge-ingestion", "qa"]),
    KitDefinition(id: "ChatKit", name: "ChatKit", description: "Conversational interfaces", category: .intelligence, capabilities: ["chat-ui", "conversation-management"]),
    KitDefinition(id: "AIKit", name: "AIKit", description: "AI/ML model integration", category: .intelligence, capabilities: ["llm-integration", "embeddings"]),
    KitDefinition(id: "IndexerKit", name: "IndexerKit", description: "Code and document indexing", category: .intelligence, capabilities: ["code-indexing", "symbol-search"]),
    
    // Collaboration Kits
    KitDefinition(id: "CollaborationKit", name: "CollaborationKit", description: "Real-time collaboration", category: .collaboration, capabilities: ["sessions", "locking", "versioning"]),
    KitDefinition(id: "FeedbackKit", name: "FeedbackKit", description: "Feedback collection", category: .collaboration, capabilities: ["feedback-collection", "suggestions"]),
    KitDefinition(id: "ExportKit", name: "ExportKit", description: "Data export", category: .collaboration, capabilities: ["json-export", "csv-export", "markdown-export"]),
    
    // System Kits
    KitDefinition(id: "SystemKit", name: "SystemKit", description: "System integration", category: .system, capabilities: ["service-registry", "permissions"]),
    KitDefinition(id: "NotificationKit", name: "NotificationKit", description: "Notification management", category: .system, capabilities: ["notifications", "channels"]),
    KitDefinition(id: "ErrorKit", name: "ErrorKit", description: "Error handling", category: .system, capabilities: ["error-tracking", "recovery-strategies"]),
    
    // User & Activity Kits
    KitDefinition(id: "UserKit", name: "UserKit", description: "User profile and preferences", category: .user, capabilities: ["profiles", "preferences"]),
    KitDefinition(id: "ActivityKit", name: "ActivityKit", description: "Activity tracking", category: .user, capabilities: ["activity-tracking", "app-launching"]),
    KitDefinition(id: "NetworkKit", name: "NetworkKit", description: "Network discovery", category: .user, capabilities: ["service-discovery", "peer-connection"]),
    KitDefinition(id: "WebKit", name: "WebKit", description: "Web search and content", category: .user, capabilities: ["web-search", "content-fetching"]),
    
    // Files & Assets Kits
    KitDefinition(id: "FileKit", name: "FileKit", description: "File system operations", category: .files, capabilities: ["file-operations", "watching"]),
    KitDefinition(id: "AssetKit", name: "AssetKit", description: "Asset management", category: .files, capabilities: ["asset-library", "tagging"]),
    KitDefinition(id: "SyntaxKit", name: "SyntaxKit", description: "Syntax highlighting", category: .files, capabilities: ["tokenization", "highlighting"]),
    KitDefinition(id: "MarketplaceKit", name: "MarketplaceKit", description: "Marketplace integration", category: .files, capabilities: ["products", "orders"])
]

// MARK: - Kit Catalog

public actor KitCatalog {
    public static let shared = KitCatalog()
    
    private var kits: [String: KitDefinition]
    
    private init() {
        // Initialize from static data
        var kitMap: [String: KitDefinition] = [:]
        for kit in builtInKits {
            kitMap[kit.id] = kit
        }
        self.kits = kitMap
    }
    
    public func register(_ kit: KitDefinition) {
        kits[kit.id] = kit
    }
    
    public func get(_ id: String) -> KitDefinition? {
        kits[id]
    }
    
    public func all() -> [KitDefinition] {
        Array(kits.values).sorted { $0.name < $1.name }
    }
    
    public func byCategory(_ category: KitCategory) -> [KitDefinition] {
        kits.values.filter { $0.category == category }
    }
    
    public func autoAttachKits() -> [KitDefinition] {
        kits.values.filter { $0.autoAttach }
    }
    
    public func kitsForCapabilities(_ capabilities: [String]) -> [KitDefinition] {
        kits.values.filter { kit in
            capabilities.contains { cap in
                kit.capabilities.contains { $0.contains(cap) }
            }
        }
    }
}
