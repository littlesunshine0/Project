//
//  NavigationHistory.swift
//  DataKit
//

import Foundation

/// Navigation history for back/forward
public struct NavigationHistory: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public var entries: [NavigationEntry]
    public var currentIndex: Int
    
    public init(id: String = UUID().uuidString, entries: [NavigationEntry] = [], currentIndex: Int = -1) {
        self.id = id
        self.entries = entries
        self.currentIndex = currentIndex
    }
    
    public var canGoBack: Bool { currentIndex > 0 }
    public var canGoForward: Bool { currentIndex < entries.count - 1 }
    public var current: NavigationEntry? { 
        guard currentIndex >= 0, currentIndex < entries.count else { return nil }
        return entries[currentIndex]
    }
}

public struct NavigationEntry: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let route: String
    public let title: String
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, route: String, title: String) {
        self.id = id
        self.route = route
        self.title = title
        self.timestamp = Date()
    }
}
