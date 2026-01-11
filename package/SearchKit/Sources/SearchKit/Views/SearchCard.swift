//
//  SearchCard.swift
//  SearchKit
//
//  Reusable Search card components
//

import SwiftUI

// MARK: - Search Result Card

public struct SearchResultCard: View {
    public let result: SearchResult
    public var onSelect: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    public init(result: SearchResult, onSelect: (() -> Void)? = nil) {
        self.result = result
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: { onSelect?() }) {
            HStack(spacing: 12) {
                // Type icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(typeColor.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: typeIcon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(typeColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(result.title)
                            .font(.headline)
                            .foregroundStyle(primaryTextColor)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        // Relevance indicator
                        RelevanceBadge(score: result.relevance)
                    }
                    
                    if !result.subtitle.isEmpty {
                        Text(result.subtitle)
                            .font(.caption)
                            .foregroundStyle(secondaryTextColor)
                            .lineLimit(1)
                    }
                    
                    if !result.content.isEmpty {
                        Text(result.content)
                            .font(.caption)
                            .foregroundStyle(tertiaryTextColor)
                            .lineLimit(2)
                    }
                    
                    HStack(spacing: 8) {
                        Text(result.type.rawValue.capitalized)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(typeColor.opacity(0.1))
                            .foregroundStyle(typeColor)
                            .clipShape(Capsule())
                        
                        if let path = result.path {
                            Text(path)
                                .font(.caption2)
                                .foregroundStyle(tertiaryTextColor)
                                .lineLimit(1)
                        }
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(tertiaryTextColor)
                    .opacity(isHovered ? 1 : 0.5)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(isHovered ? typeColor.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
            )
            .scaleEffect(isHovered ? 1.01 : 1.0)
            .animation(.easeOut(duration: 0.15), value: isHovered)
            .onHover { isHovered = $0 }
        }
        .buttonStyle(.plain)
    }
    
    private var typeColor: Color {
        switch result.type {
        case .documentation: return .teal
        case .document: return .blue
        case .code: return .orange
        case .asset: return .pink
        case .workflow: return .purple
        case .project: return .green
        case .template: return .indigo
        case .command: return .red
        case .file: return .gray
        }
    }
    
    private var typeIcon: String {
        switch result.type {
        case .documentation: return "book.closed"
        case .document: return "doc.text"
        case .code: return "chevron.left.forwardslash.chevron.right"
        case .asset: return "photo"
        case .workflow: return "arrow.triangle.branch"
        case .project: return "folder"
        case .template: return "doc.on.doc"
        case .command: return "terminal"
        case .file: return "doc"
        }
    }
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6)
    }
    
    private var tertiaryTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.4)
    }
    
    private var cardBackground: some ShapeStyle {
        colorScheme == .dark ? Color(white: 0.15) : Color.white
    }
}

// MARK: - Relevance Badge

struct RelevanceBadge: View {
    let score: Double
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(index < relevanceLevel ? relevanceColor : Color.gray.opacity(0.3))
                    .frame(width: 4, height: 4)
            }
        }
    }
    
    private var relevanceLevel: Int {
        if score >= 80 { return 3 }
        if score >= 40 { return 2 }
        if score > 0 { return 1 }
        return 0
    }
    
    private var relevanceColor: Color {
        if score >= 80 { return .green }
        if score >= 40 { return .orange }
        return .gray
    }
}

// MARK: - Recent Search Card

public struct RecentSearchCard: View {
    public let query: SearchQuery
    public var onSelect: (() -> Void)?
    public var onSave: (() -> Void)?
    public var onDelete: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(
        query: SearchQuery,
        onSelect: (() -> Void)? = nil,
        onSave: (() -> Void)? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.query = query
        self.onSelect = onSelect
        self.onSave = onSave
        self.onDelete = onDelete
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Button(action: { onSelect?() }) {
                HStack(spacing: 8) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.caption)
                        .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
                    
                    Text(query.query)
                        .font(.subheadline)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(query.timestamp, style: .relative)
                        .font(.caption2)
                        .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.4))
                }
            }
            .buttonStyle(.plain)
            
            if let onSave = onSave {
                Button(action: onSave) {
                    Image(systemName: "bookmark")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
            }
            
            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.4))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(colorScheme == .dark ? Color(white: 0.12) : Color.gray.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

// MARK: - Preview

#Preview("Search Cards") {
    VStack(spacing: 16) {
        SearchResultCard(
            result: SearchResult(
                type: .documentation,
                title: "Getting Started Guide",
                subtitle: "Learn the basics of FlowKit",
                content: "This guide will help you get started with FlowKit...",
                path: "/docs/getting-started.md",
                relevance: 85
            ),
            onSelect: {}
        )
        
        RecentSearchCard(
            query: SearchQuery(query: "workflow automation"),
            onSelect: {},
            onSave: {},
            onDelete: {}
        )
    }
    .padding()
    .frame(width: 400)
}
