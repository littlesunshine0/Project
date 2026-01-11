//
//  KitDescriptors.swift
//  BridgeKit
//
//  Pre-defined descriptors for all existing Kits
//

import Foundation

/// Pre-defined Kit descriptors for automatic bridging
public enum KitDescriptors {
    
    // MARK: - DocKit
    
    public static let docKit = KitDescriptor(
        id: "com.flowkit.dockit",
        name: "DocKit",
        inputs: [
            DataPort(name: "sourceCode", dataType: .code, description: "Source code to document"),
            DataPort(name: "projectPath", dataType: .path, description: "Project directory path"),
            DataPort(name: "metadata", dataType: .metadata, description: "Project metadata")
        ],
        outputs: [
            DataPort(name: "readme", dataType: .markdown, description: "Generated README"),
            DataPort(name: "apiDocs", dataType: .markdown, description: "API documentation"),
            DataPort(name: "changelog", dataType: .markdown, description: "Changelog"),
            DataPort(name: "specs", dataType: .markdown, description: "Specifications"),
            DataPort(name: "config", dataType: .json, description: "Configuration files")
        ],
        triggers: [.onProjectCreate, .onFileSave, .onFileChange, .manual]
    )
    
    // MARK: - ParseKit
    
    public static let parseKit = KitDescriptor(
        id: "com.flowkit.parsekit",
        name: "ParseKit",
        inputs: [
            DataPort(name: "file", dataType: .file, description: "File to parse"),
            DataPort(name: "text", dataType: .text, description: "Text content to parse"),
            DataPort(name: "code", dataType: .code, description: "Code to parse")
        ],
        outputs: [
            DataPort(name: "ast", dataType: .json, description: "Abstract syntax tree"),
            DataPort(name: "tokens", dataType: .json, description: "Parsed tokens"),
            DataPort(name: "structure", dataType: .json, description: "Document structure"),
            DataPort(name: "metadata", dataType: .metadata, description: "Extracted metadata")
        ],
        triggers: [.onFileChange, .onFileSave, .manual]
    )
    
    // MARK: - CommandKit
    
    public static let commandKit = KitDescriptor(
        id: "com.flowkit.commandkit",
        name: "CommandKit",
        inputs: [
            DataPort(name: "text", dataType: .text, description: "User input text"),
            DataPort(name: "query", dataType: .query, description: "Command query")
        ],
        outputs: [
            DataPort(name: "command", dataType: .command, description: "Parsed command"),
            DataPort(name: "suggestions", dataType: .suggestion, description: "Command suggestions"),
            DataPort(name: "action", dataType: .action, description: "Action to execute")
        ],
        triggers: [.onCommand, .manual]
    )
    
    // MARK: - SearchKit
    
    public static let searchKit = KitDescriptor(
        id: "com.flowkit.searchkit",
        name: "SearchKit",
        inputs: [
            DataPort(name: "query", dataType: .query, description: "Search query"),
            DataPort(name: "content", dataType: .content, description: "Content to index"),
            DataPort(name: "document", dataType: .document, description: "Document to index")
        ],
        outputs: [
            DataPort(name: "results", dataType: .searchResult, description: "Search results"),
            DataPort(name: "suggestions", dataType: .suggestion, description: "Search suggestions")
        ],
        triggers: [.onSearch, .manual]
    )
    
    // MARK: - NLUKit
    
    public static let nluKit = KitDescriptor(
        id: "com.flowkit.nlukit",
        name: "NLUKit",
        inputs: [
            DataPort(name: "text", dataType: .text, description: "Natural language text"),
            DataPort(name: "query", dataType: .query, description: "User query")
        ],
        outputs: [
            DataPort(name: "intent", dataType: .intent, description: "Classified intent"),
            DataPort(name: "entities", dataType: .entity, description: "Extracted entities"),
            DataPort(name: "command", dataType: .command, description: "Derived command")
        ],
        triggers: [.onIntent, .onCommand, .manual]
    )
    
    // MARK: - LearnKit
    
    public static let learnKit = KitDescriptor(
        id: "com.flowkit.learnkit",
        name: "LearnKit",
        inputs: [
            DataPort(name: "data", dataType: .json, description: "Training data"),
            DataPort(name: "features", dataType: .json, description: "Feature vectors"),
            DataPort(name: "content", dataType: .content, description: "Content for learning")
        ],
        outputs: [
            DataPort(name: "prediction", dataType: .prediction, description: "Model prediction"),
            DataPort(name: "suggestion", dataType: .suggestion, description: "ML-based suggestion"),
            DataPort(name: "model", dataType: .json, description: "Trained model data")
        ],
        triggers: [.onProjectCreate, .manual]
    )
    
    // MARK: - WorkflowKit
    
    public static let workflowKit = KitDescriptor(
        id: "com.flowkit.workflowkit",
        name: "WorkflowKit",
        inputs: [
            DataPort(name: "command", dataType: .command, description: "Command to execute"),
            DataPort(name: "action", dataType: .action, description: "Action to perform"),
            DataPort(name: "task", dataType: .task, description: "Task definition")
        ],
        outputs: [
            DataPort(name: "workflow", dataType: .workflow, description: "Created workflow"),
            DataPort(name: "result", dataType: .json, description: "Execution result"),
            DataPort(name: "status", dataType: .json, description: "Workflow status")
        ],
        triggers: [.onCommand, .onWorkflowComplete, .manual]
    )
    
    // MARK: - AgentKit
    
    public static let agentKit = KitDescriptor(
        id: "com.flowkit.agentkit",
        name: "AgentKit",
        inputs: [
            DataPort(name: "intent", dataType: .intent, description: "User intent"),
            DataPort(name: "task", dataType: .task, description: "Task to perform"),
            DataPort(name: "workflow", dataType: .workflow, description: "Workflow to execute")
        ],
        outputs: [
            DataPort(name: "action", dataType: .action, description: "Agent action"),
            DataPort(name: "agent", dataType: .agent, description: "Created agent"),
            DataPort(name: "result", dataType: .json, description: "Agent result")
        ],
        triggers: [.onIntent, .onAgentAction, .manual]
    )
    
    // MARK: - ContentHub
    
    public static let contentHub = KitDescriptor(
        id: "com.flowkit.contenthub",
        name: "ContentHub",
        inputs: [
            DataPort(name: "content", dataType: .content, description: "Content to store"),
            DataPort(name: "document", dataType: .document, description: "Document to store"),
            DataPort(name: "metadata", dataType: .metadata, description: "Content metadata")
        ],
        outputs: [
            DataPort(name: "content", dataType: .content, description: "Retrieved content"),
            DataPort(name: "searchResult", dataType: .searchResult, description: "Content search results")
        ],
        triggers: [.onProjectCreate, .onFileSave, .manual]
    )
    
    // MARK: - IdeaKit
    
    public static let ideaKit = KitDescriptor(
        id: "com.flowkit.ideakit",
        name: "IdeaKit",
        inputs: [
            DataPort(name: "intent", dataType: .intent, description: "Project intent"),
            DataPort(name: "text", dataType: .text, description: "Project description")
        ],
        outputs: [
            DataPort(name: "spec", dataType: .markdown, description: "Project specification"),
            DataPort(name: "architecture", dataType: .json, description: "Architecture design"),
            DataPort(name: "tasks", dataType: .json, description: "Task breakdown")
        ],
        triggers: [.onProjectCreate, .manual]
    )
    
    // MARK: - IconKit
    
    public static let iconKit = KitDescriptor(
        id: "com.flowkit.iconkit",
        name: "IconKit",
        inputs: [
            DataPort(name: "metadata", dataType: .metadata, description: "Icon metadata"),
            DataPort(name: "config", dataType: .json, description: "Icon configuration")
        ],
        outputs: [
            DataPort(name: "icon", dataType: .file, description: "Generated icon"),
            DataPort(name: "assets", dataType: .json, description: "Asset catalog")
        ],
        triggers: [.onProjectCreate, .manual]
    )
    
    // MARK: - AnalyticsKit
    
    public static let analyticsKit = KitDescriptor(
        id: "com.flowkit.analyticskit",
        name: "AnalyticsKit",
        inputs: [
            DataPort(name: "event", dataType: .json, description: "Event data"),
            DataPort(name: "metric", dataType: .json, description: "Metric data")
        ],
        outputs: [
            DataPort(name: "stats", dataType: .json, description: "Analytics statistics"),
            DataPort(name: "report", dataType: .json, description: "Analytics report")
        ],
        triggers: [.onProjectCreate, .onFileSave, .manual]
    )
    
    // MARK: - KnowledgeKit
    
    public static let knowledgeKit = KitDescriptor(
        id: "com.flowkit.knowledgekit",
        name: "KnowledgeKit",
        inputs: [
            DataPort(name: "content", dataType: .content, description: "Content to ingest"),
            DataPort(name: "query", dataType: .query, description: "Knowledge query")
        ],
        outputs: [
            DataPort(name: "knowledge", dataType: .json, description: "Knowledge entries"),
            DataPort(name: "answer", dataType: .text, description: "Query answer")
        ],
        triggers: [.onFileSave, .onSearch, .manual]
    )
    
    // MARK: - ChatKit
    
    public static let chatKit = KitDescriptor(
        id: "com.flowkit.chatkit",
        name: "ChatKit",
        inputs: [
            DataPort(name: "message", dataType: .text, description: "User message"),
            DataPort(name: "context", dataType: .json, description: "Conversation context")
        ],
        outputs: [
            DataPort(name: "response", dataType: .text, description: "Chat response"),
            DataPort(name: "action", dataType: .action, description: "Suggested action")
        ],
        triggers: [.onCommand, .manual]
    )
    
    // MARK: - AIKit
    
    public static let aiKit = KitDescriptor(
        id: "com.flowkit.aikit",
        name: "AIKit",
        inputs: [
            DataPort(name: "prompt", dataType: .text, description: "AI prompt"),
            DataPort(name: "data", dataType: .json, description: "Input data")
        ],
        outputs: [
            DataPort(name: "completion", dataType: .text, description: "AI completion"),
            DataPort(name: "embedding", dataType: .json, description: "Vector embedding")
        ],
        triggers: [.onIntent, .manual]
    )
    
    // MARK: - IndexerKit
    
    public static let indexerKit = KitDescriptor(
        id: "com.flowkit.indexerkit",
        name: "IndexerKit",
        inputs: [
            DataPort(name: "content", dataType: .content, description: "Content to index"),
            DataPort(name: "path", dataType: .path, description: "Path to index")
        ],
        outputs: [
            DataPort(name: "index", dataType: .json, description: "Search index"),
            DataPort(name: "stats", dataType: .json, description: "Index statistics")
        ],
        triggers: [.onProjectCreate, .onFileSave, .onFileChange, .manual]
    )
    
    // MARK: - CollaborationKit
    
    public static let collaborationKit = KitDescriptor(
        id: "com.flowkit.collaborationkit",
        name: "CollaborationKit",
        inputs: [
            DataPort(name: "resource", dataType: .file, description: "Resource to collaborate on"),
            DataPort(name: "user", dataType: .json, description: "User info")
        ],
        outputs: [
            DataPort(name: "session", dataType: .json, description: "Collaboration session"),
            DataPort(name: "version", dataType: .json, description: "Version info")
        ],
        triggers: [.onFileSave, .manual]
    )
    
    // MARK: - FeedbackKit
    
    public static let feedbackKit = KitDescriptor(
        id: "com.flowkit.feedbackkit",
        name: "FeedbackKit",
        inputs: [
            DataPort(name: "feedback", dataType: .text, description: "User feedback"),
            DataPort(name: "context", dataType: .json, description: "Feedback context")
        ],
        outputs: [
            DataPort(name: "suggestion", dataType: .suggestion, description: "Improvement suggestion"),
            DataPort(name: "stats", dataType: .json, description: "Feedback statistics")
        ],
        triggers: [.manual]
    )
    
    // MARK: - ExportKit
    
    public static let exportKit = KitDescriptor(
        id: "com.flowkit.exportkit",
        name: "ExportKit",
        inputs: [
            DataPort(name: "data", dataType: .json, description: "Data to export"),
            DataPort(name: "format", dataType: .text, description: "Export format")
        ],
        outputs: [
            DataPort(name: "file", dataType: .file, description: "Exported file"),
            DataPort(name: "content", dataType: .content, description: "Exported content")
        ],
        triggers: [.manual]
    )
    
    // MARK: - SystemKit
    
    public static let systemKit = KitDescriptor(
        id: "com.flowkit.systemkit",
        name: "SystemKit",
        inputs: [
            DataPort(name: "service", dataType: .json, description: "Service definition"),
            DataPort(name: "permission", dataType: .text, description: "Permission request")
        ],
        outputs: [
            DataPort(name: "status", dataType: .json, description: "System status"),
            DataPort(name: "metrics", dataType: .json, description: "System metrics")
        ],
        triggers: [.onProjectCreate, .manual]
    )
    
    // MARK: - NotificationKit
    
    public static let notificationKit = KitDescriptor(
        id: "com.flowkit.notificationkit",
        name: "NotificationKit",
        inputs: [
            DataPort(name: "message", dataType: .text, description: "Notification message"),
            DataPort(name: "channel", dataType: .text, description: "Notification channel")
        ],
        outputs: [
            DataPort(name: "notification", dataType: .json, description: "Sent notification")
        ],
        triggers: [.onWorkflowComplete, .onAgentAction, .manual]
    )
    
    // MARK: - ErrorKit
    
    public static let errorKit = KitDescriptor(
        id: "com.flowkit.errorkit",
        name: "ErrorKit",
        inputs: [
            DataPort(name: "error", dataType: .json, description: "Error to handle"),
            DataPort(name: "context", dataType: .json, description: "Error context")
        ],
        outputs: [
            DataPort(name: "recovery", dataType: .action, description: "Recovery action"),
            DataPort(name: "report", dataType: .json, description: "Error report")
        ],
        triggers: [.manual]
    )
    
    // MARK: - UserKit
    
    public static let userKit = KitDescriptor(
        id: "com.flowkit.userkit",
        name: "UserKit",
        inputs: [
            DataPort(name: "profile", dataType: .json, description: "User profile data"),
            DataPort(name: "preference", dataType: .json, description: "User preference")
        ],
        outputs: [
            DataPort(name: "user", dataType: .json, description: "User data"),
            DataPort(name: "session", dataType: .json, description: "User session")
        ],
        triggers: [.onProjectCreate, .manual]
    )
    
    // MARK: - ActivityKit
    
    public static let activityKit = KitDescriptor(
        id: "com.flowkit.activitykit",
        name: "ActivityKit",
        inputs: [
            DataPort(name: "activity", dataType: .json, description: "Activity to record"),
            DataPort(name: "app", dataType: .json, description: "App to launch")
        ],
        outputs: [
            DataPort(name: "activities", dataType: .json, description: "Activity log"),
            DataPort(name: "launchResult", dataType: .json, description: "App launch result")
        ],
        triggers: [.onFileSave, .onCommand, .manual]
    )
    
    // MARK: - NetworkKit
    
    public static let networkKit = KitDescriptor(
        id: "com.flowkit.networkkit",
        name: "NetworkKit",
        inputs: [
            DataPort(name: "service", dataType: .json, description: "Service to register"),
            DataPort(name: "peer", dataType: .json, description: "Peer to connect")
        ],
        outputs: [
            DataPort(name: "services", dataType: .json, description: "Discovered services"),
            DataPort(name: "peers", dataType: .json, description: "Connected peers")
        ],
        triggers: [.onProjectCreate, .manual]
    )
    
    // MARK: - WebKit
    
    public static let webKit = KitDescriptor(
        id: "com.flowkit.webkit",
        name: "WebKit",
        inputs: [
            DataPort(name: "query", dataType: .query, description: "Search query"),
            DataPort(name: "url", dataType: .text, description: "URL to fetch")
        ],
        outputs: [
            DataPort(name: "results", dataType: .searchResult, description: "Search results"),
            DataPort(name: "content", dataType: .content, description: "Fetched content")
        ],
        triggers: [.onSearch, .manual]
    )
    
    // MARK: - FileKit
    
    public static let fileKit = KitDescriptor(
        id: "com.flowkit.filekit",
        name: "FileKit",
        inputs: [
            DataPort(name: "path", dataType: .path, description: "File path"),
            DataPort(name: "content", dataType: .content, description: "File content")
        ],
        outputs: [
            DataPort(name: "files", dataType: .json, description: "File listing"),
            DataPort(name: "result", dataType: .json, description: "Operation result")
        ],
        triggers: [.onFileSave, .onFileChange, .manual]
    )
    
    // MARK: - AssetKit
    
    public static let assetKit = KitDescriptor(
        id: "com.flowkit.assetkit",
        name: "AssetKit",
        inputs: [
            DataPort(name: "asset", dataType: .file, description: "Asset file"),
            DataPort(name: "tags", dataType: .json, description: "Asset tags")
        ],
        outputs: [
            DataPort(name: "assets", dataType: .json, description: "Asset library"),
            DataPort(name: "collection", dataType: .json, description: "Asset collection")
        ],
        triggers: [.onProjectCreate, .onFileSave, .manual]
    )
    
    // MARK: - SyntaxKit
    
    public static let syntaxKit = KitDescriptor(
        id: "com.flowkit.syntaxkit",
        name: "SyntaxKit",
        inputs: [
            DataPort(name: "code", dataType: .code, description: "Code to highlight"),
            DataPort(name: "language", dataType: .text, description: "Language identifier")
        ],
        outputs: [
            DataPort(name: "tokens", dataType: .json, description: "Syntax tokens"),
            DataPort(name: "highlighted", dataType: .json, description: "Highlighted lines")
        ],
        triggers: [.onFileSave, .onFileChange, .manual]
    )
    
    // MARK: - MarketplaceKit
    
    public static let marketplaceKit = KitDescriptor(
        id: "com.flowkit.marketplacekit",
        name: "MarketplaceKit",
        inputs: [
            DataPort(name: "product", dataType: .json, description: "Product data"),
            DataPort(name: "order", dataType: .json, description: "Order data")
        ],
        outputs: [
            DataPort(name: "listing", dataType: .json, description: "Product listing"),
            DataPort(name: "orderStatus", dataType: .json, description: "Order status")
        ],
        triggers: [.manual]
    )
    
    // MARK: - AppIdeaKit
    
    public static let appIdeaKit = KitDescriptor(
        id: "com.flowkit.appideakit",
        name: "AppIdeaKit",
        inputs: [
            DataPort(name: "idea", dataType: .json, description: "App idea data"),
            DataPort(name: "description", dataType: .text, description: "Idea description")
        ],
        outputs: [
            DataPort(name: "enrichedIdea", dataType: .json, description: "ML-enriched idea"),
            DataPort(name: "generatedApp", dataType: .json, description: "Generated app structure"),
            DataPort(name: "specs", dataType: .markdown, description: "Generated specifications"),
            DataPort(name: "tasks", dataType: .json, description: "Generated tasks")
        ],
        triggers: [.onProjectCreate, .manual]
    )
    
    // MARK: - All Descriptors
    
    public static var all: [KitDescriptor] {
        [
            // Core Kits
            docKit, parseKit, commandKit, searchKit, nluKit, learnKit,
            workflowKit, agentKit, contentHub, ideaKit, iconKit,
            // Analytics & Intelligence
            analyticsKit, knowledgeKit, chatKit, aiKit, indexerKit,
            // Collaboration & System
            collaborationKit, feedbackKit, exportKit, systemKit, notificationKit, errorKit,
            // User & Activity
            userKit, activityKit, networkKit, webKit,
            // Files & Assets
            fileKit, assetKit, syntaxKit, marketplaceKit,
            // App Generation
            appIdeaKit
        ]
    }
    
    /// Register all Kit descriptors with the registry
    public static func registerAll() async {
        for kit in all {
            await BridgeRegistry.shared.register(kit)
        }
        print("[KitDescriptors] Registered \(all.count) Kits")
    }
}
