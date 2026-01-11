//
//  NotificationKit.swift
//  NotificationKit
//
//  Notification management and delivery
//

import Foundation

public struct NotificationKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.notificationkit"
    public init() {}
}

// MARK: - Notification Manager

public actor NotificationManager {
    public static let shared = NotificationManager()
    
    private var notifications: [UUID: AppNotification] = [:]
    private var channels: [String: NotificationChannel] = [
        "system": NotificationChannel(id: "system", name: "System", priority: .high),
        "workflow": NotificationChannel(id: "workflow", name: "Workflow", priority: .medium),
        "info": NotificationChannel(id: "info", name: "Information", priority: .low)
    ]
    private var preferences: [String: Bool] = [:]
    
    private init() {}
    
    public func send(_ notification: AppNotification) -> UUID {
        notifications[notification.id] = notification
        return notification.id
    }
    
    public func send(title: String, message: String, channel: String = "info", priority: NotificationPriority = .medium) -> UUID {
        let notification = AppNotification(title: title, message: message, channel: channel, priority: priority)
        return send(notification)
    }
    
    public func get(_ id: UUID) -> AppNotification? { notifications[id] }
    public func getAll() -> [AppNotification] { Array(notifications.values) }
    
    public func getByChannel(_ channel: String) -> [AppNotification] {
        notifications.values.filter { $0.channel == channel }
    }
    
    public func markAsRead(_ id: UUID) {
        if var n = notifications[id] { n.isRead = true; notifications[id] = n }
    }
    
    public func dismiss(_ id: UUID) { notifications.removeValue(forKey: id) }
    public func dismissAll() { notifications.removeAll() }
    
    public func getUnreadCount() -> Int { notifications.values.filter { !$0.isRead }.count }
    
    public func setChannelEnabled(_ channel: String, enabled: Bool) { preferences[channel] = enabled }
    public func isChannelEnabled(_ channel: String) -> Bool { preferences[channel] ?? true }
    
    public func getChannels() -> [NotificationChannel] { Array(channels.values) }
    
    public var stats: NotificationStats {
        NotificationStats(
            total: notifications.count,
            unread: getUnreadCount(),
            channelCount: channels.count
        )
    }
}

// MARK: - Workflow Notifications

public actor WorkflowNotificationService {
    public static let shared = WorkflowNotificationService()
    
    private var subscriptions: [String: Set<String>] = [:]  // workflow -> user IDs
    
    private init() {}
    
    public func subscribe(userId: String, to workflow: String) {
        subscriptions[workflow, default: []].insert(userId)
    }
    
    public func unsubscribe(userId: String, from workflow: String) {
        subscriptions[workflow]?.remove(userId)
    }
    
    public func notifyWorkflowComplete(workflow: String, result: String) async {
        let subscribers = subscriptions[workflow] ?? []
        for _ in subscribers {
            _ = await NotificationManager.shared.send(
                title: "Workflow Complete",
                message: "\(workflow): \(result)",
                channel: "workflow"
            )
        }
    }
    
    public func notifyWorkflowError(workflow: String, error: String) async {
        _ = await NotificationManager.shared.send(
            title: "Workflow Error",
            message: "\(workflow): \(error)",
            channel: "workflow",
            priority: .high
        )
    }
    
    public func getSubscribers(for workflow: String) -> [String] {
        Array(subscriptions[workflow] ?? [])
    }
}

// MARK: - Models

public struct AppNotification: Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let message: String
    public let channel: String
    public let priority: NotificationPriority
    public var isRead: Bool
    public let createdAt: Date
    
    public init(id: UUID = UUID(), title: String, message: String, channel: String = "info", priority: NotificationPriority = .medium, isRead: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.message = message
        self.channel = channel
        self.priority = priority
        self.isRead = isRead
        self.createdAt = createdAt
    }
}

public enum NotificationPriority: Int, Sendable, CaseIterable {
    case low = 1, medium = 2, high = 3, urgent = 4
}

public struct NotificationChannel: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let priority: NotificationPriority
    
    public init(id: String, name: String, priority: NotificationPriority = .medium) {
        self.id = id
        self.name = name
        self.priority = priority
    }
}

public struct NotificationStats: Sendable {
    public let total: Int
    public let unread: Int
    public let channelCount: Int
}
