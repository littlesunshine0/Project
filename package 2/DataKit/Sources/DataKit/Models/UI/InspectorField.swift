//
//  InspectorField.swift
//  DataKit
//

import Foundation

public struct InspectorField: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let label: String
    public let type: FieldType
    public let value: String
    public let isEditable: Bool
    
    public init(id: String, label: String, type: FieldType = .text, value: String = "", isEditable: Bool = false) {
        self.id = id
        self.label = label
        self.type = type
        self.value = value
        self.isEditable = isEditable
    }
}
