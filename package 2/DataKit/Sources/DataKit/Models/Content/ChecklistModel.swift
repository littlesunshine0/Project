//
//  ChecklistModel.swift
//  DataKit
//

import Foundation

/// Checklist model
public struct ChecklistModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public var items: [ChecklistItem]
    
    public init(id: String = UUID().uuidString, title: String, items: [ChecklistItem] = []) {
        self.id = id
        self.title = title
        self.items = items
    }
    
    public var completedCount: Int {
        items.filter { $0.isCompleted }.count
    }
    
    public var progress: Double {
        guard !items.isEmpty else { return 0 }
        return Double(completedCount) / Double(items.count)
    }
}
