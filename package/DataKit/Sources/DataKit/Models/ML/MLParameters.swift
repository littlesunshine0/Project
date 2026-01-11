//
//  MLParameters.swift
//  DataKit
//

import Foundation

public struct MLParameters: Codable, Sendable, Hashable {
    public let temperature: Double
    public let maxTokens: Int
    public let topK: Int
    public let topP: Double
    
    public init(temperature: Double = 0.7, maxTokens: Int = 1024, topK: Int = 40, topP: Double = 0.9) {
        self.temperature = temperature
        self.maxTokens = maxTokens
        self.topK = topK
        self.topP = topP
    }
}
