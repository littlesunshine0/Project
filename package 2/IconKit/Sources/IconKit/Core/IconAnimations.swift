//
//  IconAnimations.swift
//  IconKit
//
//  Professional animation system for icons
//  Includes easing curves, physics-based motion, and orchestrated sequences
//

import SwiftUI

// MARK: - Custom Easing Curves

/// Professional easing functions beyond standard SwiftUI
public struct IconEasing {
    
    /// Smooth ease-in-out with overshoot (bouncy feel)
    public static func elasticOut(duration: Double = 0.6) -> Animation {
        .timingCurve(0.68, -0.55, 0.265, 1.55, duration: duration)
    }
    
    /// Smooth deceleration (natural stop)
    public static func smoothDecel(duration: Double = 0.4) -> Animation {
        .timingCurve(0.0, 0.0, 0.2, 1.0, duration: duration)
    }
    
    /// Quick start, smooth end
    public static func quickStart(duration: Double = 0.3) -> Animation {
        .timingCurve(0.4, 0.0, 0.2, 1.0, duration: duration)
    }
    
    /// Anticipation (slight pullback before action)
    public static func anticipate(duration: Double = 0.5) -> Animation {
        .timingCurve(0.36, 0.0, 0.66, -0.56, duration: duration)
    }
    
    /// Breathing animation (organic pulse)
    public static func breathing(duration: Double = 2.0) -> Animation {
        .easeInOut(duration: duration).repeatForever(autoreverses: true)
    }
    
    /// Gentle float (subtle up/down)
    public static func gentleFloat(duration: Double = 3.0) -> Animation {
        .easeInOut(duration: duration).repeatForever(autoreverses: true)
    }
    
    /// Rotation with momentum
    public static func spinWithMomentum(duration: Double = 1.0) -> Animation {
        .timingCurve(0.0, 0.7, 0.3, 1.0, duration: duration)
    }
}

// MARK: - Animation Phases

/// Orchestrated animation phases for complex icon animations
public enum AnimationPhase: CaseIterable {
    case idle
    case anticipate
    case action
    case settle
    
    public var scale: CGFloat {
        switch self {
        case .idle: return 1.0
        case .anticipate: return 0.95
        case .action: return 1.08
        case .settle: return 1.0
        }
    }
    
    public var rotation: Double {
        switch self {
        case .idle: return 0
        case .anticipate: return -3
        case .action: return 5
        case .settle: return 0
        }
    }
    
    public var opacity: Double {
        switch self {
        case .idle: return 1.0
        case .anticipate: return 0.9
        case .action: return 1.0
        case .settle: return 1.0
        }
    }
}

// MARK: - Glow Animation State

/// State for animated glow effects
public struct GlowState: Sendable {
    public let intensity: Double
    public let radius: CGFloat
    public let offset: CGSize
    
    public static let idle = GlowState(intensity: 0.3, radius: 10, offset: .zero)
    public static let active = GlowState(intensity: 0.8, radius: 20, offset: .zero)
    public static let pulse = GlowState(intensity: 0.6, radius: 15, offset: .zero)
    
    public init(intensity: Double, radius: CGFloat, offset: CGSize) {
        self.intensity = intensity
        self.radius = radius
        self.offset = offset
    }
}

// MARK: - Particle System

/// Simple particle for icon effects
public struct IconParticle: Identifiable {
    public let id = UUID()
    public var position: CGPoint
    public var velocity: CGVector
    public var scale: CGFloat
    public var opacity: Double
    public var rotation: Double
    public var lifetime: Double
    public var age: Double = 0
    
    public init(
        position: CGPoint,
        velocity: CGVector = .zero,
        scale: CGFloat = 1.0,
        opacity: Double = 1.0,
        rotation: Double = 0,
        lifetime: Double = 1.0
    ) {
        self.position = position
        self.velocity = velocity
        self.scale = scale
        self.opacity = opacity
        self.rotation = rotation
        self.lifetime = lifetime
    }
    
    public var isAlive: Bool { age < lifetime }
    
    public var currentOpacity: Double {
        let progress = age / lifetime
        // Fade in quickly, fade out slowly
        if progress < 0.1 {
            return opacity * (progress / 0.1)
        } else {
            return opacity * (1 - pow(progress, 2))
        }
    }
    
    public mutating func update(deltaTime: Double) {
        age += deltaTime
        position.x += velocity.dx * deltaTime
        position.y += velocity.dy * deltaTime
        // Slow down over time
        velocity.dx *= 0.98
        velocity.dy *= 0.98
    }
}

/// Particle emitter for icon effects
@Observable
public class IconParticleEmitter {
    public var particles: [IconParticle] = []
    public var isEmitting = false
    
    private var emitTimer: Timer?
    private let maxParticles: Int
    
    public init(maxParticles: Int = 20) {
        self.maxParticles = maxParticles
    }
    
    public func startEmitting(from center: CGPoint, spread: CGFloat = 50) {
        isEmitting = true
        emitTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.emit(from: center, spread: spread)
        }
    }
    
    public func stopEmitting() {
        isEmitting = false
        emitTimer?.invalidate()
        emitTimer = nil
    }
    
    private func emit(from center: CGPoint, spread: CGFloat) {
        guard particles.count < maxParticles else { return }
        
        let angle = Double.random(in: 0...(2 * .pi))
        let speed = Double.random(in: 20...60)
        
        let particle = IconParticle(
            position: center,
            velocity: CGVector(
                dx: cos(angle) * speed,
                dy: sin(angle) * speed
            ),
            scale: CGFloat.random(in: 0.3...0.8),
            opacity: Double.random(in: 0.5...1.0),
            rotation: Double.random(in: 0...360),
            lifetime: Double.random(in: 0.8...1.5)
        )
        
        particles.append(particle)
    }
    
    public func update(deltaTime: Double) {
        for i in particles.indices.reversed() {
            particles[i].update(deltaTime: deltaTime)
            if !particles[i].isAlive {
                particles.remove(at: i)
            }
        }
    }
}

// MARK: - Animation Modifiers

/// Breathing glow effect modifier
public struct BreathingGlowModifier: ViewModifier {
    let color: Color
    let minRadius: CGFloat
    let maxRadius: CGFloat
    let duration: Double
    
    @State private var isGlowing = false
    
    public init(color: Color, minRadius: CGFloat = 5, maxRadius: CGFloat = 15, duration: Double = 2.0) {
        self.color = color
        self.minRadius = minRadius
        self.maxRadius = maxRadius
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(isGlowing ? 0.8 : 0.3), radius: isGlowing ? maxRadius : minRadius)
            .onAppear {
                withAnimation(IconEasing.breathing(duration: duration)) {
                    isGlowing = true
                }
            }
    }
}

/// Floating animation modifier
public struct FloatingModifier: ViewModifier {
    let amplitude: CGFloat
    let duration: Double
    
    @State private var isFloating = false
    
    public init(amplitude: CGFloat = 5, duration: Double = 3.0) {
        self.amplitude = amplitude
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .offset(y: isFloating ? -amplitude : amplitude)
            .onAppear {
                withAnimation(IconEasing.gentleFloat(duration: duration)) {
                    isFloating = true
                }
            }
    }
}

/// Pulse scale modifier
public struct PulseModifier: ViewModifier {
    let minScale: CGFloat
    let maxScale: CGFloat
    let duration: Double
    
    @State private var isPulsing = false
    
    public init(minScale: CGFloat = 0.98, maxScale: CGFloat = 1.02, duration: Double = 1.5) {
        self.minScale = minScale
        self.maxScale = maxScale
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? maxScale : minScale)
            .onAppear {
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}

/// Shimmer effect modifier
public struct ShimmerModifier: ViewModifier {
    let duration: Double
    
    @State private var shimmerOffset: CGFloat = -1
    
    public init(duration: Double = 2.0) {
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.3),
                            Color.white.opacity(0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.5)
                    .offset(x: shimmerOffset * geo.size.width * 1.5)
                    .onAppear {
                        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                            shimmerOffset = 1
                        }
                    }
                }
            )
            .clipped()
    }
}

// MARK: - View Extensions

public extension View {
    func breathingGlow(color: Color, minRadius: CGFloat = 5, maxRadius: CGFloat = 15, duration: Double = 2.0) -> some View {
        modifier(BreathingGlowModifier(color: color, minRadius: minRadius, maxRadius: maxRadius, duration: duration))
    }
    
    func floating(amplitude: CGFloat = 5, duration: Double = 3.0) -> some View {
        modifier(FloatingModifier(amplitude: amplitude, duration: duration))
    }
    
    func pulse(minScale: CGFloat = 0.98, maxScale: CGFloat = 1.02, duration: Double = 1.5) -> some View {
        modifier(PulseModifier(minScale: minScale, maxScale: maxScale, duration: duration))
    }
    
    func shimmer(duration: Double = 2.0) -> some View {
        modifier(ShimmerModifier(duration: duration))
    }
}

// MARK: - Orchestrated Animation Controller

/// Controller for complex multi-phase animations
@MainActor
@Observable
public class IconAnimationController {
    public var phase: AnimationPhase = .idle
    public var glowState: GlowState = .idle
    public var rotation: Double = 0
    public var scale: CGFloat = 1.0
    public var isAnimating = false
    
    public init() {}
    
    /// Play a complete animation sequence
    public func playSequence() {
        guard !isAnimating else { return }
        isAnimating = true
        
        // Phase 1: Anticipate
        withAnimation(IconEasing.quickStart(duration: 0.15)) {
            phase = .anticipate
            scale = phase.scale
            rotation = phase.rotation
        }
        
        // Phase 2: Action
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 150_000_000)
            withAnimation(IconEasing.elasticOut(duration: 0.4)) {
                self.phase = .action
                self.scale = self.phase.scale
                self.rotation = self.phase.rotation
                self.glowState = .active
            }
        }
        
        // Phase 3: Settle
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 550_000_000)
            withAnimation(IconEasing.smoothDecel(duration: 0.3)) {
                self.phase = .settle
                self.scale = self.phase.scale
                self.rotation = self.phase.rotation
                self.glowState = .idle
            }
        }
        
        // Reset
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 850_000_000)
            self.phase = .idle
            self.isAnimating = false
        }
    }
    
    /// Start continuous idle animation
    public func startIdleAnimation() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            glowState = .pulse
        }
    }
}
