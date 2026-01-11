//
//  IdeaAnalyzer.swift
//  AppIdeaKit - ML-Powered Idea Analysis
//

import Foundation

// MARK: - Idea Analyzer

public actor IdeaAnalyzer {
    public static let shared = IdeaAnalyzer()
    
    private var keywordWeights: [String: [String: Float]] = [:]
    
    private init() {
        // Initialize keyword weights inline
        keywordWeights = [
            "document": ["DocKit": 5, "ParseKit": 3, "SearchKit": 2],
            "parse": ["ParseKit": 5, "SyntaxKit": 3],
            "search": ["SearchKit": 5, "IndexerKit": 3, "KnowledgeKit": 2],
            "workflow": ["WorkflowKit": 5, "AgentKit": 3],
            "agent": ["AgentKit": 5, "WorkflowKit": 3, "AIKit": 2],
            "ai": ["AIKit": 5, "LearnKit": 3, "NLUKit": 2],
            "ml": ["LearnKit": 5, "AIKit": 3],
            "chat": ["ChatKit": 5, "NLUKit": 3],
            "command": ["CommandKit": 5, "NLUKit": 2],
            "file": ["FileKit": 5, "AssetKit": 2],
            "asset": ["AssetKit": 5, "FileKit": 2],
            "syntax": ["SyntaxKit": 5, "ParseKit": 3],
            "code": ["IndexerKit": 4, "SyntaxKit": 3, "ParseKit": 2],
            "analytics": ["AnalyticsKit": 5, "FeedbackKit": 2],
            "notification": ["NotificationKit": 5],
            "error": ["ErrorKit": 5],
            "user": ["UserKit": 5],
            "network": ["NetworkKit": 5],
            "web": ["WebKit": 5],
            "marketplace": ["MarketplaceKit": 5],
            "export": ["ExportKit": 5],
            "collaborate": ["CollaborationKit": 5],
            "feedback": ["FeedbackKit": 5],
            "knowledge": ["KnowledgeKit": 5, "SearchKit": 2],
            "index": ["IndexerKit": 5, "SearchKit": 3],
            "system": ["SystemKit": 5],
            "activity": ["ActivityKit": 5]
        ]
    }
    
    // MARK: - Analysis
    
    public func analyze(_ idea: AppIdea) -> AnalysisResult {
        let keywords = extractKeywords(from: idea)
        let suggestedKits = suggestKits(for: idea, keywords: keywords)
        let predictedComplexity = predictComplexity(for: idea)
        let topics = extractTopics(from: idea)
        
        return AnalysisResult(
            keywords: keywords,
            suggestedKits: suggestedKits,
            predictedComplexity: predictedComplexity,
            topics: topics,
            confidenceScore: calculateConfidence(idea)
        )
    }
    
    public func enrichIdea(_ idea: AppIdea) -> AppIdea {
        let analysis = analyze(idea)
        var enriched = idea
        enriched.mlMetadata.keywords = analysis.keywords
        enriched.mlMetadata.predictedKits = analysis.suggestedKits
        enriched.mlMetadata.predictedComplexity = analysis.predictedComplexity
        enriched.mlMetadata.topics = analysis.topics
        enriched.mlMetadata.confidenceScore = analysis.confidenceScore
        enriched.suggestedKits = analysis.suggestedKits
        return enriched
    }
    
    // MARK: - Keyword Extraction
    
    private func extractKeywords(from idea: AppIdea) -> [String] {
        let text = "\(idea.name) \(idea.description) \(idea.context.problemStatement)"
        let words = text.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.count > 3 }
        
        // Score words by relevance
        var scores: [String: Int] = [:]
        for word in words {
            scores[word, default: 0] += 1
        }
        
        // Boost technical keywords
        let techKeywords = ["api", "cli", "generator", "analyzer", "engine", "service",
                          "automation", "workflow", "agent", "ml", "ai", "search",
                          "index", "parse", "compile", "build", "deploy", "test"]
        for keyword in techKeywords where text.lowercased().contains(keyword) {
            scores[keyword, default: 0] += 5
        }
        
        return scores.sorted { $0.value > $1.value }
            .prefix(10)
            .map { $0.key }
    }
    
    // MARK: - Kit Suggestion
    
    private func suggestKits(for idea: AppIdea, keywords: [String]) -> [String] {
        var kitScores: [String: Float] = [:]
        
        // Score based on category
        let categoryKits = kitsByCategory(idea.category)
        for kit in categoryKits {
            kitScores[kit, default: 0] += 3.0
        }
        
        // Score based on keywords
        for keyword in keywords {
            if let kits = keywordWeights[keyword] {
                for (kit, weight) in kits {
                    kitScores[kit, default: 0] += weight
                }
            }
        }
        
        // Score based on type
        let typeKits = kitsByType(idea.type)
        for kit in typeKits {
            kitScores[kit, default: 0] += 2.0
        }
        
        // Always include auto-attach kits
        let autoKits = ["IdeaKit", "IconKit", "ContentHub", "BridgeKit", "DocKit"]
        for kit in autoKits {
            kitScores[kit, default: 0] += 5.0
        }
        
        return kitScores.sorted { $0.value > $1.value }
            .map { $0.key }
    }
    
    private func kitsByCategory(_ category: AppCategory) -> [String] {
        switch category {
        case .developerTool, .builderTool, .cliTool:
            return ["CommandKit", "ParseKit", "FileKit", "SyntaxKit"]
        case .codeAnalysis:
            return ["IndexerKit", "ParseKit", "SyntaxKit", "AnalyticsKit"]
        case .documentation:
            return ["DocKit", "ParseKit", "SearchKit", "ExportKit"]
        case .aiFirst, .mlPowered:
            return ["AIKit", "LearnKit", "NLUKit", "KnowledgeKit"]
        case .automation:
            return ["WorkflowKit", "AgentKit", "CommandKit"]
        case .assistant:
            return ["ChatKit", "NLUKit", "AIKit", "KnowledgeKit"]
        case .productivity, .organization, .planning:
            return ["WorkflowKit", "NotificationKit", "UserKit"]
        case .tracking:
            return ["AnalyticsKit", "ActivityKit", "FeedbackKit"]
        case .learning, .skillBuilding, .education:
            return ["LearnKit", "KnowledgeKit", "FeedbackKit"]
        case .startup, .business, .enterprise:
            return ["AnalyticsKit", "ExportKit", "CollaborationKit"]
        case .marketplace:
            return ["MarketplaceKit", "UserKit", "NotificationKit"]
        case .consumer, .lifestyle, .social:
            return ["UserKit", "NotificationKit", "ActivityKit"]
        case .metaApp, .framework, .platform:
            return ["SystemKit", "BridgeKit", "WorkflowKit", "AgentKit"]
        }
    }
    
    private func kitsByType(_ type: AppType) -> [String] {
        switch type {
        case .generator: return ["DocKit", "ParseKit", "ExportKit"]
        case .analyzer: return ["IndexerKit", "AnalyticsKit", "ParseKit"]
        case .converter: return ["ParseKit", "ExportKit"]
        case .manager: return ["FileKit", "AssetKit", "UserKit"]
        case .tracker: return ["AnalyticsKit", "ActivityKit", "FeedbackKit"]
        case .builder: return ["WorkflowKit", "CommandKit"]
        case .assistant: return ["ChatKit", "NLUKit", "AIKit"]
        case .dashboard: return ["AnalyticsKit", "ExportKit"]
        case .marketplace: return ["MarketplaceKit", "UserKit"]
        case .engine: return ["WorkflowKit", "AgentKit", "LearnKit"]
        case .compiler: return ["ParseKit", "SyntaxKit"]
        case .orchestrator: return ["WorkflowKit", "AgentKit", "SystemKit"]
        case .utility: return ["CommandKit", "FileKit"]
        }
    }
    
    // MARK: - Complexity Prediction
    
    private func predictComplexity(for idea: AppIdea) -> Complexity {
        var score = 0
        
        // Feature count
        score += idea.features.count * 2
        
        // Required kits
        score += idea.requiredKits.count * 3
        
        // Category complexity
        switch idea.category {
        case .metaApp, .framework, .platform, .enterprise:
            score += 20
        case .aiFirst, .mlPowered:
            score += 15
        case .automation, .marketplace:
            score += 10
        case .developerTool, .builderTool:
            score += 8
        default:
            score += 5
        }
        
        // Type complexity
        switch idea.type {
        case .engine, .orchestrator, .compiler:
            score += 15
        case .builder, .analyzer:
            score += 10
        case .generator, .converter:
            score += 5
        default:
            score += 3
        }
        
        // Description length (more detail = more complex)
        score += idea.description.count / 100
        
        return complexityFromScore(score)
    }
    
    private func complexityFromScore(_ score: Int) -> Complexity {
        switch score {
        case 0..<10: return .trivial
        case 10..<20: return .simple
        case 20..<35: return .medium
        case 35..<50: return .complex
        case 50..<70: return .advanced
        default: return .enterprise
        }
    }
    
    // MARK: - Topic Extraction
    
    private func extractTopics(from idea: AppIdea) -> [String] {
        var topics: Set<String> = []
        
        topics.insert(idea.category.rawValue)
        topics.insert(idea.kind.rawValue)
        topics.insert(idea.type.rawValue)
        
        // Add derived topics
        let text = idea.description.lowercased()
        let topicKeywords: [String: String] = [
            "automat": "Automation",
            "generat": "Generation",
            "analyz": "Analysis",
            "search": "Search",
            "learn": "Learning",
            "ai": "AI/ML",
            "workflow": "Workflows",
            "agent": "Agents",
            "document": "Documentation",
            "code": "Code",
            "project": "Projects",
            "team": "Collaboration"
        ]
        
        for (keyword, topic) in topicKeywords {
            if text.contains(keyword) {
                topics.insert(topic)
            }
        }
        
        return Array(topics)
    }
    
    // MARK: - Confidence
    
    private func calculateConfidence(_ idea: AppIdea) -> Float {
        var confidence: Float = 0.5
        
        // More description = higher confidence
        if idea.description.count > 50 { confidence += 0.1 }
        if idea.description.count > 100 { confidence += 0.1 }
        
        // Features defined
        if !idea.features.isEmpty { confidence += 0.1 }
        
        // Context filled
        if !idea.context.problemStatement.isEmpty { confidence += 0.1 }
        if !idea.context.targetAudience.isEmpty { confidence += 0.05 }
        if !idea.context.useCases.isEmpty { confidence += 0.05 }
        
        return min(confidence, 1.0)
    }
}

// MARK: - Analysis Result

public struct AnalysisResult: Sendable {
    public let keywords: [String]
    public let suggestedKits: [String]
    public let predictedComplexity: Complexity
    public let topics: [String]
    public let confidenceScore: Float
}
