//
//  LearnList.swift
//  LearnKit
//

import SwiftUI

public struct LearnList: View {
    @ObservedObject public var viewModel: LearnViewModel
    
    public init(viewModel: LearnViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.filteredLessons) { lesson in
                LearnRow(lesson: lesson)
                    .onTapGesture { viewModel.startLesson(lesson) }
            }
        }
        .listStyle(.plain)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.filteredLessons.isEmpty {
                ContentUnavailableView("No Lessons", systemImage: "book", description: Text("No lessons available"))
            }
        }
    }
}

public struct LearnRow: View {
    public let lesson: Lesson
    
    public init(lesson: Lesson) {
        self.lesson = lesson
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: lesson.icon)
                .font(.title3)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(lesson.title)
                    .font(.headline)
                
                Text(lesson.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text("\(lesson.estimatedMinutes) min")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}
