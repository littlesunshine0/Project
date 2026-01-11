//
//  WalkthroughStep.swift
//  DataKit
//

import Foundation

public struct WalkthroughStep: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let description: String
    public let targetElement: String?
    public let action: String?
    
    public init(id: String, title: String, description: String = "", targetElement: String? = nil, action: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.targetElement = targetElement
        self.action = action
    }
}
