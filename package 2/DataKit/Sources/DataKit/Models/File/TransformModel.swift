//
//  TransformModel.swift
//  DataKit
//

import Foundation

/// Transform model for file conversions
public struct TransformModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let inputFormats: [String]
    public let outputFormat: String
    public let options: [String: AnyCodable]
    
    public init(id: String, name: String, inputFormats: [String], outputFormat: String, options: [String: AnyCodable] = [:]) {
        self.id = id
        self.name = name
        self.inputFormats = inputFormats
        self.outputFormat = outputFormat
        self.options = options
    }
}
