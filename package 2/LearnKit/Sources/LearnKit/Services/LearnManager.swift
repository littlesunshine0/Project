//
//  LearnManager.swift
//  LearnKit
//
//  Learning system management and progress tracking
//

import Foundation
import Combine

// MARK: - Learn Manager

@MainActor
public class LearnManager: ObservableObject {
    public static let shared = LearnManager()
    
    @Published public var lessons: [Lesson] = []
    @Published public var progress: [UUID: LessonProgress] = [:]
    @Published public var currentLesson: Lesson?
    @Published public var isLoading = false
    
    private let progressKey = "lessonProgress"
    
    private init() {
        loadLessons()
        loadProgress()
    }
    
    // MARK: - Lesson Management
    
    public func startLesson(_ lesson: Lesson) {
        currentLesson = lesson
        if progress[lesson.id] == nil {
            progress[lesson.id] = LessonProgress(lessonId: lesson.id)
        }
        saveProgress()
    }
    
    public func completeStep(_ stepIndex: Int) {
        guard let lesson = currentLesson else { return }
        if var lessonProgress = progress[lesson.id] {
            lessonProgress.completedSteps.insert(stepIndex)
            lessonProgress.lastAccessedAt = Date()
            progress[lesson.id] = lessonProgress
            saveProgress()
        }
    }
    
    public func completeLesson(_ lesson: Lesson) {
        if var lessonProgress = progress[lesson.id] {
            lessonProgress.isCompleted = true
            lessonProgress.completedAt = Date()
            progress[lesson.id] = lessonProgress
            saveProgress()
        }
        currentLesson = nil
    }
    
    // MARK: - Query
    
    public func getLessons(byCategory category: LessonCategory) -> [Lesson] {
        lessons.filter { $0.category == category }
    }
    
    public func getProgress(for lesson: Lesson) -> LessonProgress? {
        progress[lesson.id]
    }
    
    public func isCompleted(_ lesson: Lesson) -> Bool {
        progress[lesson.id]?.isCompleted ?? false
    }
    
    // MARK: - Statistics
    
    public var totalLessons: Int { lessons.count }
    public var completedLessons: Int { progress.values.filter { $0.isCompleted }.count }
    public var completionRate: Double {
        guard totalLessons > 0 else { return 0 }
        return Double(completedLessons) / Double(totalLessons)
    }
    
    // MARK: - Persistence
    
    private func loadLessons() {
        lessons = Lesson.builtInLessons
    }
    
    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode([UUID: LessonProgress].self, from: data) {
            progress = decoded
        }
    }
    
    private func saveProgress() {
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: progressKey)
        }
    }
}

// MARK: - Lesson

public struct Lesson: Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let description: String
    public let category: LessonCategory
    public let steps: [LessonStep]
    public let estimatedMinutes: Int
    public let icon: String
    
    public init(id: UUID = UUID(), title: String, description: String, category: LessonCategory, steps: [LessonStep], estimatedMinutes: Int, icon: String = "book") {
        self.id = id; self.title = title; self.description = description; self.category = category
        self.steps = steps; self.estimatedMinutes = estimatedMinutes; self.icon = icon
    }
    
    public static let builtInLessons: [Lesson] = [
        Lesson(title: "Getting Started", description: "Learn the basics of FlowKit", category: .basics,
               steps: [LessonStep(title: "Welcome", content: "Welcome to FlowKit!"), LessonStep(title: "Navigation", content: "Learn to navigate.")],
               estimatedMinutes: 5, icon: "star"),
        Lesson(title: "Creating Workflows", description: "Build your first workflow", category: .workflows,
               steps: [LessonStep(title: "What is a Workflow?", content: "Workflows automate tasks."), LessonStep(title: "Create One", content: "Let's create a workflow.")],
               estimatedMinutes: 10, icon: "arrow.triangle.branch"),
        Lesson(title: "Using Commands", description: "Master the command system", category: .commands,
               steps: [LessonStep(title: "Command Basics", content: "Commands start with /."), LessonStep(title: "Common Commands", content: "Learn common commands.")],
               estimatedMinutes: 8, icon: "terminal")
    ]
}

public struct LessonStep: Sendable {
    public let title: String
    public let content: String
    public init(title: String, content: String) { self.title = title; self.content = content }
}

public enum LessonCategory: String, CaseIterable, Codable, Sendable {
    case basics = "Basics"
    case workflows = "Workflows"
    case commands = "Commands"
    case agents = "Agents"
    case documentation = "Documentation"
    case advanced = "Advanced"
    
    public var icon: String {
        switch self {
        case .basics: return "star"
        case .workflows: return "arrow.triangle.branch"
        case .commands: return "terminal"
        case .agents: return "cpu"
        case .documentation: return "doc.text"
        case .advanced: return "graduationcap"
        }
    }
}

public struct LessonProgress: Codable, Sendable {
    public let lessonId: UUID
    public var completedSteps: Set<Int>
    public var isCompleted: Bool
    public var startedAt: Date
    public var lastAccessedAt: Date
    public var completedAt: Date?
    
    public init(lessonId: UUID) {
        self.lessonId = lessonId; self.completedSteps = []; self.isCompleted = false
        self.startedAt = Date(); self.lastAccessedAt = Date(); self.completedAt = nil
    }
}
