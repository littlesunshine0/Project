//
//  SearchViewModel.swift
//  SearchKit
//

import Foundation
import Combine

@MainActor
public class SearchViewModel: ObservableObject {
    @Published public var query = ""
    @Published public var results: [SearchResult] = []
    @Published public var recentSearches: [String] = []
    @Published public var selectedSection: SearchSection = .all
    @Published public var isSearching = false
    @Published public var error: SearchError?
    
    private var searchTask: Task<Void, Never>?
    
    public init() {}
    
    // MARK: - Search
    
    public func search() async {
        guard !query.isEmpty else {
            results = []
            return
        }
        
        isSearching = true
        searchTask?.cancel()
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000) // Debounce
            
            guard !Task.isCancelled else { return }
            
            let searchResults = await SearchKit.search(query)
            
            await MainActor.run {
                self.results = searchResults
                self.isSearching = false
                
                if !self.recentSearches.contains(self.query) {
                    self.recentSearches.insert(self.query, at: 0)
                    if self.recentSearches.count > 10 {
                        self.recentSearches.removeLast()
                    }
                }
            }
        }
    }
    
    public func clearResults() {
        results = []
        query = ""
    }
    
    public func clearHistory() {
        recentSearches = []
    }
    
    // MARK: - Filtering
    
    public var filteredResults: [SearchResult] {
        switch selectedSection {
        case .all: return results
        case .recent: return []
        case .saved: return []
        case .suggestions: return []
        }
    }
}
