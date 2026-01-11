//
//  LearnViewModel.swift
//  LearnKit
//

import Foundation
import Combine

@MainActor
public class LearnViewModel: ObservableObject {
    @Published public var lessons: [Lesson] = []
    @Published public var currentLesson: Lesson?
    @Published public var searchText = ""
    @Published public var selectedCategory: LessonCategory?
    @Published public var selectedSection: LearnSection = .all
    @Published public var isLoading = false
    @Published public var error: LearnError?
    
    private let manager: LearnManager
    
    public init(manager: LearnManager = .shared) {
        self.manager = manager
        loadLessons()
    }
    
    public func loadLessons() {
        lessons = manager.lessons
    }
    
    public func startLesson(_ lesson: Lesson) {
        manager.startLesson(lesson)
        currentLesson = lesson
    }
    
    public var filteredLessons: [Lesson] {
        var result = lessons
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
}
