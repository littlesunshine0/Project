//
//  ActivityKit.swift
//  ActivityKit - Activity Tracking & App Integration
//

import Foundation

// MARK: - Activity

public struct Activity: Identifiable, Sendable {
    public let id: String
    public let type: ActivityType
    public let name: String
    public let description: String?
    public let timestamp: Date
    public var metadata: [String: String]
    
    public init(type: ActivityType, name: String, description: String? = nil) {
        self.id = UUID().uuidString
        self.type = type
        self.name = name
        self.description = description
        self.timestamp = Date()
        self.metadata = [:]
    }
}

public enum ActivityType: String, Sendable {
    case fileOpen, fileSave, fileCreate, fileDelete
    case appLaunch, appClose
    case workflowStart, workflowComplete
    case search, command
    case custom
}

// MARK: - App Launch

public struct AppLaunchRequest: Sendable {
    public let bundleId: String
    public let arguments: [String]
    public let environment: [String: String]
    
    public init(bundleId: String, arguments: [String] = [], environment: [String: String] = [:]) {
        self.bundleId = bundleId
        self.arguments = arguments
        self.environment = environment
    }
}

public struct AppLaunchResult: Sendable {
    public let success: Bool
    public let processId: Int?
    public let error: String?
}

// MARK: - Activity Tracker

public actor ActivityTracker {
    public static let shared = ActivityTracker()
    
    private var activities: [Activity] = []
    private var listeners: [String: @Sendable (Activity) -> Void] = [:]
    
    private init() {}
    
    public func record(_ type: ActivityType, name: String, description: String? = nil) -> Activity {
        let activity = Activity(type: type, name: name, description: description)
        activities.append(activity)
        notifyListeners(activity)
        return activity
    }
    
    public func getActivities(limit: Int = 100) -> [Activity] {
        Array(activities.suffix(limit))
    }
    
    public func getActivities(type: ActivityType) -> [Activity] {
        activities.filter { $0.type == type }
    }
    
    public func getActivities(since: Date) -> [Activity] {
        activities.filter { $0.timestamp >= since }
    }
    
    public func addListener(id: String, handler: @escaping @Sendable (Activity) -> Void) {
        listeners[id] = handler
    }
    
    public func removeListener(id: String) {
        listeners.removeValue(forKey: id)
    }
    
    private func notifyListeners(_ activity: Activity) {
        for handler in listeners.values {
            handler(activity)
        }
    }
    
    public var stats: ActivityStats {
        ActivityStats(
            totalActivities: activities.count,
            byType: Dictionary(grouping: activities, by: { $0.type }).mapValues { $0.count }
        )
    }
}

public struct ActivityStats: Sendable {
    public let totalActivities: Int
    public let byType: [ActivityType: Int]
}

// MARK: - App Launcher

public actor AppLauncher {
    public static let shared = AppLauncher()
    
    private var launchHistory: [AppLaunchRequest] = []
    
    private init() {}
    
    public func launch(_ request: AppLaunchRequest) -> AppLaunchResult {
        launchHistory.append(request)
        // Simulated launch - in real implementation would use NSWorkspace
        return AppLaunchResult(success: true, processId: Int.random(in: 1000...9999), error: nil)
    }
    
    public func launchByBundleId(_ bundleId: String) -> AppLaunchResult {
        launch(AppLaunchRequest(bundleId: bundleId))
    }
    
    public func getRecentLaunches(limit: Int = 10) -> [AppLaunchRequest] {
        Array(launchHistory.suffix(limit))
    }
}
