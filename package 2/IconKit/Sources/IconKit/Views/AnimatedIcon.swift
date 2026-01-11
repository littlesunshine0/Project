//
//  AnimatedIcon.swift
//  IconKit
//
//  Animated icon components for UI
//

import SwiftUI

/// Animation types for icons
public enum IconAnimation: Sendable {
    case none
    case pulse
    case rotate
    case bounce
    case fade
    case glow
}

/// Animated icon view
public struct AnimatedIcon: View {
    let systemName: String
    let color: Color
    let size: CGFloat
    let animation: IconAnimation
    
    @State private var isAnimating = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        systemName: String,
        color: Color = .primary,
        size: CGFloat = 24,
        animation: IconAnimation = .none
    ) {
        self.systemName = systemName
        self.color = color
        self.size = size
        self.animation = animation
    }
    
    public var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(color)
            .modifier(AnimationModifier(
                animation: animation,
                isAnimating: isAnimating,
                reduceMotion: reduceMotion
            ))
            .onAppear {
                if !reduceMotion {
                    startAnimation()
                }
            }
    }
    
    private func startAnimation() {
        switch animation {
        case .none:
            break
        case .pulse:
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        case .rotate:
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        case .bounce:
            withAnimation(.spring(response: 0.5, dampingFraction: 0.3).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        case .fade:
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        case .glow:
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Animation Modifier

private struct AnimationModifier: ViewModifier {
    let animation: IconAnimation
    let isAnimating: Bool
    let reduceMotion: Bool
    
    func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            switch animation {
            case .none:
                content
            case .pulse:
                content.scaleEffect(isAnimating ? 1.2 : 1.0)
            case .rotate:
                content.rotationEffect(.degrees(isAnimating ? 360 : 0))
            case .bounce:
                content.offset(y: isAnimating ? -5 : 0)
            case .fade:
                content.opacity(isAnimating ? 0.5 : 1.0)
            case .glow:
                content
                    .shadow(color: .white.opacity(isAnimating ? 0.8 : 0.2), radius: isAnimating ? 10 : 2)
            }
        }
    }
}

// MARK: - Icon with Badge

public struct IconWithBadge: View {
    let systemName: String
    let badgeCount: Int?
    let color: Color
    let size: CGFloat
    
    public init(
        systemName: String,
        badge: Int? = nil,
        color: Color = .primary,
        size: CGFloat = 24
    ) {
        self.systemName = systemName
        self.badgeCount = badge
        self.color = color
        self.size = size
    }
    
    public var body: some View {
        ZStack(alignment: .topTrailing) {
            AnimatedIcon(systemName: systemName, color: color, size: size)
            
            if let count = badgeCount, count > 0 {
                Text("\(min(count, 99))")
                    .font(.system(size: size * 0.4, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(size * 0.15)
                    .background(Circle().fill(.red))
                    .offset(x: size * 0.3, y: -size * 0.2)
            }
        }
    }
}

// MARK: - Icon Button

public struct IconButton: View {
    let systemName: String
    let color: Color
    let size: CGFloat
    let action: () -> Void
    
    @State private var isHovered = false
    @State private var isPressed = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(
        systemName: String,
        color: Color = .primary,
        size: CGFloat = 24,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.color = color
        self.size = size
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            AnimatedIcon(systemName: systemName, color: color, size: size)
                .padding(size * 0.4)
                .background(
                    Circle()
                        .fill(isHovered ? color.opacity(0.1) : Color.clear)
                )
                .scaleEffect(isPressed ? 0.9 : (isHovered ? 1.1 : 1.0))
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .animation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        .animation(reduceMotion ? .none : .spring(response: 0.2, dampingFraction: 0.8), value: isPressed)
    }
}

// MARK: - Preview

#Preview("Animated Icons") {
    VStack(spacing: 30) {
        HStack(spacing: 20) {
            AnimatedIcon(systemName: "star.fill", color: .yellow, size: 32, animation: .pulse)
            AnimatedIcon(systemName: "gear", color: .gray, size: 32, animation: .rotate)
            AnimatedIcon(systemName: "bell.fill", color: .orange, size: 32, animation: .bounce)
            AnimatedIcon(systemName: "heart.fill", color: .red, size: 32, animation: .glow)
        }
        
        HStack(spacing: 20) {
            IconWithBadge(systemName: "envelope.fill", badge: 5, color: .blue, size: 32)
            IconWithBadge(systemName: "bell.fill", badge: 99, color: .orange, size: 32)
        }
    }
    .padding()
}
