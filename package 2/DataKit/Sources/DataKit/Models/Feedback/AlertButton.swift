//
//  AlertButton.swift
//  DataKit
//

import Foundation

public struct AlertButton: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let style: AlertButtonStyle
    public let action: String
    
    public init(id: String = UUID().uuidString, title: String, style: AlertButtonStyle = .default, action: String) {
        self.id = id
        self.title = title
        self.style = style
        self.action = action
    }
}
