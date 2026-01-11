//
//  IconModel.swift
//  DataKit
//

import Foundation

/// Icon model
public struct IconModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let type: IconType
    public let size: IconSize
    public let color: String?
    
    public init(id: String = UUID().uuidString, name: String, type: IconType = .sfSymbol, size: IconSize = .medium, color: String? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.size = size
        self.color = color
    }
}
