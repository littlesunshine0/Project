//
//  GuideStep.swift
//  DataKit
//

import Foundation

public struct GuideStep: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let content: String
    public let action: String?
    
    public init(id: String, title: String, content: String = "", action: String? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.action = action
    }
}
