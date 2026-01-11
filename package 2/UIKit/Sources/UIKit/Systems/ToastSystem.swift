//
//  ToastSystem.swift
//  UIKit
//
//  Toast, snackbar, and notification banner systems
//

import Foundation
import DataKit

// MARK: - Toast System

public struct ToastSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "toast"
    public let name = "Toast"
    public let description = "Non-intrusive toast notifications"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let position: ToastPosition
        public let duration: TimeInterval
        public let maxVisible: Int
        public let stackDirection: StackDirection
        public let cornerRadius: CGFloat
        public let showIcon: Bool
        public let allowDismiss: Bool
        
        public static let `default` = Configuration(
            position: .bottomTrailing,
            duration: 4.0,
            maxVisible: 3,
            stackDirection: .up,
            cornerRadius: 12,
            showIcon: true,
            allowDismiss: true
        )
        
        public init(position: ToastPosition = .bottomTrailing, duration: TimeInterval = 4.0, maxVisible: Int = 3, stackDirection: StackDirection = .up, cornerRadius: CGFloat = 12, showIcon: Bool = true, allowDismiss: Bool = true) {
            self.position = position
            self.duration = duration
            self.maxVisible = maxVisible
            self.stackDirection = stackDirection
            self.cornerRadius = cornerRadius
            self.showIcon = showIcon
            self.allowDismiss = allowDismiss
        }
        
        public enum ToastPosition: String, Codable, Sendable {
            case topLeading, top, topTrailing
            case bottomLeading, bottom, bottomTrailing
            case center
        }
        
        public enum StackDirection: String, Codable, Sendable { case up, down }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var toasts: [Toast]
        
        public static let initial = State(toasts: [])
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

// MARK: - Toast

public struct Toast: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let message: String
    public let type: ToastType
    public let icon: String?
    public let action: ToastAction?
    public let duration: TimeInterval?
    public let createdAt: Date
    
    public init(id: String = UUID().uuidString, message: String, type: ToastType = .info, icon: String? = nil, action: ToastAction? = nil, duration: TimeInterval? = nil, createdAt: Date = Date()) {
        self.id = id
        self.message = message
        self.type = type
        self.icon = icon
        self.action = action
        self.duration = duration
        self.createdAt = createdAt
    }
}

public enum ToastType: String, Codable, Sendable {
    case info, success, warning, error, loading
    
    public var defaultIcon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .loading: return "arrow.triangle.2.circlepath"
        }
    }
    
    public var defaultColor: String {
        switch self {
        case .info: return "blue"
        case .success: return "green"
        case .warning: return "orange"
        case .error: return "red"
        case .loading: return "gray"
        }
    }
}

public struct ToastAction: Codable, Sendable, Hashable {
    public let title: String
    public let action: String
    
    public init(title: String, action: String) {
        self.title = title
        self.action = action
    }
}

// MARK: - Snackbar System

public struct SnackbarSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "snackbar"
    public let name = "Snackbar"
    public let description = "Material-style snackbar notifications with actions"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let position: SnackbarPosition
        public let duration: TimeInterval
        public let maxWidth: CGFloat
        public let showAction: Bool
        
        public static let `default` = Configuration(
            position: .bottom,
            duration: 5.0,
            maxWidth: 600,
            showAction: true
        )
        
        public init(position: SnackbarPosition = .bottom, duration: TimeInterval = 5.0, maxWidth: CGFloat = 600, showAction: Bool = true) {
            self.position = position
            self.duration = duration
            self.maxWidth = maxWidth
            self.showAction = showAction
        }
        
        public enum SnackbarPosition: String, Codable, Sendable { case top, bottom }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var snackbars: [Snackbar]
        
        public static let initial = State(snackbars: [])
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct Snackbar: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let message: String
    public let action: SnackbarAction?
    public let duration: TimeInterval?
    
    public init(id: String = UUID().uuidString, message: String, action: SnackbarAction? = nil, duration: TimeInterval? = nil) {
        self.id = id
        self.message = message
        self.action = action
        self.duration = duration
    }
}

public struct SnackbarAction: Codable, Sendable, Hashable {
    public let title: String
    public let action: String
    
    public init(title: String, action: String) {
        self.title = title
        self.action = action
    }
}

// MARK: - Banner System

public struct BannerSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "banner"
    public let name = "Banner"
    public let description = "Full-width notification banners"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iOS, .iPadOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let position: BannerPosition
        public let showIcon: Bool
        public let showCloseButton: Bool
        public let autoDismiss: Bool
        public let autoDismissDelay: TimeInterval
        
        public static let `default` = Configuration(
            position: .top,
            showIcon: true,
            showCloseButton: true,
            autoDismiss: false,
            autoDismissDelay: 8.0
        )
        
        public init(position: BannerPosition = .top, showIcon: Bool = true, showCloseButton: Bool = true, autoDismiss: Bool = false, autoDismissDelay: TimeInterval = 8.0) {
            self.position = position
            self.showIcon = showIcon
            self.showCloseButton = showCloseButton
            self.autoDismiss = autoDismiss
            self.autoDismissDelay = autoDismissDelay
        }
        
        public enum BannerPosition: String, Codable, Sendable { case top, bottom, inline }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var banners: [Banner]
        
        public static let initial = State(banners: [])
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct Banner: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let message: String?
    public let type: BannerType
    public let icon: String?
    public let actions: [BannerAction]?
    public let isDismissable: Bool
    
    public init(id: String = UUID().uuidString, title: String, message: String? = nil, type: BannerType = .info, icon: String? = nil, actions: [BannerAction]? = nil, isDismissable: Bool = true) {
        self.id = id
        self.title = title
        self.message = message
        self.type = type
        self.icon = icon
        self.actions = actions
        self.isDismissable = isDismissable
    }
}

public enum BannerType: String, Codable, Sendable {
    case info, success, warning, error, announcement
}

public struct BannerAction: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let action: String
    public let style: BannerActionStyle
    
    public init(id: String, title: String, action: String, style: BannerActionStyle = .default) {
        self.id = id
        self.title = title
        self.action = action
        self.style = style
    }
    
    public enum BannerActionStyle: String, Codable, Sendable { case `default`, primary, link }
}
