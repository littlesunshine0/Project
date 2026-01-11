//
//  LoadState.swift
//  DataKit
//

import Foundation

/// Loading state for async operations
public enum LoadState: String, Codable, Sendable, CaseIterable {
    case idle
    case loading
    case loaded
    case refreshing
    case error
    case empty
    
    public var isLoading: Bool {
        self == .loading || self == .refreshing
    }
    
    public var isComplete: Bool {
        self == .loaded || self == .error || self == .empty
    }
}
