//
//  ContextMemory.swift
//  IdeaKit - Project Operating System
//
//  Tool: ContextMemory
//  Phase: Learning
//  Purpose: Learn from project for future - patterns, lessons, what worked/failed
//  Outputs: lessons_learned.md, patterns.json
//

import Foundation

/// Learns from project execution for future improvements
public final class ContextMemory: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "context_memory"
    public static let name = "Context Memory"
    public static let description = "Learn from project execution to improve future projects"
    public static let phase = ProjectPhase.learning
    public static let outputs = ["lessons_learned.md", "patterns.json"]
    public static let inputs = ["*.md", "*.json"]
    public static let isDefault = true
    
    // MARK: - Singleton
    
    public static let shared = ContextMemory()
    private init() {}
    
    // MARK: - State
    
    private var lessons: [Lesson] = []
    private var patterns: [Pattern] = []
    private var decisions: [Decision] = []
    
    // MARK: - Initialization
    
    /// Initialize context memory for a project
    public func initialize(context: ProjectContext) async throws {
        // Load existing lessons if available
        let lessonsPath = context.artifactsPath.appendingPathComponent("lessons.json")
        if FileManager.default.fileExists(atPath: lessonsPath.path) {
            let data = try Data(contentsOf: lessonsPath)
            lessons = try JSONDecoder().decode([Lesson].self, from: data)
        }
        
        // Load existing patterns
        let patternsPath = context.artifactsPath.appendingPathComponent("patterns.json")
        if FileManager.default.fileExists(atPath: patternsPath.path) {
            let data = try Data(contentsOf: patternsPath)
            patterns = try JSONDecoder().decode([Pattern].self, from: data)
        }
    }
    
    // MARK: - Recording
    
    /// Record a lesson learned
    public func recordLesson(_ lesson: Lesson) {
        lessons.append(lesson)
    }
    
    /// Record a pattern observed
    public func recordPattern(_ pattern: Pattern) {
        // Check if pattern already exists
        if let index = patterns.firstIndex(where: { $0.name == pattern.name }) {
            patterns[index].occurrences += 1
            patterns[index].lastSeen = Date()
        } else {
            patterns.append(pattern)
        }
    }
    
    /// Record a decision
    public func recordDecision(_ decision: Decision) {
        decisions.append(decision)
    }
    
    // MARK: - Retrieval
    
    /// Get relevant lessons for a topic
    public func getLessons(for topic: String) -> [Lesson] {
        lessons.filter { lesson in
            lesson.tags.contains { $0.lowercased().contains(topic.lowercased()) } ||
            lesson.title.lowercased().contains(topic.lowercased())
        }
    }
    
    /// Get patterns by category
    public func getPatterns(category: PatternCategory) -> [Pattern] {
        patterns.filter { $0.category == category }
    }
    
    // MARK: - Generation
    
    /// Generate lessons learned markdown
    public func generateLessonsMarkdown() -> String {
        var md = """
        # Lessons Learned
        
        _Captured insights from project execution_
        
        ## Summary
        
        - Total Lessons: \(lessons.count)
        - Positive Outcomes: \(lessons.filter { $0.outcome == .positive }.count)
        - Negative Outcomes: \(lessons.filter { $0.outcome == .negative }.count)
        
        """
        
        // Group by category
        let grouped = Dictionary(grouping: lessons, by: { $0.category })
        
        for category in LessonCategory.allCases {
            guard let categoryLessons = grouped[category], !categoryLessons.isEmpty else { continue }
            
            md += "\n## \(category.rawValue.capitalized)\n\n"
            
            for lesson in categoryLessons {
                let outcomeEmoji = lesson.outcome == .positive ? "✅" : "❌"
                
                md += """
                ### \(outcomeEmoji) \(lesson.title)
                
                **What happened**: \(lesson.description)
                
                **Impact**: \(lesson.impact)
                
                **Recommendation**: \(lesson.recommendation)
                
                _Tags: \(lesson.tags.joined(separator: ", "))_
                
                """
            }
        }
        
        md += """
        
        ---
        
        ## Decisions Log
        
        | Decision | Rationale | Outcome |
        |----------|-----------|---------|
        """
        
        for decision in decisions {
            let outcomeStr = decision.outcome.map { $0 ? "✅" : "❌" } ?? "⏳"
            md += "\n| \(decision.title) | \(decision.rationale) | \(outcomeStr) |"
        }
        
        return md
    }
    
    /// Generate patterns JSON
    public func generatePatternsJSON() -> [String: Any] {
        [
            "patterns": patterns.map { pattern in
                [
                    "id": pattern.id.uuidString,
                    "name": pattern.name,
                    "category": pattern.category.rawValue,
                    "description": pattern.description,
                    "occurrences": pattern.occurrences,
                    "effectiveness": pattern.effectiveness,
                    "lastSeen": ISO8601DateFormatter().string(from: pattern.lastSeen)
                ]
            },
            "summary": [
                "totalPatterns": patterns.count,
                "byCategory": Dictionary(grouping: patterns, by: { $0.category }).mapValues { $0.count }
            ],
            "generatedAt": ISO8601DateFormatter().string(from: Date())
        ]
    }
    
    /// Save current state
    public func save(to context: ProjectContext) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        // Save lessons
        let lessonsData = try encoder.encode(lessons)
        let lessonsPath = context.artifactsPath.appendingPathComponent("lessons.json")
        try lessonsData.write(to: lessonsPath)
        
        // Save patterns
        let patternsData = try encoder.encode(patterns)
        let patternsPath = context.artifactsPath.appendingPathComponent("patterns.json")
        try patternsData.write(to: patternsPath)
    }
}

// MARK: - Supporting Types

public struct Lesson: Codable, Sendable, Identifiable {
    public var id: UUID
    public var title: String
    public var description: String
    public var category: LessonCategory
    public var outcome: LessonOutcome
    public var impact: String
    public var recommendation: String
    public var tags: [String]
    public var recordedAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        category: LessonCategory,
        outcome: LessonOutcome,
        impact: String = "",
        recommendation: String = "",
        tags: [String] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.outcome = outcome
        self.impact = impact
        self.recommendation = recommendation
        self.tags = tags
        self.recordedAt = Date()
    }
}

public enum LessonCategory: String, Codable, CaseIterable, Sendable {
    case architecture, process, tooling, communication, testing, deployment
}

public enum LessonOutcome: String, Codable, Sendable {
    case positive, negative, neutral
}

public struct Pattern: Codable, Sendable, Identifiable {
    public var id: UUID
    public var name: String
    public var category: PatternCategory
    public var description: String
    public var occurrences: Int
    public var effectiveness: Double
    public var lastSeen: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        category: PatternCategory,
        description: String,
        occurrences: Int = 1,
        effectiveness: Double = 0.5
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.description = description
        self.occurrences = occurrences
        self.effectiveness = effectiveness
        self.lastSeen = Date()
    }
}

public enum PatternCategory: String, Codable, CaseIterable, Sendable {
    case architecture, code, process, testing, documentation
}

public struct Decision: Codable, Sendable, Identifiable {
    public var id: UUID
    public var title: String
    public var rationale: String
    public var alternatives: [String]
    public var outcome: Bool?
    public var recordedAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        rationale: String,
        alternatives: [String] = [],
        outcome: Bool? = nil
    ) {
        self.id = id
        self.title = title
        self.rationale = rationale
        self.alternatives = alternatives
        self.outcome = outcome
        self.recordedAt = Date()
    }
}
