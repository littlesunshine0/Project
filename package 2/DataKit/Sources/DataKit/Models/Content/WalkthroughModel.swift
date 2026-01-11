//
//  WalkthroughModel.swift
//  DataKit
//

import Foundation

/// Walkthrough model
public struct WalkthroughModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let steps: [WalkthroughStep]
    public let isInteractive: Bool
    
    public init(id: String = UUID().uuidString, title: String, steps: [WalkthroughStep] = [], isInteractive: Bool = true) {
        self.id = id
        self.title = title
        self.steps = steps
        self.isInteractive = isInteractive
    }
}
