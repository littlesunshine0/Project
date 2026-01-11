//
//  FooterStatusItem.swift
//  DataKit
//

import Foundation

public struct FooterStatusItem: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let text: String
    public let icon: String?
    public let action: String?
    
    public init(id: String, text: String, icon: String? = nil, action: String? = nil) {
        self.id = id
        self.text = text
        self.icon = icon
        self.action = action
    }
}
