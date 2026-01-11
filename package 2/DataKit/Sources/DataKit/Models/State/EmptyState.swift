//
//  EmptyState.swift
//  DataKit
//

import Foundation

/// Empty state configuration for views
public struct EmptyState: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: EmptyStateType
    public let title: String
    public let message: String?
    public let icon: String
    public let action: EmptyStateAction?
    
    public init(id: String = UUID().uuidString, type: EmptyStateType, title: String, message: String? = nil, icon: String, action: EmptyStateAction? = nil) {
        self.id = id
        self.type = type
        self.title = title
        self.message = message
        self.icon = icon
        self.action = action
    }
}

public enum EmptyStateType: String, Codable, Sendable, CaseIterable {
    case noData, noResults, noConnection, noPermission, error, firstRun
}

public struct EmptyStateAction: Codable, Sendable, Hashable {
    public let title: String
    public let action: String
    
    public init(title: String, action: String) {
        self.title = title
        self.action = action
    }
}
