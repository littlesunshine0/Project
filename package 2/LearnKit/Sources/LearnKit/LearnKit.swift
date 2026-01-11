//
//  LearnKit.swift
//  LearnKit
//
//  Machine Learning & Prediction System
//

import Foundation

/// LearnKit - Machine Learning & Prediction System
public struct LearnKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.learnkit"
    
    public init() {}
    
    /// Record a user action for learning
    public static func record(_ action: UserAction) async {
        await LearningEngine.shared.record(action)
    }
    
    /// Predict next likely action
    public static func predict(context: PredictionContext) async -> [Prediction] {
        await LearningEngine.shared.predict(context: context)
    }
    
    /// Get personalized suggestions
    public static func suggest(for userId: String, limit: Int = 5) async -> [Suggestion] {
        await LearningEngine.shared.suggest(for: userId, limit: limit)
    }
    
    /// Train model with historical data
    public static func train(with data: [TrainingData]) async {
        await LearningEngine.shared.train(with: data)
    }
}

// MARK: - User Action

public struct UserAction: Codable, Sendable {
    public let id: UUID
    public let userId: String
    public let actionType: ActionType
    public let target: String
    public let context: [String: String]
    public let timestamp: Date
    
    public init(id: UUID = UUID(), userId: String, actionType: ActionType, target: String, context: [String: String] = [:], timestamp: Date = Date()) {
        self.id = id
        self.userId = userId
        self.actionType = actionType
        self.target = target
        self.context = context
        self.timestamp = timestamp
    }
    
    public enum ActionType: String, Codable, CaseIterable, Sendable {
        case executeWorkflow, createWorkflow, searchDocs, viewAnalytics, runCommand, openFile, editFile, saveFile
    }
}

// MARK: - Prediction

public struct Prediction: Identifiable, Sendable {
    public let id: UUID
    public let actionType: UserAction.ActionType
    public let target: String
    public let confidence: Double
    public let reason: String
    
    public init(id: UUID = UUID(), actionType: UserAction.ActionType, target: String, confidence: Double, reason: String = "") {
        self.id = id
        self.actionType = actionType
        self.target = target
        self.confidence = confidence
        self.reason = reason
    }
}

public struct PredictionContext: Sendable {
    public let userId: String
    public let currentFile: String?
    public let recentActions: [UserAction.ActionType]
    public let timeOfDay: Int
    
    public init(userId: String, currentFile: String? = nil, recentActions: [UserAction.ActionType] = [], timeOfDay: Int = Calendar.current.component(.hour, from: Date())) {
        self.userId = userId
        self.currentFile = currentFile
        self.recentActions = recentActions
        self.timeOfDay = timeOfDay
    }
}

// MARK: - Suggestion

public struct Suggestion: Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let description: String
    public let actionType: UserAction.ActionType
    public let target: String
    public let score: Double
    
    public init(id: UUID = UUID(), title: String, description: String, actionType: UserAction.ActionType, target: String, score: Double) {
        self.id = id
        self.title = title
        self.description = description
        self.actionType = actionType
        self.target = target
        self.score = score
    }
}

// MARK: - Training Data

public struct TrainingData: Codable, Sendable {
    public let actions: [UserAction]
    public let outcomes: [String: Double]
    
    public init(actions: [UserAction], outcomes: [String: Double] = [:]) {
        self.actions = actions
        self.outcomes = outcomes
    }
}

// MARK: - Learn Section

public enum LearnSection: String, CaseIterable, Sendable {
    case all = "All Lessons"
    case inProgress = "In Progress"
    case completed = "Completed"
    case recommended = "Recommended"
    
    public var icon: String {
        switch self {
        case .all: return "book"
        case .inProgress: return "play.circle"
        case .completed: return "checkmark.circle"
        case .recommended: return "star"
        }
    }
}

// MARK: - Learning Engine

public actor LearningEngine {
    public static let shared = LearningEngine()
    
    private var actionHistory: [UserAction] = []
    private var actionCounts: [String: Int] = [:]
    private var sequencePatterns: [[UserAction.ActionType]: UserAction.ActionType] = [:]
    
    private init() {}
    
    public func record(_ action: UserAction) {
        actionHistory.append(action)
        
        // Update counts
        let key = "\(action.userId):\(action.actionType.rawValue):\(action.target)"
        actionCounts[key, default: 0] += 1
        
        // Learn sequences
        if actionHistory.count >= 3 {
            let recent = actionHistory.suffix(3).map { $0.actionType }
            let pattern = Array(recent.dropLast())
            sequencePatterns[pattern] = recent.last!
        }
        
        // Keep history bounded
        if actionHistory.count > 10000 {
            actionHistory.removeFirst(1000)
        }
    }
    
    public func predict(context: PredictionContext) async -> [Prediction] {
        var predictions: [Prediction] = []
        
        // Pattern-based prediction
        if context.recentActions.count >= 2 {
            let pattern = Array(context.recentActions.suffix(2))
            if let nextAction = sequencePatterns[pattern] {
                predictions.append(Prediction(actionType: nextAction, target: "", confidence: 0.7, reason: "Based on your recent pattern"))
            }
        }
        
        // Frequency-based prediction
        let userActions = actionHistory.filter { $0.userId == context.userId }
        let grouped = Dictionary(grouping: userActions) { $0.actionType }
        let sorted = grouped.sorted { $0.value.count > $1.value.count }
        
        for (actionType, actions) in sorted.prefix(3) {
            let mostCommonTarget = Dictionary(grouping: actions) { $0.target }.max { $0.value.count < $1.value.count }?.key ?? ""
            let confidence = Double(actions.count) / Double(max(userActions.count, 1))
            
            if !predictions.contains(where: { $0.actionType == actionType }) {
                predictions.append(Prediction(actionType: actionType, target: mostCommonTarget, confidence: min(confidence, 0.9), reason: "Frequently used"))
            }
        }
        
        // Time-based prediction
        let hourActions = userActions.filter {
            Calendar.current.component(.hour, from: $0.timestamp) == context.timeOfDay
        }
        if let mostCommon = Dictionary(grouping: hourActions) { $0.actionType }.max(by: { $0.value.count < $1.value.count }) {
            if !predictions.contains(where: { $0.actionType == mostCommon.key }) {
                predictions.append(Prediction(actionType: mostCommon.key, target: "", confidence: 0.5, reason: "Common at this time"))
            }
        }
        
        return predictions.sorted { $0.confidence > $1.confidence }.prefix(5).map { $0 }
    }
    
    public func suggest(for userId: String, limit: Int) async -> [Suggestion] {
        let context = PredictionContext(userId: userId)
        let predictions = await predict(context: context)
        
        return predictions.prefix(limit).map { prediction in
            Suggestion(
                title: "Run \(prediction.actionType.rawValue)",
                description: prediction.reason,
                actionType: prediction.actionType,
                target: prediction.target,
                score: prediction.confidence
            )
        }
    }
    
    public func train(with data: [TrainingData]) {
        for trainingData in data {
            for action in trainingData.actions {
                actionHistory.append(action)
            }
        }
        
        // Rebuild patterns
        sequencePatterns.removeAll()
        for i in 2..<actionHistory.count {
            let pattern = [actionHistory[i-2].actionType, actionHistory[i-1].actionType]
            sequencePatterns[pattern] = actionHistory[i].actionType
        }
    }
    
    public func getStats() -> (actionCount: Int, patternCount: Int) {
        (actionHistory.count, sequencePatterns.count)
    }
}
