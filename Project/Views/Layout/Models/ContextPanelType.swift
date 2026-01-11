//
//  ContextPanelType.swift
//  FlowKit
//
//  SwiftUI Color rendering for DataKit ContextPanelTypeModel
//

import SwiftUI
import DesignKit
import DataKit

// MARK: - Type Alias (Use DataKit model)

public typealias ContextPanelType = ContextPanelTypeModel
public typealias ContextPanelPosition = ContextPanelPositionModel

// MARK: - SwiftUI Color Extension

extension ContextPanelTypeModel {
    /// SwiftUI Color for rendering
    public var accentColor: Color {
        switch colorCategory {
        case "chat": return FlowColors.Category.chat
        case "commands": return FlowColors.Category.commands
        case "info": return FlowColors.Status.info
        case "warning": return FlowColors.Status.warning
        case "error": return FlowColors.Status.error
        case "documentation": return FlowColors.Category.documentation
        case "projects": return FlowColors.Category.projects
        default: return FlowColors.Status.neutral
        }
    }
}

// MARK: - Panel Position (Local for SwiftUI Layout)

/// Position for floating panels in SwiftUI layout
public enum PanelPosition: String, Sendable, Equatable {
    case top
    case bottom
}

extension ContextPanelTypeModel {
    /// Default panel position for SwiftUI layout
    public var defaultPanelPosition: PanelPosition {
        switch defaultPosition {
        case .right: return .top
        case .bottom: return .bottom
        }
    }
}
