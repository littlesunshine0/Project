//
//  TaskModel.swift
//  DataKit
//

import Foundation

/// Task to be executed
public struct TaskModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let priority: TaskPriority
    public let status: TaskStatus
    public let assignedTo: String?
    public let dueDate: Date?
    public let createdAt: Date
    public var completedAt: Date?
    
    public init(id: String = UUID().uuidString, name: String, description: String = "", priority: TaskPriority = .normal, status: TaskStatus = .pending, assignedTo: String? = nil, dueDate: Date? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.priority = priority
        self.status = status
        self.assignedTo = assignedTo
        self.dueDate = dueDate
        self.createdAt = Date()
        self.completedAt = nil
    }
}
