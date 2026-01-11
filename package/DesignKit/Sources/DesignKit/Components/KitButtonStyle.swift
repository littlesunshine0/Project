//
//  KitButtonStyle.swift
//  DesignKit
//
//  Custom button style for Kit components
//

import SwiftUI

public struct KitButtonStyle: ButtonStyle {
    public let color: Color
    
    public init(color: Color) { self.color = color }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(FlowTypography.body(.medium))
            .foregroundStyle(color)
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(color.opacity(configuration.isPressed ? 0.2 : 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
