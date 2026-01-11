//
//  SearchManager.swift
//  SearchKit
//
//  Search session management and history tracking
//

import Foundation
import Combine

// MARK: - Search Manager

@MainActor
public class SearchManager: ObservableObject {
    public static let shared = SearchManager()
    
    @Published public var recentSearches: [SearchQuery] = []
    @Published public var savedSearches: [SearchQuery] = []
    @Published public var currentResults: [SearchResult] = []
    @Published public var isSearching = false
    
    private let maxRecent = 20
    private let recentKey = "recentSearches"
    private let savedKey = "savedSearches"
    
    private init() {
        loadSearches()
    }
    
    // MARK: - Search
    
    public func search(_ query: String, filters: SearchFilters = SearchFilters()) async {
        guard !query.isEmpty else {
            currentResults = []
            return
        }
        
        isSearching = true
        
        let searchQuery = SearchQuery(query: query, filters: filters)
        addToRecent(searchQuery)
        
        currentResults = await SearchKit.search(query, filters: filters)
        
        isSearching = false
    }
    
    public func quickSearch(_ query: String) async {
        isSearching = true
        currentResults = await SearchKit.quickSearch(query)
        isSearching = false
    }
    
    public func clearResults() {
        currentResults = []
    }
    
    // MARK: - History
    
    private func addToRecent(_ query: SearchQuery) {
        recentSearches.removeAll { $0.query == query.query }
        recentSearches.insert(query, at: 0)
        if recentSearches.count > maxRecent {
            recentSearches.removeLast()
        }
        saveSearches()
    }
    
    public func saveSearch(_ query: SearchQuery) {
        if !savedSearches.contains(where: { $0.query == query.query }) {
            savedSearches.append(query)
            saveSearches()
        }
    }
    
    public func removeSavedSearch(_ query: SearchQuery) {
        savedSearches.removeAll { $0.id == query.id }
        saveSearches()
    }
    
    public func clearRecentSearches() {
        recentSearches.removeAll()
        saveSearches()
    }
    
    // MARK: - Statistics
    
    public var totalSearches: Int { recentSearches.count }
    public var savedCount: Int { savedSearches.count }
    
    // MARK: - Persistence
    
    private func loadSearches() {
        if let data = UserDefaults.standard.data(forKey: recentKey),
           let decoded = try? JSONDecoder().decode([SearchQuery].self, from: data) {
            recentSearches = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: savedKey),
           let decoded = try? JSONDecoder().decode([SearchQuery].self, from: data) {
            savedSearches = decoded
        }
    }
    
    private func saveSearches() {
        if let encoded = try? JSONEncoder().encode(recentSearches) {
            UserDefaults.standard.set(encoded, forKey: recentKey)
        }
        if let encoded = try? JSONEncoder().encode(savedSearches) {
            UserDefaults.standard.set(encoded, forKey: savedKey)
        }
    }
}

// MARK: - Search Query

public struct SearchQuery: Codable, Identifiable, Sendable {
    public let id: UUID
    public let query: String
    public let filters: SearchFilters
    public let timestamp: Date
    
    public init(id: UUID = UUID(), query: String, filters: SearchFilters = SearchFilters(), timestamp: Date = Date()) {
        self.id = id
        self.query = query
        self.filters = filters
        self.timestamp = timestamp
    }
}

// Make SearchFilters Codable
extension SearchFilters: Codable {
    enum CodingKeys: String, CodingKey {
        case includeDocumentation, includeDocuments, includeCode, includeAssets, includeWorkflows, maxResults, category, fileType
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        includeDocumentation = try container.decodeIfPresent(Bool.self, forKey: .includeDocumentation) ?? true
        includeDocuments = try container.decodeIfPresent(Bool.self, forKey: .includeDocuments) ?? true
        includeCode = try container.decodeIfPresent(Bool.self, forKey: .includeCode) ?? true
        includeAssets = try container.decodeIfPresent(Bool.self, forKey: .includeAssets) ?? true
        includeWorkflows = try container.decodeIfPresent(Bool.self, forKey: .includeWorkflows) ?? true
        maxResults = try container.decodeIfPresent(Int.self, forKey: .maxResults) ?? 50
        category = try container.decodeIfPresent(String.self, forKey: .category)
        fileType = try container.decodeIfPresent(String.self, forKey: .fileType)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(includeDocumentation, forKey: .includeDocumentation)
        try container.encode(includeDocuments, forKey: .includeDocuments)
        try container.encode(includeCode, forKey: .includeCode)
        try container.encode(includeAssets, forKey: .includeAssets)
        try container.encode(includeWorkflows, forKey: .includeWorkflows)
        try container.encode(maxResults, forKey: .maxResults)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(fileType, forKey: .fileType)
    }
}
