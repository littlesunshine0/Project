//
//  SearchError.swift
//  SearchKit
//

import Foundation

public enum SearchError: LocalizedError, Sendable {
    case emptyQuery
    case indexNotReady
    case timeout
    case invalidFilter(String)
    case noResults
    
    public var errorDescription: String? {
        switch self {
        case .emptyQuery: return "Search query is empty"
        case .indexNotReady: return "Search index is not ready"
        case .timeout: return "Search timed out"
        case .invalidFilter(let filter): return "Invalid filter: \(filter)"
        case .noResults: return "No results found"
        }
    }
    
    public var icon: String {
        switch self {
        case .emptyQuery: return "magnifyingglass"
        case .indexNotReady: return "clock"
        case .timeout: return "clock.badge.exclamationmark"
        case .invalidFilter: return "line.3.horizontal.decrease.circle"
        case .noResults: return "magnifyingglass"
        }
    }
}
