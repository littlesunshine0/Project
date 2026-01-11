//
//  WidgetCardSize.swift
//  DesignKit
//
//  Widget card sizes following Apple HIG guidelines
//  Supports adaptive grid layouts with multiple size options
//

import SwiftUI

/// Widget sizes following Apple HIG for adaptive layouts
/// Designed to work in 2, 3, or 4 column grids
public enum WidgetCardSize: String, CaseIterable, Sendable {
    /// Extra small - minimal info display (1 column in 4-col grid)
    case extraSmall
    /// Compact - condensed info (1 column in 4-col grid)
    case compact
    /// Small - standard metric widget (1 column in 4-col grid)
    case small
    /// Medium - detailed content (2 columns in 4-col grid)
    case medium
    /// Large - expanded content (2 columns, taller)
    case large
    /// Wide - horizontal span (3-4 columns in 4-col grid)
    case wide
    /// Tall - vertical emphasis (1 column, double height)
    case tall
    /// Full - full width content
    case full
    
    // MARK: - Dimensions
    
    public var minWidth: CGFloat {
        switch self {
        case .extraSmall: return 100
        case .compact: return 140
        case .small: return 160
        case .tall: return 160
        case .medium: return 280
        case .large: return 320
        case .wide: return 400
        case .full: return 500
        }
    }
    
    public var minHeight: CGFloat {
        switch self {
        case .extraSmall: return 70
        case .compact: return 90
        case .small: return 110
        case .medium: return 120
        case .wide: return 100
        case .large: return 200
        case .tall: return 220
        case .full: return 120
        }
    }
    
    public var maxWidth: CGFloat? {
        switch self {
        case .extraSmall: return 140
        case .compact: return 180
        case .small: return 220
        case .tall: return 220
        case .medium: return 400
        case .large: return 450
        case .wide: return nil
        case .full: return nil
        }
    }
    
    // MARK: - Grid Span
    
    /// Number of columns this widget spans in a 4-column grid
    public var columnSpan: Int {
        switch self {
        case .extraSmall, .compact, .small, .tall: return 1
        case .medium, .large: return 2
        case .wide: return 3
        case .full: return 4
        }
    }
    
    /// Number of rows this widget spans
    public var rowSpan: Int {
        switch self {
        case .extraSmall, .compact, .small, .medium, .wide, .full: return 1
        case .large, .tall: return 2
        }
    }
    
    // MARK: - Padding
    
    public var contentPadding: CGFloat {
        switch self {
        case .extraSmall: return 10
        case .compact: return 12
        case .small, .tall: return 14
        case .medium, .large: return 16
        case .wide, .full: return 18
        }
    }
    
    // MARK: - Typography Scale
    
    public var titleSize: CGFloat {
        switch self {
        case .extraSmall: return 11
        case .compact: return 12
        case .small, .tall: return 13
        case .medium, .large: return 14
        case .wide, .full: return 15
        }
    }
    
    public var valueSize: CGFloat {
        switch self {
        case .extraSmall: return 18
        case .compact: return 20
        case .small, .tall: return 24
        case .medium, .large: return 28
        case .wide, .full: return 32
        }
    }
    
    // MARK: - Icon Size
    
    public var iconSize: CGFloat {
        switch self {
        case .extraSmall: return 24
        case .compact: return 28
        case .small, .tall: return 32
        case .medium, .large: return 36
        case .wide, .full: return 40
        }
    }
}

// MARK: - Adaptive Grid Helper

public struct AdaptiveWidgetGrid {
    
    /// Calculate optimal column count based on available width
    public static func columnCount(for width: CGFloat, minColumnWidth: CGFloat = 180) -> Int {
        max(1, Int(width / minColumnWidth))
    }
    
    /// Create grid items for adaptive layout
    public static func gridItems(columns: Int, spacing: CGFloat = 16) -> [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns)
    }
    
    /// Determine if widgets should double up based on available width
    public static func shouldDoubleUp(availableWidth: CGFloat, chatOpen: Bool) -> Bool {
        let effectiveWidth = chatOpen ? availableWidth - 500 : availableWidth
        return effectiveWidth >= 800
    }
}
