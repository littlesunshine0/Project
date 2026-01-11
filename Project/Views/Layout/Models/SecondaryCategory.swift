//
//  SecondaryCategory.swift
//  FlowKit
//
//  Secondary navigation category model
//

import SwiftUI

public struct SecondaryCategory: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let color: Color
    public var children: [SecondaryCategory]
    
    public init(id: String, title: String, icon: String, color: Color = .secondary, children: [SecondaryCategory] = []) {
        self.id = id
        self.title = title
        self.icon = icon
        self.color = color
        self.children = children
    }
    
    public static func == (lhs: SecondaryCategory, rhs: SecondaryCategory) -> Bool { lhs.id == rhs.id }
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
