//
//  ViewModel.swift
//  DataKit
//

import Foundation

/// View model for UI binding
public struct ViewModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: ViewType
    public let title: String
    public let icon: String
    public let isVisible: Bool
    public let order: Int
    
    public init(id: String, type: ViewType, title: String, icon: String = "doc", isVisible: Bool = true, order: Int = 0) {
        self.id = id
        self.type = type
        self.title = title
        self.icon = icon
        self.isVisible = isVisible
        self.order = order
    }
}
