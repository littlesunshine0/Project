//
//  FlowMotion.swift
//  DesignKit
//
//  Animation constants for FlowKit
//

import SwiftUI

public struct FlowMotion {
    public static let quick = Animation.easeOut(duration: 0.15)
    public static let standard = Animation.easeInOut(duration: 0.25)
    public static let bounce = Animation.spring(response: 0.35, dampingFraction: 0.7)
    public static let smooth = Animation.easeInOut(duration: 0.4)
}
