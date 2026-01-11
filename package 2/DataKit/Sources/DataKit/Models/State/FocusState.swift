//
//  FocusState.swift
//  DataKit
//

import Foundation

/// Focus state for accessibility and keyboard navigation
/// Named FocusStateModel to avoid conflict with SwiftUI's @FocusState property wrapper
public struct FocusStateModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public var focusedElement: String?
    public var focusRing: [String]
    public var currentIndex: Int
    public var isTrapActive: Bool
    
    public init(id: String = UUID().uuidString, focusedElement: String? = nil, focusRing: [String] = [], currentIndex: Int = 0, isTrapActive: Bool = false) {
        self.id = id
        self.focusedElement = focusedElement
        self.focusRing = focusRing
        self.currentIndex = currentIndex
        self.isTrapActive = isTrapActive
    }
    
    public mutating func focusNext() {
        guard !focusRing.isEmpty else { return }
        currentIndex = (currentIndex + 1) % focusRing.count
        focusedElement = focusRing[currentIndex]
    }
    
    public mutating func focusPrevious() {
        guard !focusRing.isEmpty else { return }
        currentIndex = currentIndex > 0 ? currentIndex - 1 : focusRing.count - 1
        focusedElement = focusRing[currentIndex]
    }
}
