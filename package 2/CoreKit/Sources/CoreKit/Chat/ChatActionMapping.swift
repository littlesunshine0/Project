//
//  ChatActionMapping.swift
//  CoreKit - Chat → Action Mapping
//
//  The chat is not a chatbot, it's a command surface.
//  Everything it does is backed by CRUD actions.
//

import Foundation

// MARK: - Chat Intent

/// Parsed intent from a chat message
public struct ChatIntent: Sendable {
    public let id: String
    public let type: ChatIntentType
    public let action: ChatAction
    public let targets: [ChatTarget]
    public let parameters: [String: String]
    public let confidence: Float
    public let rawMessage: String
    
    public init(
        id: String = UUID().uuidString,
        type: ChatIntentType,
        action: ChatAction,
        targets: [ChatTarget] = [],
        parameters: [String: String] = [:],
        confidence: Float = 1.0,
        rawMessage: String = ""
    ) {
        self.id = id
        self.type = type
        self.action = action
        self.targets = targets
        self.parameters = parameters
        self.confidence = confidence
        self.rawMessage = rawMessage
    }
}

public enum ChatIntentType: String, Sendable, CaseIterable {
    // Query
    case explain         // "Explain this"
    case describe        // "What does this do?"
    case find            // "Find all views"
    case show            // "Show me the dependencies"
    case list            // "List all scripts"
    case compare         // "Compare these files"
    
    // Modify
    case create          // "Create a new workflow"
    case edit            // "Edit this file"
    case delete          // "Delete this script"
    case rename          // "Rename this to..."
    case move            // "Move this to..."
    case convert         // "Convert this to JSON"
    
    // Execute
    case run             // "Run this script"
    case test            // "Test this component"
    case build           // "Build the project"
    case deploy          // "Deploy to staging"
    
    // Generate
    case generate        // "Generate docs for this"
    case document        // "Document this function"
    case refactor        // "Refactor this code"
    case suggest         // "Suggest improvements"
    
    // Link
    case link            // "Link this to that"
    case unlink          // "Remove this dependency"
    case connect         // "Connect these workflows"
    
    // Meta
    case help            // "How do I..."
    case status          // "What's the status of..."
    case history         // "Show history of..."
    case undo            // "Undo last action"
}

// MARK: - Chat Action

/// The action to perform
public struct ChatAction: Sendable {
    public let type: ChatActionType
    public let crudOperations: [CRUDOperation]
    public let requiresConfirmation: Bool
    public let isDestructive: Bool
    public let estimatedDuration: TimeInterval?
    
    public init(
        type: ChatActionType,
        crudOperations: [CRUDOperation] = [],
        requiresConfirmation: Bool = false,
        isDestructive: Bool = false,
        estimatedDuration: TimeInterval? = nil
    ) {
        self.type = type
        self.crudOperations = crudOperations
        self.requiresConfirmation = requiresConfirmation
        self.isDestructive = isDestructive
        self.estimatedDuration = estimatedDuration
    }
}

public enum ChatActionType: String, Sendable {
    // Read operations
    case query
    case search
    case analyze
    case explain
    
    // Write operations
    case create
    case update
    case delete
    case move
    
    // Execute operations
    case execute
    case test
    case build
    
    // Generate operations
    case generate
    case transform
    case refactor
    
    // Link operations
    case link
    case unlink
    
    // System operations
    case navigate
    case preview
    case export
    case undo
}

// MARK: - Chat Target

/// What the action targets
public struct ChatTarget: Sendable {
    public let type: ChatTargetType
    public let identifier: String?  // Node ID, path, or query
    public let nodeType: NodeType?
    public let filter: ChatFilter?
    
    public init(
        type: ChatTargetType,
        identifier: String? = nil,
        nodeType: NodeType? = nil,
        filter: ChatFilter? = nil
    ) {
        self.type = type
        self.identifier = identifier
        self.nodeType = nodeType
        self.filter = filter
    }
}

public enum ChatTargetType: String, Sendable {
    case currentNode     // "this"
    case specificNode    // "HomeView.swift"
    case nodeById        // By ID
    case nodeByPath      // By path
    case nodesByType     // "all views"
    case nodesByQuery    // "files containing X"
    case project         // "the project"
    case selection       // Currently selected
}

public struct ChatFilter: Sendable {
    public let type: NodeType?
    public let capability: NodeCapability?
    public let tag: String?
    public let query: String?
    
    public init(type: NodeType? = nil, capability: NodeCapability? = nil, tag: String? = nil, query: String? = nil) {
        self.type = type
        self.capability = capability
        self.tag = tag
        self.query = query
    }
}

// MARK: - Chat Response

/// Response to a chat intent
public struct ChatResponse: Sendable {
    public let id: String
    public let intentId: String
    public let type: ChatResponseType
    public let content: ChatResponseContent
    public let actions: [ChatFollowUpAction]
    public let timestamp: Date
    
    public init(
        id: String = UUID().uuidString,
        intentId: String,
        type: ChatResponseType,
        content: ChatResponseContent,
        actions: [ChatFollowUpAction] = [],
        timestamp: Date = Date()
    ) {
        self.id = id
        self.intentId = intentId
        self.type = type
        self.content = content
        self.actions = actions
        self.timestamp = timestamp
    }
}

public enum ChatResponseType: String, Sendable {
    case text            // Plain text response
    case nodeList        // List of nodes
    case nodeDetail      // Single node detail
    case preview         // Preview content
    case diff            // Before/after diff
    case confirmation    // Needs confirmation
    case error           // Error message
    case progress        // Progress update
    case complete        // Action completed
}

public enum ChatResponseContent: Sendable {
    case text(String)
    case nodes([Node])
    case node(Node)
    case preview(PreviewContent)
    case diff(DiffContent)
    case error(String)
    case progress(Float, String)
    case result(CRUDResult)
}

public struct PreviewContent: Sendable {
    public let nodeId: String
    public let type: PreviewType
    public let content: String
    
    public init(nodeId: String, type: PreviewType, content: String) {
        self.nodeId = nodeId
        self.type = type
        self.content = content
    }
}

public enum PreviewType: String, Sendable {
    case code, ui, markdown, image, data, terminal
}

public struct DiffContent: Sendable {
    public let before: String
    public let after: String
    public let changes: [String]
    
    public init(before: String, after: String, changes: [String] = []) {
        self.before = before
        self.after = after
        self.changes = changes
    }
}

public struct ChatFollowUpAction: Sendable {
    public let label: String
    public let intent: ChatIntent
    
    public init(label: String, intent: ChatIntent) {
        self.label = label
        self.intent = intent
    }
}

// MARK: - Intent Parser

/// Parses chat messages into intents
public actor ChatIntentParser {
    public static let shared = ChatIntentParser()
    
    private init() {}
    
    /// Parse a chat message into an intent
    public func parse(_ message: String) -> ChatIntent {
        let lowercased = message.lowercased()
        
        // Detect intent type
        let intentType = detectIntentType(lowercased)
        
        // Detect targets
        let targets = detectTargets(message)
        
        // Extract parameters
        let parameters = extractParameters(message)
        
        // Build action
        let action = buildAction(intentType: intentType, targets: targets, parameters: parameters)
        
        // Calculate confidence
        let confidence = calculateConfidence(message: message, intentType: intentType)
        
        return ChatIntent(
            type: intentType,
            action: action,
            targets: targets,
            parameters: parameters,
            confidence: confidence,
            rawMessage: message
        )
    }
    
    private func detectIntentType(_ message: String) -> ChatIntentType {
        // Explain/Describe
        if message.contains("explain") || message.contains("what does") || message.contains("what is") {
            return .explain
        }
        if message.contains("describe") || message.contains("tell me about") {
            return .describe
        }
        
        // Find/Show/List
        if message.contains("find") || message.contains("search") {
            return .find
        }
        if message.contains("show") || message.contains("display") {
            return .show
        }
        if message.contains("list") || message.contains("all ") {
            return .list
        }
        
        // Create/Edit/Delete
        if message.contains("create") || message.contains("new ") || message.contains("add ") {
            return .create
        }
        if message.contains("edit") || message.contains("modify") || message.contains("change") {
            return .edit
        }
        if message.contains("delete") || message.contains("remove") {
            return .delete
        }
        
        // Execute
        if message.contains("run") || message.contains("execute") {
            return .run
        }
        if message.contains("test") {
            return .test
        }
        if message.contains("build") {
            return .build
        }
        
        // Generate
        if message.contains("generate") || message.contains("create docs") {
            return .generate
        }
        if message.contains("document") {
            return .document
        }
        if message.contains("refactor") {
            return .refactor
        }
        if message.contains("suggest") || message.contains("improve") {
            return .suggest
        }
        
        // Link
        if message.contains("link") || message.contains("connect") {
            return .link
        }
        if message.contains("unlink") || message.contains("disconnect") {
            return .unlink
        }
        
        // Convert
        if message.contains("convert") || message.contains("transform") {
            return .convert
        }
        
        // Default to explain
        return .explain
    }
    
    private func detectTargets(_ message: String) -> [ChatTarget] {
        var targets: [ChatTarget] = []
        
        // Check for "this"
        if message.lowercased().contains("this") {
            targets.append(ChatTarget(type: .currentNode))
        }
        
        // Check for file extensions
        let filePattern = #"[\w\-]+\.\w+"#
        if let regex = try? NSRegularExpression(pattern: filePattern),
           let match = regex.firstMatch(in: message, range: NSRange(message.startIndex..., in: message)) {
            let filename = String(message[Range(match.range, in: message)!])
            targets.append(ChatTarget(type: .specificNode, identifier: filename))
        }
        
        // Check for type references
        let typeKeywords: [String: NodeType] = [
            "views": .view, "view": .view,
            "scripts": .script, "script": .script,
            "commands": .command, "command": .command,
            "workflows": .workflow, "workflow": .workflow,
            "agents": .agent, "agent": .agent,
            "tests": .test, "test": .test,
            "assets": .asset, "asset": .asset,
            "packages": .package, "package": .package
        ]
        
        for (keyword, nodeType) in typeKeywords {
            if message.lowercased().contains(keyword) {
                targets.append(ChatTarget(type: .nodesByType, nodeType: nodeType))
                break
            }
        }
        
        // Check for "project"
        if message.lowercased().contains("project") {
            targets.append(ChatTarget(type: .project))
        }
        
        return targets.isEmpty ? [ChatTarget(type: .currentNode)] : targets
    }
    
    private func extractParameters(_ message: String) -> [String: String] {
        var params: [String: String] = [:]
        
        // Extract quoted strings
        let quotePattern = #""([^"]+)""#
        if let regex = try? NSRegularExpression(pattern: quotePattern) {
            let matches = regex.matches(in: message, range: NSRange(message.startIndex..., in: message))
            for (index, match) in matches.enumerated() {
                if let range = Range(match.range(at: 1), in: message) {
                    params["quoted_\(index)"] = String(message[range])
                }
            }
        }
        
        return params
    }
    
    private func buildAction(intentType: ChatIntentType, targets: [ChatTarget], parameters: [String: String]) -> ChatAction {
        let actionType: ChatActionType
        var requiresConfirmation = false
        var isDestructive = false
        
        switch intentType {
        case .explain, .describe, .find, .show, .list, .compare:
            actionType = .query
        case .create:
            actionType = .create
        case .edit, .rename, .move:
            actionType = .update
        case .delete:
            actionType = .delete
            requiresConfirmation = true
            isDestructive = true
        case .run, .test, .build, .deploy:
            actionType = .execute
        case .generate, .document:
            actionType = .generate
        case .refactor, .convert:
            actionType = .transform
        case .suggest:
            actionType = .analyze
        case .link, .connect:
            actionType = .link
        case .unlink:
            actionType = .unlink
        case .help, .status, .history:
            actionType = .query
        case .undo:
            actionType = .undo
        }
        
        return ChatAction(
            type: actionType,
            requiresConfirmation: requiresConfirmation,
            isDestructive: isDestructive
        )
    }
    
    private func calculateConfidence(message: String, intentType: ChatIntentType) -> Float {
        // Simple heuristic - longer, clearer messages = higher confidence
        let wordCount = message.split(separator: " ").count
        var confidence: Float = 0.5
        
        if wordCount >= 3 { confidence += 0.2 }
        if wordCount >= 5 { confidence += 0.1 }
        
        // Explicit keywords boost confidence
        let explicitKeywords = ["please", "can you", "i want", "i need"]
        for keyword in explicitKeywords where message.lowercased().contains(keyword) {
            confidence += 0.1
            break
        }
        
        return min(1.0, confidence)
    }
}
