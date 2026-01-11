//
//  ConstraintModel.swift
//  DataKit
//

import Foundation

/// Constraint model
public struct ConstraintModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let type: ConstraintType
    public let value: AnyCodable
    public let message: String?
    
    public init(id: String, type: ConstraintType, value: AnyCodable, message: String? = nil) {
        self.id = id
        self.type = type
        self.value = value
        self.message = message
    }
}
