//
//  BottomPanelTab.swift
//  FlowKit
//
//  SwiftUI rendering extensions for bottom panel tabs
//  Core model lives in DataKit - this file provides Color rendering
//

import SwiftUI
import DesignKit
import DataKit

// MARK: - Type Alias

public typealias BottomPanelTab = BottomPanelTabModel

// MARK: - SwiftUI Color Extension

extension BottomPanelTabModel {
    /// SwiftUI Color for rendering
    public var accentColor: Color {
        switch colorCategory {
        case "commands": return FlowColors.Category.commands
        case "info": return FlowColors.Status.info
        case "warning": return FlowColors.Status.warning
        case "error": return FlowColors.Status.error
        default: return FlowColors.Status.neutral
        }
    }
}
