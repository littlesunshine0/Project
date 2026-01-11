//
//  FooterStatus.swift
//  DataKit
//

import Foundation

/// Footer status
public struct FooterStatus: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let items: [FooterStatusItem]
    
    public init(id: String = UUID().uuidString, items: [FooterStatusItem] = []) {
        self.id = id
        self.items = items
    }
}
