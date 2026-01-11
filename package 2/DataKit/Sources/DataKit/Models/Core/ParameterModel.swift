//
//  ParameterModel.swift
//  DataKit
//

import Foundation

public struct ParameterModel: Codable, Sendable, Hashable {
    public let name: String
    public let type: ParameterType
    public let required: Bool
    public let defaultValue: String?
    
    public init(name: String, type: ParameterType, required: Bool = true, defaultValue: String? = nil) {
        self.name = name
        self.type = type
        self.required = required
        self.defaultValue = defaultValue
    }
}
