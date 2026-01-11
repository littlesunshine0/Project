//
//  StatItem.swift
//  DesignKit
//
//  Stat display item component
//

import SwiftUI

public struct StatItem: View {
    public let icon: String
    public let value: String
    public let label: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(icon: String, value: String, label: String) {
        self.icon = icon
        self.value = value
        self.label = label
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.caption).foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            Text(value).font(FlowTypography.caption(.medium)).foregroundStyle(FlowColors.Text.primary(colorScheme))
        }
    }
}
