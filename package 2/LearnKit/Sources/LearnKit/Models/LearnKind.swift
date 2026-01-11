//
//  LearnKind.swift
//  LearnKit
//

import Foundation

public enum LearnKind: String, CaseIterable, Codable, Sendable {
    case tutorial = "Tutorial"
    case course = "Course"
    case quickStart = "Quick Start"
    case deepDive = "Deep Dive"
    case reference = "Reference"
    
    public var icon: String {
        switch self {
        case .tutorial: return "book"
        case .course: return "books.vertical"
        case .quickStart: return "bolt"
        case .deepDive: return "arrow.down.circle"
        case .reference: return "doc.text.magnifyingglass"
        }
    }
}
