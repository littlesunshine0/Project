//
//  AlertModel.swift
//  DataKit
//

import Foundation

/// Alert model for modal alerts
public struct AlertModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: AlertType
    public let title: String
    public let message: String
    public let buttons: [AlertButton]
    
    public init(id: String = UUID().uuidString, type: AlertType = .info, title: String, message: String, buttons: [AlertButton] = []) {
        self.id = id
        self.type = type
        self.title = title
        self.message = message
        self.buttons = buttons.isEmpty ? [AlertButton(title: "OK", style: .default, action: "dismiss")] : buttons
    }
}
