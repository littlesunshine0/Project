//
//  KnowledgeCard.swift
//  KnowledgeKit
//
//  Reusable Knowledge card components
//

import SwiftUI

// MARK: - Knowledge Entry Card

public struct KnowledgeEntryCard: View {
    public let entry: KnowledgeEntry
    public var onSelect: (() -> Void)?
    public var onFavorite: (() -> Void)?
    public var onDelete: (() -> Void)?
    public var isFavorite: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    public init(
        entry: KnowledgeEntry,
        isFavorite: Bool = false,
        onSelect: (() -> Void)? = nil,
        onFavorite: (() -> Void)? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.entry = entry
        self.isFavorite = isFavorite
        self.onSelect = onSelect
        self.onFavorite = onFavorite
        self.onDelete = onDelete
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                ZStack {
                    Circle().fill(categoryColor.opacity(0.15)).frame(width: 40, height: 40)
                    Image(systemName: categoryIcon).font(.system(size: 18, weight: .semibold)).foregroundStyle(categoryColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.title).font(.headline).foregroundStyle(primaryTextColor)
                    Text(entry.category.rawValue.capitalized).font(.caption).foregroundStyle(secondaryTextColor)
                }
                
                Spacer()

                if let onFavorite = onFavorite {
                    Button(action: onFavorite) {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundStyle(isFavorite ? .yellow : secondaryTextColor)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            // Content preview
            Text(entry.content)
                .font(.subheadline)
                .foregroundStyle(secondaryTextColor)
                .lineLimit(3)
            
            // Tags
            if !entry.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(entry.tags.prefix(5), id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(categoryColor.opacity(0.1))
                                .foregroundStyle(categoryColor)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            
            // Footer
            HStack {
                if let source = entry.source {
                    Label(source, systemImage: "link")
                        .font(.caption2)
                        .foregroundStyle(tertiaryTextColor)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Text(entry.createdAt, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(tertiaryTextColor)
            }
            
            // Actions
            if onSelect != nil || onDelete != nil {
                Divider()
                HStack(spacing: 12) {
                    if let onSelect = onSelect {
                        Button(action: onSelect) {
                            Label("View", systemImage: "eye")
                        }
                        .buttonStyle(KnowledgeButtonStyle(color: categoryColor))
                    }
                    Spacer()
                    if let onDelete = onDelete {
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(KnowledgeButtonStyle(color: .red))
                    }
                }
            }
        }
        .padding(16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(isHovered ? categoryColor.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .scaleEffect(isHovered ? 1.01 : 1.0)
        .animation(.easeOut(duration: 0.15), value: isHovered)
        .onHover { isHovered = $0 }
    }
    
    private var categoryColor: Color {
        switch entry.category {
        case .general: return .gray
        case .documentation: return .teal
        case .code: return .orange
        case .api: return .blue
        case .tutorial: return .purple
        case .reference: return .indigo
        case .data: return .green
        case .faq: return .pink
        }
    }
    
    private var categoryIcon: String {
        switch entry.category {
        case .general: return "brain"
        case .documentation: return "book.closed"
        case .code: return "chevron.left.forwardslash.chevron.right"
        case .api: return "doc.badge.gearshape"
        case .tutorial: return "graduationcap"
        case .reference: return "text.book.closed"
        case .data: return "cylinder"
        case .faq: return "questionmark.circle"
        }
    }
    
    private var primaryTextColor: Color { colorScheme == .dark ? .white : .black }
    private var secondaryTextColor: Color { colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6) }
    private var tertiaryTextColor: Color { colorScheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.4) }
    private var cardBackground: some ShapeStyle { colorScheme == .dark ? Color(white: 0.15) : Color.white }
}

// MARK: - Knowledge Button Style

struct KnowledgeButtonStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline).fontWeight(.medium).foregroundStyle(color)
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(color.opacity(configuration.isPressed ? 0.2 : 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Knowledge Template Card

public struct KnowledgeTemplateCard: View {
    public let template: KnowledgeTemplate
    public var onSelect: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(template: KnowledgeTemplate, onSelect: (() -> Void)? = nil) {
        self.template = template
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: { onSelect?() }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle().fill(Color.purple.opacity(0.15)).frame(width: 40, height: 40)
                        Image(systemName: template.icon).font(.system(size: 18, weight: .semibold)).foregroundStyle(.purple)
                    }
                    Spacer()
                    Text(template.category.rawValue.capitalized)
                        .font(.caption).fontWeight(.medium)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color.purple.opacity(0.1)).foregroundStyle(.purple).clipShape(Capsule())
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(template.name).font(.headline).foregroundStyle(colorScheme == .dark ? .white : .black)
                    Text(template.description).font(.caption)
                        .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6)).lineLimit(2)
                }
            }
            .padding(16).frame(maxWidth: .infinity, alignment: .leading)
            .background(colorScheme == .dark ? Color(white: 0.15) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
