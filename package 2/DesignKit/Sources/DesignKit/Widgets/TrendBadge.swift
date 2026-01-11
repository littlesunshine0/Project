//
//  TrendBadge.swift
//  DesignKit
//
//  Trend indicator badge component with compact mode
//

import SwiftUI

public struct TrendBadge: View {
    public let trend: MetricWidget.Trend
    public let compact: Bool
    @State private var isAnimating = false
    
    public init(trend: MetricWidget.Trend, compact: Bool = false) {
        self.trend = trend
        self.compact = compact
    }
    
    public var body: some View {
        HStack(spacing: compact ? 2 : 3) {
            Image(systemName: trend.icon)
                .font(.system(size: compact ? 7 : 9, weight: .bold))
                .offset(y: isAnimating ? -1 : 1)
            if !compact {
                Text(trend.text).font(FlowTypography.micro(.bold))
            }
        }
        .foregroundStyle(trend.color)
        .padding(.horizontal, compact ? 5 : 8)
        .padding(.vertical, compact ? 3 : 4)
        .background(
            Capsule()
                .fill(trend.color.opacity(0.15))
                .overlay(Capsule().strokeBorder(trend.color.opacity(0.2), lineWidth: 1))
        )
        .onAppear { withAnimation(.easeInOut(duration: 1).repeatForever()) { isAnimating = true } }
    }
}
