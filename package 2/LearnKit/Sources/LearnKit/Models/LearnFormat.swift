//
//  LearnFormat.swift
//  LearnKit
//

import Foundation

public enum LearnFormat: String, CaseIterable, Codable, Sendable {
    case text = "Text"
    case video = "Video"
    case interactive = "Interactive"
    case quiz = "Quiz"
    case project = "Project"
    
    public var icon: String {
        switch self {
        case .text: return "doc.text"
        case .video: return "play.rectangle"
        case .interactive: return "hand.tap"
        case .quiz: return "checkmark.circle"
        case .project: return "folder"
        }
    }
}
