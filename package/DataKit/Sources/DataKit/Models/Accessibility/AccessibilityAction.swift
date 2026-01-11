//
//  AccessibilityAction.swift
//  DataKit
//

import Foundation

public struct AccessibilityAction: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let handler: String
    
    public init(id: String = UUID().uuidString, name: String, handler: String) {
        self.id = id
        self.name = name
        self.handler = handler
    }
}
