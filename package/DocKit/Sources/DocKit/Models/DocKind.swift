//
//  DocKind.swift
//  DocKit
//

import Foundation

public enum DocKind: String, CaseIterable, Codable, Sendable {
    case generated = "Generated"
    case manual = "Manual"
    case template = "Template"
    case imported = "Imported"
    case synced = "Synced"
    
    public var icon: String {
        switch self {
        case .generated: return "wand.and.stars"
        case .manual: return "pencil"
        case .template: return "doc.on.doc"
        case .imported: return "square.and.arrow.down"
        case .synced: return "arrow.triangle.2.circlepath"
        }
    }
}
