//
//  KnowledgeManager.swift
//  KnowledgeKit
//
//  Knowledge base management and browsing
//

import Foundation
import Combine

// MARK: - Knowledge Manager

@MainActor
public class KnowledgeManager: ObservableObject {
    public static let shared = KnowledgeManager()
    
    @Published public var entries: [KnowledgeEntry] = []
    @Published public var favorites: [KnowledgeEntry] = []
    @Published public var recentEntries: [KnowledgeEntry] = []
    @Published public var isLoading = false
    
    private let maxRecent = 20
    
    private init() {
        Task { await loadEntries() }
    }
    
    // MARK: - Entry Management
    
    public func addEntry(
        title: String,
        content: String,
        category: KnowledgeCategory = .general,
        tags: [String] = [],
        source: String? = nil
    ) async -> KnowledgeEntry {
        let entry = KnowledgeEntry(
            title: title,
            content: content,
            category: category,
            tags: tags,
            source: source
        )
        
        _ = await KnowledgeBase.shared.add(entry)
        await loadEntries()
        
        return entry
    }
    
    public func deleteEntry(_ entry: KnowledgeEntry) async {
        await KnowledgeBase.shared.delete(entry.id)
        await loadEntries()
    }
    
    // MARK: - Search & Browse
    
    public func search(_ query: String) async -> [KnowledgeEntry] {
        await KnowledgeBase.shared.search(query)
    }
    
    public func browse(category: KnowledgeCategory) async -> [KnowledgeEntry] {
        await KnowledgeBase.shared.getByCategory(category)
    }
    
    public func browseByTag(_ tag: String) async -> [KnowledgeEntry] {
        await KnowledgeBase.shared.getByTag(tag)
    }
    
    // MARK: - Favorites
    
    public func toggleFavorite(_ entry: KnowledgeEntry) async {
        let browser = KnowledgeBrowserService.shared
        if await browser.isFavorite(entry.id) {
            await browser.removeFavorite(entry.id)
        } else {
            await browser.addFavorite(entry.id)
        }
        favorites = await browser.getFavorites()
    }
    
    public func isFavorite(_ entry: KnowledgeEntry) async -> Bool {
        await KnowledgeBrowserService.shared.isFavorite(entry.id)
    }
    
    // MARK: - Statistics
    
    public var totalEntries: Int { entries.count }
    public var favoriteCount: Int { favorites.count }
    
    public func entriesByCategory() -> [KnowledgeCategory: Int] {
        var counts: [KnowledgeCategory: Int] = [:]
        for entry in entries {
            counts[entry.category, default: 0] += 1
        }
        return counts
    }
    
    // MARK: - Loading
    
    private func loadEntries() async {
        isLoading = true
        entries = await KnowledgeBase.shared.getAll()
        favorites = await KnowledgeBrowserService.shared.getFavorites()
        recentEntries = Array(entries.sorted { $0.createdAt > $1.createdAt }.prefix(maxRecent))
        isLoading = false
    }
    
    public func refresh() async {
        await loadEntries()
    }
}

// MARK: - Knowledge Composer

@MainActor
public class KnowledgeComposer: ObservableObject {
    public static let shared = KnowledgeComposer()
    
    @Published public var draftEntry: KnowledgeDraft?
    @Published public var templates: [KnowledgeTemplate] = []
    
    private init() {
        loadTemplates()
    }
    
    // MARK: - Composition
    
    public func startComposition(from template: KnowledgeTemplate? = nil) -> KnowledgeDraft {
        let draft = KnowledgeDraft(template: template)
        draftEntry = draft
        return draft
    }
    
    public func finalize() async -> KnowledgeEntry? {
        guard let draft = draftEntry else { return nil }
        
        let entry = await KnowledgeManager.shared.addEntry(
            title: draft.title,
            content: draft.content,
            category: draft.category,
            tags: draft.tags,
            source: draft.source
        )
        
        draftEntry = nil
        return entry
    }
    
    public func cancelComposition() {
        draftEntry = nil
    }
    
    // MARK: - Templates
    
    private func loadTemplates() {
        templates = KnowledgeTemplate.builtInTemplates
    }
}

// MARK: - Knowledge Draft

public struct KnowledgeDraft {
    public var title: String
    public var content: String
    public var category: KnowledgeCategory
    public var tags: [String]
    public var source: String?
    
    public init(template: KnowledgeTemplate? = nil) {
        if let template = template {
            self.title = template.name
            self.content = template.defaultContent
            self.category = template.category
            self.tags = template.defaultTags
            self.source = nil
        } else {
            self.title = "New Entry"
            self.content = ""
            self.category = .general
            self.tags = []
            self.source = nil
        }
    }
}

// MARK: - Knowledge Template

public struct KnowledgeTemplate: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let description: String
    public let category: KnowledgeCategory
    public let defaultContent: String
    public let defaultTags: [String]
    public let icon: String
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        category: KnowledgeCategory = .general,
        defaultContent: String = "",
        defaultTags: [String] = [],
        icon: String = "brain"
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.defaultContent = defaultContent
        self.defaultTags = defaultTags
        self.icon = icon
    }
    
    public static let builtInTemplates: [KnowledgeTemplate] = [
        KnowledgeTemplate(
            name: "API Reference",
            description: "Document an API endpoint or method",
            category: .api,
            defaultContent: "## Endpoint\n\n## Parameters\n\n## Response\n\n## Example",
            defaultTags: ["api", "reference"],
            icon: "doc.badge.gearshape"
        ),
        KnowledgeTemplate(
            name: "Tutorial",
            description: "Step-by-step guide",
            category: .tutorial,
            defaultContent: "## Overview\n\n## Prerequisites\n\n## Steps\n\n## Conclusion",
            defaultTags: ["tutorial", "guide"],
            icon: "book"
        ),
        KnowledgeTemplate(
            name: "Code Snippet",
            description: "Reusable code example",
            category: .code,
            defaultContent: "## Description\n\n## Code\n\n```\n\n```\n\n## Usage",
            defaultTags: ["code", "snippet"],
            icon: "chevron.left.forwardslash.chevron.right"
        ),
        KnowledgeTemplate(
            name: "FAQ Entry",
            description: "Frequently asked question",
            category: .faq,
            defaultContent: "## Question\n\n## Answer\n\n## Related",
            defaultTags: ["faq"],
            icon: "questionmark.circle"
        )
    ]
}
