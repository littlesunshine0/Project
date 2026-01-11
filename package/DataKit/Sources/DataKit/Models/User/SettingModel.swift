//
//  SettingModel.swift
//  DataKit
//

import Foundation

/// Setting model
public struct SettingModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let key: String
    public let title: String
    public let description: String?
    public let type: SettingType
    public var value: AnyCodable
    public let defaultValue: AnyCodable
    public let options: [SettingOption]?
    public let isAdvanced: Bool
    
    public init(id: String, key: String, title: String, description: String? = nil, type: SettingType, value: AnyCodable, defaultValue: AnyCodable? = nil, options: [SettingOption]? = nil, isAdvanced: Bool = false) {
        self.id = id
        self.key = key
        self.title = title
        self.description = description
        self.type = type
        self.value = value
        self.defaultValue = defaultValue ?? value
        self.options = options
        self.isAdvanced = isAdvanced
    }
}
