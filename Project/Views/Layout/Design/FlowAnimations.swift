//
//  FlowAnimations.swift
//  FlowKit
//
//  Advanced animation system with spring physics and motion design
//

import SwiftUI

// MARK: - Flow Motion System

public enum FlowMotion {
    
    // MARK: - Standard Animations
    
    /// Standard UI transition - balanced speed and smoothness
    public static var standard: Animation {
        .spring(response: 0.35, dampingFraction: 0.8, blendDuration: 0.1)
    }
    
    /// Quick micro-interactions
    public static var quick: Animation {
        .spring(response: 0.2, dampingFraction: 0.85, blendDuration: 0)
    }
    
    /// Slow, deliberate transitions
    public static var gentle: Animation {
        .spring(response: 0.5, dampingFraction: 0.75, blendDuration: 0.15)
    }
    
    /// Bouncy, playful animation
    public static var bouncy: Animation {
        .spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.1)
    }
    
    /// Snappy, responsive feel
    public static var snappy: Animation {
        .spring(response: 0.25, dampingFraction: 0.9, blendDuration: 0)
    }
    
    // MARK: - Panel Animations
    
    /// Panel open/close
    public static var panelTransition: Animation {
        .spring(response: 0.4, dampingFraction: 0.82, blendDuration: 0.1)
    }
    
    /// Sidebar slide
    public static var sidebarSlide: Animation {
        .spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.05)
    }
    
    /// Bottom panel expand/collapse
    public static var bottomPanel: Animation {
        .spring(response: 0.3, dampingFraction: 0.88, blendDuration: 0.05)
    }
    
    // MARK: - Interactive Animations
    
    /// Hover state change
    public static var hover: Animation {
        .easeOut(duration: 0.15)
    }
    
    /// Press/tap feedback
    public static var press: Animation {
        .spring(response: 0.15, dampingFraction: 0.9, blendDuration: 0)
    }
    
    /// Focus ring appearance
    public static var focus: Animation {
        .easeInOut(duration: 0.2)
    }
    
    // MARK: - Content Animations
    
    /// List item appearance
    public static var listItem: Animation {
        .spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.05)
    }
    
    /// Card flip/transform
    public static var cardTransform: Animation {
        .spring(response: 0.45, dampingFraction: 0.7, blendDuration: 0.1)
    }
    
    /// Tab switch
    public static var tabSwitch: Animation {
        .spring(response: 0.25, dampingFraction: 0.9, blendDuration: 0)
    }
    
    // MARK: - Staggered Animations
    
    /// Create staggered delay for list items
    public static func staggered(index: Int, baseDelay: Double = 0.03) -> Animation {
        standard.delay(Double(index) * baseDelay)
    }
    
    /// Create staggered animation with custom base
    public static func staggered(index: Int, base: Animation, delay: Double = 0.03) -> Animation {
        base.delay(Double(index) * delay)
    }
}

// MARK: - Transition Presets

public extension AnyTransition {
    
    /// Slide from right with fade
    static var slideFromRight: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .trailing).combined(with: .opacity)
        )
    }
    
    /// Slide from left with fade
    static var slideFromLeft: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .leading).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
    
    /// Slide from bottom with fade
    static var slideFromBottom: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )
    }
    
    /// Scale up with fade
    static var scaleUp: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.9).combined(with: .opacity),
            removal: .scale(scale: 0.95).combined(with: .opacity)
        )
    }
    
    /// Panel appearance (scale + slide)
    static var panelAppear: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.95, anchor: .topTrailing)
                .combined(with: .opacity)
                .combined(with: .offset(x: 20)),
            removal: .scale(scale: 0.98, anchor: .topTrailing)
                .combined(with: .opacity)
                .combined(with: .offset(x: 10))
        )
    }
    
    /// Bottom bar expand
    static var bottomBarExpand: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )
    }
}

// MARK: - Animation Modifiers

public struct PressableButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(FlowMotion.press, value: configuration.isPressed)
    }
}

public struct HoverScaleModifier: ViewModifier {
    @State private var isHovered = false
    let scale: CGFloat
    
    public init(scale: CGFloat = 1.02) {
        self.scale = scale
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(isHovered ? scale : 1.0)
            .animation(FlowMotion.hover, value: isHovered)
            .onHover { isHovered = $0 }
    }
}

public struct GlowPulseModifier: ViewModifier {
    let color: Color
    let isActive: Bool
    @State private var isPulsing = false
    
    public func body(content: Content) -> some View {
        content
            .shadow(
                color: isActive ? color.opacity(isPulsing ? 0.6 : 0.3) : .clear,
                radius: isPulsing ? 12 : 8
            )
            .onAppear {
                if isActive {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        isPulsing = true
                    }
                }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        isPulsing = true
                    }
                } else {
                    isPulsing = false
                }
            }
    }
}

// MARK: - View Extensions

public extension View {
    func pressableButton() -> some View {
        buttonStyle(PressableButtonStyle())
    }
    
    func hoverScale(_ scale: CGFloat = 1.02) -> some View {
        modifier(HoverScaleModifier(scale: scale))
    }
    
    func glowPulse(color: Color, isActive: Bool) -> some View {
        modifier(GlowPulseModifier(color: color, isActive: isActive))
    }
    
    func animateOnAppear(delay: Double = 0) -> some View {
        self
            .opacity(0)
            .offset(y: 10)
            .onAppear {
                withAnimation(FlowMotion.standard.delay(delay)) {
                    // Animation handled by state
                }
            }
    }
}
