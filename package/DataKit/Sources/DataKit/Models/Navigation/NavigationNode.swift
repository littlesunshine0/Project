//
//  NavigationNode.swift
//  DataKit
//

import Foundation

/// Navigation node in the app hierarchy
public struct NavigationNode: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let path: String
    public let title: String
    public let icon: String?
    public let parent: String?
    public let children: [String]
    public let isNavigable: Bool
    public let metadata: [String: AnyCodable]
    
    public init(id: String, path: String, title: String, icon: String? = nil, parent: String? = nil, children: [String] = [], isNavigable: Bool = true, metadata: [String: AnyCodable] = [:]) {
        self.id = id
        self.path = path
        self.title = title
        self.icon = icon
        self.parent = parent
        self.children = children
        self.isNavigable = isNavigable
        self.metadata = metadata
    }
}
