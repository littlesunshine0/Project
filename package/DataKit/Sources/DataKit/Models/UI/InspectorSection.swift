//
//  InspectorSection.swift
//  DataKit
//

import Foundation

public struct InspectorSection: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let fields: [InspectorField]
    
    public init(id: String, title: String, fields: [InspectorField] = []) {
        self.id = id
        self.title = title
        self.fields = fields
    }
}
