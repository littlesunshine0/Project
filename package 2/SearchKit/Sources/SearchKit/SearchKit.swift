//
//  SearchKit.swift
//  SearchKit
//
//  Universal Search System
//

import Foundation

/// SearchKit - Universal Search System
public struct SearchKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.searchkit"
    
    public init() {}
    
    /// Search across all indexed content
    public static func search(_ query: String, filters: SearchFilters = SearchFilters()) async -> [SearchResult] {
        await SearchEngine.shared.search(query: query, filters: filters)
    }
    
    /// Quick search (top 10 results)
    public static func quickSearch(_ query: String) async -> [SearchResult] {
        var filters = SearchFilters()
        filters.maxResults = 10
        return await search(query, filters: filters)
    }
    
    /// Index content for searching
    public static func index(_ item: SearchableItem) async {
        await SearchIndex.shared.add(item)
    }
    
    /// Calculate relevance score
    public static func relevance(query: String, title: String, content: String) -> Double {
        RelevanceCalculator.calculate(query: query, title: title, content: content)
    }
}

// MARK: - Search Result

public struct SearchResult: Identifiable, Sendable {
    public let id: UUID
    public let type: ResultType
    public let title: String
    public let subtitle: String
    public let content: String
    public let path: String?
    public let relevance: Double
    public let metadata: [String: String]
    
    public init(id: UUID = UUID(), type: ResultType, title: String, subtitle: String = "", content: String = "", path: String? = nil, relevance: Double = 0, metadata: [String: String] = [:]) {
        self.id = id
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.path = path
        self.relevance = relevance
        self.metadata = metadata
    }
    
    public enum ResultType: String, Codable, Sendable {
        case documentation, document, code, asset, workflow, project, template, command, file
        
        public var icon: String {
            switch self {
            case .documentation: return "book"
            case .document: return "doc.text"
            case .code: return "chevron.left.forwardslash.chevron.right"
            case .asset: return "photo"
            case .workflow: return "arrow.triangle.branch"
            case .project: return "folder"
            case .template: return "doc.on.doc"
            case .command: return "command"
            case .file: return "doc"
            }
        }
    }
}

// MARK: - Search Section

public enum SearchSection: String, CaseIterable, Sendable {
    case all = "All Results"
    case recent = "Recent Searches"
    case saved = "Saved Searches"
    case suggestions = "Suggestions"
    
    public var icon: String {
        switch self {
        case .all: return "magnifyingglass"
        case .recent: return "clock"
        case .saved: return "bookmark"
        case .suggestions: return "lightbulb"
        }
    }
}

// MARK: - Search Filters

public struct SearchFilters: Sendable {
    public var includeDocumentation: Bool = true
    public var includeDocuments: Bool = true
    public var includeCode: Bool = true
    public var includeAssets: Bool = true
    public var includeWorkflows: Bool = true
    public var maxResults: Int = 50
    public var category: String?
    public var fileType: String?
    
    public init() {}
}

// MARK: - Searchable Item

public struct SearchableItem: Identifiable, Sendable {
    public let id: UUID
    public let type: SearchResult.ResultType
    public let title: String
    public let content: String
    public let path: String?
    public let metadata: [String: String]
    
    public init(id: UUID = UUID(), type: SearchResult.ResultType, title: String, content: String, path: String? = nil, metadata: [String: String] = [:]) {
        self.id = id
        self.type = type
        self.title = title
        self.content = content
        self.path = path
        self.metadata = metadata
    }
}

// MARK: - Search Index

public actor SearchIndex {
    public static let shared = SearchIndex()
    private var items: [SearchableItem] = []
    
    private init() {}
    
    public func add(_ item: SearchableItem) { items.append(item) }
    public func addBatch(_ newItems: [SearchableItem]) { items.append(contentsOf: newItems) }
    public func clear() { items.removeAll() }
    public func getAll() -> [SearchableItem] { items }
    public func count() -> Int { items.count }
    
    public func search(query: String, filters: SearchFilters) -> [SearchResult] {
        let queryLower = query.lowercased()
        
        var results: [SearchResult] = []
        
        for item in items {
            // Apply type filters
            switch item.type {
            case .documentation: if !filters.includeDocumentation { continue }
            case .document: if !filters.includeDocuments { continue }
            case .code: if !filters.includeCode { continue }
            case .asset: if !filters.includeAssets { continue }
            case .workflow: if !filters.includeWorkflows { continue }
            default: break
            }
            
            let relevance = RelevanceCalculator.calculate(query: queryLower, title: item.title, content: item.content)
            
            if relevance > 0 {
                results.append(SearchResult(
                    id: item.id,
                    type: item.type,
                    title: item.title,
                    content: item.content,
                    path: item.path,
                    relevance: relevance,
                    metadata: item.metadata
                ))
            }
        }
        
        return results.sorted { $0.relevance > $1.relevance }.prefix(filters.maxResults).map { $0 }
    }
}

// MARK: - Search Engine

public actor SearchEngine {
    public static let shared = SearchEngine()
    
    private init() {}
    
    public func search(query: String, filters: SearchFilters) async -> [SearchResult] {
        await SearchIndex.shared.search(query: query, filters: filters)
    }
}

// MARK: - Relevance Calculator

public struct RelevanceCalculator {
    public static func calculate(query: String, title: String, content: String) -> Double {
        let queryLower = query.lowercased()
        let titleLower = title.lowercased()
        let contentLower = content.lowercased()
        
        var score = 0.0
        
        // Exact title match
        if titleLower == queryLower {
            score += 100.0
        } else if titleLower.contains(queryLower) {
            score += 50.0
        }
        
        // Word matching in title
        let queryWords = queryLower.split(separator: " ")
        for word in queryWords {
            if titleLower.contains(word) { score += 20.0 }
        }
        
        // Content occurrences
        let occurrences = contentLower.components(separatedBy: queryLower).count - 1
        score += Double(occurrences) * 5.0
        
        // Word matching in content
        for word in queryWords {
            let wordOccurrences = contentLower.components(separatedBy: word).count - 1
            score += Double(wordOccurrences) * 2.0
        }
        
        // Bonus for shorter content (more focused)
        if content.count < 500 { score += 10.0 }
        else if content.count < 1000 { score += 5.0 }
        
        return score
    }
}
