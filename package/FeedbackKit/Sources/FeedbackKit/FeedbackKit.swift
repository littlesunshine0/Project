//
//  FeedbackKit.swift
//  FeedbackKit
//
//  Feedback collection and contextual suggestions
//

import Foundation

public struct FeedbackKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.feedbackkit"
    public init() {}
}

// MARK: - Feedback Collection

public actor FeedbackCollector {
    public static let shared = FeedbackCollector()
    
    private var feedback: [UUID: FeedbackItem] = [:]
    private var categoryIndex: [FeedbackCategory: Set<UUID>] = [:]
    private var ratingStats: [Int: Int] = [:]  // rating -> count
    
    private init() {}
    
    public func submit(_ item: FeedbackItem) -> UUID {
        feedback[item.id] = item
        categoryIndex[item.category, default: []].insert(item.id)
        if let rating = item.rating {
            ratingStats[rating, default: 0] += 1
        }
        return item.id
    }
    
    public func submit(message: String, category: FeedbackCategory = .general, rating: Int? = nil, context: [String: String] = [:]) -> UUID {
        let item = FeedbackItem(message: message, category: category, rating: rating, context: context)
        return submit(item)
    }
    
    public func getFeedback(_ id: UUID) -> FeedbackItem? { feedback[id] }
    
    public func getByCategory(_ category: FeedbackCategory) -> [FeedbackItem] {
        (categoryIndex[category] ?? []).compactMap { feedback[$0] }
    }
    
    public func getAll() -> [FeedbackItem] { Array(feedback.values) }
    
    public func getRecent(limit: Int = 50) -> [FeedbackItem] {
        Array(feedback.values.sorted { $0.submittedAt > $1.submittedAt }.prefix(limit))
    }

    public var stats: FeedbackStats {
        let avgRating: Double? = ratingStats.isEmpty ? nil : Double(ratingStats.reduce(0) { $0 + $1.key * $1.value }) / Double(ratingStats.values.reduce(0, +))
        return FeedbackStats(
            totalFeedback: feedback.count,
            byCategory: Dictionary(uniqueKeysWithValues: categoryIndex.map { ($0.key, $0.value.count) }),
            averageRating: avgRating
        )
    }
}

// MARK: - Contextual Suggestions

public actor SuggestionEngine {
    public static let shared = SuggestionEngine()
    
    private var suggestions: [UUID: Suggestion] = [:]
    private var rules: [SuggestionRule] = []
    private var contextHistory: [[String: String]] = []
    
    private init() {}
    
    public func addRule(_ rule: SuggestionRule) {
        rules.append(rule)
    }
    
    public func getSuggestions(for context: [String: String]) -> [Suggestion] {
        contextHistory.append(context)
        if contextHistory.count > 100 { contextHistory.removeFirst() }
        
        var result: [Suggestion] = []
        
        for rule in rules {
            if rule.matches(context) {
                let suggestion = Suggestion(title: rule.title, message: rule.message, priority: rule.priority, action: rule.action)
                suggestions[suggestion.id] = suggestion
                result.append(suggestion)
            }
        }
        
        return result.sorted { $0.priority.rawValue > $1.priority.rawValue }
    }
    
    public func dismissSuggestion(_ id: UUID) {
        suggestions.removeValue(forKey: id)
    }
    
    public func getActiveSuggestions() -> [Suggestion] {
        Array(suggestions.values).sorted { $0.priority.rawValue > $1.priority.rawValue }
    }
    
    public func getRules() -> [SuggestionRule] { rules }
}

// MARK: - Command Suggestions

public actor CommandSuggestionService {
    public static let shared = CommandSuggestionService()
    
    private var commandHistory: [String] = []
    private var frequencyMap: [String: Int] = [:]
    
    private init() {}
    
    public func recordCommand(_ command: String) {
        commandHistory.append(command)
        frequencyMap[command, default: 0] += 1
        if commandHistory.count > 500 { commandHistory.removeFirst() }
    }
    
    public func suggestCommands(for prefix: String) -> [String] {
        let matching = frequencyMap.keys.filter { $0.lowercased().hasPrefix(prefix.lowercased()) }
        return matching.sorted { (frequencyMap[$0] ?? 0) > (frequencyMap[$1] ?? 0) }
    }
    
    public func getFrequentCommands(limit: Int = 10) -> [String] {
        frequencyMap.sorted { $0.value > $1.value }.prefix(limit).map { $0.key }
    }
    
    public func getRecentCommands(limit: Int = 10) -> [String] {
        Array(commandHistory.suffix(limit).reversed())
    }
}

// MARK: - Models

public struct FeedbackItem: Identifiable, Sendable {
    public let id: UUID
    public let message: String
    public let category: FeedbackCategory
    public let rating: Int?
    public let context: [String: String]
    public let submittedAt: Date
    
    public init(id: UUID = UUID(), message: String, category: FeedbackCategory = .general, rating: Int? = nil, context: [String: String] = [:], submittedAt: Date = Date()) {
        self.id = id
        self.message = message
        self.category = category
        self.rating = rating
        self.context = context
        self.submittedAt = submittedAt
    }
}

public enum FeedbackCategory: String, Sendable, CaseIterable {
    case general, bug, feature, improvement, question, praise
}

public struct FeedbackStats: Sendable {
    public let totalFeedback: Int
    public let byCategory: [FeedbackCategory: Int]
    public let averageRating: Double?
}

public struct Suggestion: Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let message: String
    public let priority: SuggestionPriority
    public let action: String?
    public let createdAt: Date
    
    public init(id: UUID = UUID(), title: String, message: String, priority: SuggestionPriority = .medium, action: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.message = message
        self.priority = priority
        self.action = action
        self.createdAt = createdAt
    }
}

public enum SuggestionPriority: Int, Sendable, CaseIterable {
    case low = 1, medium = 2, high = 3, critical = 4
}

public struct SuggestionRule: Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let message: String
    public let conditions: [String: String]
    public let priority: SuggestionPriority
    public let action: String?
    
    public init(id: UUID = UUID(), title: String, message: String, conditions: [String: String], priority: SuggestionPriority = .medium, action: String? = nil) {
        self.id = id
        self.title = title
        self.message = message
        self.conditions = conditions
        self.priority = priority
        self.action = action
    }
    
    public func matches(_ context: [String: String]) -> Bool {
        for (key, value) in conditions {
            if context[key] != value { return false }
        }
        return true
    }
}
