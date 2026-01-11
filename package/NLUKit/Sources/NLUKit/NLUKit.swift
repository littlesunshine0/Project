//
//  NLUKit.swift
//  NLUKit
//
//  Natural Language Understanding System
//

import Foundation

/// NLUKit - Natural Language Understanding System
public struct NLUKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.nlukit"
    
    public init() {}
    
    /// Classify intent from text
    public static func classifyIntent(_ text: String) async -> Intent {
        await NLUEngine.shared.classifyIntent(text)
    }
    
    /// Extract entities from text
    public static func extractEntities(_ text: String) async -> [Entity] {
        await NLUEngine.shared.extractEntities(text)
    }
    
    /// Real-time intent prediction (optimized for <200ms)
    public static func predictRealtime(_ text: String) async -> IntentPrediction {
        await NLUEngine.shared.predictRealtime(text)
    }
    
    /// Generate text embedding
    public static func embed(_ text: String) async -> [Float] {
        await NLUEngine.shared.generateEmbedding(text)
    }
}

// MARK: - Intent

public struct Intent: Codable, Sendable {
    public let type: IntentType
    public let confidence: Double
    public let entities: [Entity]
    
    public init(type: IntentType, confidence: Double, entities: [Entity] = []) {
        self.type = type
        self.confidence = confidence
        self.entities = entities
    }
}

public enum IntentType: String, Codable, CaseIterable, Sendable {
    case createWorkflow, executeWorkflow, pauseWorkflow, resumeWorkflow, deleteWorkflow, listWorkflows
    case searchDocumentation, ingestDocumentation, viewDocumentation
    case viewAnalytics, generateReport, identifyBottlenecks
    case configureSettings, viewSettings, updatePreferences
    case executeCommand, listCommands
    case shareWorkflow, viewSharedWorkflows, collaborateOnWorkflow
    case viewHistory, reExecuteWorkflow
    case provideFeedback, rateWorkflow
    case help, unknown
    
    public var description: String {
        switch self {
        case .createWorkflow: return "create a workflow"
        case .executeWorkflow: return "execute a workflow"
        case .pauseWorkflow: return "pause a workflow"
        case .resumeWorkflow: return "resume a workflow"
        case .deleteWorkflow: return "delete a workflow"
        case .listWorkflows: return "list workflows"
        case .searchDocumentation: return "search documentation"
        case .ingestDocumentation: return "ingest documentation"
        case .viewDocumentation: return "view documentation"
        case .viewAnalytics: return "view analytics"
        case .generateReport: return "generate a report"
        case .identifyBottlenecks: return "identify bottlenecks"
        case .configureSettings: return "configure settings"
        case .viewSettings: return "view settings"
        case .updatePreferences: return "update preferences"
        case .executeCommand: return "execute a command"
        case .listCommands: return "list commands"
        case .shareWorkflow: return "share a workflow"
        case .viewSharedWorkflows: return "view shared workflows"
        case .collaborateOnWorkflow: return "collaborate on a workflow"
        case .viewHistory: return "view history"
        case .reExecuteWorkflow: return "re-execute a workflow"
        case .provideFeedback: return "provide feedback"
        case .rateWorkflow: return "rate a workflow"
        case .help: return "get help"
        case .unknown: return "perform an action"
        }
    }
}

// MARK: - Entity

public struct Entity: Codable, Sendable {
    public let type: EntityType
    public let value: String
    public let startIndex: Int
    public let endIndex: Int
    
    public init(type: EntityType, value: String, startIndex: Int = 0, endIndex: Int = 0) {
        self.type = type
        self.value = value
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
}

public enum EntityType: String, Codable, CaseIterable, Sendable {
    case workflowName, workflowId, command, directoryPath, url, fileName
    case date, time, number, boolean, projectName, userName, tag
}

// MARK: - Intent Prediction

public struct IntentPrediction: Sendable {
    public let intent: Intent
    public let isPartial: Bool
    public let latency: TimeInterval
    
    public var meetsLatencyRequirement: Bool { latency <= 0.200 }
    
    public init(intent: Intent, isPartial: Bool, latency: TimeInterval) {
        self.intent = intent
        self.isPartial = isPartial
        self.latency = latency
    }
}

// MARK: - NLU Engine

public actor NLUEngine {
    public static let shared = NLUEngine()
    
    private let intentKeywords: [IntentType: [String]] = [
        .createWorkflow: ["create", "new", "make", "build", "add"],
        .executeWorkflow: ["run", "execute", "start", "launch", "do"],
        .pauseWorkflow: ["pause", "stop", "halt", "suspend"],
        .resumeWorkflow: ["resume", "continue", "restart"],
        .deleteWorkflow: ["delete", "remove", "destroy"],
        .listWorkflows: ["list", "show", "display", "all"],
        .searchDocumentation: ["search", "find", "look", "query", "docs"],
        .viewAnalytics: ["analytics", "stats", "metrics", "report"],
        .configureSettings: ["config", "configure", "settings", "setup"],
        .help: ["help", "?", "how", "what"]
    ]
    
    private init() {}
    
    public func classifyIntent(_ text: String) async -> Intent {
        let startTime = Date()
        let lowercased = text.lowercased()
        
        var bestIntent: IntentType = .unknown
        var bestScore: Double = 0.0
        
        for (intent, keywords) in intentKeywords {
            var score = 0.0
            for keyword in keywords {
                if lowercased.contains(keyword) {
                    score += 1.0
                    if lowercased.hasPrefix(keyword) { score += 0.5 }
                }
            }
            if score > bestScore {
                bestScore = score
                bestIntent = intent
            }
        }
        
        let confidence = min(bestScore / 3.0, 1.0)
        let entities = await extractEntities(text)
        
        let _ = Date().timeIntervalSince(startTime)
        
        return Intent(type: bestIntent, confidence: confidence > 0.3 ? confidence : 0.3, entities: entities)
    }
    
    public func extractEntities(_ text: String) async -> [Entity] {
        var entities: [Entity] = []
        
        // Extract quoted strings (workflow names)
        let quotePattern = #""([^"]+)""#
        if let regex = try? NSRegularExpression(pattern: quotePattern) {
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            for match in matches {
                if let range = Range(match.range(at: 1), in: text) {
                    entities.append(Entity(type: .workflowName, value: String(text[range]), startIndex: text.distance(from: text.startIndex, to: range.lowerBound), endIndex: text.distance(from: text.startIndex, to: range.upperBound)))
                }
            }
        }
        
        // Extract file paths
        let pathPattern = #"(/[^\s]+|~/[^\s]+)"#
        if let regex = try? NSRegularExpression(pattern: pathPattern) {
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            for match in matches {
                if let range = Range(match.range, in: text) {
                    entities.append(Entity(type: .directoryPath, value: String(text[range])))
                }
            }
        }
        
        // Extract URLs
        let urlPattern = #"https?://[^\s]+"#
        if let regex = try? NSRegularExpression(pattern: urlPattern) {
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            for match in matches {
                if let range = Range(match.range, in: text) {
                    entities.append(Entity(type: .url, value: String(text[range])))
                }
            }
        }
        
        // Extract numbers
        let numberPattern = #"\b\d+\b"#
        if let regex = try? NSRegularExpression(pattern: numberPattern) {
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            for match in matches {
                if let range = Range(match.range, in: text) {
                    entities.append(Entity(type: .number, value: String(text[range])))
                }
            }
        }
        
        return entities
    }
    
    public func predictRealtime(_ text: String) async -> IntentPrediction {
        let startTime = Date()
        
        if text.count < 3 {
            return IntentPrediction(intent: Intent(type: .unknown, confidence: 0), isPartial: true, latency: Date().timeIntervalSince(startTime))
        }
        
        let intent = await classifyIntent(text)
        let latency = Date().timeIntervalSince(startTime)
        
        return IntentPrediction(intent: intent, isPartial: true, latency: latency)
    }
    
    public func generateEmbedding(_ text: String) async -> [Float] {
        // Simple hash-based embedding for fallback
        let hash = text.hashValue
        var embedding: [Float] = []
        for i in 0..<384 {
            embedding.append(Float((hash &+ i) % 100) / 100.0)
        }
        return embedding
    }
}
