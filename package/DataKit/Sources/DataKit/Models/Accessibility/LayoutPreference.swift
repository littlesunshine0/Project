//
//  LayoutPreference.swift
//  DataKit
//

import Foundation

/// Layout preference
public struct LayoutPreference: Codable, Sendable, Hashable {
    public let density: LayoutDensity
    public let sidebarPosition: SidebarPosition
    public let showLabels: Bool
    public let compactMode: Bool
    
    public init(density: LayoutDensity = .comfortable, sidebarPosition: SidebarPosition = .leading, showLabels: Bool = true, compactMode: Bool = false) {
        self.density = density
        self.sidebarPosition = sidebarPosition
        self.showLabels = showLabels
        self.compactMode = compactMode
    }
}
