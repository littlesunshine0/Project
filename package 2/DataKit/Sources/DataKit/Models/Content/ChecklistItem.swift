//
//  ChecklistItem.swift
//  DataKit
//

import Foundation

public struct ChecklistItem: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public var isCompleted: Bool
    
    public init(id: String = UUID().uuidString, title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}
