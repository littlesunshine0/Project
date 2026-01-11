//
//  CommandKind.swift
//  CommandKit
//

import Foundation

public enum CommandKind: String, CaseIterable, Codable, Sendable {
    case action = "Action"
    case query = "Query"
    case navigation = "Navigation"
    case mutation = "Mutation"
    case composite = "Composite"
    
    public var icon: String {
        switch self {
        case .action: return "bolt"
        case .query: return "magnifyingglass"
        case .navigation: return "arrow.right"
        case .mutation: return "pencil"
        case .composite: return "square.stack.3d.up"
        }
    }
    
    public var description: String {
        switch self {
        case .action: return "Performs an action"
        case .query: return "Retrieves information"
        case .navigation: return "Navigates to a location"
        case .mutation: return "Modifies data"
        case .composite: return "Combines multiple commands"
        }
    }
}
