//
//  LearnError.swift
//  LearnKit
//

import Foundation

public enum LearnError: LocalizedError, Sendable {
    case lessonNotFound(UUID)
    case progressSaveFailed(String)
    case invalidLesson(String)
    case prerequisiteNotMet(String)
    
    public var errorDescription: String? {
        switch self {
        case .lessonNotFound(let id): return "Lesson not found: \(id)"
        case .progressSaveFailed(let msg): return "Failed to save progress: \(msg)"
        case .invalidLesson(let msg): return "Invalid lesson: \(msg)"
        case .prerequisiteNotMet(let lesson): return "Prerequisite not met: \(lesson)"
        }
    }
    
    public var icon: String {
        switch self {
        case .lessonNotFound: return "book"
        case .progressSaveFailed: return "exclamationmark.triangle"
        case .invalidLesson: return "xmark.circle"
        case .prerequisiteNotMet: return "lock"
        }
    }
}
