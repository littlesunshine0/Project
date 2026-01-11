//
//  MetricWidget.swift
//  DesignKit
//
//  Metric display widget component with adaptive sizing
//

import SwiftUI

public struct MetricWidget: View {
    public let title: String
    public let value: String
    public let subtitle: String?
    public let icon: String
    public let color: Color
    public let trend: Trend?
    public let size: WidgetCardSize
    
    public enum Trend {
        case up(String), down(String), neutral(String)
        
        public var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .neutral: return "arrow.right"
            }
        }
        
        public var color: Color {
            switch self {
            case .up: return FlowColors.Status.success
            case .down: return FlowColors.Status.error
            case .neutral: return FlowColors.Status.neutral
            }
        }
        
        public var text: String {
            switch self {
            case .up(let t), .down(let t), .neutral(let t): return t
            }
        }
    }
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var animateValue = false
    
    public init(
        title: String,
        value: String,
        subtitle: String? = nil,
        icon: String,
        color: Color = .accentColor,
        trend: Trend? = nil,
        size: WidgetCardSize = .small
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.trend = trend
        self.size = size
    }
    
    public var body: some View {
        WidgetCard(style: .vibrant(color), size: size, accentColor: color) {
            VStack(alignment: .leading, spacing: size == .compact ? 6 : 10) {
                HStack {
                    ZStack {
                        Circle().fill(color.opacity(0.15)).frame(width: iconContainerSize, height: iconContainerSize)
                        Circle().fill(LinearGradient(colors: [color, color.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: iconContainerSize - 4, height: iconContainerSize - 4).shadow(color: color.opacity(0.3), radius: 6, y: 2)
                        Image(systemName: icon).font(.system(size: iconFontSize, weight: .semibold)).foregroundStyle(.white)
                    }
                    Spacer()
                    if let trend = trend { TrendBadge(trend: trend, compact: size == .compact) }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: size == .compact ? 2 : 3) {
                    Text(value).font(valueFont).foregroundStyle(FlowColors.Text.primary(colorScheme))
                        .scaleEffect(animateValue ? 1.0 : 0.9).opacity(animateValue ? 1.0 : 0)
                    Text(title).font(titleFont).foregroundStyle(FlowColors.Text.secondary(colorScheme))
                    if let subtitle = subtitle, size != .compact {
                        Text(subtitle).font(FlowTypography.micro()).foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                    }
                }
            }
            .padding(size.contentPadding)
        }
        .onAppear { withAnimation(FlowMotion.bounce.delay(0.1)) { animateValue = true } }
    }
    
    private var iconContainerSize: CGFloat {
        switch size {
        case .extraSmall, .compact: return 28
        case .small: return 36
        default: return 40
        }
    }
    
    private var iconFontSize: CGFloat {
        switch size {
        case .extraSmall, .compact: return 11
        case .small: return 14
        default: return 16
        }
    }
    
    private var valueFont: Font {
        switch size {
        case .extraSmall, .compact: return FlowTypography.title3(.bold)
        case .small: return FlowTypography.title2(.bold)
        default: return FlowTypography.title1(.bold)
        }
    }
    
    private var titleFont: Font {
        switch size {
        case .extraSmall, .compact: return FlowTypography.micro(.medium)
        case .small: return FlowTypography.caption(.medium)
        default: return FlowTypography.body(.medium)
        }
    }
}
