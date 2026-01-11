//
//  WorkflowFormat.swift
//  WorkflowKit
//

import Foundation

public enum WorkflowFormat: String, CaseIterable, Codable, Sendable {
    case yaml = "YAML"
    case json = "JSON"
    case swift = "Swift"
    case visual = "Visual"
    case script = "Script"
    
    public var icon: String {
        switch self {
        case .yaml: return "doc.text"
        case .json: return "curlybraces"
        case .swift: return "swift"
        case .visual: return "rectangle.3.group"
        case .script: return "terminal"
        }
    }
    
    public var fileExtension: String {
        switch self {
        case .yaml: return "yaml"
        case .json: return "json"
        case .swift: return "swift"
        case .visual: return "workflow"
        case .script: return "sh"
        }
    }
}
