//
//  InputPanelWidthModeModel.swift
//  DataKit
//
//  Width mode for the input panel
//

import Foundation

/// Width mode for the input panel
public enum InputPanelWidthModeModel: String, Equatable, Codable, Sendable {
    /// Panel matches chat sidebar width (default)
    case matchChat
    /// Panel extends across to left sidebar
    case extended
    
    public var title: String {
        switch self {
        case .matchChat: return "Match Chat"
        case .extended: return "Extended"
        }
    }
    
    public var icon: String {
        switch self {
        case .matchChat: return "rectangle.righthalf.filled"
        case .extended: return "rectangle.fill"
        }
    }
}
