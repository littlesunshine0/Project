//
//  KnowledgeKind.swift
//  KnowledgeKit
//

import Foundation

public enum KnowledgeKind: String, CaseIterable, Codable, Sendable {
    case fact = "Fact"
    case concept = "Concept"
    case procedure = "Procedure"
    case reference = "Reference"
    case example = "Example"
    
    public var icon: String {
        switch self {
        case .fact: return "checkmark.circle"
        case .concept: return "lightbulb"
        case .procedure: return "list.number"
        case .reference: return "book"
        case .example: return "doc.text.magnifyingglass"
        }
    }
}
