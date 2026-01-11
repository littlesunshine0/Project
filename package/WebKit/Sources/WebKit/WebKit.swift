//
//  WebKit.swift
//  WebKit - Web Search & Content Fetching
//

import Foundation

// MARK: - Search Result

public struct WebSearchResult: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let url: String
    public let snippet: String
    public let source: String
    public let timestamp: Date
    
    public init(title: String, url: String, snippet: String, source: String = "web") {
        self.id = UUID().uuidString
        self.title = title
        self.url = url
        self.snippet = snippet
        self.source = source
        self.timestamp = Date()
    }
}

// MARK: - Web Content

public struct WebContent: Sendable {
    public let url: String
    public let title: String?
    public let content: String
    public let contentType: String
    public let fetchedAt: Date
    
    public init(url: String, title: String?, content: String, contentType: String = "text/html") {
        self.url = url
        self.title = title
        self.content = content
        self.contentType = contentType
        self.fetchedAt = Date()
    }
}

// MARK: - Web Search Service

public actor WebSearchService {
    public static let shared = WebSearchService()
    
    private var searchHistory: [(query: String, results: [WebSearchResult])] = []
    private var cache: [String: WebContent] = [:]
    
    private init() {}
    
    public func search(query: String, limit: Int = 10) -> [WebSearchResult] {
        // Simulated search - in real implementation would call search API
        let results = [
            WebSearchResult(
                title: "Result for: \(query)",
                url: "https://example.com/\(query.replacingOccurrences(of: " ", with: "-"))",
                snippet: "This is a search result for '\(query)'..."
            )
        ]
        searchHistory.append((query, results))
        return results
    }
    
    public func fetch(url: String) -> WebContent? {
        if let cached = cache[url] {
            return cached
        }
        // Simulated fetch - in real implementation would make HTTP request
        let content = WebContent(
            url: url,
            title: "Page at \(url)",
            content: "<html><body>Content from \(url)</body></html>"
        )
        cache[url] = content
        return content
    }
    
    public func clearCache() {
        cache.removeAll()
    }
    
    public func getSearchHistory(limit: Int = 20) -> [(query: String, results: [WebSearchResult])] {
        Array(searchHistory.suffix(limit))
    }
    
    public var stats: WebStats {
        WebStats(
            searchCount: searchHistory.count,
            cacheSize: cache.count
        )
    }
}

public struct WebStats: Sendable {
    public let searchCount: Int
    public let cacheSize: Int
}
