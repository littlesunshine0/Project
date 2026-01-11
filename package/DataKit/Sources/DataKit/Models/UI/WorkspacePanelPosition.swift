//
//  WorkspacePanelPosition.swift
//  DataKit
//
//  Panel position within workspace
//

import Foundation

/// Panel position within workspace
public enum WorkspacePanelPosition: String, Codable, Sendable {
    case left
    case right
    case bottom
    case floating
    
    public var title: String {
        switch self {
        case .left: return "Left"
        case .right: return "Right"
        case .bottom: return "Bottom"
        case .floating: return "Floating"
        }
    }
    
    public var icon: String {
        switch self {
        case .left: return "sidebar.left"
        case .right: return "sidebar.right"
        case .bottom: return "rectangle.bottomhalf.filled"
        case .floating: return "rectangle.on.rectangle"
        }
    }
}
