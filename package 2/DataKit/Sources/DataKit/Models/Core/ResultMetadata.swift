//
//  ResultMetadata.swift
//  DataKit
//

import Foundation

public struct ResultMetadata: Codable, Sendable {
    public let duration: TimeInterval?
    public let timestamp: Date
    public let source: String?
    
    public init(duration: TimeInterval? = nil, timestamp: Date = Date(), source: String? = nil) {
        self.duration = duration
        self.timestamp = timestamp
        self.source = source
    }
}
