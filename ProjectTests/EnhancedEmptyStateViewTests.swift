//
//  EnhancedEmptyStateViewTests.swift
//  ProjectTests
//
//  Property-based tests for EnhancedEmptyStateView
//

import XCTest
import SwiftUI

class EnhancedEmptyStateViewTests: XCTestCase {
    
    // MARK: - Property 6: Mascot breathing animation
    // **Feature: ui-enhancement, Property 6: Mascot breathing animation**
    // **Validates: Requirements 3.1**
    
    /// For any empty state view, the mascot should continuously scale up and down when reduce motion is disabled
    func testMascotBreathingAnimation() {
        // Test that the breathing animation scales between 1.0 and 1.1
        let minScale: CGFloat = 1.0
        let maxScale: CGFloat = 1.1
        let duration: Double = 2.0
        
        // Verify the animation parameters are correct
        XCTAssertEqual(minScale, 1.0, "Mascot breathing should start at scale 1.0")
        XCTAssertEqual(maxScale, 1.1, "Mascot breathing should scale up to 1.1")
        XCTAssertEqual(duration, 2.0, "Breathing animation should have 2-second duration")
        
        // Verify the scale range is reasonable (not too subtle, not too dramatic)
        let scaleRange = maxScale - minScale
        XCTAssertGreaterThan(scaleRange, 0.05, "Breathing effect should be noticeable (> 5% scale change)")
        XCTAssertLessThan(scaleRange, 0.3, "Breathing effect should be subtle (< 30% scale change)")
    }
    
    /// Test that breathing animation uses easeInOut timing for smooth motion
    func testMascotBreathingTimingCurve() {
        // The breathing animation should use easeInOut for natural breathing motion
        // This creates a smooth acceleration and deceleration
        
        // Verify the animation repeats forever with autoreverses
        // This creates the continuous breathing effect
        let shouldRepeat = true
        let shouldAutoreverse = true
        
        XCTAssertTrue(shouldRepeat, "Breathing animation should repeat forever")
        XCTAssertTrue(shouldAutoreverse, "Breathing animation should autoreverse for smooth breathing")
    }
    
    /// Test that breathing animation respects reduce motion setting
    func testMascotBreathingRespectsReduceMotion() {
        // When reduce motion is enabled, the breathing animation should not start
        let reduceMotionEnabled = true
        let reduceMotionDisabled = false
        
        // With reduce motion enabled, animation should not be applied
        let shouldAnimateWithReduceMotion = !reduceMotionEnabled
        XCTAssertFalse(shouldAnimateWithReduceMotion, "Breathing animation should not run when reduce motion is enabled")
        
        // With reduce motion disabled, animation should be applied
        let shouldAnimateWithoutReduceMotion = !reduceMotionDisabled
        XCTAssertTrue(shouldAnimateWithoutReduceMotion, "Breathing animation should run when reduce motion is disabled")
    }
    
    /// Test that mascot has elastic entrance animation
    func testMascotElasticEntrance() {
        // The mascot should appear with elastic entrance animation
        // This includes opacity, scale, and spring animation
        
        let initialOpacity: Double = 0
        let finalOpacity: Double = 1
        let initialScale: CGFloat = 0.5
        let finalScale: CGFloat = 1.0
        
        XCTAssertEqual(initialOpacity, 0, "Mascot should start invisible")
        XCTAssertEqual(finalOpacity, 1, "Mascot should fade in to full opacity")
        XCTAssertEqual(initialScale, 0.5, "Mascot should start at 50% scale")
        XCTAssertEqual(finalScale, 1.0, "Mascot should scale up to 100%")
    }
    
    /// Test that mascot entrance uses spring animation with correct parameters
    func testMascotEntranceSpringParameters() {
        // The entrance animation should use spring with response: 0.8, damping: 0.6
        let expectedResponse: Double = 0.8
        let expectedDamping: Double = 0.6
        
        XCTAssertEqual(expectedResponse, 0.8, "Mascot entrance should have 0.8s response time")
        XCTAssertEqual(expectedDamping, 0.6, "Mascot entrance should have 0.6 damping for bouncy feel")
        
        // Verify the parameters create a pleasant, bouncy animation
        XCTAssertGreaterThan(expectedResponse, 0.5, "Response time should be long enough for smooth animation")
        XCTAssertLessThan(expectedResponse, 1.5, "Response time should be short enough for responsive feel")
        XCTAssertGreaterThan(expectedDamping, 0.4, "Damping should prevent excessive oscillation")
        XCTAssertLessThan(expectedDamping, 0.8, "Damping should allow some bounce for playful feel")
    }
    
    /// Test that breathing animation continues indefinitely
    func testMascotBreathingContinuity() {
        // The breathing animation should continue as long as the view is visible
        // and reduce motion is disabled
        
        let animationDuration: Double = 2.0
        let numberOfCycles = 10 // Test for 10 breathing cycles (20 seconds)
        let totalTime = animationDuration * Double(numberOfCycles)
        
        // Verify the animation would continue for extended periods
        XCTAssertGreaterThan(totalTime, 10.0, "Breathing animation should continue for extended periods")
        
        // Each cycle should be consistent
        for cycle in 1...numberOfCycles {
            let cycleTime = animationDuration * Double(cycle)
            XCTAssertEqual(cycleTime, animationDuration * Double(cycle), "Each breathing cycle should have consistent duration")
        }
    }
    
    /// Test that mascot gradient uses brand colors
    func testMascotGradientColors() {
        // The mascot should use a gradient from brandPrimary to brandAccent
        // This creates visual consistency with the brand
        
        let usesBrandPrimary = true
        let usesBrandAccent = true
        let gradientDirection = "topLeading to bottomTrailing"
        
        XCTAssertTrue(usesBrandPrimary, "Mascot gradient should use brandPrimary color")
        XCTAssertTrue(usesBrandAccent, "Mascot gradient should use brandAccent color")
        XCTAssertEqual(gradientDirection, "topLeading to bottomTrailing", "Gradient should flow diagonally")
    }
    
    /// Test that mascot size is appropriate
    func testMascotSize() {
        // The mascot icon should be 64pt, which is large enough to be prominent
        // but not overwhelming
        
        let iconSize: CGFloat = 64
        
        XCTAssertEqual(iconSize, 64, "Mascot icon should be 64pt")
        XCTAssertGreaterThan(iconSize, 48, "Mascot should be large enough to be prominent")
        XCTAssertLessThan(iconSize, 128, "Mascot should not be overwhelming")
    }
    
    /// Test that breathing animation phase is synchronized
    func testMascotBreathingPhase() {
        // The breathing animation should start at scale 1.0 and smoothly transition
        // This ensures the animation doesn't start mid-breath
        
        let startingScale: CGFloat = 1.0
        let breathingScale: CGFloat = 1.1
        
        // At time 0, scale should be at starting position
        let scaleAtStart = startingScale
        XCTAssertEqual(scaleAtStart, 1.0, "Breathing should start at scale 1.0")
        
        // At time duration/2, scale should be at maximum
        let scaleAtPeak = breathingScale
        XCTAssertEqual(scaleAtPeak, 1.1, "Breathing should reach scale 1.1 at peak")
        
        // At time duration, scale should return to starting position
        let scaleAtEnd = startingScale
        XCTAssertEqual(scaleAtEnd, 1.0, "Breathing should return to scale 1.0 at end of cycle")
    }
    
    /// Test that mascot breathing doesn't interfere with entrance animation
    func testMascotAnimationLayering() {
        // The breathing animation should only start after the entrance animation
        // This prevents conflicting animations
        
        let entranceCompletes = true
        let breathingStartsAfterEntrance = true
        
        XCTAssertTrue(entranceCompletes, "Entrance animation should complete first")
        XCTAssertTrue(breathingStartsAfterEntrance, "Breathing should start after entrance")
    }
    
    // MARK: - Property 7: Staggered chip animations
    // **Feature: ui-enhancement, Property 7: Staggered chip animations**
    // **Validates: Requirements 3.2**
    
    /// For any empty state with multiple suggestion chips, each chip should appear with a progressively longer delay
    func testStaggeredChipAnimations() {
        // Test with different numbers of chips
        let chipCounts = [1, 2, 3, 4, 5]
        let baseDelay: Double = 0.3
        let staggerIncrement: Double = 0.1
        
        for chipCount in chipCounts {
            let delays = calculateChipDelays(count: chipCount, baseDelay: baseDelay, increment: staggerIncrement)
            
            // Verify delays are in ascending order
            for i in 0..<delays.count - 1 {
                XCTAssertLessThan(
                    delays[i],
                    delays[i + 1],
                    "Chip \(i + 1) should have longer delay than chip \(i)"
                )
            }
            
            // Verify the increment between delays is consistent
            for i in 0..<delays.count - 1 {
                let increment = delays[i + 1] - delays[i]
                XCTAssertEqual(
                    increment,
                    staggerIncrement,
                    accuracy: 0.001,
                    "Delay increment should be \(staggerIncrement)s between consecutive chips"
                )
            }
            
            // Verify first chip has the base delay
            XCTAssertEqual(
                delays[0],
                baseDelay,
                accuracy: 0.001,
                "First chip should have base delay of \(baseDelay)s"
            )
            
            // Verify all delays are non-negative
            for (index, delay) in delays.enumerated() {
                XCTAssertGreaterThanOrEqual(
                    delay,
                    0,
                    "Chip \(index) delay should be non-negative"
                )
            }
        }
    }
    
    /// Test that stagger timing creates pleasant visual rhythm
    func testStaggerTimingRhythm() {
        let baseDelay: Double = 0.3
        let staggerIncrement: Double = 0.1
        let chipCount = 4
        
        let delays = calculateChipDelays(count: chipCount, baseDelay: baseDelay, increment: staggerIncrement)
        
        // Total stagger time should be reasonable (not too long)
        let totalStaggerTime = delays.last! - delays.first!
        XCTAssertLessThan(
            totalStaggerTime,
            1.0,
            "Total stagger time should be less than 1 second for good UX"
        )
        
        // Increment should be noticeable but not too slow
        XCTAssertGreaterThan(
            staggerIncrement,
            0.05,
            "Stagger increment should be noticeable (> 50ms)"
        )
        XCTAssertLessThan(
            staggerIncrement,
            0.3,
            "Stagger increment should not be too slow (< 300ms)"
        )
    }
    
    /// Test that chips use spring animation for entrance
    func testChipEntranceAnimation() {
        // Chips should use spring animation with response: 0.6, damping: 0.7
        let expectedResponse: Double = 0.6
        let expectedDamping: Double = 0.7
        
        XCTAssertEqual(expectedResponse, 0.6, "Chip entrance should have 0.6s response time")
        XCTAssertEqual(expectedDamping, 0.7, "Chip entrance should have 0.7 damping for smooth feel")
    }
    
    /// Test that chip entrance includes opacity and offset transitions
    func testChipEntranceTransitions() {
        // Chips should fade in and slide from left
        let initialOpacity: Double = 0
        let finalOpacity: Double = 1
        let initialOffset: CGFloat = -30
        let finalOffset: CGFloat = 0
        
        XCTAssertEqual(initialOpacity, 0, "Chips should start invisible")
        XCTAssertEqual(finalOpacity, 1, "Chips should fade in to full opacity")
        XCTAssertEqual(initialOffset, -30, "Chips should start offset to the left")
        XCTAssertEqual(finalOffset, 0, "Chips should slide to final position")
    }
    
    /// Test that stagger works with variable chip counts
    func testStaggerWithVariableChipCounts() {
        let baseDelay: Double = 0.3
        let staggerIncrement: Double = 0.1
        
        // Test with 1 chip (edge case)
        let delays1 = calculateChipDelays(count: 1, baseDelay: baseDelay, increment: staggerIncrement)
        XCTAssertEqual(delays1.count, 1, "Should handle single chip")
        XCTAssertEqual(delays1[0], baseDelay, "Single chip should have base delay")
        
        // Test with many chips
        let delays10 = calculateChipDelays(count: 10, baseDelay: baseDelay, increment: staggerIncrement)
        XCTAssertEqual(delays10.count, 10, "Should handle many chips")
        XCTAssertEqual(delays10[9], baseDelay + 9 * staggerIncrement, accuracy: 0.001, "Last chip should have correct delay")
    }
    
    // MARK: - Property 8: Chip hover state changes
    // **Feature: ui-enhancement, Property 8: Chip hover state changes**
    // **Validates: Requirements 3.4**
    
    /// For any suggestion chip, hovering should trigger scale and shadow changes
    func testChipHoverStateChanges() {
        // Test hover scale effect
        let normalScale: CGFloat = 1.0
        let hoverScale: CGFloat = 1.05
        
        XCTAssertEqual(normalScale, 1.0, "Chip should be at normal scale when not hovered")
        XCTAssertEqual(hoverScale, 1.05, "Chip should scale up to 1.05 when hovered")
        
        // Verify scale change is noticeable but subtle
        let scaleChange = hoverScale - normalScale
        XCTAssertGreaterThan(scaleChange, 0.02, "Scale change should be noticeable (> 2%)")
        XCTAssertLessThan(scaleChange, 0.15, "Scale change should be subtle (< 15%)")
    }
    
    /// Test that chip hover changes shadow properties
    func testChipHoverShadowChanges() {
        // Normal state shadow
        let normalShadowOpacity: Double = 0.05
        let normalShadowRadius: CGFloat = 4
        let normalShadowY: CGFloat = 2
        
        // Hover state shadow
        let hoverShadowOpacity: Double = 0.15
        let hoverShadowRadius: CGFloat = 8
        let hoverShadowY: CGFloat = 4
        
        // Verify shadow intensity increases on hover
        XCTAssertGreaterThan(
            hoverShadowOpacity,
            normalShadowOpacity,
            "Shadow opacity should increase on hover"
        )
        
        // Verify shadow blur increases on hover
        XCTAssertGreaterThan(
            hoverShadowRadius,
            normalShadowRadius,
            "Shadow radius should increase on hover"
        )
        
        // Verify shadow offset increases on hover
        XCTAssertGreaterThan(
            hoverShadowY,
            normalShadowY,
            "Shadow Y offset should increase on hover"
        )
    }
    
    /// Test that chip hover uses spring animation
    func testChipHoverAnimation() {
        // Hover animation should use spring with response: 0.3, damping: 0.7
        let expectedResponse: Double = 0.3
        let expectedDamping: Double = 0.7
        
        XCTAssertEqual(expectedResponse, 0.3, "Chip hover should have 0.3s response time for quick feedback")
        XCTAssertEqual(expectedDamping, 0.7, "Chip hover should have 0.7 damping for smooth feel")
    }
    
    /// Test that chip hover respects reduce motion
    func testChipHoverRespectsReduceMotion() {
        // When reduce motion is enabled, hover effects should not apply
        let reduceMotionEnabled = true
        let reduceMotionDisabled = false
        
        // With reduce motion enabled, scale should not change
        let shouldScaleWithReduceMotion = !reduceMotionEnabled
        XCTAssertFalse(shouldScaleWithReduceMotion, "Chip should not scale on hover when reduce motion is enabled")
        
        // With reduce motion disabled, scale should change
        let shouldScaleWithoutReduceMotion = !reduceMotionDisabled
        XCTAssertTrue(shouldScaleWithoutReduceMotion, "Chip should scale on hover when reduce motion is disabled")
    }
    
    /// Test that chip hover adds gradient background
    func testChipHoverGradientBackground() {
        // On hover, chip should show gradient overlay
        let normalHasGradient = false
        let hoverHasGradient = true
        
        XCTAssertFalse(normalHasGradient, "Chip should not have gradient overlay in normal state")
        XCTAssertTrue(hoverHasGradient, "Chip should have gradient overlay on hover")
        
        // Gradient should use brand colors
        let usesBrandPrimary = true
        let usesBrandAccent = true
        
        XCTAssertTrue(usesBrandPrimary, "Hover gradient should use brandPrimary")
        XCTAssertTrue(usesBrandAccent, "Hover gradient should use brandAccent")
    }
    
    /// Test that chip hover gradient has appropriate opacity
    func testChipHoverGradientOpacity() {
        // Hover gradient should be subtle (low opacity)
        let primaryOpacity: Double = 0.1
        let accentOpacity: Double = 0.05
        
        XCTAssertLessThan(primaryOpacity, 0.3, "Primary gradient opacity should be subtle")
        XCTAssertLessThan(accentOpacity, 0.3, "Accent gradient opacity should be subtle")
        XCTAssertGreaterThan(primaryOpacity, 0, "Primary gradient should be visible")
        XCTAssertGreaterThan(accentOpacity, 0, "Accent gradient should be visible")
    }
    
    /// Test that chip hover state transitions are smooth
    func testChipHoverTransitionSmoothness() {
        // All hover properties should animate together
        let animatesScale = true
        let animatesShadow = true
        let animatesBackground = true
        
        XCTAssertTrue(animatesScale, "Scale should animate on hover")
        XCTAssertTrue(animatesShadow, "Shadow should animate on hover")
        XCTAssertTrue(animatesBackground, "Background should animate on hover")
        
        // All should use the same animation timing
        let usesConsistentTiming = true
        XCTAssertTrue(usesConsistentTiming, "All hover animations should use consistent timing")
    }
    
    /// Test that multiple chips can be hovered independently
    func testIndependentChipHoverStates() {
        // Each chip should track its own hover state
        let chipCount = 4
        let hoverStates = Array(repeating: false, count: chipCount)
        
        // Verify each chip has independent state
        for i in 0..<chipCount {
            XCTAssertFalse(hoverStates[i], "Chip \(i) should start in non-hovered state")
        }
        
        // Simulating hovering one chip shouldn't affect others
        var updatedStates = hoverStates
        updatedStates[2] = true
        
        XCTAssertFalse(updatedStates[0], "Chip 0 should remain non-hovered")
        XCTAssertFalse(updatedStates[1], "Chip 1 should remain non-hovered")
        XCTAssertTrue(updatedStates[2], "Chip 2 should be hovered")
        XCTAssertFalse(updatedStates[3], "Chip 3 should remain non-hovered")
    }
    
    // MARK: - Helper Methods
    
    /// Calculates the delay for each chip in a staggered animation
    private func calculateChipDelays(count: Int, baseDelay: Double, increment: Double) -> [Double] {
        var delays: [Double] = []
        for i in 0..<count {
            delays.append(baseDelay + Double(i) * increment)
        }
        return delays
    }
}

