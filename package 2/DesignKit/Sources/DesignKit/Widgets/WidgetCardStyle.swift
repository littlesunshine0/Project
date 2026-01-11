//
//  WidgetCardStyle.swift
//  DesignKit
//
//  Widget card style enum
//

import SwiftUI

public enum WidgetCardStyle: Equatable {
    case standard
    case elevated
    case outlined
    case glass
    case gradient(Color, Color)
    case vibrant(Color)
    
    public static func == (lhs: WidgetCardStyle, rhs: WidgetCardStyle) -> Bool {
        switch (lhs, rhs) {
        case (.standard, .standard), (.elevated, .elevated), (.outlined, .outlined), (.glass, .glass): return true
        case (.gradient(let c1, let c2), .gradient(let c3, let c4)): return c1 == c3 && c2 == c4
        case (.vibrant(let c1), .vibrant(let c2)): return c1 == c2
        default: return false
        }
    }
}
