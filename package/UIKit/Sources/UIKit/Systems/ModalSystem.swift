//
//  ModalSystem.swift
//  UIKit
//
//  Modal, sheet, popover, and dialog systems
//

import Foundation
import DataKit

// MARK: - Modal System

public struct ModalSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "modal"
    public let name = "Modal"
    public let description = "Modal presentation system for dialogs, sheets, and popovers"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let defaultStyle: ModalStyle
        public let allowDismissOnBackgroundTap: Bool
        public let showCloseButton: Bool
        public let animationDuration: TimeInterval
        public let backdropOpacity: CGFloat
        public let cornerRadius: CGFloat
        
        public static let `default` = Configuration(
            defaultStyle: .sheet,
            allowDismissOnBackgroundTap: true,
            showCloseButton: true,
            animationDuration: 0.3,
            backdropOpacity: 0.4,
            cornerRadius: 16
        )
        
        public init(defaultStyle: ModalStyle = .sheet, allowDismissOnBackgroundTap: Bool = true, showCloseButton: Bool = true, animationDuration: TimeInterval = 0.3, backdropOpacity: CGFloat = 0.4, cornerRadius: CGFloat = 16) {
            self.defaultStyle = defaultStyle
            self.allowDismissOnBackgroundTap = allowDismissOnBackgroundTap
            self.showCloseButton = showCloseButton
            self.animationDuration = animationDuration
            self.backdropOpacity = backdropOpacity
            self.cornerRadius = cornerRadius
        }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var presentedModals: [Modal]
        public var isAnimating: Bool
        
        public static let initial = State(presentedModals: [], isAnimating: false)
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

// MARK: - Modal Types

public struct Modal: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let style: ModalStyle
    public let title: String?
    public let size: ModalSize
    public let contentType: String
    public let isDismissable: Bool
    public let showCloseButton: Bool
    public let priority: Int
    
    public init(id: String, style: ModalStyle, title: String? = nil, size: ModalSize = .medium, contentType: String, isDismissable: Bool = true, showCloseButton: Bool = true, priority: Int = 0) {
        self.id = id
        self.style = style
        self.title = title
        self.size = size
        self.contentType = contentType
        self.isDismissable = isDismissable
        self.showCloseButton = showCloseButton
        self.priority = priority
    }
}

public enum ModalStyle: String, Codable, Sendable {
    case sheet
    case fullScreenCover
    case popover
    case alert
    case confirmationDialog
    case inspector
    case drawer
    case overlay
}

public enum ModalSize: Codable, Sendable, Hashable {
    case small
    case medium
    case large
    case fullScreen
    case custom(width: CGFloat, height: CGFloat)
    
    public var dimensions: UISize {
        switch self {
        case .small: return UISize(width: 400, height: 300)
        case .medium: return UISize(width: 600, height: 450)
        case .large: return UISize(width: 800, height: 600)
        case .fullScreen: return UISize(width: 0, height: 0)
        case .custom(let width, let height): return UISize(width: width, height: height)
        }
    }
}

// MARK: - Alert System

public struct AlertSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "alert"
    public let name = "Alert"
    public let description = "System for displaying alerts and confirmation dialogs"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let defaultStyle: AlertStyle
        public let showIcon: Bool
        public let animatePresentation: Bool
        
        public static let `default` = Configuration(
            defaultStyle: .alert,
            showIcon: true,
            animatePresentation: true
        )
        
        public init(defaultStyle: AlertStyle = .alert, showIcon: Bool = true, animatePresentation: Bool = true) {
            self.defaultStyle = defaultStyle
            self.showIcon = showIcon
            self.animatePresentation = animatePresentation
        }
        
        public enum AlertStyle: String, Codable, Sendable { case alert, sheet, inline }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var alerts: [Alert]
        
        public static let initial = State(alerts: [])
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct Alert: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let message: String?
    public let severity: AlertSeverity
    public let actions: [AlertAction]
    public let icon: String?
    
    public init(id: String, title: String, message: String? = nil, severity: AlertSeverity = .info, actions: [AlertAction], icon: String? = nil) {
        self.id = id
        self.title = title
        self.message = message
        self.severity = severity
        self.actions = actions
        self.icon = icon
    }
}

public enum AlertSeverity: String, Codable, Sendable {
    case info, success, warning, error, critical
    
    public var defaultIcon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .critical: return "exclamationmark.octagon.fill"
        }
    }
}

public struct AlertAction: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let style: AlertActionStyle
    public let action: String
    
    public init(id: String, title: String, style: AlertActionStyle = .default, action: String) {
        self.id = id
        self.title = title
        self.style = style
        self.action = action
    }
    
    public enum AlertActionStyle: String, Codable, Sendable { case `default`, cancel, destructive }
}

// MARK: - Popover System

public struct PopoverSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "popover"
    public let name = "Popover"
    public let description = "Contextual popover system"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let arrowEdge: ArrowEdge
        public let cornerRadius: CGFloat
        public let shadowRadius: CGFloat
        public let dismissOnOutsideClick: Bool
        public let showArrow: Bool
        
        public static let `default` = Configuration(
            arrowEdge: .bottom,
            cornerRadius: 12,
            shadowRadius: 16,
            dismissOnOutsideClick: true,
            showArrow: true
        )
        
        public init(arrowEdge: ArrowEdge = .bottom, cornerRadius: CGFloat = 12, shadowRadius: CGFloat = 16, dismissOnOutsideClick: Bool = true, showArrow: Bool = true) {
            self.arrowEdge = arrowEdge
            self.cornerRadius = cornerRadius
            self.shadowRadius = shadowRadius
            self.dismissOnOutsideClick = dismissOnOutsideClick
            self.showArrow = showArrow
        }
        
        public enum ArrowEdge: String, Codable, Sendable { case top, bottom, leading, trailing }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var popovers: [Popover]
        
        public static let initial = State(popovers: [])
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct Popover: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let anchorId: String
    public let contentType: String
    public let size: UISize
    public let arrowEdge: PopoverSystem.Configuration.ArrowEdge
    
    public init(id: String, anchorId: String, contentType: String, size: UISize, arrowEdge: PopoverSystem.Configuration.ArrowEdge = .bottom) {
        self.id = id
        self.anchorId = anchorId
        self.contentType = contentType
        self.size = size
        self.arrowEdge = arrowEdge
    }
}

// MARK: - Drawer System

public struct DrawerSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "drawer"
    public let name = "Drawer"
    public let description = "Slide-out drawer panels"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let edge: DrawerEdge
        public let width: CGFloat
        public let showOverlay: Bool
        public let allowSwipeGesture: Bool
        
        public static let `default` = Configuration(
            edge: .trailing,
            width: 320,
            showOverlay: true,
            allowSwipeGesture: true
        )
        
        public init(edge: DrawerEdge = .trailing, width: CGFloat = 320, showOverlay: Bool = true, allowSwipeGesture: Bool = true) {
            self.edge = edge
            self.width = width
            self.showOverlay = showOverlay
            self.allowSwipeGesture = allowSwipeGesture
        }
        
        public enum DrawerEdge: String, Codable, Sendable { case leading, trailing, top, bottom }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var isOpen: Bool
        public var contentType: String?
        public var width: CGFloat
        
        public static let initial = State(isOpen: false, contentType: nil, width: 320)
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}
