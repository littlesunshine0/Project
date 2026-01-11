//
//  AgentFormat.swift
//  AgentKit
//

import Foundation

public enum AgentFormat: String, CaseIterable, Codable, Sendable {
    case yaml = "YAML"
    case json = "JSON"
    case swift = "Swift"
    case visual = "Visual"
    
    public var icon: String {
        switch self {
        case .yaml: return "doc.text"
        case .json: return "curlybraces"
        case .swift: return "swift"
        case .visual: return "rectangle.3.group"
        }
    }
    
    public var fileExtension: String {
        switch self {
        case .yaml: return "yaml"
        case .json: return "json"
        case .swift: return "swift"
        case .visual: return "agent"
        }
    }
}
