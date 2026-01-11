//
//  PrimaryNavItem.swift
//  FlowKit
//
//  SwiftUI rendering extensions for primary navigation items
//  Core model lives in DataKit - this file provides Color rendering
//

import SwiftUI
import DesignKit
import DataKit

// MARK: - Type Alias

public typealias PrimaryNavItem = PrimaryNavItemModel

// MARK: - SwiftUI Color Extension

extension PrimaryNavItemModel {
    /// SwiftUI Color for rendering
    public var color: Color {
        FlowColors.Category.forItem(rawValue)
    }
}
