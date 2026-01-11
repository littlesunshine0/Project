//
//  DocError.swift
//  DocKit
//

import Foundation

public enum DocError: LocalizedError, Sendable {
    case notFound(String)
    case parsingFailed(String)
    case generationFailed(String)
    case invalidFormat(String)
    case templateNotFound(String)
    case exportFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .notFound(let name): return "Document not found: \(name)"
        case .parsingFailed(let msg): return "Parsing failed: \(msg)"
        case .generationFailed(let msg): return "Generation failed: \(msg)"
        case .invalidFormat(let format): return "Invalid format: \(format)"
        case .templateNotFound(let name): return "Template not found: \(name)"
        case .exportFailed(let msg): return "Export failed: \(msg)"
        }
    }
    
    public var icon: String {
        switch self {
        case .notFound: return "doc.questionmark"
        case .parsingFailed: return "exclamationmark.triangle"
        case .generationFailed: return "xmark.circle"
        case .invalidFormat: return "doc.badge.ellipsis"
        case .templateNotFound: return "doc.on.doc"
        case .exportFailed: return "square.and.arrow.up.trianglebadge.exclamationmark"
        }
    }
}
