//
//  SettingOption.swift
//  DataKit
//

import Foundation

public struct SettingOption: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let label: String
    public let value: AnyCodable
    
    public init(id: String, label: String, value: AnyCodable) {
        self.id = id
        self.label = label
        self.value = value
    }
}
