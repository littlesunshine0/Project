//
//  DocCard.swift
//  DocKit
//
//  Reusable Documentation card components
//

import SwiftUI

// MARK: - Doc Card

public struct DocCard: View {
    public let document: Document
    public var onOpen: (() -> Void)?
    public var onEdit: (() -> Void)?
    public var onDelete: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(
        document: Document,
        onOpen: (() -> Void)? = nil,
        onEdit: (() -> Void)? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.document = document
        self.onOpen = onOpen
        self.onEdit = onEdit
        self.onDelete = onDelete
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.teal.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: formatIcon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.teal)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(document.title)
                        .font(.headline)
                        .foregroundStyle(primaryTextColor)
                    
                    Text(document.format.rawValue.capitalized)
                        .font(.caption)
                        .foregroundStyle(secondaryTextColor)
                }
                
                Spacer()
                
                // Word count badge
                Text("\(document.wordCount) words")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.teal.opacity(0.1))
                    .foregroundStyle(.teal)
                    .clipShape(Capsule())
            }
            
            // Description
            if !document.description.isEmpty {
                Text(document.description)
                    .font(.subheadline)
                    .foregroundStyle(secondaryTextColor)
                    .lineLimit(2)
            }
            
            // Sections preview
            if !document.sections.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "list.bullet")
                        .font(.caption)
                        .foregroundStyle(secondaryTextColor)
                    
                    Text("\(document.sections.count) sections")
                        .font(.caption)
                        .foregroundStyle(secondaryTextColor)
                }
            }
            
            // Tags
            if !document.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(document.tags.prefix(5), id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.teal.opacity(0.1))
                                .foregroundStyle(.teal)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            
            // Stats
            HStack(spacing: 16) {
                DocStatItem(icon: "calendar", value: document.createdAt.formatted(date: .abbreviated, time: .omitted), label: "Created")
                DocStatItem(icon: "clock", value: document.updatedAt.formatted(date: .abbreviated, time: .omitted), label: "Updated")
            }
            
            // Actions
            if onOpen != nil || onEdit != nil || onDelete != nil {
                Divider()
                
                HStack(spacing: 12) {
                    if let onOpen = onOpen {
                        Button(action: onOpen) {
                            Label("Open", systemImage: "doc.text")
                        }
                        .buttonStyle(DocButtonStyle(color: .teal))
                    }
                    
                    if let onEdit = onEdit {
                        Button(action: onEdit) {
                            Label("Edit", systemImage: "pencil")
                        }
                        .buttonStyle(DocButtonStyle(color: .blue))
                    }
                    
                    Spacer()
                    
                    if let onDelete = onDelete {
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(DocButtonStyle(color: .red))
                    }
                }
            }
        }
        .padding(16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private var formatIcon: String {
        switch document.format {
        case .markdown: return "doc.text"
        case .html: return "chevron.left.forwardslash.chevron.right"
        case .openapi: return "doc.badge.gearshape"
        case .yaml, .json: return "curlybraces"
        case .swift: return "swift"
        case .plaintext: return "doc.plaintext"
        }
    }
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6)
    }
    
    private var cardBackground: some ShapeStyle {
        colorScheme == .dark ? Color(white: 0.15) : Color.white
    }
}

// MARK: - Doc Stat Item

struct DocStatItem: View {
    let icon: String
    let value: String
    let label: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
        }
    }
}

// MARK: - Doc Button Style

struct DocButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(configuration.isPressed ? 0.2 : 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Doc Template Card

public struct DocTemplateCard: View {
    public let template: DocTemplate
    public var onSelect: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(template: DocTemplate, onSelect: (() -> Void)? = nil) {
        self.template = template
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: { onSelect?() }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.teal.opacity(0.15))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: template.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.teal)
                    }
                    
                    Spacer()
                    
                    Text(template.format.rawValue.capitalized)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.teal.opacity(0.1))
                        .foregroundStyle(.teal)
                        .clipShape(Capsule())
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(template.name)
                        .font(.headline)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                    Text(template.description)
                        .font(.caption)
                        .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6))
                        .lineLimit(2)
                }
                
                HStack(spacing: 8) {
                    Label("\(template.defaultSections.count) sections", systemImage: "list.bullet")
                }
                .font(.caption2)
                .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(colorScheme == .dark ? Color(white: 0.15) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Doc Card") {
    VStack(spacing: 16) {
        DocCard(
            document: Document(
                title: "API Documentation",
                description: "Complete API reference for the FlowKit framework",
                sections: [
                    DocumentSection(title: "Overview", content: "API overview.", level: 1),
                    DocumentSection(title: "Endpoints", content: "List of endpoints.", level: 2)
                ],
                format: .markdown,
                tags: ["api", "reference", "docs"]
            ),
            onOpen: {},
            onEdit: {},
            onDelete: {}
        )
        
        DocTemplateCard(
            template: DocTemplate.builtInTemplates[0],
            onSelect: {}
        )
    }
    .padding()
    .frame(width: 400)
}
