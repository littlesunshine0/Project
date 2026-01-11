//
//  FeedbackIngestor.swift
//  IdeaKit - Project Operating System
//
//  Tool: FeedbackIngestor
//  Phase: Execution
//  Purpose: Capture feedback continuously - user, developer, TODOs
//  Outputs: feedback.md
//

import Foundation

/// Ingests and organizes project feedback
public final class FeedbackIngestor: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "feedback_ingestor"
    public static let name = "Feedback Ingestor"
    public static let description = "Capture and organize feedback from users, developers, and code TODOs"
    public static let phase = ProjectPhase.execution
    public static let outputs = ["feedback.md"]
    public static let inputs: [String] = []
    public static let isDefault = false
    
    // MARK: - Singleton
    
    public static let shared = FeedbackIngestor()
    private init() {}
    
    // MARK: - State
    
    private var feedbackItems: [FeedbackItem] = []
    
    // MARK: - Ingestion
    
    /// Add feedback item
    public func ingest(_ item: FeedbackItem) {
        feedbackItems.append(item)
    }
    
    /// Ingest TODO from code
    public func ingestTODO(message: String, file: String, line: Int) {
        let item = FeedbackItem(
            source: .code,
            type: .todo,
            content: message,
            metadata: ["file": file, "line": String(line)]
        )
        feedbackItems.append(item)
    }
    
    /// Ingest user feedback
    public func ingestUserFeedback(content: String, sentiment: FeedbackSentiment, category: String = "") {
        let item = FeedbackItem(
            source: .user,
            type: .feedback,
            content: content,
            sentiment: sentiment,
            metadata: category.isEmpty ? [:] : ["category": category]
        )
        feedbackItems.append(item)
    }
    
    /// Ingest developer note
    public func ingestDeveloperNote(content: String, priority: FeedbackPriority = .medium) {
        let item = FeedbackItem(
            source: .developer,
            type: .note,
            content: content,
            priority: priority
        )
        feedbackItems.append(item)
    }
    
    // MARK: - Retrieval
    
    /// Get all feedback
    public func allFeedback() -> [FeedbackItem] {
        feedbackItems
    }
    
    /// Get feedback by source
    public func feedback(from source: FeedbackSource) -> [FeedbackItem] {
        feedbackItems.filter { $0.source == source }
    }
    
    /// Get actionable items
    public func actionableItems() -> [FeedbackItem] {
        feedbackItems.filter { $0.status == .open && $0.priority != .low }
    }
    
    // MARK: - Generation
    
    /// Generate feedback markdown
    public func generateMarkdown() -> String {
        var md = """
        # Project Feedback
        
        ## Summary
        
        | Source | Count | Open | Resolved |
        |--------|-------|------|----------|
        """
        
        for source in FeedbackSource.allCases {
            let items = feedback(from: source)
            let open = items.filter { $0.status == .open }.count
            let resolved = items.filter { $0.status == .resolved }.count
            md += "\n| \(source.rawValue.capitalized) | \(items.count) | \(open) | \(resolved) |"
        }
        
        md += "\n\n"
        
        // Actionable items first
        let actionable = actionableItems()
        if !actionable.isEmpty {
            md += """
            ## 🎯 Actionable Items
            
            \(actionable.map { itemRow($0) }.joined(separator: "\n"))
            
            """
        }
        
        // By source
        for source in FeedbackSource.allCases {
            let items = feedback(from: source)
            if !items.isEmpty {
                md += """
                
                ## \(sourceEmoji(source)) \(source.rawValue.capitalized) Feedback
                
                \(items.map { itemRow($0) }.joined(separator: "\n"))
                
                """
            }
        }
        
        // Sentiment analysis
        let userFeedback = feedback(from: .user)
        if !userFeedback.isEmpty {
            md += """
            
            ## Sentiment Analysis
            
            | Sentiment | Count | Percentage |
            |-----------|-------|------------|
            """
            
            for sentiment in FeedbackSentiment.allCases {
                let count = userFeedback.filter { $0.sentiment == sentiment }.count
                let percentage = userFeedback.isEmpty ? 0 : (Double(count) / Double(userFeedback.count)) * 100
                md += "\n| \(sentimentEmoji(sentiment)) \(sentiment.rawValue.capitalized) | \(count) | \(Int(percentage))% |"
            }
        }
        
        return md
    }
    
    // MARK: - Private Helpers
    
    private func itemRow(_ item: FeedbackItem) -> String {
        let priorityEmoji = priorityEmoji(item.priority)
        let statusEmoji = item.status == .open ? "⏳" : "✅"
        
        var row = "- \(priorityEmoji) \(statusEmoji) **\(item.type.rawValue.uppercased())**: \(item.content)"
        
        if let file = item.metadata["file"], let line = item.metadata["line"] {
            row += " (`\(file):\(line)`)"
        }
        
        return row
    }
    
    private func sourceEmoji(_ source: FeedbackSource) -> String {
        switch source {
        case .user: return "👤"
        case .developer: return "👨‍💻"
        case .code: return "📝"
        case .automated: return "🤖"
        }
    }
    
    private func priorityEmoji(_ priority: FeedbackPriority) -> String {
        switch priority {
        case .critical: return "🔴"
        case .high: return "🟠"
        case .medium: return "🟡"
        case .low: return "🟢"
        }
    }
    
    private func sentimentEmoji(_ sentiment: FeedbackSentiment) -> String {
        switch sentiment {
        case .positive: return "😊"
        case .neutral: return "😐"
        case .negative: return "😞"
        }
    }
}

// MARK: - Supporting Types

public struct FeedbackItem: Sendable, Identifiable {
    public var id: UUID
    public var source: FeedbackSource
    public var type: FeedbackType
    public var content: String
    public var sentiment: FeedbackSentiment
    public var priority: FeedbackPriority
    public var status: FeedbackStatus
    public var metadata: [String: String]
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        source: FeedbackSource,
        type: FeedbackType,
        content: String,
        sentiment: FeedbackSentiment = .neutral,
        priority: FeedbackPriority = .medium,
        status: FeedbackStatus = .open,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.source = source
        self.type = type
        self.content = content
        self.sentiment = sentiment
        self.priority = priority
        self.status = status
        self.metadata = metadata
        self.createdAt = Date()
    }
}

public enum FeedbackSource: String, CaseIterable, Sendable {
    case user, developer, code, automated
}

public enum FeedbackType: String, Sendable {
    case feedback, bug, feature, todo, note, question
}

public enum FeedbackSentiment: String, CaseIterable, Sendable {
    case positive, neutral, negative
}

public enum FeedbackPriority: String, Sendable {
    case critical, high, medium, low
}

public enum FeedbackStatus: String, Sendable {
    case open, inProgress, resolved, wontFix
}
