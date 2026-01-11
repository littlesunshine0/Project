//
//  ColorModel.swift
//  DataKit
//

import Foundation

/// Color model
public struct ColorModel: Codable, Sendable, Hashable {
    public let hex: String
    public let opacity: Double
    
    public init(hex: String, opacity: Double = 1.0) {
        self.hex = hex
        self.opacity = opacity
    }
}
