//
//  KnowledgeFormat.swift
//  KnowledgeKit
//

import Foundation

public enum KnowledgeFormat: String, CaseIterable, Codable, Sendable {
    case text = "Text"
    case markdown = "Markdown"
    case json = "JSON"
    case yaml = "YAML"
    case html = "HTML"
    
    public var icon: String {
        switch self {
        case .text: return "doc.text"
        case .markdown: return "doc.richtext"
        case .json: return "curlybraces"
        case .yaml: return "doc.text"
        case .html: return "chevron.left.forwardslash.chevron.right"
        }
    }
}
