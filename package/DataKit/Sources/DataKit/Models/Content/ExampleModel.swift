//
//  ExampleModel.swift
//  DataKit
//

import Foundation

/// Example model
public struct ExampleModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let description: String
    public let code: String
    public let language: String
    public let output: String?
    
    public init(id: String = UUID().uuidString, title: String, description: String = "", code: String, language: String = "swift", output: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.code = code
        self.language = language
        self.output = output
    }
}
