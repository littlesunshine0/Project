//
//  RecoveryAction.swift
//  DataKit
//

import Foundation

public struct RecoveryAction: Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let action: String
    
    public init(id: String, title: String, action: String) {
        self.id = id
        self.title = title
        self.action = action
    }
}
