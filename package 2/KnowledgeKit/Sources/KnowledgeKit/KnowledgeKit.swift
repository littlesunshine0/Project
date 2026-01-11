//
//  KnowledgeKit.swift
//  KnowledgeKit
//
//  Knowledge base management, ingestion, and retrieval
//

import Foundation

public struct KnowledgeKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.knowledgekit"
    public init() {}
}

// MARK: - Knowledge Base

public actor KnowledgeBase {
    public static let shared = KnowledgeBase()
    
    private var entries: [UUID: KnowledgeEntry] = [:]
    private var tagIndex: [String: Set<UUID>] = [:]
    private var categoryIndex: [KnowledgeCategory: Set<UUID>] = [:]
    private var searchIndex: [String: Set<UUID>] = [:]
    
    private init() {}
    
    // MARK: - CRUD
    
    public func add(_ entry: KnowledgeEntry) -> UUID {
        entries[entry.id] = entry
        
        // Index by tags
        for tag in entry.tags {
            tagIndex[tag.lowercased(), default: []].insert(entry.id)
        }
        
        // Index by category
        categoryIndex[entry.category, default: []].insert(entry.id)
        
        // Full-text index
        indexEntry(entry)
        
        return entry.id
    }
    
    public func add(title: String, content: String, category: KnowledgeCategory = .general, tags: [String] = [], source: String? = nil) -> UUID {
        let entry = KnowledgeEntry(title: title, content: content, category: category, tags: tags, source: source)
        return add(entry)
    }
    
    public func get(_ id: UUID) -> KnowledgeEntry? { entries[id] }
    
    public func update(_ id: UUID, title: String? = nil, content: String? = nil, tags: [String]? = nil) {
        guard var entry = entries[id] else { return }
        if let t = title { entry = KnowledgeEntry(id: entry.id, title: t, content: entry.content, category: entry.category, tags: entry.tags, source: entry.source, createdAt: entry.createdAt) }
        if let c = content { entry = KnowledgeEntry(id: entry.id, title: entry.title, content: c, category: entry.category, tags: entry.tags, source: entry.source, createdAt: entry.createdAt) }
        entries[id] = entry
        indexEntry(entry)
    }
    
    public func delete(_ id: UUID) {
        guard let entry = entries.removeValue(forKey: id) else { return }
        for tag in entry.tags { tagIndex[tag.lowercased()]?.remove(id) }
        categoryIndex[entry.category]?.remove(id)
    }
    
    // MARK: - Search
    
    public func search(_ query: String) -> [KnowledgeEntry] {
        let words = tokenize(query)
        var matchingIds: Set<UUID>?
        
        for word in words {
            if let ids = searchIndex[word] {
                matchingIds = matchingIds == nil ? ids : matchingIds?.intersection(ids)
            }
        }
        
        return (matchingIds ?? []).compactMap { entries[$0] }
    }
    
    public func getByTag(_ tag: String) -> [KnowledgeEntry] {
        (tagIndex[tag.lowercased()] ?? []).compactMap { entries[$0] }
    }
    
    public func getByCategory(_ category: KnowledgeCategory) -> [KnowledgeEntry] {
        (categoryIndex[category] ?? []).compactMap { entries[$0] }
    }
    
    public func getAll() -> [KnowledgeEntry] { Array(entries.values) }
    
    // MARK: - Indexing
    
    private func indexEntry(_ entry: KnowledgeEntry) {
        let words = tokenize(entry.title) + tokenize(entry.content)
        for word in words {
            searchIndex[word, default: []].insert(entry.id)
        }
    }
    
    private func tokenize(_ text: String) -> [String] {
        text.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.count > 2 }
    }
    
    public var stats: KnowledgeStats {
        KnowledgeStats(
            totalEntries: entries.count,
            categoryCounts: Dictionary(uniqueKeysWithValues: categoryIndex.map { ($0.key, $0.value.count) }),
            tagCount: tagIndex.count,
            indexedWords: searchIndex.count
        )
    }
}

// MARK: - Knowledge Ingestion

public actor KnowledgeIngestion {
    public static let shared = KnowledgeIngestion()
    
    private init() {}
    
    public func ingestText(_ text: String, title: String, category: KnowledgeCategory = .general, tags: [String] = []) async -> UUID {
        await KnowledgeBase.shared.add(title: title, content: text, category: category, tags: tags)
    }
    
    public func ingestMarkdown(_ markdown: String, title: String) async -> UUID {
        // Extract tags from headers
        var tags: [String] = []
        let lines = markdown.components(separatedBy: .newlines)
        for line in lines where line.hasPrefix("#") {
            let header = line.trimmingCharacters(in: CharacterSet(charactersIn: "# "))
            if !header.isEmpty { tags.append(header) }
        }
        
        return await KnowledgeBase.shared.add(title: title, content: markdown, category: .documentation, tags: tags)
    }
    
    public func ingestJSON(_ json: String, title: String) async -> UUID {
        await KnowledgeBase.shared.add(title: title, content: json, category: .data, tags: ["json"])
    }
    
    public func ingestBatch(_ items: [(title: String, content: String, category: KnowledgeCategory)]) async -> [UUID] {
        var ids: [UUID] = []
        for item in items {
            let id = await KnowledgeBase.shared.add(title: item.title, content: item.content, category: item.category)
            ids.append(id)
        }
        return ids
    }
}

// MARK: - Knowledge Browser Service

public actor KnowledgeBrowserService {
    public static let shared = KnowledgeBrowserService()
    
    private var recentSearches: [String] = []
    private var favorites: Set<UUID> = []
    
    private init() {}
    
    public func search(_ query: String) async -> [KnowledgeEntry] {
        recentSearches.append(query)
        if recentSearches.count > 50 { recentSearches.removeFirst() }
        return await KnowledgeBase.shared.search(query)
    }
    
    public func browse(category: KnowledgeCategory) async -> [KnowledgeEntry] {
        await KnowledgeBase.shared.getByCategory(category)
    }
    
    public func browseByTag(_ tag: String) async -> [KnowledgeEntry] {
        await KnowledgeBase.shared.getByTag(tag)
    }
    
    public func addFavorite(_ id: UUID) { favorites.insert(id) }
    public func removeFavorite(_ id: UUID) { favorites.remove(id) }
    public func isFavorite(_ id: UUID) -> Bool { favorites.contains(id) }
    
    public func getFavorites() async -> [KnowledgeEntry] {
        var result: [KnowledgeEntry] = []
        for id in favorites {
            if let entry = await KnowledgeBase.shared.get(id) {
                result.append(entry)
            }
        }
        return result
    }
    
    public func getRecentSearches() -> [String] { recentSearches }
}

// MARK: - Models

public struct KnowledgeEntry: Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let content: String
    public let category: KnowledgeCategory
    public let tags: [String]
    public let source: String?
    public let createdAt: Date
    
    public init(id: UUID = UUID(), title: String, content: String, category: KnowledgeCategory = .general, tags: [String] = [], source: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.tags = tags
        self.source = source
        self.createdAt = createdAt
    }
}

public enum KnowledgeCategory: String, Sendable, CaseIterable, Codable {
    case general, documentation, code, api, tutorial, reference, data, faq
    
    public var icon: String {
        switch self {
        case .general: return "lightbulb"
        case .documentation: return "doc.text"
        case .code: return "chevron.left.forwardslash.chevron.right"
        case .api: return "network"
        case .tutorial: return "book"
        case .reference: return "books.vertical"
        case .data: return "cylinder"
        case .faq: return "questionmark.circle"
        }
    }
}

// MARK: - Knowledge Section

public enum KnowledgeSection: String, CaseIterable, Sendable {
    case all = "All Knowledge"
    case favorites = "Favorites"
    case recent = "Recent"
    case byCategory = "By Category"
    
    public var icon: String {
        switch self {
        case .all: return "brain"
        case .favorites: return "star"
        case .recent: return "clock"
        case .byCategory: return "folder"
        }
    }
}

public struct KnowledgeStats: Sendable {
    public let totalEntries: Int
    public let categoryCounts: [KnowledgeCategory: Int]
    public let tagCount: Int
    public let indexedWords: Int
}
