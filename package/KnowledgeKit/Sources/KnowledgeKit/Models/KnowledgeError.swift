//
//  KnowledgeError.swift
//  KnowledgeKit
//

import Foundation

public enum KnowledgeError: LocalizedError, Sendable {
    case entryNotFound(UUID)
    case ingestionFailed(String)
    case indexingFailed(String)
    case searchFailed(String)
    case duplicateEntry(String)
    
    public var errorDescription: String? {
        switch self {
        case .entryNotFound(let id): return "Entry not found: \(id)"
        case .ingestionFailed(let msg): return "Ingestion failed: \(msg)"
        case .indexingFailed(let msg): return "Indexing failed: \(msg)"
        case .searchFailed(let msg): return "Search failed: \(msg)"
        case .duplicateEntry(let title): return "Duplicate entry: \(title)"
        }
    }
    
    public var icon: String {
        switch self {
        case .entryNotFound: return "brain"
        case .ingestionFailed: return "arrow.down.circle"
        case .indexingFailed: return "list.bullet"
        case .searchFailed: return "magnifyingglass"
        case .duplicateEntry: return "doc.on.doc"
        }
    }
}
