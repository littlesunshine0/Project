//
//  StatusModel.swift
//  DataKit
//

import Foundation

/// Status model for state representation
public struct StatusModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: StatusType
    public let title: String
    public let message: String?
    public let icon: String
    public let color: String
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, type: StatusType, title: String, message: String? = nil, icon: String? = nil, color: String? = nil) {
        self.id = id
        self.type = type
        self.title = title
        self.message = message
        self.icon = icon ?? type.defaultIcon
        self.color = color ?? type.defaultColor
        self.timestamp = Date()
    }
}
