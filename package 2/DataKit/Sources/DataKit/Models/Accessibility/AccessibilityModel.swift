//
//  AccessibilityModel.swift
//  DataKit
//

import Foundation

/// Accessibility configuration
public struct AccessibilityModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let label: String
    public let hint: String?
    public let value: String?
    public let traits: [AccessibilityTrait]
    public let actions: [AccessibilityAction]
    public let isHidden: Bool
    
    public init(id: String = UUID().uuidString, label: String, hint: String? = nil, value: String? = nil, traits: [AccessibilityTrait] = [], actions: [AccessibilityAction] = [], isHidden: Bool = false) {
        self.id = id
        self.label = label
        self.hint = hint
        self.value = value
        self.traits = traits
        self.actions = actions
        self.isHidden = isHidden
    }
}
