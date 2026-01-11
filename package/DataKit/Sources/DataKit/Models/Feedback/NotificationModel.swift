//
//  NotificationModel.swift
//  DataKit
//

import Foundation

/// Notification model
public struct NotificationModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: NotificationType
    public let title: String
    public let body: String?
    public let icon: String?
    public let action: String?
    public let timestamp: Date
    public var isRead: Bool
    public var isDismissed: Bool
    
    public init(id: String = UUID().uuidString, type: NotificationType = .info, title: String, body: String? = nil, icon: String? = nil, action: String? = nil) {
        self.id = id
        self.type = type
        self.title = title
        self.body = body
        self.icon = icon
        self.action = action
        self.timestamp = Date()
        self.isRead = false
        self.isDismissed = false
    }
}
