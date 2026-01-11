//
//  ChatFormat.swift
//  ChatKit
//

import Foundation

public enum ChatFormat: String, CaseIterable, Codable, Sendable {
    case text = "Text"
    case markdown = "Markdown"
    case code = "Code"
    case rich = "Rich"
    
    public var icon: String {
        switch self {
        case .text: return "text.alignleft"
        case .markdown: return "doc.richtext"
        case .code: return "chevron.left.forwardslash.chevron.right"
        case .rich: return "textformat"
        }
    }
}
