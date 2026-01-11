//
//  ExplanationFactor.swift
//  DataKit
//

import Foundation

public struct ExplanationFactor: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let contribution: Double
    public let description: String?
    
    public init(id: String = UUID().uuidString, name: String, contribution: Double, description: String? = nil) {
        self.id = id
        self.name = name
        self.contribution = contribution
        self.description = description
    }
}
