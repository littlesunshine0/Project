//
//  LearnCard.swift
//  LearnKit
//
//  Reusable Learning card components
//

import SwiftUI

// MARK: - Lesson Card

public struct LessonCard: View {
    public let lesson: Lesson
    public let progress: LessonProgress?
    public var onStart: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    public init(lesson: Lesson, progress: LessonProgress? = nil, onStart: (() -> Void)? = nil) {
        self.lesson = lesson
        self.progress = progress
        self.onStart = onStart
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle().fill(categoryColor.opacity(0.15)).frame(width: 40, height: 40)
                    Image(systemName: lesson.icon).font(.system(size: 18, weight: .semibold)).foregroundStyle(categoryColor)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(lesson.title).font(.headline).foregroundStyle(primaryTextColor)
                    Text(lesson.category.rawValue.capitalized).font(.caption).foregroundStyle(secondaryTextColor)
                }
                Spacer()
                if let progress = progress, progress.isCompleted {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                }
            }
            
            Text(lesson.description).font(.subheadline).foregroundStyle(secondaryTextColor).lineLimit(2)

            // Progress bar
            if let progress = progress, !progress.isCompleted {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(progress.completedSteps.count)/\(lesson.steps.count) steps")
                            .font(.caption2).foregroundStyle(secondaryTextColor)
                        Spacer()
                        Text("\(Int(Double(progress.completedSteps.count) / Double(lesson.steps.count) * 100))%")
                            .font(.caption2).fontWeight(.medium).foregroundStyle(categoryColor)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2).fill(Color.gray.opacity(0.2)).frame(height: 4)
                            RoundedRectangle(cornerRadius: 2).fill(categoryColor)
                                .frame(width: geo.size.width * CGFloat(progress.completedSteps.count) / CGFloat(lesson.steps.count), height: 4)
                        }
                    }.frame(height: 4)
                }
            }
            
            HStack {
                Label("\(lesson.estimatedMinutes) min", systemImage: "clock").font(.caption2).foregroundStyle(tertiaryTextColor)
                Label("\(lesson.steps.count) steps", systemImage: "list.bullet").font(.caption2).foregroundStyle(tertiaryTextColor)
                Spacer()
                if let onStart = onStart {
                    Button(action: onStart) {
                        Text(progress == nil ? "Start" : (progress?.isCompleted == true ? "Review" : "Continue"))
                            .font(.caption).fontWeight(.medium).foregroundStyle(.white)
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(categoryColor).clipShape(Capsule())
                    }.buttonStyle(.plain)
                }
            }
        }
        .padding(16).background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(isHovered ? categoryColor.opacity(0.3) : Color.clear, lineWidth: 1))
        .scaleEffect(isHovered ? 1.01 : 1.0).animation(.easeOut(duration: 0.15), value: isHovered).onHover { isHovered = $0 }
    }
    
    private var categoryColor: Color {
        switch lesson.category {
        case .basics: return .blue; case .workflows: return .purple; case .commands: return .pink
        case .agents: return .orange; case .documentation: return .teal; case .advanced: return .red
        }
    }
    private var primaryTextColor: Color { colorScheme == .dark ? .white : .black }
    private var secondaryTextColor: Color { colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6) }
    private var tertiaryTextColor: Color { colorScheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.4) }
    private var cardBackground: some ShapeStyle { colorScheme == .dark ? Color(white: 0.15) : Color.white }
}
