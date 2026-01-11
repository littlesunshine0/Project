//
//  NavigationKit.swift
//  NavigationKit
//
//  Navigation Coordination for FlowKit
//  Provides unified navigation state and routing across the app
//
//  Structure:
//  - Services/     NavigationCoordinator
//  - Models/       NavigationDestination, SheetDestination
//

import Foundation
import Combine

/// NavigationKit - Navigation Coordination System
public struct NavigationKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.navigationkit"
    
    public init() {}
    
    /// Get the shared navigation coordinator
    @MainActor
    public static var coordinator: NavigationCoordinator { NavigationCoordinator.shared }
    
    /// Navigate to a destination
    @MainActor
    public static func navigate(to destination: NavigationDestination) {
        NavigationCoordinator.shared.navigate(to: destination)
    }
    
    /// Go back
    @MainActor
    public static func goBack() {
        NavigationCoordinator.shared.goBack()
    }
    
    /// Present a sheet
    @MainActor
    public static func present(_ sheet: SheetDestination) {
        NavigationCoordinator.shared.present(sheet)
    }
}

// MARK: - Navigation Section

public enum NavigationSection: String, CaseIterable, Sendable {
    case main = "Main"
    case tools = "Tools"
    case resources = "Resources"
    case system = "System"
    
    public var icon: String {
        switch self {
        case .main: return "house"
        case .tools: return "wrench.and.screwdriver"
        case .resources: return "folder"
        case .system: return "gearshape"
        }
    }
}

// MARK: - Navigation Item

public struct NavigationItem: Identifiable, Sendable {
    public let id: UUID
    public let destination: NavigationDestination
    public let title: String
    public let subtitle: String?
    public let badge: Int?
    
    public init(
        id: UUID = UUID(),
        destination: NavigationDestination,
        title: String? = nil,
        subtitle: String? = nil,
        badge: Int? = nil
    ) {
        self.id = id
        self.destination = destination
        self.title = title ?? destination.title
        self.subtitle = subtitle
        self.badge = badge
    }
    
    public var icon: String { destination.icon }
}

// MARK: - Tab Configuration

public struct TabConfiguration: Sendable {
    public let tabs: [NavigationDestination]
    public let defaultTab: NavigationDestination
    
    public init(tabs: [NavigationDestination], defaultTab: NavigationDestination) {
        self.tabs = tabs
        self.defaultTab = defaultTab
    }
    
    public static let `default` = TabConfiguration(
        tabs: [.dashboard(), .workflows(), .agents(), .documentation(), .settings()],
        defaultTab: .dashboard()
    )
    
    public static let compact = TabConfiguration(
        tabs: [.dashboard(), .workflows(), .chat()],
        defaultTab: .dashboard()
    )
}
