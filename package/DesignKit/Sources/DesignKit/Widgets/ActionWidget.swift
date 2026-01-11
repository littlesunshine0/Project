//
//  ActionWidget.swift
//  DesignKit
//
//  Action button widget component with adaptive sizing
//

import SwiftUI

public struct ActionWidget: View {
    public let title: String
    public let description: String
    public let icon: String
    public let color: Color
    public let badge: String?
    public let size: WidgetCardSize
    public let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    public init(
        title: String,
        description: String,
        icon: String,
        color: Color,
        badge: String? = nil,
        size: WidgetCardSize = .small,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.color = color
        self.badge = badge
        self.size = size
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            WidgetCard(style: .vibrant(color), size: size, accentColor: color) {
                VStack(alignment: .leading, spacing: size == .compact ? 6 : 10) {
                    HStack {
                        ZStack {
                            Circle().fill(color.opacity(0.3)).frame(width: iconContainerSize + 4, height: iconContainerSize + 4).blur(radius: isHovered ? 8 : 4)
                            Circle().fill(LinearGradient(colors: [color, color.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: iconContainerSize, height: iconContainerSize).shadow(color: color.opacity(0.4), radius: isHovered ? 12 : 6, y: isHovered ? 6 : 3)
                            Image(systemName: icon).font(.system(size: iconFontSize, weight: .semibold)).foregroundStyle(.white)
                        }
                        Spacer()
                        if let badge = badge, size != .compact { FlowBadge(badge, color: color, style: .subtle) }
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: size == .compact ? 2 : 4) {
                        HStack {
                            Text(title).font(titleFont).foregroundStyle(FlowColors.Text.primary(colorScheme))
                            Image(systemName: "arrow.right").font(.system(size: size == .compact ? 8 : 10, weight: .bold)).foregroundStyle(color).offset(x: isHovered ? 4 : 0)
                        }
                        if size != .compact {
                            Text(description).font(FlowTypography.caption()).foregroundStyle(FlowColors.Text.secondary(colorScheme)).lineLimit(2)
                        }
                    }
                }
                .padding(size.contentPadding)
            }
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
    
    private var iconContainerSize: CGFloat {
        switch size {
        case .extraSmall, .compact: return 32
        case .small: return 40
        default: return 44
        }
    }
    
    private var iconFontSize: CGFloat {
        switch size {
        case .extraSmall, .compact: return 14
        case .small: return 18
        default: return 20
        }
    }
    
    private var titleFont: Font {
        switch size {
        case .extraSmall, .compact: return FlowTypography.body(.medium)
        case .small: return FlowTypography.headline()
        default: return FlowTypography.title3()
        }
    }
}
