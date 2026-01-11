//
//  BannerAction.swift
//  DataKit
//

import Foundation

public struct BannerAction: Codable, Sendable, Hashable {
    public let title: String
    public let action: String
    
    public init(title: String, action: String) {
        self.title = title
        self.action = action
    }
}
