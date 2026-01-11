//
//  ShortcutModel.swift
//  DataKit
//

import Foundation

/// Shortcut model
public struct ShortcutModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let keys: [String]
    public let action: String
    public let category: String
    public var isEnabled: Bool
    public let isCustom: Bool
    
    public init(id: String, name: String, keys: [String], action: String, category: String = "general", isEnabled: Bool = true, isCustom: Bool = false) {
        self.id = id
        self.name = name
        self.keys = keys
        self.action = action
        self.category = category
        self.isEnabled = isEnabled
        self.isCustom = isCustom
    }
    
    public var keyCombo: String {
        keys.joined(separator: "+")
    }
}
