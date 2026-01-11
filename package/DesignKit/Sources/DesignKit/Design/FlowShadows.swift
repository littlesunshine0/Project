//
//  FlowShadows.swift
//  DesignKit
//
//  Shadow definitions for FlowKit
//

import SwiftUI

public struct FlowShadows {
    public static func subtle(_ scheme: ColorScheme) -> (color: Color, radius: CGFloat, y: CGFloat) {
        (scheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.08), 4, 2)
    }
    
    public static func medium(_ scheme: ColorScheme) -> (color: Color, radius: CGFloat, y: CGFloat) {
        (scheme == .dark ? Color.black.opacity(0.4) : Color.black.opacity(0.12), 8, 4)
    }
    
    public static func elevated(_ scheme: ColorScheme) -> (color: Color, radius: CGFloat, y: CGFloat) {
        (scheme == .dark ? Color.black.opacity(0.5) : Color.black.opacity(0.15), 16, 8)
    }
}
