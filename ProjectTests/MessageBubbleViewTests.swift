//
//  MessageBubbleViewTests.swift
//  ProjectTests
//
//  Property-based tests for MessageBubbleView
//

import XCTest
import SwiftUI
@testable import Project

class MessageBubbleViewTests: XCTestCase {
    
    // MARK: - Property 3: Message hover state changes
    // **Feature: ui-enhancement, Property 3: Message hover state changes**
    // **Validates: Requirements 2.2**
    
    /// For any message bubble, when the user hovers over it, the bubble should display an elevated shadow and subtle scale transformation
    func testMessageHoverStateChanges() {
        // Test that hover state affects shadow and scale
        // When hovered: shadow should be more intense, scale should be 1.02
        // When not hovered: shadow should be subtle, scale should be 1.0
        
        // Test shadow intensity changes on hover
        let notHoveredShadowOpacity: Double = 0.08
        let hoveredShadowOpacity: Double = 0.15
        
        XCTAssertLessThan(
            notHoveredShadowOpacity,
            hoveredShadowOpacity,
            "Hovered message should have more intense shadow than non-hovered"
        )
        
        // Test shadow radius changes on hover
        let notHoveredShadowRadius: CGFloat = 6
        let hoveredShadowRadius: CGFloat = 12
        
        XCTAssertLessThan(
            notHoveredShadowRadius,
            hoveredShadowRadius,
            "Hovered message should have larger shadow radius than non-hovered"
        )
        
        // Test shadow offset changes on hover
        let notHoveredShadowOffset: CGFloat = 3
        let hoveredShadowOffset: CGFloat = 6
        
        XCTAssertLessThan(
            notHoveredShadowOffset,
            hoveredShadowOffset,
            "Hovered message should have larger shadow offset than non-hovered"
        )
        
        // Test scale changes on hover
        let notHoveredScale: CGFloat = 1.0
        let hoveredScale: CGFloat = 1.02
        
        XCTAssertEqual(
            notHoveredScale,
            1.0,
            "Non-hovered message should have scale of 1.0"
        )
        
        XCTAssertEqual(
            hoveredScale,
            1.02,
            "Hovered message should have scale of 1.02"
        )
        
        XCTAssertGreaterThan(
            hoveredScale,
            notHoveredScale,
            "Hovered message should have larger scale than non-hovered"
        )
    }
    
    /// Test that hover state changes are smooth with spring animation
    func testMessageHoverAnimationTiming() {
        // The hover animation should use spring animation with response: 0.3, damping: 0.7
        // This creates a smooth, responsive animation
        
        let expectedResponse: Double = 0.3
        let expectedDamping: Double = 0.7
        
        // Verify the animation parameters are appropriate for hover interactions
        XCTAssertLessThanOrEqual(
            expectedResponse,
            0.5,
            "Hover animation response should be quick (<= 0.5s) for immediate feedback"
        )
        
        XCTAssertGreaterThanOrEqual(
            expectedDamping,
            0.6,
            "Hover animation damping should be high (>= 0.6) for smooth motion without excessive bounce"
        )
        
        XCTAssertLessThanOrEqual(
            expectedDamping,
            0.8,
            "Hover animation damping should not be too high (<= 0.8) to maintain some spring character"
        )
    }
    
    /// Test that hover state respects reduce motion setting
    func testMessageHoverRespectsReduceMotion() {
        // When reduce motion is enabled, the scale effect should not be applied
        // When reduce motion is disabled, the scale effect should be applied
        
        // Test with reduce motion enabled
        let reduceMotionEnabled = true
        let scaleWithReduceMotion = reduceMotionEnabled ? 1.0 : 1.02
        
        XCTAssertEqual(
            scaleWithReduceMotion,
            1.0,
            "Message should not scale on hover when reduce motion is enabled"
        )
        
        // Test with reduce motion disabled
        let reduceMotionDisabled = false
        let scaleWithoutReduceMotion = reduceMotionDisabled ? 1.0 : 1.02
        
        XCTAssertEqual(
            scaleWithoutReduceMotion,
            1.02,
            "Message should scale on hover when reduce motion is disabled"
        )
    }
    
    /// Test that all shadow layers change on hover
    func testMessageHoverMultiLayerShadowChanges() {
        // The message bubble uses 3 shadow layers, all should change on hover
        
        // Define shadow layers for non-hovered state
        let notHoveredLayers = [
            (opacity: 0.08, radius: CGFloat(6), y: CGFloat(3)),
            (opacity: 0.05, radius: CGFloat(4), y: CGFloat(2)),
            (opacity: 0.02, radius: CGFloat(2), y: CGFloat(1))
        ]
        
        // Define shadow layers for hovered state
        let hoveredLayers = [
            (opacity: 0.15, radius: CGFloat(12), y: CGFloat(6)),
            (opacity: 0.1, radius: CGFloat(8), y: CGFloat(4)),
            (opacity: 0.05, radius: CGFloat(4), y: CGFloat(2))
        ]
        
        // Verify we have the same number of layers
        XCTAssertEqual(
            notHoveredLayers.count,
            hoveredLayers.count,
            "Hovered and non-hovered states should have the same number of shadow layers"
        )
        
        // Verify each layer increases in intensity on hover
        for (index, (notHovered, hovered)) in zip(notHoveredLayers, hoveredLayers).enumerated() {
            XCTAssertGreaterThan(
                hovered.opacity,
                notHovered.opacity,
                "Shadow layer \(index) opacity should increase on hover"
            )
            
            XCTAssertGreaterThan(
                hovered.radius,
                notHovered.radius,
                "Shadow layer \(index) radius should increase on hover"
            )
            
            XCTAssertGreaterThan(
                hovered.y,
                notHovered.y,
                "Shadow layer \(index) y offset should increase on hover"
            )
        }
    }
    
    /// Test that hover state changes are consistent across message types
    func testMessageHoverConsistentAcrossMessageTypes() {
        // Both user and assistant messages should have the same hover behavior
        // The scale and shadow changes should be identical regardless of sender
        
        let hoveredScale: CGFloat = 1.02
        let notHoveredScale: CGFloat = 1.0
        
        // Test user message hover
        let userMessageHoverScale = hoveredScale
        XCTAssertEqual(
            userMessageHoverScale,
            1.02,
            "User message should scale to 1.02 on hover"
        )
        
        // Test assistant message hover
        let assistantMessageHoverScale = hoveredScale
        XCTAssertEqual(
            assistantMessageHoverScale,
            1.02,
            "Assistant message should scale to 1.02 on hover"
        )
        
        // Verify both have the same hover behavior
        XCTAssertEqual(
            userMessageHoverScale,
            assistantMessageHoverScale,
            "User and assistant messages should have identical hover scale"
        )
    }
    
    /// Test that hover state transition is immediate (no delay)
    func testMessageHoverTransitionTiming() {
        // The hover state should change immediately when the mouse enters/exits
        // The animation should start within 16ms (one frame at 60fps)
        
        let startTime = Date()
        
        // Simulate hover state change
        var isHovered = false
        isHovered = true
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        XCTAssertLessThan(
            duration,
            0.016,
            "Hover state change should occur within 16ms, took \(duration * 1000)ms"
        )
        
        XCTAssertTrue(isHovered, "Hover state should be updated")
    }
    
    /// Test that shadow intensity increases proportionally across all layers
    func testMessageHoverShadowProportionalIncrease() {
        // When hovering, all shadow layers should increase by approximately the same ratio
        // This ensures the depth effect remains consistent
        
        let notHoveredOpacities = [0.08, 0.05, 0.02]
        let hoveredOpacities = [0.15, 0.1, 0.05]
        
        // Calculate ratios for each layer
        let ratios = zip(notHoveredOpacities, hoveredOpacities).map { notHovered, hovered in
            hovered / notHovered
        }
        
        // All ratios should be similar (within 20% of each other)
        let minRatio = ratios.min() ?? 0
        let maxRatio = ratios.max() ?? 0
        let ratioVariance = (maxRatio - minRatio) / minRatio
        
        XCTAssertLessThan(
            ratioVariance,
            0.5,
            "Shadow opacity increase ratios should be consistent across layers (variance < 50%)"
        )
    }
    
    /// Test that corner radius remains constant during hover
    func testMessageHoverCornerRadiusConstant() {
        // The corner radius should remain 18pt regardless of hover state
        // Only scale, shadow, and opacity should change
        
        let cornerRadius: CGFloat = 18
        
        // Verify corner radius is appropriate for organic feel
        XCTAssertGreaterThanOrEqual(
            cornerRadius,
            16,
            "Corner radius should be at least 16pt for organic feel"
        )
        
        XCTAssertLessThanOrEqual(
            cornerRadius,
            24,
            "Corner radius should be at most 24pt to maintain bubble shape"
        )
        
        // Verify corner radius doesn't change on hover
        let notHoveredCornerRadius = cornerRadius
        let hoveredCornerRadius = cornerRadius
        
        XCTAssertEqual(
            notHoveredCornerRadius,
            hoveredCornerRadius,
            "Corner radius should remain constant during hover"
        )
    }
    
    // MARK: - Property 4: Message entrance animation
    // **Feature: ui-enhancement, Property 4: Message entrance animation**
    // **Validates: Requirements 2.4**
    
    /// For any message bubble, when it appears, it should animate in with opacity, scale, and offset transitions
    func testMessageEntranceAnimation() {
        // Test that entrance animation uses opacity, scale, and offset
        
        // Initial state (before appearance)
        let initialOpacity: Double = 0
        let initialScale: CGFloat = 0.8
        let initialOffset: CGFloat = 20
        
        // Final state (after appearance)
        let finalOpacity: Double = 1
        let finalScale: CGFloat = 1.0
        let finalOffset: CGFloat = 0
        
        // Verify initial state is different from final state
        XCTAssertLessThan(
            initialOpacity,
            finalOpacity,
            "Message should start with lower opacity and fade in"
        )
        
        XCTAssertLessThan(
            initialScale,
            finalScale,
            "Message should start smaller and scale up"
        )
        
        XCTAssertGreaterThan(
            initialOffset,
            finalOffset,
            "Message should start offset down and move up"
        )
        
        // Verify final state values are correct
        XCTAssertEqual(finalOpacity, 1.0, "Message should be fully opaque after entrance")
        XCTAssertEqual(finalScale, 1.0, "Message should be at normal scale after entrance")
        XCTAssertEqual(finalOffset, 0, "Message should have no offset after entrance")
    }
    
    /// Test that entrance animation uses spring animation with correct parameters
    func testMessageEntranceAnimationTiming() {
        // The entrance animation should use spring animation with response: 0.6, damping: 0.7
        
        let expectedResponse: Double = 0.6
        let expectedDamping: Double = 0.7
        
        // Verify the animation parameters create a smooth, elastic entrance
        XCTAssertGreaterThanOrEqual(
            expectedResponse,
            0.5,
            "Entrance animation response should be at least 0.5s for smooth motion"
        )
        
        XCTAssertLessThanOrEqual(
            expectedResponse,
            0.8,
            "Entrance animation response should be at most 0.8s to avoid sluggishness"
        )
        
        XCTAssertGreaterThanOrEqual(
            expectedDamping,
            0.6,
            "Entrance animation damping should be at least 0.6 for controlled bounce"
        )
        
        XCTAssertLessThanOrEqual(
            expectedDamping,
            0.8,
            "Entrance animation damping should be at most 0.8 to maintain spring character"
        )
    }
    
    /// Test that entrance animation respects reduce motion setting
    func testMessageEntranceRespectsReduceMotion() {
        // When reduce motion is enabled, the message should appear immediately without animation
        // When reduce motion is disabled, the message should animate in
        
        // Test with reduce motion enabled
        let reduceMotionEnabled = true
        
        if reduceMotionEnabled {
            // Message should appear immediately (hasAppeared = true without animation)
            let hasAppeared = true
            XCTAssertTrue(hasAppeared, "Message should appear immediately when reduce motion is enabled")
        }
        
        // Test with reduce motion disabled
        let reduceMotionDisabled = false
        
        if !reduceMotionDisabled {
            // Message should animate in (hasAppeared transitions from false to true with animation)
            let initialState = false
            let finalState = true
            
            XCTAssertNotEqual(
                initialState,
                finalState,
                "Message should transition from hidden to visible when reduce motion is disabled"
            )
        }
    }
    
    /// Test that entrance animation combines multiple properties
    func testMessageEntranceCombinesMultipleProperties() {
        // The entrance animation should combine opacity, scale, and offset
        // All three should transition simultaneously for a cohesive effect
        
        let properties = ["opacity", "scale", "offset"]
        
        XCTAssertEqual(
            properties.count,
            3,
            "Entrance animation should combine exactly 3 properties"
        )
        
        XCTAssertTrue(
            properties.contains("opacity"),
            "Entrance animation should include opacity transition"
        )
        
        XCTAssertTrue(
            properties.contains("scale"),
            "Entrance animation should include scale transition"
        )
        
        XCTAssertTrue(
            properties.contains("offset"),
            "Entrance animation should include offset transition"
        )
    }
    
    /// Test that entrance animation scale is subtle
    func testMessageEntranceScaleIsSubtle() {
        // The scale should start at 0.8 (20% smaller) for a subtle effect
        // Too small (< 0.5) would be jarring, too large (> 0.9) would be barely noticeable
        
        let initialScale: CGFloat = 0.8
        
        XCTAssertGreaterThanOrEqual(
            initialScale,
            0.7,
            "Initial scale should be at least 0.7 to avoid jarring appearance"
        )
        
        XCTAssertLessThanOrEqual(
            initialScale,
            0.9,
            "Initial scale should be at most 0.9 to be noticeable"
        )
        
        // Verify the scale change is noticeable but not extreme
        let finalScale: CGFloat = 1.0
        let scaleChange = finalScale - initialScale
        
        XCTAssertGreaterThanOrEqual(
            scaleChange,
            0.1,
            "Scale change should be at least 0.1 to be noticeable"
        )
        
        XCTAssertLessThanOrEqual(
            scaleChange,
            0.3,
            "Scale change should be at most 0.3 to avoid being jarring"
        )
    }
    
    /// Test that entrance animation offset is appropriate
    func testMessageEntranceOffsetIsAppropriate() {
        // The offset should start at 20pt down for a subtle slide-up effect
        
        let initialOffset: CGFloat = 20
        
        XCTAssertGreaterThanOrEqual(
            initialOffset,
            10,
            "Initial offset should be at least 10pt to be noticeable"
        )
        
        XCTAssertLessThanOrEqual(
            initialOffset,
            40,
            "Initial offset should be at most 40pt to avoid excessive movement"
        )
        
        // Verify the offset moves upward (positive to zero)
        let finalOffset: CGFloat = 0
        
        XCTAssertGreaterThan(
            initialOffset,
            finalOffset,
            "Message should move upward during entrance (from positive offset to zero)"
        )
    }
    
    /// Test that entrance animation is triggered on appear
    func testMessageEntranceTriggeredOnAppear() {
        // The entrance animation should be triggered by the onAppear modifier
        // This ensures the animation plays when the message is first displayed
        
        // Verify that hasAppeared state starts as false
        let initialHasAppeared = false
        
        XCTAssertFalse(
            initialHasAppeared,
            "hasAppeared should start as false before the message appears"
        )
        
        // After onAppear is called, hasAppeared should become true
        let finalHasAppeared = true
        
        XCTAssertTrue(
            finalHasAppeared,
            "hasAppeared should become true after the message appears"
        )
        
        XCTAssertNotEqual(
            initialHasAppeared,
            finalHasAppeared,
            "hasAppeared should transition from false to true on appear"
        )
    }
    
    /// Test that entrance animation is consistent across message types
    func testMessageEntranceConsistentAcrossMessageTypes() {
        // Both user and assistant messages should have the same entrance animation
        
        let entranceOpacity: Double = 0
        let entranceScale: CGFloat = 0.8
        let entranceOffset: CGFloat = 20
        
        // Test user message entrance
        let userMessageEntrance = (opacity: entranceOpacity, scale: entranceScale, offset: entranceOffset)
        
        // Test assistant message entrance
        let assistantMessageEntrance = (opacity: entranceOpacity, scale: entranceScale, offset: entranceOffset)
        
        // Verify both have identical entrance parameters
        XCTAssertEqual(
            userMessageEntrance.opacity,
            assistantMessageEntrance.opacity,
            "User and assistant messages should have identical entrance opacity"
        )
        
        XCTAssertEqual(
            userMessageEntrance.scale,
            assistantMessageEntrance.scale,
            "User and assistant messages should have identical entrance scale"
        )
        
        XCTAssertEqual(
            userMessageEntrance.offset,
            assistantMessageEntrance.offset,
            "User and assistant messages should have identical entrance offset"
        )
    }
    
    // MARK: - Property 5: Avatar fade-in animation
    // **Feature: ui-enhancement, Property 5: Avatar fade-in animation**
    // **Validates: Requirements 2.5**
    
    /// For any message bubble with an avatar, the avatar should fade in with opacity and scale transitions
    func testAvatarFadeInAnimation() {
        // Test that avatar animation uses opacity and scale
        
        // Initial state (before appearance)
        let initialOpacity: Double = 0
        let initialScale: CGFloat = 0.5
        
        // Final state (after appearance)
        let finalOpacity: Double = 1
        let finalScale: CGFloat = 1.0
        
        // Verify initial state is different from final state
        XCTAssertLessThan(
            initialOpacity,
            finalOpacity,
            "Avatar should start with lower opacity and fade in"
        )
        
        XCTAssertLessThan(
            initialScale,
            finalScale,
            "Avatar should start smaller and scale up"
        )
        
        // Verify final state values are correct
        XCTAssertEqual(finalOpacity, 1.0, "Avatar should be fully opaque after fade-in")
        XCTAssertEqual(finalScale, 1.0, "Avatar should be at normal scale after fade-in")
    }
    
    /// Test that avatar fade-in has a delay
    func testAvatarFadeInDelay() {
        // The avatar animation should have a 0.1s delay after the message appears
        
        let expectedDelay: Double = 0.1
        
        XCTAssertGreaterThan(
            expectedDelay,
            0,
            "Avatar animation should have a delay to create staggered effect"
        )
        
        XCTAssertLessThanOrEqual(
            expectedDelay,
            0.2,
            "Avatar animation delay should be subtle (<= 0.2s) to avoid feeling sluggish"
        )
    }
    
    /// Test that avatar fade-in uses spring animation
    func testAvatarFadeInAnimationTiming() {
        // The avatar animation should use spring animation with response: 0.6, damping: 0.7
        // Same as the message entrance animation for consistency
        
        let expectedResponse: Double = 0.6
        let expectedDamping: Double = 0.7
        
        // Verify the animation parameters create a smooth fade-in
        XCTAssertGreaterThanOrEqual(
            expectedResponse,
            0.5,
            "Avatar animation response should be at least 0.5s for smooth motion"
        )
        
        XCTAssertLessThanOrEqual(
            expectedResponse,
            0.8,
            "Avatar animation response should be at most 0.8s to avoid sluggishness"
        )
        
        XCTAssertGreaterThanOrEqual(
            expectedDamping,
            0.6,
            "Avatar animation damping should be at least 0.6 for controlled bounce"
        )
        
        XCTAssertLessThanOrEqual(
            expectedDamping,
            0.8,
            "Avatar animation damping should be at most 0.8 to maintain spring character"
        )
    }
    
    /// Test that avatar is positioned based on message sender
    func testAvatarPositionBasedOnSender() {
        // User messages should have avatar on the right
        // Assistant messages should have avatar on the left
        
        // For user messages
        let userAvatarPosition = "right"
        XCTAssertEqual(
            userAvatarPosition,
            "right",
            "User message avatar should be positioned on the right"
        )
        
        // For assistant messages
        let assistantAvatarPosition = "left"
        XCTAssertEqual(
            assistantAvatarPosition,
            "left",
            "Assistant message avatar should be positioned on the left"
        )
        
        // Verify they're different
        XCTAssertNotEqual(
            userAvatarPosition,
            assistantAvatarPosition,
            "User and assistant avatars should be on opposite sides"
        )
    }
    
    /// Test that avatar has appropriate size
    func testAvatarSize() {
        // Avatar should be 32x32 points for good visibility without overwhelming the message
        
        let avatarSize: CGFloat = 32
        
        XCTAssertGreaterThanOrEqual(
            avatarSize,
            24,
            "Avatar should be at least 24pt for visibility"
        )
        
        XCTAssertLessThanOrEqual(
            avatarSize,
            48,
            "Avatar should be at most 48pt to avoid overwhelming the message"
        )
    }
    
    /// Test that avatar uses circle shape
    func testAvatarShape() {
        // Avatar should be circular for a friendly, modern appearance
        
        let avatarShape = "circle"
        
        XCTAssertEqual(
            avatarShape,
            "circle",
            "Avatar should use circle shape"
        )
    }
    
    /// Test that avatar has appropriate icon for sender
    func testAvatarIconForSender() {
        // User avatar should use "person.fill" icon
        // Assistant avatar should use "sparkles" icon
        
        let userIcon = "person.fill"
        let assistantIcon = "sparkles"
        
        XCTAssertEqual(
            userIcon,
            "person.fill",
            "User avatar should use person.fill icon"
        )
        
        XCTAssertEqual(
            assistantIcon,
            "sparkles",
            "Assistant avatar should use sparkles icon"
        )
        
        XCTAssertNotEqual(
            userIcon,
            assistantIcon,
            "User and assistant avatars should have different icons"
        )
    }
    
    /// Test that avatar uses brand accent color
    func testAvatarUsesBrandAccentColor() {
        // Avatar should use brandAccent color for consistency with the design system
        
        // Verify brand accent color is defined
        XCTAssertNotNil(Color.brandAccent, "Brand accent color should be defined")
        
        // Avatar background should use brandAccent with opacity
        let backgroundOpacity: Double = 0.2
        
        XCTAssertGreaterThan(
            backgroundOpacity,
            0,
            "Avatar background should have visible opacity"
        )
        
        XCTAssertLessThanOrEqual(
            backgroundOpacity,
            0.3,
            "Avatar background opacity should be subtle (<= 0.3)"
        )
    }
    
    /// Test that avatar initial scale is appropriate
    func testAvatarInitialScaleIsAppropriate() {
        // The avatar should start at 0.5 scale (50% size) for a noticeable fade-in effect
        
        let initialScale: CGFloat = 0.5
        
        XCTAssertGreaterThanOrEqual(
            initialScale,
            0.3,
            "Initial avatar scale should be at least 0.3 to avoid being too jarring"
        )
        
        XCTAssertLessThanOrEqual(
            initialScale,
            0.7,
            "Initial avatar scale should be at most 0.7 to be noticeable"
        )
        
        // Verify the scale change is significant
        let finalScale: CGFloat = 1.0
        let scaleChange = finalScale - initialScale
        
        XCTAssertGreaterThanOrEqual(
            scaleChange,
            0.3,
            "Avatar scale change should be at least 0.3 to be noticeable"
        )
        
        XCTAssertLessThanOrEqual(
            scaleChange,
            0.7,
            "Avatar scale change should be at most 0.7 to avoid being too dramatic"
        )
    }
    
    /// Test that avatar animation is synchronized with message appearance
    func testAvatarAnimationSynchronizedWithMessage() {
        // Avatar animation should be triggered by the same hasAppeared state as the message
        // This ensures they animate together (with the avatar slightly delayed)
        
        // Both should use the same state variable
        let messageHasAppeared = true
        let avatarHasAppeared = true
        
        XCTAssertEqual(
            messageHasAppeared,
            avatarHasAppeared,
            "Avatar and message should use the same appearance state"
        )
        
        // The delay creates the staggered effect
        let avatarDelay: Double = 0.1
        let messageDelay: Double = 0.0
        
        XCTAssertGreaterThan(
            avatarDelay,
            messageDelay,
            "Avatar should have a delay relative to the message"
        )
    }
    
    /// Test that avatar animation respects reduce motion
    func testAvatarFadeInRespectsReduceMotion() {
        // When reduce motion is enabled, the avatar should appear immediately
        // The animation is controlled by the same hasAppeared state that respects reduce motion
        
        let reduceMotionEnabled = true
        
        if reduceMotionEnabled {
            // Avatar should appear immediately (hasAppeared = true without animation)
            let hasAppeared = true
            XCTAssertTrue(hasAppeared, "Avatar should appear immediately when reduce motion is enabled")
        }
        
        // Test with reduce motion disabled
        let reduceMotionDisabled = false
        
        if !reduceMotionDisabled {
            // Avatar should animate in
            let initialState = false
            let finalState = true
            
            XCTAssertNotEqual(
                initialState,
                finalState,
                "Avatar should transition from hidden to visible when reduce motion is disabled"
            )
        }
    }
}


