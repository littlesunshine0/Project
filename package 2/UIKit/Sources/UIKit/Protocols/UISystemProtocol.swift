//
//  UISystemProtocol.swift
//  UIKit
//
//  Core protocols for UI systems
//

import Foundation
import DataKit

// MARK: - UI System Protocol

/// Base protocol for all UI systems
public protocol UISystemProtocol: Identifiable, Sendable {
    var id: String { get }
    var name: String { get }
    var description: String { get }
    var version: String { get }
    var supportedPlatforms: [UIPlatform] { get }
}

// MARK: - Configurable System

/// Protocol for systems that can be configured
public protocol ConfigurableSystem: UISystemProtocol {
    associatedtype Configuration: UIConfigurationProtocol
    var defaultConfiguration: Configuration { get }
}

// MARK: - Stateful System

/// Protocol for systems that maintain state
public protocol StatefulSystem: UISystemProtocol {
    associatedtype State: UIStateProtocol
    var initialState: State { get }
}

// MARK: - Composable System

/// Protocol for systems that can contain other systems
public protocol ComposableSystem: UISystemProtocol {
    var childSystems: [any UISystemProtocol] { get }
    var slots: [UISlotDefinition] { get }
}

// MARK: - Layout System

/// Protocol for layout systems
public protocol LayoutSystemProtocol: UISystemProtocol {
    var layoutMode: LayoutMode { get }
    var regions: [UIRegion] { get }
    var constraints: [UIConstraint] { get }
}

// MARK: - Interactive System

/// Protocol for interactive systems
public protocol InteractiveSystem: UISystemProtocol {
    var interactions: [UIInteraction] { get }
    var gestures: [UIGesture] { get }
    var shortcuts: [UIShortcut] { get }
}

// MARK: - Themeable System

/// Protocol for themeable systems
public protocol ThemeableSystem: UISystemProtocol {
    var themeTokens: [UIThemeToken] { get }
    var colorSchemes: [UIColorScheme] { get }
}

// MARK: - Accessible System

/// Protocol for accessible systems
public protocol AccessibleSystem: UISystemProtocol {
    var accessibilityLabel: String { get }
    var accessibilityHint: String? { get }
    var accessibilityTraits: [UIAccessibilityTrait] { get }
}

// MARK: - Configuration Protocol

public protocol UIConfigurationProtocol: Codable, Sendable, Hashable {
    static var `default`: Self { get }
}

// MARK: - State Protocol

public protocol UIStateProtocol: Codable, Sendable {
    static var initial: Self { get }
}

// MARK: - Supporting Types

public enum UIPlatform: String, Codable, Sendable {
    case macOS
    case iOS
    case iPadOS
    case visionOS
    case tvOS
    case watchOS
    case web
}

public enum LayoutMode: String, Codable, Sendable {
    case fixed
    case flexible
    case adaptive
    case responsive
    case fluid
}

public struct UIRegion: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let position: UIPosition
    public let size: UISize
    public let constraints: [UIConstraint]
    public let isResizable: Bool
    public let isCollapsible: Bool
    public let minSize: UISize?
    public let maxSize: UISize?
    
    public init(id: String, name: String, position: UIPosition, size: UISize, constraints: [UIConstraint] = [], isResizable: Bool = true, isCollapsible: Bool = false, minSize: UISize? = nil, maxSize: UISize? = nil) {
        self.id = id
        self.name = name
        self.position = position
        self.size = size
        self.constraints = constraints
        self.isResizable = isResizable
        self.isCollapsible = isCollapsible
        self.minSize = minSize
        self.maxSize = maxSize
    }
}

public struct UIPosition: Codable, Sendable, Hashable {
    public let x: CGFloat
    public let y: CGFloat
    public let anchor: UIAnchor
    
    public init(x: CGFloat = 0, y: CGFloat = 0, anchor: UIAnchor = .topLeading) {
        self.x = x
        self.y = y
        self.anchor = anchor
    }
    
    public static let zero = UIPosition(x: 0, y: 0)
}

public enum UIAnchor: String, Codable, Sendable {
    case topLeading, top, topTrailing
    case leading, center, trailing
    case bottomLeading, bottom, bottomTrailing
}

public struct UISize: Codable, Sendable, Hashable {
    public let width: CGFloat
    public let height: CGFloat
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    public static let zero = UISize(width: 0, height: 0)
    public static func fixed(_ width: CGFloat, _ height: CGFloat) -> UISize { UISize(width: width, height: height) }
}

public struct UIConstraint: Codable, Sendable, Hashable {
    public let type: ConstraintType
    public let value: CGFloat
    public let priority: Int
    
    public init(type: ConstraintType, value: CGFloat, priority: Int = 1000) {
        self.type = type
        self.value = value
        self.priority = priority
    }
    
    public enum ConstraintType: String, Codable, Sendable {
        case minWidth, maxWidth, width
        case minHeight, maxHeight, height
        case aspectRatio
        case spacing, padding, margin
    }
}

public struct UISlotDefinition: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let acceptedTypes: [String]
    public let isRequired: Bool
    public let allowsMultiple: Bool
    
    public init(id: String, name: String, acceptedTypes: [String] = [], isRequired: Bool = false, allowsMultiple: Bool = false) {
        self.id = id
        self.name = name
        self.acceptedTypes = acceptedTypes
        self.isRequired = isRequired
        self.allowsMultiple = allowsMultiple
    }
}

public struct UIInteraction: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let type: InteractionType
    public let action: String
    
    public init(id: String, type: InteractionType, action: String) {
        self.id = id
        self.type = type
        self.action = action
    }
    
    public enum InteractionType: String, Codable, Sendable {
        case tap, doubleTap, longPress
        case drag, drop
        case hover, focus
        case scroll, pinch, rotate
    }
}

public struct UIGesture: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let type: GestureType
    public let action: String
    
    public init(id: String, type: GestureType, action: String) {
        self.id = id
        self.type = type
        self.action = action
    }
    
    public enum GestureType: String, Codable, Sendable {
        case swipeLeft, swipeRight, swipeUp, swipeDown
        case pinchIn, pinchOut
        case rotateClockwise, rotateCounterClockwise
        case threeFingerSwipe
    }
}

public struct UIShortcut: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let key: String
    public let modifiers: [KeyModifier]
    public let action: String
    public let label: String
    
    public init(id: String, key: String, modifiers: [KeyModifier] = [], action: String, label: String) {
        self.id = id
        self.key = key
        self.modifiers = modifiers
        self.action = action
        self.label = label
    }
    
    public enum KeyModifier: String, Codable, Sendable {
        case command, option, control, shift, function
    }
}

public struct UIThemeToken: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let category: TokenCategory
    public let value: String
    
    public init(id: String, name: String, category: TokenCategory, value: String) {
        self.id = id
        self.name = name
        self.category = category
        self.value = value
    }
    
    public enum TokenCategory: String, Codable, Sendable {
        case color, spacing, typography, shadow, border, animation
    }
}

public struct UIColorScheme: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let appearance: Appearance
    
    public init(id: String, name: String, appearance: Appearance) {
        self.id = id
        self.name = name
        self.appearance = appearance
    }
    
    public enum Appearance: String, Codable, Sendable {
        case light, dark, auto
    }
}

public enum UIAccessibilityTrait: String, Codable, Sendable {
    case button, link, header, image
    case searchField, staticText
    case adjustable, allowsDirectInteraction
    case causesPageTurn, playsSound
    case startsMediaSession, summaryElement
    case updatesFrequently, notEnabled
    case selected
}
